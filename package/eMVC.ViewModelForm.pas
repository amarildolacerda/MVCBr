unit eMVC.ViewModelForm;
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
  Graphics, Controls, Forms, Dialogs, ExtCtrls,
  eMVC.toolBox, StdCtrls, Buttons;

{$I ./translate/translate.inc}

type
  TFormNewSet = class(TForm)
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
    cbCreateView: TCheckBox;
    cbCreateModel: TCheckBox;
    cbViewModel: TCheckBox;
    chFMX: TCheckBox;
    Image1: TImage;
    Label2: TLabel;
    edFolder: TEdit;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure listClassNameClick(Sender: TObject);
    procedure nbPageChanged(Sender: TObject);
    procedure cbCreateModelClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure cbCreateDirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure translate;
    function GetFolder: string;
    procedure SetFolder(const Value: string);
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
    property Folder: string read GetFolder write SetFolder;
  end;

var
  FormNewSet: TFormNewSet;

implementation

uses eMVC.OTAUtilities;

{$R *.dfm}

procedure TFormNewSet.FormCreate(Sender: TObject);
begin
  cbCreateModel.enabled := true;
  cbCreateView.enabled := false;
  // cbViewModel.Enabled := false;
  nb.PageIndex := 0;
  // this two params for future use
  ModelAlone := true;
  viewAlone := true;
  chFMX.checked := GetFrameworkType = 'FMX';

  translate;

end;

procedure TFormNewSet.FormShow(Sender: TObject);
var
  project: string;
begin

  project := GetCurrentProject.FileName;
  if project <> '' then
  begin
    edFolder.text := extractFilePath(project) + 'Views';
  end;
  cbCreateDirClick(Sender);
end;

function TFormNewSet.GetFolder: string;
begin
  result := edFolder.text;
end;

procedure TFormNewSet.translate;
begin
  caption := 'View/ViewModel - Model';
  cbCreateDir.caption := wizardForm_groupdir_checkbox_caption;
  Label4.caption := wizardForm_NameForArtefact;
  Label1.caption := wizardForm_ViewModel_Expert;
  btnBack.caption := button_back_caption;
  btnOKNext.caption := button_next_caption;
  btnCancel.caption := button_cancel_caption;
  Label7.caption := msgCongratulation;
  cbCreateModel.caption := wizardForm_checkBox_createmodel_caption;
  cbCreateView.caption := wizardForm_checkBox_createview_caption;
  cbViewModel.caption := wizardForm_checkBox_createviewmodel_caption;
  Label10.caption := wizarForm_createview_tipoview_caption;
end;

procedure TFormNewSet.btnOKNextClick(Sender: TObject);
begin

  case nb.PageIndex of
    0:
      begin
        if trim(edtSetName.text) = '' then
        begin
          eMVC.toolBox.showInfo(format(msgNeedNameFor, ['View']));
          exit;
        end;
        if SetNameExists(edtSetName.text) then
        begin
          eMVC.toolBox.showInfo(format(msgSorryFileExists, [edtSetName.text]));
          exit;
        end;

        self.Setname := trim(edtSetName.text);
        self.CreateSubDir := cbCreateDir.checked;
      end;
    1:
      begin
        self.CreateModule := cbCreateModel.checked;
        self.CreateView := cbCreateView.checked;
        self.CreateViewModule := cbViewModel.checked;
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
          eMVC.toolBox.showInfo(format(msgGiveClassFor, ['View']));
          exit;
        end;
      end;
  end;

  if nb.PageIndex < nb.Pages.Count then
  begin
    nb.PageIndex := nb.PageIndex + 1;

    // if (nb.PageIndex = 2) and not CreateModule then
    // nb.PageIndex := 3;

    if (nb.PageIndex = 2) and not CreateView then
      nb.PageIndex := 3;

    if nb.PageIndex = nb.Pages.Count - 1 then
    begin
      btnOKNext.ModalResult := mrOK;
      btnOKNext.caption := button_finish_caption;
    end
    else
    begin
      btnOKNext.ModalResult := mrNone;
      btnOKNext.caption := button_next_caption;
    end;
  end;
  btnBack.visible := (nb.PageIndex > 0);
end;

procedure TFormNewSet.cbCreateDirClick(Sender: TObject);
begin
  edFolder.visible := cbCreateDir.checked;
  SpeedButton1.visible := cbCreateDir.checked;
end;

procedure TFormNewSet.cbCreateModelClick(Sender: TObject);
begin
  cbCreateView.checked := not cbCreateModel.checked;
  cbViewModel.checked := not cbCreateModel.checked;
end;

procedure TFormNewSet.btnBackClick(Sender: TObject);
begin
  if nb.PageIndex > 0 then
  begin
    nb.PageIndex := nb.PageIndex - 1;
    if (nb.PageIndex = 3) and not CreateView then
      nb.PageIndex := 2;

    if (nb.PageIndex = 2) and not CreateModule then
      nb.PageIndex := 1;

    if nb.PageIndex = nb.Pages.Count - 1 then
      btnOKNext.caption := button_finish_caption
    else
      btnOKNext.caption := button_next_caption;
  end;

  btnBack.visible := (nb.PageIndex > 0);
end;

procedure TFormNewSet.listClassNameClick(Sender: TObject);
begin
  if listClassName.ItemIndex >= 0 then
    edtClassName.text := listClassName.Items[listClassName.ItemIndex];
end;

procedure TFormNewSet.nbPageChanged(Sender: TObject);
begin
  if (nb.PageIndex = 2) and (trim(edtClassName.text) = '') then
  begin
    listClassName.ItemIndex := 0;
    listClassName.OnClick(listClassName);
  end;
end;

procedure TFormNewSet.SetFolder(const Value: string);
begin
  edFolder.text := Value;
end;

procedure TFormNewSet.SpeedButton1Click(Sender: TObject);
begin
  with TFileOpenDialog.create(self) do
    try
      Options := Options + [TFileDialogOption.fdoPickFolders];
      if execute then
        edFolder.text := FileName;
    finally
      free;
    end;
end;

end.
