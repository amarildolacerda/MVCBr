unit eMVC.NewClassModelForm;

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
  Graphics, Controls, Forms,
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
    clPropriedades: TCheckListBox;
    Label4: TLabel;
    clMetodos: TCheckListBox;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    Label7: TLabel;
    edUnit: TEdit;
    edUnitButton: TButton;
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
  private
    { Private declarations }
    FCanClose: Boolean;
    FClassTypeList: TStringList;
    FClassGetMethods: TProc;
    procedure proximaPagina(incPage: integer);

  public
    { Public declarations }
    FillListClassesProc: TProc;
    procedure SetClassesList(value: String; AProc: TProc);
  end;

var
  FormGeradorClassModel: TFormClassModel;

implementation

{$R *.dfm}

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
  FClassTypeList := TStringList.create;
  FCanClose := false;
  // edtPath.Text := '';
end;

procedure TFormClassModel.FormDestroy(Sender: TObject);
begin
  FClassTypeList.free;
end;

procedure TFormClassModel.FormShow(Sender: TObject);
begin
  Notebook1.PageIndex := 0;
  proximaPagina(0);
  if edUnit.text<>'' then
   if fileExists(edUnit.text) then
   if assigned(FillListClassesProc) then
      FillListClassesProc;
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

procedure TFormClassModel.cbClassNameChange(Sender: TObject);
begin
  edModelName.text := cbClassName.text ;
  if edModelName.text[1] = 'T' then
    edModelName.text := copy(edModelName.text, 2, length(edModelName.text));
  proximaPagina(0);
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
  if assigned(FillListClassesProc) then
    FillListClassesProc;
end;

procedure TFormClassModel.BitBtn3Click(Sender: TObject);
begin
  FCanClose := true;
end;

end.
