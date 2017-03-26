unit eMVC.ClassModelForm;

{ ********************************************************************** }
{ Copyright 2005 Reserved by Eazisoft.com }
{ unit: AppWizardForm
  { Author: Larry Le }
{ Description: the main window of create application wizard }
{ }
{ History: }
{ - 1.0, 19 May 2006 }
{ First version }
{ }
{ Email: linfengle@gmail.com }
{
  {********************************************************************** }
// "The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//
// The Original Code is written in Delphi.
//
// The Initial Developer of the Original Code is Larry Le.
// Copyright (C) eazisoft.com. All Rights Reserved.
//

interface

uses
  Windows, Messages, SysUtils, {$IFDEF DELPHI_6_UP}Variants, {$ENDIF}Classes,
  Graphics, Controls, Forms, intfParser, TokenInterfaces,
  Dialogs, ComCtrls, {$IFDEF VER130}FileCtrl, {$ENDIF}ExtCtrls, StdCtrls,
  Buttons, eMVC.toolbox, Vcl.CheckLst;

type
  TFormClassModel = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Notebook1: TNotebook;
    btnBack: TBitBtn;
    btnOK: TBitBtn;
    Label1: TLabel;
    edModelName: TEdit;
    Label2: TLabel;
    BitBtn3: TBitBtn;
    Label3: TLabel;
    cbClassName: TComboBox;
    clFunctions: TCheckListBox;
    Label4: TLabel;
    clMetodos: TCheckListBox;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    Label7: TLabel;
    edUnit: TEdit;
    edUnitButton: TButton;
    cbCreateDir: TCheckBox;
    CheckBox1: TCheckBox;
    cbTodosProcs: TCheckBox;
    RadioGroup1: TRadioGroup;
    procedure BitBtn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOKClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure edUnitButtonClick(Sender: TObject);
    procedure edUnitExit(Sender: TObject);
    procedure cbClassNameChange(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edModelNameExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure cbTodosProcsClick(Sender: TObject);
  private
    { Private declarations }
    FUnit: TIntfParser;

    FOldClassName: string;
    FCanClose: Boolean;
    FClassTypeList: TStringList;
    FClassGetMethods: TProc;
    procedure proximaPagina(incPage: integer);
    procedure ParseUnit;
    procedure PreencherOsMethods;
    procedure GerarCodigos;
    procedure GerarParametros(params: IParameterList; var s: string);
    procedure MarkCheckList(AList: TCheckListBox; const AChecked: Boolean);
    function GetClassType(const intf: iInterfaceType): string;
    function GetClassImplements(const intf: iInterfaceType;
      const AModel: String): string;
    function ExtractClassName(const s: String): string;
    function ExtractClassBase(): string;
    function GetClassImplementsParams(const intf: iInterfaceType): string;
    procedure FindInterface(var intf: iInterfaceType);
  public
    { Public declarations }
    FillListClassesProc: TProc;
    procedure SetClassesList(value: String; AProc: TProc);
    function GetCodigos: string;
    function GetInterf: string;
  end;

var
  FormGeradorClassModel: TFormClassModel;

implementation

{$R *.dfm}

uses CastaliaPasLexTypes;

procedure TFormClassModel.BitBtn4Click(Sender: TObject);
var
  dir: string;
begin
  dir := BrowseForFolder('Selecione a pasta para o "Application":');
  if trim(dir) <> '' then
  begin
    // edtPath.Text := dir;
  end;
end;

procedure TFormClassModel.FormCreate(Sender: TObject);
begin
  FUnit := TIntfParser.create;
  FClassTypeList := TStringList.create;
  FCanClose := false;
  // edtPath.Text := '';
end;

procedure TFormClassModel.FormDestroy(Sender: TObject);
begin
  FClassTypeList.free;
  FUnit.free;
end;

procedure TFormClassModel.FormShow(Sender: TObject);
begin
  Notebook1.PageIndex := 0;
  proximaPagina(0);
  if edUnit.text <> '' then
    if fileExists(edUnit.text) then
      if assigned(FillListClassesProc) then
        FillListClassesProc;
  postmessage(edUnit.handle, WM_SETFOCUS, 0, 0);

end;

const
  CRLF = #10#13;

procedure TFormClassModel.FindInterface(var intf: iInterfaceType);
var
  x: integer;
begin
  for x := 0 to FUnit.AUnit.Interfaces.count - 1 do
    if FUnit.AUnit.Interfaces.items[x].name = ExtractClassName(cbClassName.text)
    then
    begin
      intf := FUnit.AUnit.Interfaces.items[x];
      break;
    end;
end;

procedure TFormClassModel.GerarCodigos;
var
  intf: iInterfaceType;
  i: integer;
  s: string;
  function GetProc(p: integer): string;
  var
    x, n: integer;
    mtd: IMethod;
  begin
    result := '';
    FindInterface(intf);
    if not assigned(intf) then
      exit;
    mtd := intf.Methods.items[p];
    result := mtd.name + '%genParam' + '(';
    for n := 0 to mtd.params.count - 1 do
    begin
      if n > 0 then
        result := result + ', ';
      result := result + mtd.params.items[n].name;
    end;
    result := result + ')';
  end;

  function GetFunc(p: integer): string;
  var
    n: integer;
    fnc: IFunction;
  begin
    result := '';
    FindInterface(intf);
    if not assigned(intf) then
      exit;
    fnc := intf.Functions.items[p];
    result := fnc.name + '%genParam' + '(';
    for n := 0 to fnc.params.count - 1 do
    begin
      if n > 0 then
        result := result + ', ';
      result := result + fnc.params.items[n].name;
    end;
    result := result + ')';
  end;

begin
  Memo1.lines.clear;
  intf := nil;
  for i := 0 to clMetodos.items.count - 1 do
    if clMetodos.Checked[i] then
      with Memo1.lines do
      begin
        add(clMetodos.items[i]);
        add('begin ');;
        if clMetodos.items[i].contains('function ') then
          add('  result := base.' + GetProc(i) + ';')
        else
          add('  base.' + GetProc(i) + ';');
        add('end; ');
        add('');
      end;

  for i := 0 to clFunctions.items.count - 1 do
    if clFunctions.Checked[i] then
      with Memo1.lines do
      begin
        add(clFunctions.items[i]);
        add('begin ');;
        if  clFunctions.items[i].contains('function ') then
          add('  result := base.' + GetFunc(i) + ';')
        else
          add('  base.' + GetFunc(i) + ';');
        add('end; ');
        add('');
      end;

  if intf <> nil then
  begin
    Memo1.lines.text := stringReplace(Memo1.lines.text, '%Ident',
      GetClassImplements(intf, RadioGroup1.items[RadioGroup1.ItemIndex]),
      [rfReplaceAll]);
    Memo1.lines.text := stringReplace(Memo1.lines.text, '%genParam',
      GetClassImplementsParams(intf), [rfReplaceAll]);
  end;
end;

function TFormClassModel.GetCodigos: string;
begin
  result := Memo1.lines.text;
end;

function TFormClassModel.GetInterf: string;
var
  i: integer;
begin
  result := CRLF + '// metodos  <' + cbClassName.text + '//'.PadLeft(70) + CRLF;
  for i := 0 to clMetodos.items.count - 1 do
    if clMetodos.Checked[i] then
    begin
      result := result + clMetodos.items[i] + CRLF;
    end;

  result := result + CRLF + '// functions  <' + cbClassName.text +
    '//'.PadLeft(70) + CRLF;
  for i := 0 to clFunctions.items.count - 1 do
    if clFunctions.Checked[i] then
    begin
      result := result + clFunctions.items[i] + CRLF;
    end;
  result := stringReplace(result, '%Ident.', '', [rfReplaceAll]);
end;

procedure TFormClassModel.GerarParametros(params: IParameterList;
  var s: string);
var
  p: integer;
  prm: IParameter;
begin
  for p := 0 to params.count - 1 do
  begin
    prm := params.items[p];
    if p > 0 then
      s := s + '; ';
    case prm.Modifier of
      pmVar:
        s := s + ' var ';
      pmConst:
        s := s + ' const ';
      pmOut:
        s := s + ' out ';
    end;
    s := s + prm.name + ': ' + prm.DataType;
  end;
  s := s + ')';
end;

procedure TFormClassModel.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  s: string;
begin
  CanClose := FCanClose;
  if CanClose and (ModalResult = mrOK) then
  begin
    { if trim(edtPath.Text) = '' then
      s := 'Selecione o caminho.'
      else if not DirectoryExists(trim(edtPath.Text)) then
      s := 'Caminho não existe, selecione um caminho válido.';
      if s <> '' then
      begin
      eMVC.toolbox.showInfo(s);
      CanClose := false;
      end;
    }
  end;
end;

procedure TFormClassModel.proximaPagina(incPage: integer);
var
  n: integer;
begin
  n := Notebook1.PageIndex + incPage;
  if n >= Notebook1.Pages.count then
    Notebook1.PageIndex := Notebook1.Pages.count - 1
  else if n < 0 then
    Notebook1.PageIndex := 0
  else
    Notebook1.PageIndex := n;

  btnBack.visible := n > 0;
  // btNext.visible := not (Notebook1.PageIndex = Notebook1.Pages.count-1);

  if (Notebook1.PageIndex < Notebook1.Pages.count - 1) then
    btnOK.caption := 'Próximo'
  else
    btnOK.caption := 'Finalizar';

  btnOK.enabled := edModelName.text <> '';

  if edModelName.text = '' then
    Notebook1.PageIndex := 0;

  if (Notebook1.PageIndex = 1) and (FOldClassName <> cbClassName.text) then
    PreencherOsMethods;

  if (Notebook1.PageIndex = 3) then
    GerarCodigos;

end;

procedure TFormClassModel.SetClassesList(value: String; AProc: TProc);
begin
  FClassTypeList.text := value;
  FClassGetMethods := AProc;
end;

procedure TFormClassModel.btnBackClick(Sender: TObject);
begin
  proximaPagina(-1);

end;

procedure TFormClassModel.btnOKClick(Sender: TObject);
begin
  FCanClose := (Notebook1.PageIndex = Notebook1.Pages.count - 1);
  if not FCanClose then
    proximaPagina(1);

end;

function TFormClassModel.GetClassImplementsParams
  (const intf: iInterfaceType): string;
var
  i: integer;
  prm: IParameter;
begin
  result := '';
  for i := 0 to intf.TypeParams.count - 1 do
  begin
    prm := intf.TypeParams.items[i];
    if i = 0 then
      result := result + '<';
    if i > 0 then
      result := result + ', ';
    result := result + prm.name;
  end;
  if intf.TypeParams.count > 0 then
    result := result + '>';
end;

function TFormClassModel.GetClassImplements(const intf: iInterfaceType;
  const AModel: String): string;
var
  i: integer;
  prm: IParameter;
begin
  result := intf.name + AModel;
  for i := 0 to intf.TypeParams.count - 1 do
  begin
    prm := intf.TypeParams.items[i];
    if i = 0 then
      result := result + '<';
    if i > 0 then
      result := result + ', ';
    result := result + prm.name;
  end;
  if intf.TypeParams.count > 0 then
    result := result + '>';
end;

function TFormClassModel.GetClassType(const intf: iInterfaceType): string;
var
  i: integer;
  prm: IParameter;
begin
  result := intf.name;
  for i := 0 to intf.TypeParams.count - 1 do
  begin
    prm := intf.TypeParams.items[i];
    if i = 0 then
      result := result + '<';
    if i > 0 then
      result := result + '; ';
    result := result + prm.name;
    if prm.DataType <> '' then
      result := result + ': ' + prm.DataType;
  end;
  if intf.TypeParams.count > 0 then
    result := result + '>';
end;

procedure TFormClassModel.ParseUnit;
var
  tmp, s: string;
  AUnit: IUnit;
  i: integer;
  interf: iInterfaceType;
  inInterface: Boolean;
  tokenId: TptTokenKind;
  LClassName: string;
begin
  cbClassName.items.clear;
  tmp := cbClassName.text + '.' + edModelName.text;
  if FOldClassName = tmp then
    exit;

  try
    FreeAndNil(FUnit);
    FUnit := TIntfParser.create;

    FUnit.InterfaceOnly := true;
    FUnit.LoadAndRun(edUnit.text);

    AUnit := FUnit.AUnit;

    // for s in AUnit.UsesUnits do
    // showmessage(s);

    for i := 0 to AUnit.Interfaces.count - 1 do
    begin
      interf := AUnit.Interfaces.items[i];
      cbClassName.items.add(GetClassType(interf));
    end;

  finally
  end;
end;

procedure TFormClassModel.PreencherOsMethods;
var
  i: integer;
  interf: iInterfaceType;
  mtds: IMethod;
  fncs: IFunction;
  s: string;
begin

  if FUnit.AUnit.Interfaces.count = 0 then
    ParseUnit;

  interf := nil;
  for i := 0 to FUnit.AUnit.Interfaces.count - 1 do
    if FUnit.AUnit.Interfaces.items[i].name = ExtractClassName(cbClassName.text)
    then
    begin
      interf := FUnit.AUnit.Interfaces.items[i];
      break;
    end;
  if interf = nil then
    exit;

  clMetodos.clear;
  for i := 0 to interf.Methods.count - 1 do
  begin
    mtds := interf.Methods.items[i];
    s := 'procedure %Ident.' + mtds.name;
    s := s + '(';
    GerarParametros(mtds.params, s);
    s := s + ';';
    clMetodos.items.add(s);

    clMetodos.Checked[clMetodos.items.count - 1] := true;
  end;

  clFunctions.clear;
  for i := 0 to interf.Functions.count - 1 do
  begin
    fncs := interf.Functions.items[i];
    s := 'function %Ident.' + fncs.name;

    s := s + '(';
    GerarParametros(fncs.params, s);
    s := s + ':' + fncs.ReturnType + ';';
    clFunctions.items.add(s);
    clFunctions.Checked[clFunctions.items.count - 1] := true;
  end;

  FOldClassName := cbClassName.text + '.' + edModelName.text;

end;

procedure TFormClassModel.cbClassNameChange(Sender: TObject);
begin
  edModelName.text := ExtractClassBase();
  proximaPagina(0);
end;

procedure TFormClassModel.MarkCheckList(AList: TCheckListBox;
  Const AChecked: Boolean);
var
  i: integer;
begin
  for i := 0 to AList.count - 1 do
    AList.Checked[i] := AChecked;
end;

procedure TFormClassModel.CheckBox1Click(Sender: TObject);
begin
  MarkCheckList(clFunctions, CheckBox1.Checked);
end;

procedure TFormClassModel.cbTodosProcsClick(Sender: TObject);
begin
  MarkCheckList(clMetodos, cbTodosProcs.Checked);
end;

procedure TFormClassModel.edModelNameExit(Sender: TObject);
begin
  proximaPagina(0);
end;

procedure TFormClassModel.edUnitButtonClick(Sender: TObject);
begin
  edUnit.text := BrowseForFolder('Unit para ClassModel', '', '*.pas');
  edUnitExit(nil);
  cbClassName.setfocus;
end;

procedure TFormClassModel.edUnitExit(Sender: TObject);
begin
  // if assigned(FillListClassesProc) then
  // FillListClassesProc;
  if fileExists(edUnit.text) then
    ParseUnit;
end;

function TFormClassModel.ExtractClassBase(): string;
var
  s: string;
  intf: iInterfaceType;
begin
  result := ExtractClassName(cbClassName.text);
  FindInterface(intf);
  if assigned(intf) then
    result := GetClassImplements(intf, '');
end;

function TFormClassModel.ExtractClassName(const s: String): string;
begin
  result := s;
  if  s.contains('<') then
    result := copy(s, 1, pos('<', s) - 1);
end;

procedure TFormClassModel.BitBtn3Click(Sender: TObject);
begin
  FCanClose := true;
end;

end.
