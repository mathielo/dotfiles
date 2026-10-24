# omy-space

Home workstation: Intel i7-11700K on an ASUS ROG STRIX B560-F GAMING WIFI, NVIDIA RTX 3080,
and 4× 8 GB DDR4 from two Corsair kits.

| Slots            | Kit                  | Model                |
| ---------------- | -------------------- | -------------------- |
| A-DIMM0, B-DIMM0 | Vengeance RGB PRO    | `CMW16GX4M2C3200C16` |
| A-DIMM1, B-DIMM1 | Vengeance RGB PRO SL | `CMH16GX4M2E3200C16` |

## Faulty RAM

One module has a defective region. Memtest86+ fails a ~32 KB window at physical
`0x175ce81d8`–`0x175cefe98` (5.83 GB): every error is single-bit, on bits 58 and 61 only
(`Bits in Error Mask: 2400000000000000`). It is not known which DIMM holds it. On a running
system the faults show up as segfaults across unrelated processes, all with
`si_code=0x80` and `si_addr=0` (a #GP from a non-canonical pointer), plus the occasional
kernel oops.

A kernel parameter marks the page-aligned 64 KB block around the window as reserved, so
the kernel never allocates it:

```
memmap=0x10000%0x175ce0000-1+2
```

`memmap=<size>%<offset>-<oldtype>+<newtype>` changes the range's e820 type from 1 (RAM)
to 2 (reserved). A malformed value is rejected with `-EINVAL`, so a typo cannot take RAM
away.

**Never use the `$` form** (`memmap=0x10000$0x175ce0000`). Shells and boot-loader config
parsers expand `$0x…` as a variable, which leaves a bare `memmap=0x10000` — the kernel
reads that as "64 KB of usable RAM" and the boot hangs with no message. The Limine drop-ins
below are sourced by bash, so the hazard applies there too.

XMP stays **disabled** in the BIOS, so the memory runs at 2133 MT/s. The failing window
was measured at that speed and has not been characterised at 3200 MT/s. Clearing the CMOS
turns XMP back on. Check from Linux with
`sudo dmidecode -t memory | grep -i 'configured memory speed'`.

The physical address depends on which slots hold which DIMMs. After moving, adding or
removing a module, derive a new range before relying on this one.

### Applying it

Do this first on a fresh install. To have the installer itself run with the block
excluded, append the parameter to the kernel command line at the ISO's boot menu.

The boot entries are built by `limine-entry-tool`, which reads drop-ins from
`/etc/limine-entry-tool.d/`. The kernel-update hook rebuilds from the same files, so the
parameter carries over to every new kernel. The drop-in is
[`memmap-badram.conf`](memmap-badram.conf):

```bash
sudo install -m 644 ~/src/dotfiles/hosts/omy-space/memmap-badram.conf /etc/limine-entry-tool.d/
sudo limine-mkinitcpio
sudo grep -rl --text 'memmap=0x10000%0x175ce0000-1+2' /boot
```

The `grep` must print at least one file under `/boot`: with Omarchy's UKI setup, both
`EFI/Linux/omarchy_linux-omarchy.efi` and `limine.conf`. Snapshot boot entries made before
the drop-in existed don't carry the parameter, so boot the default entry. After rebooting,
confirm the hole exists:

```bash
journalctl -b -k | grep 'user: \[mem 0x000000017'
```

The output must show the reserved block, with System RAM resuming right after it:

```
user: [mem 0x0000000175ce0000-0x0000000175ceffff]  device reserved
user: [mem 0x0000000175cf0000-0x000000085fffffff]  System RAM
```

A missing parameter fails silently: the system boots and the crashes come back. Before
blaming the range for a new crash, check that the boot in question carried it —
`journalctl -b -N -k | grep -m1 'Command line:'`. Reading `/proc/iomem` as non-root shows
only zeros, so it proves nothing.

To remove it, delete the drop-in and run `sudo limine-mkinitcpio` again.

### Deriving a new range

1. Boot Memtest86+ with CPU mode set to `SEQ`. Parallel mode prints so many errors to the
   console that it looks frozen.

2. Set the error report mode to the Linux `memmap` list. Tests 0 and 7 are left out of
   that list because they can't pin an exact address.

3. Memtest86+ writes nothing to disk, so photograph the screen.

4. Round the reported span outward to 64 KB boundaries: the start down to a multiple of
   `0x10000`, and the size up to a multiple of `0x10000`.

## Monitors

| Output     | Monitor                     | Mode            | Placement                                                         |
| ---------- | --------------------------- | --------------- | ----------------------------------------------------------------- |
| `HDMI-A-1` | Dell U2414H                 | 1920×1080 @ 60  | Left, portrait (rotated 90° clockwise)                            |
| `DP-3`     | ASUS ROG PG348Q (ultrawide) | 3440×1440 @ 100 | Right, centred vertically on the Dell, G-Sync for fullscreen apps |

Both at scale 1. The layout is [`monitors.lua`](monitors.lua), linked to
`~/.config/hypr/monitors.lua` by `install.sh`. `omarchy-refresh-hyprland` (or
`omarchy-refresh-config hypr/monitors.lua`) copies Omarchy's default over it through the
link, which shows up as a diff in this repo: `git checkout hosts/omy-space/monitors.lua`
puts it back.

## Audio

A SteelSeries Arctis 7 headset, which shows up as two outputs: **Game** (stereo) and **Chat**
(mono, alongside the mic). The headset's ChatMix dial balances the two, so a dial turned
fully towards Chat leaves Game nearly silent. Game is the one to use.

[`wireplumber-arctis-7.conf`](wireplumber-arctis-7.conf), linked into
`~/.config/wireplumber/wireplumber.conf.d/` by `install.sh`, gives Game a higher priority
than Chat and names both "Arctis 7 Game" / "Arctis 7 Chat" in the audio panel
(`Super + Ctrl + A`). The priority only decides when nothing is chosen: an output picked
in the panel or with `Shift + Mute` is remembered across reboots in
`~/.local/state/wireplumber/default-nodes`. `wpctl status` marks the current default
with `*`.
