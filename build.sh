#!/bin/bash
# Script to compile MVCBr Installer
# 
# Requirements:
# - JCL (JEDI Code Library) must be installed in Delphi IDE
#   The installer uses JclIDEUtils unit which is part of JCL
#   Install JCL from: https://github.com/project-jedi/jcl
#
#   After installing JCL in Delphi IDE, the JCL paths will be available
#   in the Delphi library path and this script will work.

set -e

PROJECT_BASE="${PROJECT_BASE:-$HOME/project}"
PROJECT_DIR="$PROJECT_BASE/MVCBr"
DELPHI_DEPLOY="$PROJECT_BASE/delphi_deploy"
INSTALL_DIR="$PROJECT_DIR/MVCBrInstall"
DCU_DIR="$PROJECT_DIR/dcu"

# Wine paths with Z: prefix
to_winpath() {
    echo "Z:$1"
}

PROJECT_DIR_WIN=$(to_winpath "$PROJECT_DIR")
DELPHI_DEPLOY_WIN=$(to_winpath "$DELPHI_DEPLOY")
DCU_DIR_WIN=$(to_winpath "$DCU_DIR")
INSTALL_DIR_WIN=$(to_winpath "$INSTALL_DIR")
DCC32_WIN=$(to_winpath "$DELPHI_DEPLOY/cmp/DCC32.EXE")

# Compiler flags
CFLAGS='-AWinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE;'
CFLAGS+=' -NS"Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell;System;Xml;Data;Datasnap;Web;Soap;Winapi;Windows;System.Win;VCLTee"'

# Unit search path (JCL must be installed in Delphi IDE for JclIDEUtils)
UPATH="$PROJECT_DIR_WIN;$PROJECT_DIR_WIN/helpers;$PROJECT_DIR_WIN/VCL;$PROJECT_DIR_WIN/FMX;$PROJECT_DIR_WIN/UniGui;$PROJECT_DIR_WIN/package;$DELPHI_DEPLOY_WIN/cmp/dcu;$DELPHI_DEPLOY_WIN/cmp/bpl"

# Output directory (per .dproj: DCC_ExeOutput=..\, DCC_DcuOutput=.\dcu)
OUT_FLAGS="-NO$DCU_DIR_WIN -LE$PROJECT_DIR_WIN -LN$DCU_DIR_WIN"

echo "=== Compiling MVCBr Installer ==="
echo "NOTE: Requires JCL (JEDI Code Library) installed in Delphi IDE"
echo "      Install from: https://github.com/project-jedi/jcl"
cd "$INSTALL_DIR"

# Create dcu directory if not exists
mkdir -p "$DCU_DIR"

# Compile the installer
if wine "$DCC32_WIN" "MVCBrInstall.dpr" $CFLAGS $OUT_FLAGS -U"$UPATH" -I"$UPATH"; then
    echo ""
    echo "=== Installer compiled successfully ==="
    if [ -f "$PROJECT_DIR/MVCBrInstall.exe" ]; then
        echo "Output: $PROJECT_DIR/MVCBrInstall.exe"
        ls -lh "$PROJECT_DIR/MVCBrInstall.exe"
    else
        echo "WARNING: Expected output not found at $PROJECT_DIR/MVCBrInstall.exe"
    fi
else
    echo ""
    echo "=== Compilation failed ==="
    echo "Missing dependency: JCL (JEDI Code Library) - JclIDEUtils unit not found"
    echo "Install JCL in Delphi IDE: https://github.com/project-jedi/jcl"
    exit 1
fi