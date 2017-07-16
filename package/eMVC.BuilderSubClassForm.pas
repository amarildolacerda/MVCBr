unit eMVC.BuilderSubClassForm;
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

{$I ./translate/translate.inc}

type
  TFormNewFacadeModel = class(TForm)
    btnBack: TBitBtn;
    btnCancel: TBitBtn;
    ScrollBox1: TScrollBox;
    nb: TNotebook;
    btnOKNext: TBitBtn;
    edtSetName: TEdit;
    cbCreateDir: TCheckBox;
    Label1: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Bevel1: TBevel;
    chFMX: TCheckBox;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btnOKNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
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
  FormNewFacadeModel: TFormNewFacadeModel;

implementation

uses eMVC.OTAUtilities;

{$R *.dfm}

procedure TFormNewFacadeModel.FormCreate(Sender: TObject);
begin
  nb.PageIndex := 0;
  // this two params for future use
  ModelAlone := true;
  viewAlone := true;
  chFMX.checked := GetFrameworkType = 'FMX';

  translate;

end;

procedure TFormNewFacadeModel.translate;
begin
  caption := 'Built - Builder Subclass';
  cbCreateDir.caption := wizardForm_groupdir_checkbox_caption;
  Label4.caption := wizardForm_NameForArtefact;
  Label1.caption := wizardForm_bsc_Expert;
  btnBack.caption := button_back_caption;
  btnOKNext.caption := button_next_caption;
  btnCancel.caption := button_cancel_caption;
  Label7.caption := msgCongratulation;
end;

procedure TFormNewFacadeModel.btnOKNextClick(Sender: TObject);
begin

  case nb.PageIndex of
    0:
      begin
        if trim(edtSetName.Text) = '' then
        begin
          eMVC.toolBox.showInfo(format(msgNeedNameFor, ['View']));
          exit;
        end;
        if SetNameExists(edtSetName.Text) then
        begin
          eMVC.toolBox.showInfo(format(msgSorryFileExists, [edtSetName.Text]));
          exit;
        end;

        self.Setname := trim(edtSetName.Text);
        self.CreateSubDir := cbCreateDir.checked;
      end;
  end;

  if nb.PageIndex < nb.Pages.Count then
  begin
    nb.PageIndex := nb.PageIndex + 1;


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

procedure TFormNewFacadeModel.btnBackClick(Sender: TObject);
begin
  if nb.PageIndex > 0 then
  begin
    nb.PageIndex := nb.PageIndex - 1;
    if nb.PageIndex = nb.Pages.Count - 1 then
      btnOKNext.caption := button_finish_caption
    else
      btnOKNext.caption := button_next_caption;
  end;
  btnBack.visible := (nb.PageIndex > 0);
end;

end.
