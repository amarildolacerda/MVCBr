unit eMVC.ControllerForm;
{ ********************************************************************** }
{ Copyright 2005 Reserved by Eazisoft.com }
{ File Name: NewSetForm.pas }
{ Author: Larry Le }
{ Description:  Form of new set wizard }
{ }
{ History: }
{ - 1.0, 19 May 2006 }
{ First version }
{ }
{ Email: linfengle@gmail.com }
{ }
{ The contents of this file are subject to the Mozilla Public License }
{ Version 1.1 (the "License"); you may not use this file except in }
{ compliance with the License. You may obtain a copy of the License at }
{ http://www.mozilla.org/MPL/ }
{ }
{ Software distributed under the License is distributed on an "AS IS" }
{ basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See }
{ the License for the specific language governing rights and }
{ limitations under the License. }
{ }
{ The Original Code is written in Delphi. }
{ }
{ The Initial Developer of the Original Code is Larry Le. }
{ Copyright (C) eazisoft.com. All Rights Reserved. }
{ }
{ ********************************************************************** }

interface

uses
  Windows, Messages, SysUtils, {$IFDEF DELPHI_6_UP}Variants, {$ENDIF}Classes,
  Graphics, Controls, Forms, Dialogs, ExtCtrls, eMVC.toolBox, StdCtrls, Buttons;

const
{$I .\inc\persistentmodel.inc}
{$I .\translate\translate.inc}
type
  TFormNewController = class(TForm)
    btnBack: TBitBtn;
    btnCancel: TBitBtn;
    ScrollBox1: TScrollBox;
    nb: TNotebook;
    btnOKNext: TBitBtn;
    edtSetName: TEdit;
    cbCreateDir: TCheckBox;
    Label1: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    listClassName: TListBox;
    cbViewInCtrl: TCheckBox;
    Label10: TLabel;
    Bevel1: TBevel;
    edtClassName: TEdit;
    Label22: TLabel;
    cbCreateModel: TCheckBox;
    ComboBox1: TComboBox;
    cbFMX: TCheckBox;
    Image1: TImage;
    edFolder: TEdit;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure listClassNameClick(Sender: TObject);
    procedure nbPageChanged(Sender: TObject);
    procedure cbCreateDirClick(Sender: TObject);
  private
    procedure translate;
    { Private declarations }
  public
    { Public declarations }
    Setname: string;
    CreateSubDir: boolean;
    CreateModule: boolean;
    CreateView: boolean;
    CreateViewModule: boolean;
    ModelAlone: boolean;
    viewAlone: boolean;
    ViewParentClass: string;
  end;

var
  FormNewController: TFormNewController;

implementation

uses eMVC.OTAUtilities, eMVC.PersistentModelConst;

{$R *.dfm}

procedure TFormNewController.FormCreate(Sender: TObject);
var
  str: TStringList;
begin

  str := TStringList.Create;
  with str do
    try
      text := 'IModuleModel=TModuleFactory';
      ComboBox1.Items.Assign(str);
    finally
      free;
    end;

  ComboBox1.ItemIndex := 0;
  cbCreateModel.enabled := true;
  nb.PageIndex := 0;
  // this two params for future use
  ModelAlone := true;
  viewAlone := true;

  cbFMX.checked := GetFrameworkType = 'FMX';
  translate;
end;

procedure TFormNewController.translate;
begin
  caption := 'Controllers';
  cbCreateDir.caption := wizardForm_groupdir_checkbox_caption;
  cbCreateModel.caption := wizardController_CreateModel_caption;
  Label1.caption := wizardController_Expert_Caption;
  Label4.caption := wizardForm_NameForArtefact;
  Label7.caption := msgCongratulation;
  btnBack.caption := button_back_caption;
  btnOKNext.caption := button_next_caption;
  btnCancel.caption := button_cancel_caption;
end;

procedure TFormNewController.btnOKNextClick(Sender: TObject);
begin

  case nb.PageIndex of
    0:
      begin
        if trim(edtSetName.text) = '' then
        begin
          eMVC.toolBox.showInfo('Forne�a um nome para a View.');
          exit;
        end;
        if SetNameExists(edtSetName.text) then
        begin
          eMVC.toolBox.showInfo('Desculpe,A view "' + edtSetName.text +
            '" j� existe!');
          exit;
        end;

        self.Setname := trim(edtSetName.text);
        self.CreateSubDir := cbCreateDir.checked;
      end;
    1:
      begin
        self.CreateModule := cbCreateModel.checked;
        nb.PageIndex := 2;
      end;
    // 2: begin
    // ModelAlone:= not cbModelInCtrl.Checked;
    // end;
    2:
      begin
        viewAlone := not cbViewInCtrl.checked;
        if trim(edtClassName.text) <> '' then
          ViewParentClass := trim(edtClassName.text)
        else if (listClassName.ItemIndex >= 0) and
          (listClassName.ItemIndex < listClassName.Items.Count) then
          ViewParentClass := listClassName.Items[listClassName.ItemIndex]
        else
        begin
          eMVC.toolBox.showInfo
            ('Please give select or input a parent class for the View.');
          exit;
        end;
      end;
  end;

  if nb.PageIndex < nb.Pages.Count then
  begin
    nb.PageIndex := nb.PageIndex + 1;

    if (nb.PageIndex = 2) { and not CreateModule } then
      nb.PageIndex := 3;

    if (nb.PageIndex = 2) and not CreateView then
      nb.PageIndex := 3;

    if nb.PageIndex = nb.Pages.Count - 1 then
    begin
      btnOKNext.ModalResult := mrOK;
      btnOKNext.Caption := '&Finalizar';
    end
    else
    begin
      btnOKNext.ModalResult := mrNone;
      btnOKNext.Caption := '&Pr�ximo';
    end;
  end;
  btnBack.visible := (nb.PageIndex > 0);
end;

procedure TFormNewController.cbCreateDirClick(Sender: TObject);
begin
 edFolder.visible := cbCreateDir.checked;
 SpeedButton1.visible := cbCreateDir.checked;

end;

procedure TFormNewController.btnBackClick(Sender: TObject);
begin
  if nb.PageIndex > 0 then
  begin
    nb.PageIndex := nb.PageIndex - 1;
    if (nb.PageIndex = 3) and not CreateView then
      nb.PageIndex := 1; // 2;

    if (nb.PageIndex = 2) and not CreateModule then
      nb.PageIndex := 1;

    if (nb.PageIndex = 3) then
      nb.PageIndex := 1; // 2;

    if nb.PageIndex = nb.Pages.Count - 1 then
      btnOKNext.Caption := '&Finalizar'
    else
      btnOKNext.Caption := '&Pr�ximo';
  end;

  btnBack.visible := (nb.PageIndex > 0);
end;

procedure TFormNewController.listClassNameClick(Sender: TObject);
begin
  if listClassName.ItemIndex >= 0 then
    edtClassName.text := listClassName.Items[listClassName.ItemIndex];
end;

procedure TFormNewController.nbPageChanged(Sender: TObject);
begin
  if (nb.PageIndex = 2) and (trim(edtClassName.text) = '') then
  begin
    listClassName.ItemIndex := 0;
    listClassName.OnClick(listClassName);
  end;
end;

end.
