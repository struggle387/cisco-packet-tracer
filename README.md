# Packet Tracer Scoop bucket

Install Cisco Packet Tracer **9.0.1 for Windows x64** with [Scoop](https://scoop.sh/).

## Install

Run these commands in PowerShell with Scoop already installed:

```powershell
scoop bucket add packet-tracer https://github.com/struggle387/cisco-packet-tracer
scoop install packet-tracer/packettracer
```

Packet Tracer's documents and settings are stored automatically in `scoop\persist\packettracer\documents`. Its User Folder points there through a junction at `%USERPROFILE%\CiscoPacketTracer-Scoop`.
