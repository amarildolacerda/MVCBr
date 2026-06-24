#!/bin/bash
# Script to compile and run MVCBr tests

set -e

PROJECT_BASE="${PROJECT_BASE:-$HOME/project}"
PROJECT_DIR="$PROJECT_BASE/MVCBr"
DELPHI_DEPLOY="$PROJECT_BASE/delphi_deploy"
TESTS_DIR="$PROJECT_DIR/Tests"
DCU_DIR="$PROJECT_DIR/dcu"

# Wine paths with Z: prefix
to_winpath() {
    echo "Z:$1"
}

PROJECT_DIR_WIN=$(to_winpath "$PROJECT_DIR")
DELPHI_DEPLOY_WIN=$(to_winpath "$DELPHI_DEPLOY")
DCU_DIR_WIN=$(to_winpath "$DCU_DIR")
DCC32_WIN=$(to_winpath "$DELPHI_DEPLOY/cmp/DCC32.EXE")

# Compiler flags
CFLAGS='-AWinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE;'
CFLAGS+=' -NS"Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell;System;Xml;Data;Datasnap;Web;Soap;Winapi;Windows;System.Win;VCLTee"'

# Unit search path - include project root for source units
UPATH="$PROJECT_DIR_WIN;$PROJECT_DIR_WIN/helpers;$PROJECT_DIR_WIN/VCL;$PROJECT_DIR_WIN/FMX;$PROJECT_DIR_WIN/UniGui;$PROJECT_DIR_WIN/package;$DELPHI_DEPLOY_WIN/cmp/dcu;$DELPHI_DEPLOY_WIN/cmp/bpl"

# Output directory
OUT_FLAGS="-NO$DCU_DIR_WIN -LE$DCU_DIR_WIN -LN$DCU_DIR_WIN"

echo "=== Compiling MVCBr Tests ==="
cd "$TESTS_DIR"

# Create dcu directory if not exists
mkdir -p "$DCU_DIR"

# Compile the test project
wine "$DCC32_WIN" "MVCBrTests.dpr" -DVCL -DCONSOLE_TESTRUNNER $CFLAGS $OUT_FLAGS -U"$UPATH" -I"$UPATH"

echo "=== Running Tests ==="
if [ -f "MVCBrTests.exe" ]; then
    wine MVCBrTests.exe
else
    echo "ERROR: Test executable not found!"
    exit 1
fi