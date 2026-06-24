# Makefile for MVCBr
# Requires: Delphi command-line compiler (dcc32.exe) from delphi_deploy
#
# Usage:
#   make tests       - Compile test suite
#   make packages    - Compile all .dpk packages
#   make all         - Build everything
#   make clean       - Remove compiled artifacts

DELPHI_DEPLOY := $(realpath $(CURDIR)/../delphi_deploy)
DCC32 := $(DELPHI_DEPLOY)/cmp/DCC32.EXE
BASE  := $(CURDIR)
DCU   := $(BASE)/dcu
WINE  := $(shell which wine 2>/dev/null)

ifdef WINE
  to_winpath = Z:$(1)
  DCC32_RUN = $(WINE) "$(call to_winpath,$(DCC32))"
  SEP = /
  BASE_WIN = $(call to_winpath,$(BASE))
  DELPHI_DEPLOY_WIN = $(call to_winpath,$(DELPHI_DEPLOY))
else
  DCC32_RUN = "$(DCC32)"
  SEP = $(strip \)
  BASE_WIN = $(BASE)
endif

# Compiler flags (semicolons are safe in Make variables)
CFLAGS = '-AWinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE;'
CFLAGS += '-NS"Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell;System;Xml;Data;Datasnap;Web;Soap;Winapi;Windows;System.Win;VCLTee"'
ifdef WINE
  DCU_WIN = $(call to_winpath,$(DCU))
  CFLAGS += -NO$(DCU_WIN) -LE$(DCU_WIN) -LN$(DCU_WIN)
else
  CFLAGS += -NO$(DCU) -LE$(DCU) -LN$(DCU)
endif

# Unit search path (use Wine Z: paths when under Wine)
ifdef WINE
  UPATH = $(BASE_WIN);$(BASE_WIN)$(SEP)helpers;$(BASE_WIN)$(SEP)VCL;$(BASE_WIN)$(SEP)FMX;$(BASE_WIN)$(SEP)UniGui;$(DELPHI_DEPLOY_WIN)$(SEP)cmp$(SEP)dcu;$(DELPHI_DEPLOY_WIN)$(SEP)cmp$(SEP)bpl
else
  UPATH = $(BASE);$(BASE)$(SEP)helpers;$(BASE)$(SEP)VCL;$(BASE)$(SEP)FMX;$(BASE)$(SEP)UniGui;$(DELPHI_DEPLOY)$(SEP)cmp$(SEP)dcu;$(DELPHI_DEPLOY)$(SEP)cmp$(SEP)bpl
endif
UFLAGS = -U"$(UPATH)" -I"$(UPATH)"

ifdef WINE
  BASE_PRJ = $(BASE_WIN)
else
  BASE_PRJ = $(BASE)
endif

.PHONY: all tests packages clean

all: tests packages

tests:
	cd $(BASE)$(SEP)Tests && $(DCC32_RUN) "MVCBrTests.dpr" -DVCL -DCONSOLE_TESTRUNNER $(CFLAGS) $(UFLAGS)

packages:
	$(DCC32_RUN) $(BASE_PRJ)$(SEP)package$(SEP)MVCBr.dpk $(CFLAGS) $(UFLAGS)
	$(DCC32_RUN) $(BASE_PRJ)$(SEP)package$(SEP)MVCBrCore.dpk $(CFLAGS) $(UFLAGS)
	$(DCC32_RUN) $(BASE_PRJ)$(SEP)package$(SEP)MVCBrVCL.dpk $(CFLAGS) $(UFLAGS)
	$(DCC32_RUN) $(BASE_PRJ)$(SEP)package$(SEP)MVCBrFMX.dpk $(CFLAGS) $(UFLAGS)
	$(DCC32_RUN) $(BASE_PRJ)$(SEP)package$(SEP)MVCBrFireDAC.dpk $(CFLAGS) $(UFLAGS)

clean:
ifeq ($(OS),Windows_NT)
	-del /s *.dcu 2>nul
	-del /s *.exe 2>nul
	-del /s *.map 2>nul
	-del /s *.drc 2>nul
	-del /s *.tds 2>nul
	-del /s *.rsm 2>nul
	-if exist $(DCU) rmdir /s /q $(DCU)
else
	-find . -name '*.dcu' -delete 2>/dev/null
	-find . -name '*.exe' -delete 2>/dev/null
	-find . -name '*.map' -delete 2>/dev/null
	-find . -name '*.drc' -delete 2>/dev/null
	-find . -name '*.tds' -delete 2>/dev/null
	-find . -name '*.rsm' -delete 2>/dev/null
	-rm -rf $(DCU) 2>/dev/null
endif
