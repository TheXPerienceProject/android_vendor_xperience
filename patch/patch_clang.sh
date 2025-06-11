#!/bin/bash
# (C) 2025 Carlos 'klozz' Jesus <carlosj@klozz.dev>
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/../../../" 
#ROOT_DIR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || realpath "$SCRIPT_DIR/../../..")"
PATCH_DIR="$ROOT_DIR/vendor/xperience/patch"
CLANG_DIR="$ROOT_DIR/prebuilts/clang/host/linux-x86"
PATCH_FILE="$PATCH_DIR/0001-fix-preqpr2-build.patch"

echo "🔧 [Xperience Patch] Applying Clang and Soong patches..."
echo "📂 Working dir: $ROOT_DIR"

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

# Extrae el subject del parche
PATCH_SUBJECT=$(grep -m1 '^Subject:' "$PATCH_FILE" | sed 's/^Subject: //')

# Verifica si ya fue aplicado
if git -C "$CLANG_DIR" log --oneline | grep -Fq "$PATCH_SUBJECT"; then
    echo "ℹ️  Patch '$PATCH_SUBJECT' already applied. Skipping."
else
    echo "📌 Applying patch: $PATCH_FILE"
    if git -C "$CLANG_DIR" apply --check "$PATCH_FILE"; then
        git -C "$CLANG_DIR" am "$PATCH_FILE"
        echo "✅ Patch applied successfully."
    else
        echo "❌ Patch cannot be applied (already applied or conflicts)."
    fi
fi

echo "✅ [Xperience Patch] Done."
