#!/bin/bash
# Script to compile MVCBr packages

set -e

PROJECT_BASE="${PROJECT_BASE:-$HOME/project}"
PROJECT_DIR="$PROJECT_BASE/MVCBr"
DELPHI_DEPLOY="$PROJECT_BASE/delphi_deploy"
PACKAGE_DIR="$PROJECT_DIR/package"
DCU_DIR="$PROJECT_DIR/dcu"

# Wine paths with Z: prefix
to_winpath() {
    echo "Z:$1"
}

PROJECT_DIR_WIN=$(to_winpath "$PROJECT_DIR")
DELPHI_DEPLOY_WIN=$(to_winpath "$DELPHI_DEPLOY")
DCU_DIR_WIN=$(to_winpath "$DCU_DIR")
PACKAGE_DIR_WIN=$(to_winpath "$PACKAGE_DIR")
DCC32_WIN=$(to_winpath "$DELPHI_DEPLOY/cmp/DCC32.EXE")

# Compiler flags
CFLAGS='-AWinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE;'
CFLAGS+=' -NS"Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell;System;Xml;Data;Datasnap;Web;Soap;Winapi;Windows;System.Win;VCLTee"'

# Unit search path
UPATH="$PROJECT_DIR_WIN;$PROJECT_DIR_WIN/helpers;$PROJECT_DIR_WIN/VCL;$PROJECT_DIR_WIN/FMX;$PROJECT_DIR_WIN/UniGui;$PROJECT_DIR_WIN/package;$DELPHI_DEPLOY_WIN/cmp/dcu;$DELPHI_DEPLOY_WIN/cmp/bpl"

# Output directory
OUT_FLAGS="-NO$DCU_DIR_WIN -LE$DCU_DIR_WIN -LN$DCU_DIR_WIN"

# List of packages to compile
PACKAGES=(
    "MVCBrCore.dpk"
    "MVCBr.dpk"
    "MVCBrVCL.dpk"
    "MVCBrFMX.dpk"
    "MVCBrFireDAC.dpk"
    "MVCBrVCLWinX.dpk"
)

echo "=== Compiling MVCBr Packages ==="
cd "$PACKAGE_DIR"

# Create dcu directory if not exists
mkdir -p "$DCU_DIR"

for pkg in "${PACKAGES[@]}"; do
    echo ""
    echo "=== Compiling $pkg ==="
    wine "$DCC32_WIN" "$PACKAGE_DIR_WIN/$pkg" $CFLAGS $OUT_FLAGS -U"$UPATH" -I"$UPATH"
done

echo ""
echo "=== All packages compiled successfully ==="