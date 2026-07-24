---
title: redcli Usage Guide
created: 2026-07-24
author: AI-assisted
last_updated: 2026-07-24
updated_by: AI-assisted
status: active
---

# redcli — Usage Guide

`redcli` is this repository’s **RLE4K CPU reproducibility benchmark CLI**: load `.dif` → strip rasterization → multi-codec encode/decode timing → console comparison report (optional CSV export).

Input is **`.dif` only** (no Gerber / GDS). Pipeline design: [PIPELINE.md](PIPELINE.md).

---

## Quick start

```powershell
# Build from the repository root
.\scripts\msbuild.ps1 Release

# Create a working config in the current directory (built-in defaults; skipped if redcli.json already exists)
.\build\redcli.exe init

# Edit input and other fields
.\build\redcli.exe edit

# Run (CLI flags override the config file)
.\build\redcli.exe run --input D:\data\sample.dif
.\build\redcli.exe run --input D:\data\dif_folder --mode 1 --csv D:\out\report.csv
```

Executable location: `build/redcli.exe` (NMake) or `build/Release/redcli.exe` (VS generator). The build runs `redcli init` next to the exe (creates `redcli.json` from **built-in defaults** if missing).

---

## Commands

| Command | Description |
|---------|-------------|
| `redcli init` | Write `./redcli.json` from **built-in defaults** (does not overwrite an existing file; no external template required) |
| `redcli run` | Run the benchmark |
| `redcli edit` / `redcli config` | Open the resolved `redcli.json` in the default editor |
| `redcli -h` / `redcli --help` | Print built-in help (also printed when no subcommand is given) |

On startup, redcli prints its version and tcmalloc link status, e.g. `[redcli] redcli v1.0.0`.

Alias: `redcli benchmark …` is equivalent to `redcli run …` (backward compatibility).

---

## Configuration file `redcli.json`

### Search order

redcli looks for **`redcli.json`** in these directories (first hit wins):

1. Current working directory `.`
2. Parent `..`
3. Directory of `redcli.exe`
4. exe `..` / `../..`
5. `docs` / `../docs`

If none is found, the run continues with a warning and built-in defaults; **`--input` (or config `input`) is still required**.

Authoritative field list for humans: **[redcli.example.json](redcli.example.json)** (kept aligned with the built-in string in `rle4k_config.h`). Common fields:

| Field | Default | Meaning |
|-------|---------|---------|
| `input` | `""` | Path to a `.dif` file, or a folder when `mode=1` |
| `mode` | `0` | `0` = single file, `1` = scan directory for all `*.dif` |
| `output_path` | `build/out` | Conventional output directory (use `--csv` for an explicit CSV path) |
| `repeat` | `3` | Encode/decode timing repeats (averaged) |
| `check_enabled` | `1` | `1` = memcmp after decode; `0` = skip |
| `pitch_width_um` | `0.5` | Pixel pitch (µm) |
| `oblique_factor` | `32` | Oblique factor N |
| `raster_threads` | `4` | Phase 1: raster worker count |
| `encode_threads` | `0` | Phase 2: encode workers (`0` = same as raster) |
| `decode_threads` | `0` | Phase 3: decode workers (`0` = same as raster) |
| `encode_enabled` | `1` | Run encode phase |
| `decode_enabled` | `1` | Run decode phase (also skipped when encode is off) |
| `block_line` | `512` | Row-block height inside a strip (pixel rows) |
| `strip_width` | `0` | Strip width in px; `0` = auto-align |
| `align_mode` | `512` | Alignment grain for auto strip width |
| `dmd_resolution_rows` / `cols` | `512` / `1920` | DMD resolution used for auto `strip_width` |
| `formats` | `[0..5]` | Codec ID list (see below) |
| `gzip_level` / `zstd_level` / … | see example | Per-codec compression levels |
| `verbose` | `"file"` | `"file"` or `"strip"` (per-strip detail) |

When `strip_width == 0`:

```text
strip_width = ALIGN(dmd_resolution_cols × N + dmd_resolution_rows, align_mode)
```

### Format IDs

| ID | Codec |
|----|-------|
| `0` | RLE4K |
| `1` | GZIP |
| `2` | LZO2 |
| `3` | SNAPPY |
| `4` | ZSTD |
| `5` | Brotli |

---

## `run` options

CLI flags override matching config keys:

```text
redcli run [options]
```

| Option | Description |
|--------|-------------|
| `--input`, `-i <path>` | Input `.dif` or folder |
| `--mode`, `-m <0\|1>` | `0` file / `1` folder |
| `--repeat`, `-r <N>` | Repeat count (default 3) |
| `--pw <um>` | Pixel pitch µm (default 0.5) |
| `-N`, `--oblique <num>` | Oblique factor N (default 32) |
| `--strip-height`, `-sh <H>` | Row-block height (default 512) |
| `--strip-width`, `-sw <W>` | Strip width px; `0` = auto |
| `--threads`, `--raster-threads`, `-t <N>` | Raster thread count |
| `--encode-threads`, `-et <N>` | Encode threads (`0` = same as raster) |
| `--decode-threads`, `-dt <N>` | Decode threads (`0` = same as raster) |
| `--no-encode` | Skip encode phase |
| `--no-decode` | Skip decode phase |
| `--verbose`, `-v <mode>` | `"file"` or `"strip"` |
| `--csv`, `-o`, `--output <path>` | Write UTF-8 (BOM) comparison CSV; **console only by default** |
| `--force` | Accepted but unused; no resume/checkpoint in the current build |
| `-h`, `--help` | Help |

Environment variable **`RLE4K_THREADS`**: if set to a positive integer, overrides `raster_threads`.

---

## Pipeline and timing model

Each input file is measured in **serial stages** (rasterize each strip column once, then encode/decode per format):

```text
DIF load
  → for each strip column:
       Phase 1  raster   (raster_threads)
       Phase 2  encode   (encode_threads; loop formats[]; average over repeat)
       Phase 3  decode   (decode_threads; optional verify)
  → console Comparison Report
  → optional --csv write
```

Throughput uses **phase wall-clock** (thread-pool spawn→join), not a sum of per-block CPU times. See [PIPELINE.md](PIPELINE.md) and [RASTERIZATION.md](RASTERIZATION.md).

---

## Output

### Console

After each file, a **Comparison Report** is printed to stdout: codec name, compressed size (CS), compression ratio (CR), encode/decode time and throughput, and CHK (`OK` / `FAIL` / `SKIP`).

Progress and per-column timing go to stderr.

### CSV (requires `--csv`)

- Encoding: UTF-8 **with BOM**; a leading comment line declares the encoding.
- **One row per DIF file**; per-codec metrics are expanded as columns, e.g. `RLE4K_cr`, `RLE4K_cs_mb`, `RLE4K_sed_ms`, `RLE4K_set_gbps`, `RLE4K_sdd_ms`, `RLE4K_sdt_gbps`, `RLE4K_chk`.
- Without `--csv`, only the console report is produced.

---

## Examples

```powershell
# Single file, three repeats, default six codecs
.\build\redcli.exe run -i D:\geoms\demo.dif -r 3

# Folder batch + CSV export
.\build\redcli.exe run -i D:\geoms --mode 1 --csv D:\out\compare.csv

# Raster only (no encode/decode)
.\build\redcli.exe run -i D:\geoms\demo.dif --no-encode

# Override PW / N / threads
.\build\redcli.exe run -i D:\geoms\demo.dif --pw 1.0 -N 16 -t 8 -et 4 -dt 4

# Per-strip verbose logging
.\build\redcli.exe run -i D:\geoms\demo.dif --verbose strip
```

Helper scripts (from the repository root):

```powershell
.\scripts\test-single-file.ps1 D:\geoms\demo.dif
.\scripts\test-folder.ps1 D:\geoms
```

---

## Troubleshooting

| Symptom | What to do |
|---------|------------|
| `[ERROR] --input required` | Set `input` in `redcli.json`, or pass `-i` |
| `[ERROR] No .dif files` | Check the path; for `mode=1`, the folder must contain `*.dif` |
| `[WARN] redcli.json not found` | Run `redcli init` (writes built-in defaults; no template file needed) |
| `redcli.exe not found` | Run `.\scripts\msbuild.ps1` first |
| Editor does not open | Set `EDITOR` / `VISUAL`, or associate `.json` with an editor |

---

## Related docs

| Document | Contents |
|----------|----------|
| [redcli.example.json](redcli.example.json) | Documentation mirror of built-in defaults |
| [PIPELINE.md](PIPELINE.md) | Pipeline design |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Modules and data flow |
| [RASTERIZATION.md](RASTERIZATION.md) | Rasterizer and threading |
| [README.md](README.md) | Documentation index |
| Root [README.md](../README.md) | Build and reproducibility environment |
