#!/bin/bash
# Script to compile and run MVCBr tests

set -e

PROJECT_DIR="/home/kzuca/project/MVCBr"
DELPHI_DEPLOY="/home/kzuca/project/delphi_deploy"
TESTS_DIR="$PROJECT_DIR/Tests"
DCU_DIR="$PROJECT_DIR/dcu"

# Wine paths with Z: prefix
PROJECT_DIR_WIN="Z:/home/kzuca/project/MVCBr"
DELPHI_DEPLOY_WIN="Z:/home/kzuca/project/delphi_deploy"
DCU_DIR_WIN="Z:/home/kzuca/project/MVCBr/dcu"
DCC32_WIN="Z:/home/kzuca/project/delphi_deploy/cmp/DCC32.EXE"

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