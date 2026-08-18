#!/bin/bash
#   SPDX-FileCopyrightText: The XPerience Project
#   SPDX-License-Identifier: Apache-2.0
#

txtrst=$(tput sgr0)
txtbld=$(tput bold)
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
RESET='\033[0m'

# Función de degradado Rojo Granate (Estilo XPerience)
gradient_xperience() {
    local text="$1"
    local len=${#text}
    local result=""
    for ((i=0; i<len; i++)); do
        local r=$((120 + (i * 60 / len)))
        local g=$((0 + (i * 20 / len)))
        local b=$((30 + (i * 20 / len)))
        result+="\033[38;2;${r};${g};${b}m${text:$i:1}"
    done
    echo -e "${result}${txtrst}"
}

# ─── Entorno ────────────────────────────────────────────────────────────────
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ANDROID_ROOT="$( cd "$SCRIPT_DIR/../../.." && pwd )"
cd "$ANDROID_ROOT" || { echo -e "${RED}❌ It was not possible to switch to $ANDROID_ROOT${RESET}"; exit 1; }

# Leer versión de XPerience
VERSION_MAJOR=$(grep "^PRODUCT_VERSION_MAJOR" "$SCRIPT_DIR/../../config/version.mk" | sed 's/.*=[[:space:]]*//')
VERSION_MINOR=$(grep "^PRODUCT_VERSION_MINOR" "$SCRIPT_DIR/../../config/version.mk" | sed 's/.*=[[:space:]]*//')

# Leer aosp_target_release desde vendor/xperience/vars/aosp_target_release
AOSP_TARGET_FILE="$ANDROID_ROOT/vendor/xperience/vars/aosp_target_release"
if [ -f "$AOSP_TARGET_FILE" ]; then
    source "$AOSP_TARGET_FILE" 2>/dev/null
    if [ -z "$aosp_target_release" ]; then
        echo -e "${YELLOW}⚠️ The file $AOSP_TARGET_FILE does not contain the variable aosp_target_release.${RESET}"
        read -p "✏️ Enter the value of aosp_target_release (ej. cp2a): " aosp_target_release
        echo "aosp_target_release=$aosp_target_release" > "$AOSP_TARGET_FILE"
    fi
else
    echo -e "${YELLOW}⚠️ Not found $AOSP_TARGET_FILE. Creating a new one.${RESET}"
    read -p "✏️ Enter the value of aosp_target_release (ej. cp2a): " aosp_target_release
    mkdir -p "$(dirname "$AOSP_TARGET_FILE")"
    echo "aosp_target_release=$aosp_target_release" > "$AOSP_TARGET_FILE"
fi

# ─── Detectar CPU ───────────────────────────────────────────────────────────
CPU_MODEL=$(awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo | sed 's/^[ \t]*//')
CORES=$(nproc)
THREADS=$(lscpu | awk '/Thread\(s\) per core:/ {print $4}')
CORES_PER_SOCKET=$(lscpu | awk '/Core\(s\) per socket:/ {print $4}')
RAM_GB=$(free -g | awk '/^Mem:/{print $2}')

JOBS=$(( RAM_GB / 3 ))
[ "$JOBS" -lt 2 ] && JOBS=2

if echo "$CPU_MODEL" | grep -qiE "5950X"; then
    AOSP_CPU="Ryzen 9 5950X"
    MAX_JOBS=$((JOBS + 6))
    CCACHE_SIZE=64G
elif echo "$CPU_MODEL" | grep -qiE "5900XT"; then
    AOSP_CPU="Ryzen 9 5900XT"
    MAX_JOBS=$((JOBS + 4))
    CCACHE_SIZE=48G
elif echo "$CPU_MODEL" | grep -qiE "\b5900X\b"; then
    AOSP_CPU="Ryzen 9 5900X"
    MAX_JOBS=$((JOBS + 4))
    CCACHE_SIZE=48G
elif echo "$CPU_MODEL" | grep -qi "5700X"; then
    AOSP_CPU="Ryzen 7 5700X"
    MAX_JOBS=$((JOBS + 2))
    CCACHE_SIZE=24G
else
    AOSP_CPU="$CPU_MODEL"
    MAX_JOBS=$JOBS
    CCACHE_SIZE=12G
fi

#export NINJA_ARGS="-j$MAX_JOBS"
#export KATI_ARGS="-j$MAX_JOBS"
export NINJA_STATUS="🔧 [$AOSP_CPU ⚙ %p | ✅ %f/%t | 🚀 %o/sec | ⏳ %r sec left | ⌛ %e sec ]
"

# ─── Cabecera ──────────────────────────────────────────────────────────────
clear
echo -e "$(gradient_xperience "
██╗░░██╗██████╗░███████╗██████╗░██╗███████╗███╗░░██╗░█████╗░███████╗
╚██╗██╔╝██╔══██╗██╔════╝██╔══██╗██║██╔════╝████╗░██║██╔══██╗██╔════╝
░╚███╔╝░██████╔╝█████╗░░██████╔╝██║█████╗░░██╔██╗██║██║░░╚═╝█████╗░░
░██╔██╗░██╔═══╝░██╔══╝░░██╔══██╗██║██╔══╝░░██║╚████║██║░░██╗██╔══╝░░
██╔╝╚██╗██║░░░░░███████╗██║░░██║██║███████╗██║░╚███║╚█████╔╝███████╗
╚═╝░░╚═╝╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚══════╝╚═╝░░╚══╝░╚════╝░╚══════╝
")"
echo -e "════════════════════════════════════════════════════════════════════════════════"
echo -e "\n${MAGENTA}🧠 CPU detected:${RESET} ${GREEN}${CPU_MODEL}${RESET}"
echo -e "${CYAN}🧪 Compilation profile: ${YELLOW}${AOSP_CPU}${RESET}"
echo -e "${BLUE}🔧 Concurrent projects:${RESET} ${YELLOW}${MAX_JOBS}${RESET}"
echo -e "${BLUE}🧠 Cache size:${RESET} ${YELLOW}${CCACHE_SIZE}${RESET}"
echo -e "${BLUE}🔩 CPU:${RESET} ${CYAN}$CPU_MODEL${RESET} ${MAGENTA}—${RESET} ${YELLOW}$CORES${RESET} ${BLUE}núcleos${RESET} ${MAGENTA}(${RESET}${GREEN}$THREADS${RESET} ${BLUE}hilos/núcleo${RESET}, ${GREEN}$CORES_PER_SOCKET${RESET} ${BLUE}núcleos/socket${RESET}${MAGENTA})${RESET}"
echo -e "  ${txtbld}${CYAN}Building XPerience: ${VERSION_MAJOR}.${VERSION_MINOR}${RESET}"
echo -e "  ${CYAN}AOSP target release: ${GREEN}${aosp_target_release}${RESET}"
echo -e "════════════════════════════════════════════════════════════════════════════════"

# ─── Dispositivo ────────────────────────────────────────────────────────────
if [ -z "$1" ]; then
    read -p "🚀 Enter the device name (ej. lisa): " device
else
    device="$1"
fi

# ─── Tipo de compilación (Official/Unofficial) ────────────────────────────
echo -e "\n${CYAN}📦 Select the build type:${RESET}"
select build_type in "Official" "Unofficial"; do
    case $build_type in
        "Official")
            export XPE_BUILDTYPE=NIGHTLY
            export OTA_TYPE=nightly
            export XPERIENCE_CHANNEL=OFFICIAL
            break
            ;;
        "Unofficial")
            export XPE_BUILDTYPE=UNOFFICIAL
            export OTA_TYPE=unofficial
            export XPERIENCE_CHANNEL=UNOFFICIAL
            break
            ;;
        *)
            echo -e "${RED}❌ Invalid option.${RESET}"
            ;;
    esac
done

# ─── Variante (eng/userdebug/user) ────────────────────────────────────────
echo -e "\n${CYAN}🔧 Select the build variant:${RESET}"
select variant in "eng" "userdebug" "user"; do
    case $variant in
        "eng"|"userdebug"|"user")
            BUILD_VARIANT="$variant"
            break
            ;;
        *)
            echo -e "${RED}❌ Invalid option.${RESET}"
            ;;
    esac
done

# ─── Variables de entorno ──────────────────────────────────────────────────
export SELINUX_IGNORE_NEVERALLOWS=true
export SELINUX_IGNORE_PERMISSIVE=true
export SELINUX_IGNORE_NEVERALLOWS_ON_USER=true
export WITH_GMS=true
export date=$(date -u +%Y%m%d)

ccache -z

# ─── Configurar entorno ────────────────────────────────────────────────────
echo -e "\n${CYAN}🔧 Setting Up the Compilation Environment...${RESET}"
. build/envsetup.sh

if [[ "$device" == "sdk_phone_x86_64" ]]; then
    lunch "$device"-"$BUILD_VARIANT"
else
    lunch "xperience_${device}-${aosp_target_release}-${BUILD_VARIANT}"
fi

platform_version=$(get_build_var PLATFORM_VERSION)
platform_codename=$(get_build_var PLATFORM_VERSION_CODENAME)
echo -e "${CYAN}PLATFORM_VERSION_CODENAME: ${GREEN}${platform_codename}${RESET}"
echo -e "${CYAN}PLATFORM_VERSION: ${GREEN}${platform_version}${RESET}"

# ─── Limpieza previa ──────────────────────────────────────────────────────
echo -e "\n${YELLOW}🧼 Do you want to clean up before compiling?${RESET}"
select clean_opt in "No" "installclean" "Borrar out/"; do
    case $clean_opt in
        "No")
            echo -e "${GREEN}✅ Skipping cleaning.${RESET}"
            break
            ;;
        "installclean")
            echo -e "${MAGENTA}🧽 Running "make installclean."..${RESET}"
            make installclean
            break
            ;;
        "Borrar out/")
            echo -e "${RED}🗑️ Deleting the out/ directory...${RESET}"
            rm -rf out/
            break
            ;;
        *)
            echo -e "${RED}❌ Invalid option.${RESET}"
            ;;
    esac
done

# ─── Compilación ──────────────────────────────────────────────────────────
echo -e "\n${GREEN}🚀 Starting compilation...${RESET}"
time m bacon -j$MAX_JOBS

# ──────────────────────────────────────────────────────────────────────────
#  FUNCIONES POST‑BUILD
# ──────────────────────────────────────────────────────────────────────────

# Genera el OTA JSON a partir del ZIP y build.prop
generate_ota() {
    local device="$1"
    local out_dir="$ANDROID_ROOT/out/target/product/$device"
    local build_prop="$out_dir/product/etc/build.prop"

    if [[ ! -f "$build_prop" ]]; then
        echo -e "${RED}❌ No se encontró build.prop en $build_prop${RESET}"
        return 1
    fi

    local raw_ver=$(grep 'ro.xperience.build.version2=' "$build_prop" | sed 's/ro.xperience.build.version2=//')
    if [[ -z "$raw_ver" ]]; then
        echo -e "${RED}❌ ro.xperience.build.version2 no encontrado${RESET}"
        return 1
    fi

    local build_date=$(echo "$raw_ver" | cut -d'-' -f2)
    local build_time=$(echo "$raw_ver" | cut -d'-' -f3)

    parse_epoch() {
        local raw="$1"
        local formatted
        formatted="$(echo "$raw" | sed -E 's/([0-9]{8})([0-9]{2})([0-9]{2})([0-9]{2})/\1 \2:\3:\4/')"
        date -d "$formatted" +%s 2>/dev/null
    }

    local build_epoch=$(parse_epoch "${build_date}${build_time}")

    local matched_zip=""
    for zip in "$out_dir"/xperience-*.zip; do
        [[ ! -f "$zip" ]] && continue

        local zip_name=$(basename "$zip" .zip)
        local zip_date=$(echo "$zip_name" | cut -d'-' -f3)
        local zip_time=$(echo "$zip_name" | cut -d'-' -f4)

        [[ "$zip_date" =~ ^[0-9]{8}$ ]] || continue
        [[ "$zip_time" =~ ^[0-9]{6}$ ]] || continue

        local zip_epoch=$(parse_epoch "${zip_date}${zip_time}")
        local delta=$(( zip_epoch - build_epoch ))
        local abs_delta=${delta#-}

        echo -e "${CYAN}🔍 Reviewing: $zip${RESET}"
        echo "     ZIP_TS=${zip_date}${zip_time} | ZIP_EPOCH=$zip_epoch | Δ=$abs_delta seconds"

        if (( abs_delta <= 600 )); then
            matched_zip="$zip"
            break
        fi
    done

    if [[ -z "$matched_zip" ]]; then
        echo -e "${RED}❌ No ZIP was found within ±10 minutes${RESET}"
        return 1
    fi

    echo -e "${GREEN}✅ Match found: $matched_zip${RESET}"
    local final_zip_name=$(basename "$matched_zip")

    local xpe_version=$(echo "$raw_ver" | cut -d'-' -f1)

    local file_prop="$out_dir/system/build.prop"
    local file_timestamp=$(grep 'ro.build.date.utc=' "$file_prop" | grep -Eo '.{1,10}$')
    local file_md5=$(md5sum "$matched_zip" | awk '{print $1}')
    local file_size=$(stat -c%s "$matched_zip")
    local file_link="https://kota.klozz.dev/download/${device}/${final_zip_name}"

    # Crear changelog si no existe (opcional)
    local rom_log=~/changelog_xpe_${device}.txt
    [[ ! -f "$rom_log" ]] && echo "Changelog no disponible." > "$rom_log"

    local ota_json="${device}_ota.json"
    echo -e "${GREEN}✓ Generando OTA JSON: $ota_json${RESET}"

    cat <<EOF > "$ota_json"
{
  "folders": [],
  "files": [{
    "file": "$final_zip_name",
    "romtype": "${XPE_BUILDTYPE,,}",
    "filesize": "$file_size",
    "filemd5": "$file_md5",
    "fileTimestamp": $file_timestamp,
    "filelink": "$file_link",
    "version": "$xpe_version"
  }]
}
EOF

    echo -e "${GREEN}✓ JSON OTA generated successfully.${RESET}"
}

# Muestra el contenido del OTA JSON y lo copia al portapapeles
show_ota_json() {
    local ota_json="${device}_ota.json"
    if [[ ! -f "$ota_json" ]]; then
        echo -e "${RED}❌ JSON OTA not found: $ota_json${RESET}"
        return 1
    fi

    echo -e "\n${CYAN}📄 Content of $ota_json:${RESET}\n"
    echo -e "${YELLOW}----------------------------------------${RESET}"
    if command -v jq >/dev/null 2>&1; then
        jq . "$ota_json"
    else
        cat "$ota_json"
    fi
    echo -e "${YELLOW}----------------------------------------${RESET}\n"

    if command -v wl-copy >/dev/null 2>&1; then
        cat "$ota_json" | wl-copy
        echo -e "${GREEN}📋 Copied to the clipboard (wl-copy).${RESET}"
    elif command -v xclip >/dev/null 2>&1; then
        cat "$ota_json" | xclip -selection clipboard
        echo -e "${GREEN}📋 Copied to the clipboard (xclip).${RESET}"
    else
        echo -e "${YELLOW}⚠️ Clipboard tool not found. Copy manually.${RESET}"
    fi
}

# ─── Menú post‑build ──────────────────────────────────────────────────────
echo -e "\n${CYAN}📦 Post-build Actions:${RESET}"
select post_opt in "Nothing (exit)" "Generate OTA (ota.json)" "Publish build" "Show OTA json (copy)" "Generate OTA + Publish"; do
    case $post_opt in
        "Nothing (exit)")
            echo -e "${GREEN}✅ Done. I'm leaving.${RESET}"
            exit 0
            ;;
        "Generate OTA (ota.json)")
            generate_ota "$device"
            ;;
        "Publish build")
            echo -e "${BLUE}🚀 Publicando build para $device...${RESET}"
            ./publish.sh "$device" || { echo -e "${RED}❌ Failed publication.${RESET}"; exit 1; }
            echo -e "${YELLOW}⚠️ The publication script is commented out. Uncomment it if necessary and generate your own script..${RESET}"
            ;;
        "Show OTA json (copy)")
            show_ota_json
            exit 0
            ;;
        "Generate OTA + Publish")
            generate_ota "$device" || exit 1
            echo -e "${BLUE}🚀 Publishing a build for $device...${RESET}"
            ./publish.sh "$device" || { echo -e "${RED}❌ Failed publication.${RESET}"; exit 1; }
            echo -e "${YELLOW}⚠️ The publication script is commented out. Uncomment it if necessary and generate your own script..${RESET}"
            show_ota_json
            echo -e "${GREEN}✅ OTA + Publication completed. Signing off.${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid option.${RESET}"
            ;;
    esac
done