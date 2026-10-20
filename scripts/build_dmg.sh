#!/bin/bash
# Сборка .app + .dmg для MIK и Burning Tool (macOS).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
VERSION="${VERSION:-1.0.0}"
ARCH="$(uname -m)"
OUT="$ROOT/dist"
STAGE="$OUT/stage"
VENV="$ROOT/.venv"

if [[ ! -x "$VENV/bin/python" ]]; then
  python3 -m venv "$VENV"
fi
"$VENV/bin/pip" install -q -r requirements.txt 'pyinstaller>=6.6'

# PyInstaller ищет ресурсы относительно frozen root
export PYTHONPATH="$ROOT"

rm -rf "$OUT/MIK" "$OUT/MIK.app" "$OUT/Burning Tool" "$OUT/Burning Tool.app" "$STAGE"
mkdir -p "$STAGE" "$OUT"

"$VENV/bin/pyinstaller" --noconfirm --clean \
  --name MIK \
  --windowed \
  --icon "$ROOT/assets/mik.icns" \
  --osx-bundle-identifier com.vsevolodvasin.mik-aml.mik \
  --add-binary "$ROOT/bin/aml_image_v2_packer:bin" \
  --add-data "$ROOT/assets:assets" \
  --add-data "$ROOT/LICENSE:." \
  --add-data "$ROOT/THIRD_PARTY.md:." \
  --add-data "$ROOT/NOTICE:." \
  --paths "$ROOT" \
  "$ROOT/scripts/run_mik.py"

"$VENV/bin/pyinstaller" --noconfirm --clean \
  --name "Burning Tool" \
  --windowed \
  --icon "$ROOT/assets/ubt.icns" \
  --osx-bundle-identifier com.vsevolodvasin.mik-aml.burn \
  --add-data "$ROOT/assets:assets" \
  --add-data "$ROOT/LICENSE:." \
  --add-data "$ROOT/THIRD_PARTY.md:." \
  --add-data "$ROOT/NOTICE:." \
  --paths "$ROOT" \
  "$ROOT/scripts/run_burn.py"

# Copyright в Info.plist
for app in "$OUT/MIK.app" "$OUT/Burning Tool.app"; do
  /usr/libexec/PlistBuddy -c "Set :NSHumanReadableCopyright Copyright © 2026 Vsevolod Vasin" "$app/Contents/Info.plist" 2>/dev/null \
    || /usr/libexec/PlistBuddy -c "Add :NSHumanReadableCopyright string Copyright © 2026 Vsevolod Vasin" "$app/Contents/Info.plist"
  /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VERSION" "$app/Contents/Info.plist" 2>/dev/null || true
done

cp -R "$OUT/MIK.app" "$STAGE/"
cp -R "$OUT/Burning Tool.app" "$STAGE/"
cp "$ROOT/LICENSE" "$ROOT/THIRD_PARTY.md" "$ROOT/NOTICE" "$ROOT/README.md" "$STAGE/"

# README для установки e2fsprogs / burn tool
cat > "$STAGE/Dependencies.txt" <<EOF
MIK-AML $VERSION — Vsevolod Vasin
https://github.com/VsevolodVasin/mik-aml

Нужно на машине:
  brew install e2fsprogs
  # прошивка:
  # https://github.com/khadas/utils/tree/master/aml-flash-tool
EOF

DMG_NAME="MIK-AML-${VERSION}-macos-${ARCH}.dmg"
rm -f "$OUT/$DMG_NAME"

if command -v create-dmg >/dev/null 2>&1; then
  create-dmg \
    --volname "MIK-AML $VERSION" \
    --window-pos 200 120 \
    --window-size 640 400 \
    --icon-size 100 \
    --app-drop-link 480 200 \
    "$OUT/$DMG_NAME" \
    "$STAGE"
else
  hdiutil create -volname "MIK-AML $VERSION" -srcfolder "$STAGE" -ov -format UDZO "$OUT/$DMG_NAME"
fi

echo "OK: $OUT/$DMG_NAME"
ls -lh "$OUT/$DMG_NAME"
