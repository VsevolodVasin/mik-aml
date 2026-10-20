# MIK-AML (macOS)

macOS-порт **Multi Image Kitchen** и **Amlogic USB Burning Tool** для работы с образами Khadas VIM3 / VIM3L (Amlogic).

Автор: **Vsevolod Vasin** · [github.com/VsevolodVasin](https://github.com/VsevolodVasin/)

## Что умеет

- **MIK** — разобрать / собрать Amlogic `.img`, распаковать и собрать ext4-разделы (`system`, `vendor`, …).
- **Burning Tool** — импорт образа и прошивка через Khadas `aml-burn-tool` / `flash-tool` (`--soc=g12a` для VIM3L).

## Требования

- macOS 12+ (Apple Silicon или Intel)
- [Homebrew](https://brew.sh) e2fsprogs: `brew install e2fsprogs`
- Для прошивки: [Khadas aml-flash-tool](https://github.com/khadas/utils/tree/master/aml-flash-tool) (`aml-burn-tool` в `/usr/local/bin`)
- Python 3.11+ (для запуска из исходников)

## Быстрый старт (из исходников)

```bash
git clone https://github.com/VsevolodVasin/mik-aml.git
cd mik-aml
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
./MIK.command                 # Multi Image Kitchen
./"Burning Tool.command"      # USB Burning Tool
```

Или:

```bash
.venv/bin/python -m mik_aml mik
.venv/bin/python -m mik_aml burn [/path/to/image.img]
```

## DMG-релизы

Готовые `.dmg` публикуются в [Releases](https://github.com/VsevolodVasin/mik-aml/releases).

Сборка локально (нужен принятый Xcode license: `sudo xcodebuild -license accept`):

```bash
./scripts/build_dmg.sh
# артефакты: dist/MIK-AML-*.dmg
```

Релизы также собираются GitHub Actions по тегу `v*` (workflow `release-dmg.yml`).

## Лицензия

Код этого репозитория — **GPL-3.0** (см. [LICENSE](LICENSE)).  
Сторонние компоненты (MIK AGPL-исходник как референс, Amlogic packer, PyQt6) — в [THIRD_PARTY.md](THIRD_PARTY.md).

## Благодарности

- [ColdWindScholar/MIK](https://github.com/ColdWindScholar/MIK) — раскладка и строки MIK  
- Amlogic USB Burning Tool V2 — ориентир UI  
- [Khadas utils](https://github.com/khadas/utils) — `aml_image_v2_packer`, aml-flash-tool  
