unit eMVC.ProjectWizardForm;

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
  Buttons, eMVC.toolbox;

type
  TFormAppWizard = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Notebook1: TNotebook;
    btnBack: TBitBtn;
    btnOK: TBitBtn;
    Label1: TLabel;
    edtApp: TEdit;
    edtPath: TEdit;
    Label2: TLabel;
    BitBtn3: TBitBtn;
    Label3: TLabel;
    BitBtn4: TBitBtn;
    cbUsarNomeProjeto: TCheckBox;
    config: TButton;
    rgTipoProjeto: TRadioGroup;
    procedure BitBtn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOKClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure configClick(Sender: TObject);
  private
    { Private declarations }
    FCanClose: Boolean;
  public
    { Public declarations }
  end;

var
  FormAppWizard: TFormAppWizard;

implementation


uses eMVC.Config;

{$R *.dfm}

procedure TFormAppWizard.BitBtn4Click(Sender: TObject);
var
  dir: string;
begin
   dir := BrowseForFolder('Selecione a pasta para o "Application":');
    if trim(dir) <> '' then
    begin
      edtPath.Text := dir;
    end;
end;

procedure TFormAppWizard.FormCreate(Sender: TObject);
begin
  FCanClose := false;
  edtPath.Text := '';
end;

procedure TFormAppWizard.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  s: string;
begin
  CanClose := FCanClose;
  if CanClose and (ModalResult = mrOK) then
  begin
    if trim(edtPath.Text) = '' then
      s := 'Selecione o caminho.'
    else if not DirectoryExists(trim(edtPath.Text)) then
      s := 'Caminho não existe, selecione um caminho válido.';
    if s <> '' then
    begin
      eMVC.toolbox.showInfo(s);
      CanClose := false;
    end;
  end;
end;

procedure TFormAppWizard.btnOKClick(Sender: TObject);
begin
  FCanClose := true;
end;

procedure TFormAppWizard.configClick(Sender: TObject);
begin
   with TMVCConfig.new do
      ShowView(nil);
end;

procedure TFormAppWizard.BitBtn3Click(Sender: TObject);
begin
  FCanClose := true;
end;

end.
