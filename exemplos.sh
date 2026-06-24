#!/bin/bash
# Script to compile and run MVCBr VCL examples

PROJECT_BASE="${PROJECT_BASE:-$HOME/project}"
PROJECT_DIR="$PROJECT_BASE/MVCBr"
DELPHI_DEPLOY="$PROJECT_BASE/delphi_deploy"
EXEMPLOS_DIR="$PROJECT_DIR/Exemplos/vcl"
DCU_DIR="$PROJECT_DIR/dcu"

# Wine paths with Z: prefix
to_winpath() {
    echo "Z:$1"
}

PROJECT_DIR_WIN=$(to_winpath "$PROJECT_DIR")
DELPHI_DEPLOY_WIN=$(to_winpath "$DELPHI_DEPLOY")
DCU_DIR_WIN=$(to_winpath "$DCU_DIR")
EXEMPLOS_DIR_WIN=$(to_winpath "$EXEMPLOS_DIR")
DCC32_WIN=$(to_winpath "$DELPHI_DEPLOY/cmp/DCC32.EXE")

# Compiler flags
CFLAGS='-AWinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE;'
CFLAGS+=' -NS"Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell;System;Xml;Data;Datasnap;Web;Soap;Winapi;Windows;System.Win;VCLTee"'

# Unit search path
UPATH="$PROJECT_DIR_WIN;$PROJECT_DIR_WIN/helpers;$PROJECT_DIR_WIN/VCL;$PROJECT_DIR_WIN/FMX;$PROJECT_DIR_WIN/UniGui;$PROJECT_DIR_WIN/package;$DELPHI_DEPLOY_WIN/cmp/dcu;$DELPHI_DEPLOY_WIN/cmp/bpl"

# Output directory
OUT_FLAGS="-NO$DCU_DIR_WIN -LE$DCU_DIR_WIN -LN$DCU_DIR_WIN"

# List of examples to compile
EXAMPLES=(
    "basico/ExemploBasico.dpr"
    "Clientes/Clientes.dpr"
    "Grupo/Grupo.dpr"
    "ModuloBasico/ModuloModelExemplo.dpr"
)

echo "=== Compiling MVCBr VCL Examples ==="
cd "$EXEMPLOS_DIR"

# Create dcu directory if not exists
mkdir -p "$DCU_DIR"

FAILED=0
PASSED=0

for example in "${EXAMPLES[@]}"; do
    echo ""
    echo "=== Compiling $example ==="
    # Change to the example's directory for relative paths
    EXAMPLE_DIR=$(dirname "$example")
    EXAMPLE_FILE=$(basename "$example")
    
    cd "$EXEMPLOS_DIR/$EXAMPLE_DIR"
    EXAMPLE_DIR_WIN=$(to_winpath "$EXEMPLOS_DIR/$EXAMPLE_DIR")
    
    if wine "$DCC32_WIN" "$EXAMPLE_DIR_WIN/$EXAMPLE_FILE" $CFLAGS $OUT_FLAGS -U"$UPATH" -I"$UPATH"; then
        echo "SUCCESS: $example"
        ((PASSED++))
    else
        echo "FAILED: $example"
        ((FAILED++))
    fi
    cd "$EXEMPLOS_DIR"
done

echo ""
echo "=== Summary ==="
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ $FAILED -eq 0 ]; then
    echo ""
    echo "=== All examples compiled successfully ==="
    echo "=== Running ExemploBasico ==="
    
    # Run the basic example
    cd "$EXEMPLOS_DIR/basico"
    if [ -f "ExemploBasico.exe" ]; then
        wine ExemploBasico.exe
    else
        echo "ERROR: ExemploBasico.exe not found!"
        exit 1
    fi
else
    echo "Some examples failed to compile."
    exit 1
fi