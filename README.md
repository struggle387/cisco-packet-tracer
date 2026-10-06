# Packet Tracer Scoop bucket

[![Validate manifest](https://github.com/struggle387/scoop-packet-tracer/actions/workflows/validate.yml/badge.svg)](https://github.com/struggle387/scoop-packet-tracer/actions/workflows/validate.yml)

Install Cisco Packet Tracer **9.0.1 for Windows x64** with [Scoop](https://scoop.sh/). The installer reports build **9.0.1.858**.

## Install

Run these commands in PowerShell with Scoop already installed:

```powershell
scoop bucket add packet-tracer https://github.com/struggle387/scoop-packet-tracer
scoop install packet-tracer/packettracer
```

Launch **Cisco Packet Tracer** from the Start menu, or run:

```powershell
packettracer
```

To open a lab from the command line:

```powershell
packettracer "C:\Labs\example.pkt"
```

Scoop extracts the Inno Setup installer into its application directory and automatically obtains its `innounp` extraction helper. This avoids running the system installer. The package creates a command shim and a Start menu shortcut with the correct working directory, and sets the user environment variable `PT8HOME`, matching the standard installer.

Packet Tracer includes its runtime DLLs. This manifest supports x64 Windows only. Sign in with your Cisco account when the application asks, and review Cisco's software license before use.

## Downloads and integrity

- [Download page supplied for this package](https://www.computernetworkingnotes.com/ccna-study-guide/download-packet-tracer-for-windows-and-linux.html)
- [Packet Tracer 9.0.1 Windows installer on Archive.org](https://archive.org/download/cisco-packet-tracer-901-mac-os-64bit/CiscoPacketTracer_901_win_64bit.exe)
- [Archive.org file metadata](https://archive.org/metadata/cisco-packet-tracer-901-mac-os-64bit)
- [Official Cisco Packet Tracer page](https://www.netacad.com/cisco-packet-tracer)

The Archive.org item name mentions macOS, but the selected file is the Windows x64 installer. Archive.org is a third-party mirror. The manifest pins this specific file with SHA256:

```text
615e60ba1d58ec2f61bf7f0d5e7fcc735d0204ef769c6a741db5165c854efdeb
```

The original installer was checked against Archive.org's file size and SHA1 metadata and has a valid Authenticode signature from **CISCO SYSTEMS, INC.** Scoop checks the SHA256 before extraction.

This repository contains only packaging files. Cisco's proprietary installer and extracted application files are not redistributed here. The MIT license covers this repository's packaging code only; Cisco Packet Tracer retains its own license.

## Updates, saved files, and removal

```powershell
scoop update
scoop update packettracer
scoop uninstall packettracer
```

The manifest is pinned to 9.0.1. A maintainer must verify a new installer and update the manifest before `scoop update packettracer` can install a newer version. There is no speculative download URL or automatic version scraping for future releases.

Keep your own labs in a separate directory such as `Documents\Packet Tracer`. Packet Tracer manages its own user folder for settings, configurations, saves, and templates; it can be selected under **Options > Preferences > Administrative**. Files saved inside Scoop's versioned installation directory can be removed during updates or uninstall. File associations and the `pttp` assessment protocol are not registered by this package.

## Validate or maintain the manifest

The manifest follows Scoop's [app manifest documentation](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests) and [bucket layout](https://github.com/ScoopInstaller/Scoop/wiki/Buckets). Its Inno extraction, architecture block, alias shim, and shortcut structure were also compared with the official [Persepolis manifest](https://github.com/ScoopInstaller/Extras/blob/master/bucket/persepolis.json).

GitHub Actions validates the JSON against Scoop's current official schema on pushes and pull requests. For a local check, use PowerShell 7.3 or later:

```powershell
$schema = Join-Path (scoop prefix scoop) 'schema.json'
./scripts/Test-Manifest.ps1 -SchemaPath $schema
```

To additionally verify a downloaded installer and an extracted application directory:

```powershell
./scripts/Test-Manifest.ps1 -SchemaPath $schema `
    -InstallerPath ./CiscoPacketTracer_901_win_64bit.exe `
    -ExtractedPath ./extracted-app
```

Before changing versions, check the source URL, hash, Cisco signature, application version, extraction, launch behavior, shim, and shortcut. Do not upload Cisco installers or extracted files to the repository.

Validation on 2026-10-06 passed against the current official Scoop schema. An isolated test using Scoop's actual install functions verified the cached installer hash, Inno extraction, `current` junction, command shim, shortcut target and working directory, and `PT8HOME` expansion. Scoop's shim, shortcut, and environment removal functions also passed. System integration was redirected into the test workspace and process. The extracted executable stayed running during a startup smoke test; interactive Cisco sign-in was not tested.
