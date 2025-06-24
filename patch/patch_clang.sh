#!/bin/bash
set -e

echo "🔧 [Xperience Patch] Applying Clang and Soong patches..."

PATCH_DIR="vendor/xperience/patch"

backup_file() {
    local target="$1"
    if [ -f "$target" ] && [ ! -f "$target.bak" ]; then
        cp "$target" "$target.bak"
        echo "🗂  Backed up $target to $target.bak"
    fi
}

replace_if_different() {
    local src="$1"
    local dst="$2"

    if [ ! -f "$src" ]; then
        echo "❗ Source patch $src not found, skipping"
        return
    fi

    if [ ! -f "$dst" ]; then
        echo "❗ Target $dst does not exist, skipping"
        return
    fi

    if cmp -s "$src" "$dst"; then
        echo "✅ $dst is already patched, skipping"
    else
        backup_file "$dst"
        echo "📁 Replacing $dst"
        rsync -a "$src" "$dst"
    fi
}

replace_if_different "$PATCH_DIR/Android.bp.bk" "prebuilts/clang/host/linux-x86/Android.bp"
replace_if_different "$PATCH_DIR/clangprebuilts.go.bk" "build/soong/cc/config/clangprebuilts.go"

echo "✅ [Xperience Patch] Done."