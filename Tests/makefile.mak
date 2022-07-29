
DCC=c:\delphi\delphi_deploy\cmp\dcc32.exe
CMP=c:\delphi\delphi_deploy\cmp
BASE=c:\git\mvcbr

tests:
    @echo "Compiling... $(BASE);"
	$(DCC) mvcbrtests.dpr -DVCL -O$(CMP)\dcu;$(CMP)\bpl; -AWinTypes=Windows;WinProcs=Windows;DbiTypes=BDE;DbiProcs=BDE;DbiErrs=BDE; -NS"Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell;System;Xml;Data;Datasnap;Web;Soap;Winapi;Windows;System.Win;VCLTee" -I"$(CMP)\dcu;$(CMP)\bpl" -U"$(CMP)\dcu;$(CMP)\bpl;$(BASE);$(BASE)\helpers;$(BASE)\vcl;$(BASE)\vcl\helpers;$(BASE)\vcl\touch;$(BASE)\vcl\shell;$(BASE)\vcl\samples;$(BASE)\vcl\imaging;$(BASE)\vcl\bde;$(BASE)\vcl\bde\bde;$(BASE)\vcl\bde\bde\bde;$(BASE)\vcl\bde\bde\bde\bde;$(BASE)\vcl\bde\bde\bde\bde\bde;$(BASE)\vcl\bde\bde\bde\bde\bde\bde;$(BASE)\vcl\bde\bde\bde\bde\bde\bde\bde;$(BASE)\vcl\bde\bde\bde\bde\bde\bde\bde\bde;$(BASE)\vcl\bde\bde\bde\bde\bde\bde\bde\bde\bde;$(BASE)\vcl\bde\bde\bde\bde\bde\bde\bde\bde\bde\bde;$(BASE)\vcl\bde\bde\bde\bde\bde\bde\bde\bde\bde\bde\bde;$(BASE)\vcl\bde\bde\bde\bde\bde\bde\bde\bde\bde\bde\bde\bde;$(BASE)\vcl\bde\bde\bde\bde\bde\bde\bde\bde\bde\bde\bde\bde;$(BASE)\vcl\bde\bde\bde\bde\bde\bde\bde\bde\bde\bde\bde\bde\bde;$(BASE)\MongoWire"





clean:
	cls