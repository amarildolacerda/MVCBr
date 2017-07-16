unit eMVC.BuilderModelForm;

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
  caption := 'Builder Model';
  cbCreateDir.caption := wizardForm_groupdir_checkbox_caption;
  Label4.caption := wizardForm_NameForArtefact;
  Label1.caption := wizardForm_builder_Expert;
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
