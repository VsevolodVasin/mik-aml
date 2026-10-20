# Third-party components

## Our code (this repository)

Copyright (c) 2026 Vsevolod Vasin  
License: **GNU GPL v3** (see [LICENSE](LICENSE))  
Required by PyQt6 (GPL-3.0-only).

## Multi Image Kitchen (UI reference)

- Upstream: [ColdWindScholar/MIK](https://github.com/ColdWindScholar/MIK)
- License: **AGPL-3.0**
- `third_party/MIK.pb` is the PureBasic source used only as a layout/menu reference.
- The macOS app is a separate PyQt6 implementation, not a binary of MIK.exe.

## Amlogic USB Burning Tool (UI reference)

- Original Windows tool by Amlogic, Inc. (no public source).
- This port recreates dialog layout from resources and LangEn.dll strings.
- Burning on macOS uses Khadas `aml-flash-tool`, not the Windows WorldCup driver.

## `bin/aml_image_v2_packer`

- Mach-O universal binary from the [Khadas utils](https://github.com/khadas/utils) toolkit lineage (`aml_image_v2_packer`).
- **Not covered by the GPL of this repository.** Redistributed as a vendor tool for Amlogic image pack/unpack.
- If you cannot accept that, remove `bin/aml_image_v2_packer` and supply your own compatible packer.

## Runtime dependencies

| Component | License | Notes |
|-----------|---------|--------|
| PyQt6 | GPL-3.0-only | Riverbank Computing |
| e2fsprogs (`debugfs`, `mke2fs`) | GPL-2.0 | via Homebrew |
| Khadas aml-flash-tool / aml-burn-tool | see Khadas utils | install separately for USB burn |
| MIK language files (`assets/mik/language/*.lng`) | from ColdWindScholar/MIK (AGPL) | UI strings |

## Trademarks

Amlogic, Khadas, Multi Image Kitchen and related names belong to their respective owners.
