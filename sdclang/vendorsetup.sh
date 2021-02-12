# Set SDClang defaults
export SDCLANG=true
export SDCLANG_PATH=vendor/qcom/sdclang/linux-x86/bin
export SDCLANG_LTO_DEFS=vendor/xperience/sdclang/sdllvm-lto-defs.mk
export SDCLANG_COMMON_FLAGS="-Wno-alloca -Wno-bool-operation -Wno-c++17-extensions -Wno-c99-designator -Wno-dangling-gsl -Wno-deprecated-anon-enum-enum-conversion -Wno-deprecated-copy -Wno-deprecated-enum-enum-conversion -Wno-final-dtor-non-final-class -Wno-implicit-fallthrough -Wno-implicit-int-float-conversion -Wno-incomplete-setjmp-declaration -Wno-int-in-bool-context -Wno-invalid-partial-specialization -Wno-misleading-indentation -Wno-pointer-compare -Wno-range-loop-analysis -Wno-reorder-init-list -Wno-sizeof-array-div-Wno-xor-used-as-pow -Wno-string-compare -Wno-tautological-overlap-compare -Wno-thread-safety-analysis -Wno-unknown-warning-option -Wno-unsequenced -Wno-unused-comparison -Wno-wrong-info -Wno-zero-as-null-pointer-constant -flax-vector-conversions=all -fsplit-lto-unit"

# Enable based on host OS/availablitiy
case $(uname -s) in
    Linux)
        if [ -d "$SDCLANG_PATH" ]; then
            export SDCLANG=true
        fi
        ;;
    Darwin)
        ;;
    *)
        ;;
esac
