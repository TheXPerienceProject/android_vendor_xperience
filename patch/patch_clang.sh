#!/bin/bash
set -e

echo "🔧 [Xperience Patch] Applying Clang and Soong patches..."

PATCH_DIR="vendor/xperience/patch"
CLANG_DIR="prebuilts/clang/host/linux-x86"
PATCH_FILE="$PATCH_DIR/0001-fix-preqpr2-build.patch"

# Verifica que sea un repo git válido
if [ ! -d "$CLANG_DIR/.git" ]; then
    echo "⚠️  $CLANG_DIR is not a Git repository. Initializing..."
    git -C "$CLANG_DIR" init
    git -C "$CLANG_DIR" add .
    git -C "$CLANG_DIR" commit -m "Initial commit for patching" >/dev/null 2>&1 || true
fi

# Aplica el parche si no se ha aplicado antes
echo "📌 Applying patch: $PATCH_FILE"
if [ ! -f "$PATCH_FILE" ]; then
    echo "❗ Patch file $PATCH_FILE not found."
    exit 1
fi

if git -C "$CLANG_DIR" apply --check "$PATCH_FILE"; then
    git -C "$CLANG_DIR" am "$PATCH_FILE"
    echo "✅ Patch applied successfully."
else
    echo "⚠️  Patch may already be applied or conflicts found. Skipping."
fi

echo "✅ [Xperience Patch] Done."