unit eMVC.FacadeSubClassForm;
{ *************************************************************************** }
{ }
{ MVCBr � o resultado de esfor�os de um grupo }
{ }
{ Copyright (C) 2017 MVCBr }
{ }
{ amarildo lacerda }
{ http://www.tireideletra.com.br }
{ }
{ }
{ *************************************************************************** }
{ }
{ Licensed under the Apache License, Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. }
{ You may obtain a copy of the License at }
{ }
{ http://www.apache.org/licenses/LICENSE-2.0 }
{ }
{ Unless required by applicable law or agreed to in writing, software }
{ distributed under the License is distributed on an "AS IS" BASIS, }
{ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{ See the License for the specific language governing permissions and }
{ limitations under the License. }
{ }
{ *************************************************************************** }

interface

uses
  Windows, Messages, SysUtils, {$IFDEF DELPHI_6_UP}Variants, {$ENDIF}Classes,
  Graphics, Controls, Forms, Dialogs, ExtCtrls, eMVC.toolBox, StdCtrls, Buttons;

{$I ./translate/translate.inc}

type
  TFormNewFacadeSubClass = class(TForm)
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
    Label2: TLabel;
    edFacadeModel: TEdit;
    Label3: TLabel;
    edFacadeCommand: TEdit;
    edFolder: TEdit;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
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
  FormNewFacadeSubClass: TFormNewFacadeSubClass;

implementation

uses eMVC.OTAUtilities;

{$R *.dfm}

procedure TFormNewFacadeSubClass.FormCreate(Sender: TObject);
begin
  nb.PageIndex := 0;
  // this two params for future use
  ModelAlone := true;
  viewAlone := true;
  chFMX.checked := GetFrameworkType = 'FMX';

  translate;

end;

procedure TFormNewFacadeSubClass.translate;
begin
  caption := 'Facade Subclass';
  cbCreateDir.caption := wizardForm_groupdir_checkbox_caption;
  Label4.caption := wizardForm_NameForArtefact;
  Label1.caption := wizardForm_fsc_Expert;
  btnBack.caption := button_back_caption;
  btnOKNext.caption := button_next_caption;
  btnCancel.caption := button_cancel_caption;
  Label7.caption := msgCongratulation;
end;

procedure TFormNewFacadeSubClass.btnOKNextClick(Sender: TObject);
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

procedure TFormNewFacadeSubClass.cbCreateDirClick(Sender: TObject);
begin
 edFolder.visible := cbCreateDir.checked;
 SpeedButton1.visible := cbCreateDir.checked;
end;

procedure TFormNewFacadeSubClass.btnBackClick(Sender: TObject);
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
