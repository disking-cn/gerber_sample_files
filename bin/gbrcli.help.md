## gbrcli --- Gerber-to-DIF Converter

`gbrcli` is a command-line tool to convert Gerber files into DIF (Design Interface Format) format. It supports single file processing, batch processing, and configuration via JSON files.

## Version
1.7.1.26 (Links against the `gerber` library)

## Usage

### 1. Single File Mode
Process a single Gerber file.
```bash
gbrcli --input <gbr_file> [--output <dif_file>] [options]
# Example
gbrcli -i board.gbr -o board.dif
```

### 2. Batch Mode
Process all Gerber files in a directory.
```bash
gbrcli --mode batch --input-dir <dir> [--output-dir <dir>] [options]
```

### 3. Configuration
Use or create a JSON configuration file to persist settings.
```bash
# Create or open the default gbrcli.json in the current directory
gbrcli config

# Use a specific config file
gbrcli --config <json_file> [options]
```

## Options

| Option | Short | Argument | Description |
| :--- | :--- | :--- | :--- |
| `--input` | `-i` | `<path>` | Input Gerber file path (single mode) |
| `--output` | `-o` | `<path>` | Output DIF file path (default: `<input>.dif`) |
| `--mode` | | `single\|batch` | Processing mode (default: `single`) |
| `--input-dir` | | `<path>` | Input directory for batch mode |
| `--output-dir` | | `<path>` | Output directory for batch mode (default: input-dir) |
| `--output-format` | | `<n>` | Output file format (default: 1 = DIF) |
| `--output-version` | | `<n>` | DIF version, 0xMMm (default: 30 = v3.0) |
| `--storage-unit` | | `<n>` | Unit: 1=nm, 2=µm, 3=mm, 4=mil, 5=inch (default: 3) |
| `--convert-mode` | | `<n>` | 0=rescale to unit, 1=passthrough (default: 0) |
| `--accuracy` | | `<nm>` | Loss threshold in nm, [1,10000] (default: 1000) |
| `--scale-x` | | `<f>` | X-axis scale factor (default: 1.0) |
| `--scale-y` | | `<f>` | Y-axis scale factor (default: 1.0) |
| `--precision-scale` | | `<n>` | Internal precision multiplier (default: 10000) |
| `--rotate-flip` | | `<n>` | 0=none, 1=90°CW, 2=180°, 3=270°CW, 4=flip, 5-7=rot+flip |
| `--verbose` | | | Enable verbose output |
| `--version` | | | Show version and copyright information |
| `--help` | `-h` | | Show this help message |

## Configuration File (gbrcli.json)

You can define settings in a JSON file to avoid repetitive arguments.

```json
{
  "input": "board.gbr",
  "output": "board.dif",
  "input-dir": "gerbers/",
  "output-dir": "results/",
  "mode": "single",
  "output-format": 1,
  "output-version": 30,
  "storage-unit": 3,
  "convert-mode": 0,
  "accuracy": 1000.0,
  "scale-x": 1.0,
  "scale-y": 1.0,
  "precision-scale": 10000,
  "rotate-flip": 0,
  "verbose": false
}
```

## Exit Codes

- `0`: Success
- `1`: Error (missing arguments, file not found, parse failure)
