# system_care.sh

A small Bash script that checks disk usage, memory usage, and CPU load average, and reports whether anything is over a set threshold. Colored terminal output, results are logged to a file.

## ✨ Features

- Disk usage check — flags it if `/` is over the threshold
- Memory usage check — flags it if RAM usage is over the threshold
- Load average check — scales automatically to however many CPU cores the machine has, so the same script works on a 1-core VM or an 8-core desktop
- Colored output — green for all clear, red/yellow for warnings
- Logging — every run appends a line to `~/systemcare.log`

## 📋 Requirements

- Bash
- `bc` (used for the decimal load-average comparison)

## 🚀 Usage

Save the script as `system_care.sh`, then:

```bash
chmod +x system_care.sh
./system_care.sh
```

Example output:

```
System care check 2026-09-28 15:48:02
  Disk usage:   22%
  Memory usage: 51%
  Load average: 0.57

✓ All clear
```

If something's over a threshold:

```
⚠ Warnings:
  - Disk usage is at 87% (threshold 80%)
```

## ⚙️ How it works

On each run, the script:

1. Checks disk usage via `df /`
2. Checks memory usage via `free -m`
3. Checks the 1-minute load average via `uptime`, compared against a threshold scaled by core count (`nproc`)
4. Prints a summary
5. Appends a line to `~/systemcare.log`

To run it automatically, add it to cron:

```bash
crontab -e
```

```
0 9 * * * /full/path/to/system_care.sh
```

## 🛠 Configuration

Thresholds are set at the top of the script:

```bash
disk_threshold=80
memory_threshold=85
```

Load threshold is derived automatically from core count.

## 🐛 Troubleshooting

If `bc: not found`, install it:
```bash
sudo apt install bc
```

If you get a syntax error mentioning `"("`, the script is being run by `sh` instead of `bash`. Run it as `bash system_care.sh`, or make sure the first line of the file is `#!/bin/bash`.