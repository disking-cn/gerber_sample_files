# redtt — Raster Regression REPL

## Overview

`redtt` is a command-line tool for **rasterization regression testing** and
**performance benchmarking**. It rasterizes DIF geometry files using various
compression formats (RLE, GZIP, ZSTD, etc.) and measures encoding/decoding
performance.

`redtt` replaces three legacy executables (`redcli`, `d2histos`, `d2thumb`)
with unified subcommand modes.

---

## Modes

`redtt` operates in four modes, selected by flags or configuration:

| Mode | Flag | Purpose |
|------|------|---------|
| **REPL** (interactive) | `--REPL` or `workMode=repl` | Interactive session with persistent config |
| **CLI / loop** (default) | `--loop`, `--CLI`, `--PERL`, `--histos`, `--thumb` | One-shot commands from the command line |
| **--PERL** (automation) | `--PERL` | Script-friendly subprocess (replaces `redcli`) |
| **--histos** | `--histos` | DIF → run-length histogram CSV (replaces `d2histos`) |
| **--thumb** | `--thumb` | DIF → PNG thumbnail (replaces `d2thumb`) |

When no flag is given, `[global].workMode` in `redtt.json` selects the default.

---

## Format IDs

Every format is addressed by an integer ID. The same IDs are used for `go`,
`bench`, `ss`, `--PERL` and `--REDCLIMODE` commands.

| ID | Format | Description |
|:--:|--------|-------------|
| 0 | NATIVE | Native / uncompressed |
| 1 | BITMAP | Bitmap |
| 2 | RLE112 | RLE 112-bit |
| 3 | RLE128 | RLE 128-bit |
| 4 | RLE4K | RLE 4K |
| 5 | RLE16KA | RLE 16K variant A |
| 6 | RLE16KB | RLE 16K variant B |
| 7 | GZIP | GZIP |
| 8 | ZSTD | Zstandard |
| 9 | LZ4 | LZ4 |
| 10 | SNAPPY | Snappy |
| 11 | LZO2 | LZO2 |
| 12 | LZMA | LZMA |
| 13 | BZIP2 | BZIP2 |
| 14 | LZ77 | LZ77 |
| 15 | Brotli | Brotli |
| 16 | RLIE16 | RLIE 16-bit |

> **Rule-of-thumb**: IDs 2–6 and 16 are RLE-family; IDs 7–15 are general-purpose
> third-party compressors. ID 0 is native (no compression), ID 1 is a legacy
> bitmap wrapper. When a sweep targets "compressed-only", the system default
> exclusion list is `{0, 1}` — i.e. `formats=all(-)` or `formats=all(-1)`
> produces formats 2 … 16.

---

## REPL Commands

### go / encode

Rasterize a DIF file and optionally save output or statistics.

```
go [tokens...]
```

| Token | Aliases | Meaning |
|-------|---------|---------|
| `<format>` | number, `1,2,3`, `1\|2\|3` | Format id(s) |
| `y` | `save`, `yes` | Force disk save (skip confirmation) |
| `n` | `nosave`, `no` | In-memory only; no disk save |
| `all` | `*` | All formats |
| `skip` | `skip-native`, `compressed-only` | With `all`: skip native format |
| `report` | `txt` | Generate text report file |
| `csv` | `stats` | Generate CSV statistics file |
| `<path>` | — | Output path for report/CSV |

#### Examples

```
go                                          # current format, default save
go y 3                                      # format 3 (RLE128), force save
go n                                        # in-memory only; no disk save
go all skip                                 # all compressed formats, no save
go y 2|3|4 csv D:\stats\                    # formats 2,3,4 + CSV
go all report D:\reports\                   # all formats + text report
go help                                     # detailed help for this command
```

#### go vs zu

| | `zu` / `bench` | `go` / `encode` |
|---|----------------|-----------------|
| Disk output | No (by design) | Optional (`y`/`save`) |
| Decode in loop | Yes | No |
| CSV | Via `csv` config / `auto` | `csv` token on command |

### zu / bench

Full-pipeline **in-memory benchmark**: rasterize → compress → decompress.
No raster output files are written to disk by design.

```
zu [tokens...]
```

| Token | Aliases | Meaning |
|-------|---------|---------|
| `<format>` | number, `1,2,3`, `1\|2\|3` | Format id(s) |
| `all` | `*` | All formats |
| `skip` | `skip-native`, `compressed-only` | Skip native format |
| `auto` | `autoname` | Auto-generate CSV/log file names |

#### Examples

```
bench                                       # current format, in-memory
zu 4                                        # RLE4K benchmark
bench 3,4,7                                 # multiple formats
zu all skip                                 # all compressed formats
bench all skip auto                         # all compressed + auto file names
```

### ss / sweep

**Parameter sweep**: test all combinations of N × PW × format.
Results written to 32-column CSV files (one per DIF × format × N × PW × RTC
combination).

```
ss [parameters...]
```

#### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `n=` | `8,16,24,32,40,48,56,64` | N (oblique) sequence, comma-sep |
| `pw=` | `0.5,1,2,4` | PW (pixel width μm) sequence, comma-sep |
| `formats=` | `all(-)` | Format specifier. See table below |
| `log=` | auto from DIF name | Log file base name |
| `dir=` | — | Output directory for `ss split` |
| `gpu=` | — | GPU pipeline override: `all`, `encode`, `raster,decode` |

#### Format Specifiers

The `formats=` argument accepts several forms:

| Syntax | Example | Result |
|--------|---------|--------|
| Literal IDs | `formats=2,3,4` | Formats 2, 3, 4 |
| `all` | `formats=all` | All formats (0–16) |
| `all(excl_list)` | `formats=all(0,1,2)` | All except 0, 1, 2 |
| `all(-)` | `formats=all(-)` | All except system-excluded → compressed-only |
| `all(*)` | `formats=all(*)` | All plus extra system formats |

> Compressed-only (no native) is the most common sweep setting:
> `formats=all(-)` ⇒ formats 2–16.

#### Subcommands

| Subcommand | Description |
|------------|-------------|
| `ss` | Execute sweep |
| `ss resume [state=path]` | Resume from checkpoint |
| `ss resume --force [state=path]` | Force resume (scan existing CSVs) |
| `ss split [dir=path]` | Migrate legacy CSV naming |
| `ss status [state=path]` | Show checkpoint status |

#### Breakpoint and Recovery

Long sweeps auto-write `{output}/tasks.session`. On resume:

1. **Normal resume**: `ss resume` — continue from checkpoint
2. **Force resume** (crash without .session): `ss resume --force` — rebuild
   from CSVs (requires `.session` file deleted first)
3. **Check status**: `ss status` — view progress and failure count

When a single repeat fails:
- No strip CSV is written (avoids SDD=0 dirty data)
- One row appended to `{output}/tasks.failed.csv`
- Sweep halts; checkpoint saved for `ss resume`

#### CSV Schema

**Strip CSV — 32 core fields** (GPU columns are conditional)

```
TSID,VR,PC,TS,EFN,RTC,ET,DT,EC,SID,TBC,SPT,BAT,SCD,WRD,WED,WDD,SRD,SED,ACR,GFN,PW,N,GFS,TIS,CS,SDS,SDD,SET,SDT,EF,TSC,\
[GRK,GEK,GDK,H2D,D2H,PTM]
```

| # | Abbr | Name / Description | Unit |
|---|------|-------------------|------|
| 1 | TSID | Row ID (globally unique UUID) | — |
| 2 | VR | Schema version (currently `1`) | — |
| 3 | PC | Machine name (from `computer` key) | — |
| 4 | TS | Timestamp (`YYYY-MM-DD HH:MM:SS`) | — |
| 5 | EFN | Encoder format name (e.g. `RLE4K`) | — |
| 6 | RTC | Raster thread count (RRT) | — |
| 7 | ET | Encode thread count (RT → ET chain) | — |
| 8 | DT | Decode thread count (ET → DT chain) | — |
| 9 | EC | Execution / repeat index (1-based) | — |
| 10 | SID | Strip index (0-based) | — |
| 11 | TBC | Total blocks in strip | — |
| 12 | SPT | Strip parallel wall time (pipeline ≈ WRD + WED + WDD) | ms |
| 13 | BAT | Block average time (SPT / TBC) | ms |
| 14 | SCD | Strip GPU DIF cache upload time | ms |
| 15 | **WRD** | **Wall-clock raster duration** (raster + hijack stage) | ms |
| 16 | **WED** | **Wall-clock encode duration** (encode stage) | ms |
| 17 | **WDD** | **Wall-clock decode duration** (decode stage) | ms |
| 18 | SRD | Strip raster CPU time sum | ms |
| 19 | SED | Strip encode CPU time sum | ms |
| 20 | ACR | Average compression ratio | % |
| 21 | GFN | Input DIF file name (short name) | — |
| 22 | PW | Pixel pitch width | μm |
| 23 | N | Oblique sampling factor | — |
| 24 | GFS | Input file size on disk | B |
| 25 | TIS | Uncompressed bitmap data for the strip | B |
| 26 | CS | Encoded strip payload size | B |
| 27 | SDS | Compressed strip data size (CS / 1024³) | GB |
| 28 | SDD | Strip decode CPU time sum | ms |
| 29 | SET | Encode throughput (TIS MB / WED s) | MB/s |
| 30 | SDT | Decode throughput (TIS MB / WDD s) | MB/s |
| 31 | EF | Encoder format ID | — |
| 32 | TSC | Total strip count | — |
| — | GRK | GPU raster kernel event time | ms |
| — | GEK | GPU encode kernel event time | ms |
| — | GDK | GPU decode kernel event time | ms |
| — | H2D | Host-to-device PCIe bytes | B |
| — | D2H | Device-to-host PCIe bytes | B |
| — | PTM | PCIe transfer wall time (cudaMemcpy) | ms |

The six GPU fields (GRK, GEK, GDK, H2D, D2H, PTM) are appended **only** when
the sweep runs with `gpu=` configured and CUDA is available. On a CPU-only
build they are present in the header but all write `0`.

> **Note** — the legacy 26-column header (`TSID … TSC` without ET, DT, SCD,
> WRD, WED, WDD) is still supported. New files use the v2 32-column header;
> appending to a v1 file preserves v1 columns.

#### File Naming

```
{PC}_{DIF}_{EFN}_N{n}_PW{pw}_T{rtc}.csv
```

- `PC` — machine name (from `computer` config)
- `DIF` — input DIF stem
- `PW` — pixel width × 1000 as integer: `0.5` → `PW500`

Example: `PC01_test001_RLE4K_N32_PW500_T4.csv`

#### Examples

```
dif "D:\geoms\test.dif"
ss                                       # default N and PW, compressed-only formats
ss n=8,16 pw=0.5,1                       # specific N and PW
ss formats=3,4,7 n=8,16 pw=0.5,1        # formats 3,4,7
ss formats=all(-) n=16 pw=1              # all compressed formats
ss formats=all(0,1,2) n=8,16 pw=0.5,1   # all except 0,1,2
ss resume                                # resume from checkpoint
ss resume --force                        # crash recovery from CSVs
ss split                                 # migrate legacy CSVs
```

### un / decode / unpack

Batch decode compressed raster files. Supports individual files or directories.

```
un <input_path> [output_path] [file_count_limit]
```

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `<input_path>` | path | Yes | File or directory to decode |
| `[output_path]` | path | No | Output directory (omit or use `-` for in-memory only) |
| `[file_count_limit]` | integer | No | Max files (directory only; random selection) |

#### Supported File Formats

| Extension | Format ID | Format |
|-----------|-----------|--------|
| `.bin` | 0 | NATIVE |
| `.nbmp` | 1 | BITMAP |
| `.rle112` | 2 | RLE112 |
| `.rle128` | 3 | RLE128 |
| `.rle4k` | 4 | RLE4K |
| `.a.rle16k` | 5 | RLE16KA |
| `.b.rle16k` | 6 | RLE16KB |
| `.gzip` | 7 | GZIP |
| `.zstd` | 8 | ZSTD |
| `.lz4` | 9 | LZ4 |
| `.snappy` | 10 | SNAPPY |
| `.lzo2` | 11 | LZO2 |
| `.lzma` | 12 | LZMA |
| `.bz2` | 13 | BZIP2 |
| `.lz77` | 14 | LZ77 |
| `.brotli` | 15 | Brotli |
| `.rle66` | 16 | RLE66 |
| `.rlie16` | 17 | RLIE16 |

#### Decode Modes

| Mode | When | Behavior |
|------|------|----------|
| **In-memory** | No output path, or `-` | Decode in RAM; no file written; print elapsed time |
| **File output** | Output path provided | Decode to disk; output as `.bin`; print progress |

#### Examples

```
un D:\data\file.rle4k                      # in-memory decode
un D:\data\ - 100                          # in-memory; 100-file limit
un D:\data\file.rle4k D:\output\           # decode to disk
un D:\data\ D:\output\ 100                 # directory decode; limit 100
```

### fields / schema

Show the field abbreviation lookup table for CSV columns.

```
fields <abbreviation>    # look up a specific column
fields                   # show all abbreviations and names
```

### print / show / config

Display the current `TestConfig` settings.

```
print
show
config
```

### clear / clean

Clean output artifacts (CSV files, log files, thumbnails, etc.) from the
configured output directory.

```
clear
clean
```

### save

Persist current configuration to `redtt.json` beside the executable.

```
save
```

### quit / exit / q

Exit the REPL.

```
quit
exit
q
```

### help

Show command help.

```
help                         # all commands and aliases
help <command_name>          # detailed help for a specific command
help params                  # config parameter reference
```

---

## REPL Configuration Parameters

Set configuration values in the REPL using canonical names or aliases:

| Canonical | Aliases | Type | Description |
|-----------|---------|------|-------------|
| `dif` | `input`, `file` | path | Input DIF file path |
| `folder` | `path` | path | Input folder path (auto-discovers all DIFs) |
| `files` | — | string | Semicolon-separated DIF file list |
| `format` | `fmt`, `f` | integer | Default raster format (0–16) |
| `pw` | `pitch` | double | Pixel pitch width (μm) |
| `N` | `n`, `of`, `oblique` | integer | Oblique factor |
| `RRT` | `rtc`, `rasterThreadCount` | integer | Raster thread count |
| `RT` | `rt`, `threads`, `runtimeThreadCount` | integer | Runtime thread count (encode/decode) |
| `repeat` | — | integer | Repeat count for statistical accuracy |
| `output` | — | path | Output base directory (default: `D:\outputs`) |
| `csv` | — | path | CSV output path |
| `computer` | — | string | Machine name (used in CSV PC column) |
| `storageWorkerCount` | — | integer | Decoder thread pool size |
| `workMode` | — | string | Default mode: `repl` or `loop` |

#### Setting Parameters

```
dif D:\geoms\sample.dif
pw 0.5
N 32
format 4
RT 8
RRT 4
repeat 3
save
```

---

## --PERL Mode (CLI Automation)

`--PERL` provides script-friendly, non-interactive automation.
`--PERL` is case-insensitive.

```
redtt --PERL peek --file sample.dif
redtt --PERL format --list
redtt --PERL raster -i sample.dif -f 4
redtt --PERL loop --mode fer -i sample.dif --repeat 2
redtt --PERL config
```

### Subcommands

#### peek

Display DIF file metadata (layers, polygon count, size) without processing.

```
redtt --PERL peek --file sample.dif
```

#### format

Query the available compression format IDs and names.

```
redtt --PERL format --list
```

#### raster

Rasterize a single DIF file with specified format.

```
redtt --PERL raster -i sample.dif -f 4
```

| Option | Short | Description |
|--------|-------|-------------|
| `--input` | `-i` | Input DIF file |
| `--format` | `-f` | Format ID |

#### loop

Execute a benchmark loop over formats, repeats, or parameters.

```
redtt --PERL loop --mode fer -i sample.dif --repeat 2
```

| Option | Description |
|--------|-------------|
| `-i` | Input DIF file |
| `--mode` | Loop mode |
| `--repeat` | Repeat count |

#### config

Display or modify configuration.

```
redtt --PERL config
```

---

## --histos Mode

Convert DIF files to **run-length histogram CSV** output.

```
redtt --histos -i sample.dif -o output.csv -pw 0.5 -n 32 -r 64 -t 6
```

| Option | Default | Description |
|--------|---------|-------------|
| `-i` | — | Input DIF file (required) |
| `-o` | — | Output CSV file (required) |
| `-pw` | `1` | Pixel width (μm) |
| `-n` | `32` | Oblique factor |
| `-r` | `32` | Histogram bin width |
| `-t` | `4` | Thread count |

---

## --thumb Mode

Generate a **PNG thumbnail** from a DIF file.

```
redtt --thumb -i sample.dif -o thumb.png -p 64
```

| Option | Default | Description |
|--------|---------|-------------|
| `-i` | — | Input DIF file (required) |
| `-o` | — | Output PNG file (required) |
| `-p` | `64` | Pixel size (μm; 32–128) |

The color palette is read from `d2thumb.json` beside the executable.

---

## Quick Start

### Interactive REPL (recommended)

```
redtt --REPL

> dif D:\geoms\sample.dif
> pw 0.5
> N 32
> format 4
> RT 8
> bench 4            # in-memory benchmark
> go y 4 csv         # rasterize + save + CSV
> ss n=8,16,32 pw=0.5,1   # parameter sweep
> help               # command reference
> save
> quit
```

### CLI one-shot

```
redtt loop --mode fer -i D:\geoms\sample.dif -f 4 --repeat 2
```

### Automation (scripts / CI / LLM)

```
redtt --PERL raster -i D:\geoms\sample.dif -f 4
redtt --PERL loop --mode fer -i D:\geoms\sample.dif --repeat 3
```

### Histogram / Thumbnail

```
redtt --histos -i D:\geoms\sample.dif -o out.csv -pw 0.5 -n 32
redtt --thumb -i D:\geoms\sample.dif -o thumb.png -p 64
```

### Batch decode

```
redtt
> un D:\compressed\ D:\decoded\   # directory decode to disk
```

### Persisting default mode

```
# Set REPL as default mode
redtt config --work-mode repl
redtt          # now enters REPL by default
```

---

## Configuration File

Configuration is persisted to `redtt.json` beside the executable
(default path from `TestConfig::GetDefaultConfigPath()`).

```json
{
  "global": {
    "workMode": "repl",
    "computer": "LOCAL",
    "output": "D:\\outputs"
  }
  // ... other settings
}
```

---

## Output Layout

```
{output}/
+-- *.csv                         # Strip CSVs from ss/loop
+-- tasks.session                 # SS checkpoint file
+-- tasks.failed.csv              # Failure log
+-- logs/
|   +-- {name}_{date}_{time}.log  # Sweep logs
+-- legacy/                       # Migrated legacy CSVs
```

---

## Legacy Executables (Obsolete)

| Legacy Tool | redtt Equivalent | Status |
|-------------|------------------|--------|
| `redcli.exe` | `redtt --PERL` | No longer built; use `--PERL` |
| `d2histos.exe` | `redtt --histos` | No longer built; use `--histos` |
| `d2thumb.exe` | `redtt --thumb` | No longer built; use `--thumb` |

---

## See Also

- `docs/0002.raster.md` — Rasterization internals
- `docs/0003.loop.md` — Loop mode and parameter sweeps
- `docs/IMPLEMENTATION_PLAN.md` — Refactor plan
- `raster/libred/docs/MESSAGES.md` — Static strings (TR/TRF)