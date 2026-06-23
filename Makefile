# Makefile for MVCBr
# Requires: Delphi command-line compiler (dcc32.exe) from delphi_deploy
#
# Usage:
#   make tests       - Compile test suite
#   make server      - Compile OData server
#   make packages    - Compile all .dpk packages
#   make all         - Build everything
#   make clean       - Remove compiled artifacts

DCC32 ?= dcc32
BASE  ?= $(CURDIR)
DCU   ?= $(BASE)\dcu

# Compiler flags
CFLAGS = -AWinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE;
CFLAGS += -NS"Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell;System;Xml;Data;Datasnap;Web;Soap;Winapi;Windows;System.Win;VCLTee"
CFLAGS += -NO$(DCU) -LE$(DCU) -LN$(DCU)

# Unit search path
UPATH  = $(BASE);$(BASE)\helpers;$(BASE)\VCL;$(BASE)\oData;$(BASE)\MongoWire
UPATH += $(BASE)\MVCBrServer;$(BASE)\DMVC;$(BASE)\FMX;$(BASE)\UniGui
UFLAGS = -U"$(UPATH)" -I"$(UPATH)"

.PHONY: all tests server packages clean

all: tests server packages

tests:
	$(DCC32) Tests\MVCBrTests.dpr -DVCL $(CFLAGS) $(UFLAGS)

server:
	$(DCC32) MVCBrServer\ODataBrServer.dpr $(CFLAGS) $(UFLAGS)

packages:
	$(DCC32) package\MVCBr.dpk $(CFLAGS) $(UFLAGS)
	$(DCC32) package\MVCBrCore.dpk $(CFLAGS) $(UFLAGS)
	$(DCC32) package\MVCBrVCL.dpk $(CFLAGS) $(UFLAGS)
	$(DCC32) package\MVCBrFMX.dpk $(CFLAGS) $(UFLAGS)
	$(DCC32) package\MVCBrFireDAC.dpk $(CFLAGS) $(UFLAGS)
	$(DCC32) package\MVCBrOData.dpk $(CFLAGS) $(UFLAGS)

clean:
	-del /s *.dcu 2>nul
	-del /s *.exe 2>nul
	-del /s *.map 2>nul
	-del /s *.drc 2>nul
	-del /s *.tds 2>nul
	-del /s *.rsm 2>nul
	-if exist $(DCU) rmdir /s /q $(DCU)
