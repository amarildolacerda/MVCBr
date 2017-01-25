unit eMVC.NewSetForm;
{**********************************************************************}
{ Copyright 2005 Reserved by Eazisoft.com                              }
 { File Name: NewSetForm.pas                                           }
{ Author: Larry Le                                                     }
{ Description:  Form of new set wizard                                 }
{                                                                      }
{ History:                                                             }
{ - 1.0, 19 May 2006                                                   }
{   First version                                                      }
{                                                                      }
{ Email: linfengle@gmail.com                                           }
{                                                                      }
{ The contents of this file are subject to the Mozilla Public License  }
{ Version 1.1 (the "License"); you may not use this file except in     }
{ compliance with the License. You may obtain a copy of the License at }
{ http://www.mozilla.org/MPL/                                          }
{                                                                      }
{ Software distributed under the License is distributed on an "AS IS"  }
{ basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See  }
{ the License for the specific language governing rights and           }
{ limitations under the License.                                       }
{                                                                      }
{ The Original Code is written in Delphi.                              }
{                                                                      }
{ The Initial Developer of the Original Code is Larry Le.              }
{ Copyright (C) eazisoft.com. All Rights Reserved.                     }
{                                                                      }
{**********************************************************************}


interface

uses
  Windows, Messages, SysUtils, {$IFDEF DELPHI_6_UP}Variants, {$ENDIF}Classes,
  Graphics, Controls, Forms, Dialogs, ExtCtrls, eMVC.toolBox, StdCtrls, Buttons;

type
  TFormNewSet = class(TForm)
    btnBack: TBitBtn;
    btnCancel: TBitBtn;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    nb: TNotebook;
    btnOKNext: TBitBtn;
    edtSetName: TEdit;
    cbCreateDir: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
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
    procedure FormCreate(Sender: TObject);
    procedure btnOKNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure listClassNameClick(Sender: TObject);
    procedure nbPageChanged(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Setname: string;
    CreateSubDir: boolean;
    CreateModule: boolean;
    CreateView: Boolean;
    CreateViewModule: Boolean;
    ModelAlone: boolean;
    viewAlone: boolean;
    ViewParentClass: string;
  end;

var
  FormNewSet: TFormNewSet;

implementation
uses eMVC.OTAUtilities;

{$R *.dfm}

procedure TFormNewSet.FormCreate(Sender: TObject);
begin
  nb.PageIndex := 0;
  //this two params for future use
  ModelAlone := true;
  viewAlone := true;
end;

procedure TFormNewSet.btnOKNextClick(Sender: TObject);
begin

  case nb.PageIndex of
    0:
      begin
        if trim(edtSetName.Text) = '' then
        begin
          eMVC.ToolBox.showInfo('Forneça um nome para a View.');
          exit;
        end;
        if SetNameExists(edtSetName.Text) then
        begin
          eMVC.ToolBox.showInfo('Desculpe,A view "' + edtSetName.Text + '" já existe!');
          exit;
        end;

        self.Setname := trim(edtSetname.Text);
        self.CreateSubDir := cbCreateDir.Checked;
      end;
    1: begin
        self.CreateModule := cbCreateModel.checked;
        self.CreateView := cbCreateView.checked;
        self.CreateViewModule := cbViewModel.checked;
      end;
//    2: begin
//        ModelAlone:= not cbModelInCtrl.Checked;
//      end;
    2: begin
        ViewAlone := not cbViewInCtrl.Checked;
        if trim(edtClassname.Text) <> '' then
          ViewParentClass := trim(edtClassname.Text)
        else if (listClassName.ItemIndex >= 0) and (listClassName.ItemIndex < listClassName.Items.Count) then
          ViewParentClass := listClassName.items[listClassName.ItemIndex]
        else begin
          eMVC.ToolBox.showInfo('Please give select or input a parent class for the View.');
          exit;
        end;
      end;
  end;

  if nb.PageIndex < nb.Pages.Count then
  begin
    nb.PageIndex := nb.PageIndex + 1;

 //   if (nb.PageIndex = 2) and not CreateModule then
//      nb.PageIndex := 3;

    if (nb.PageIndex = 2) and not CreateView then
      nb.PageIndex := 3;

    if nb.PageIndex = nb.Pages.Count - 1 then
    begin
      btnOKNext.ModalResult := mrOK;
      btnOKNext.Caption := '&Finalizar';
    end
    else begin
      btnOKNext.ModalResult := mrNone;
      btnOKNext.Caption := '&Próximo';
    end;
  end;
  btnBack.visible := (nb.PageIndex > 0);
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
      btnOKNext.Caption := '&Finalizar'
    else
      btnOKNext.Caption := '&Próximo';
  end;

  btnBack.visible := (nb.PageIndex > 0);
end;

procedure TFormNewSet.listClassNameClick(Sender: TObject);
begin
  if listClassName.ItemIndex >= 0 then
    edtClassName.Text := listClassName.Items[listClassName.ItemIndex];
end;

procedure TFormNewSet.nbPageChanged(Sender: TObject);
begin
  if (nb.PageIndex = 2) and (trim(edtClassName.Text) = '') then
  begin
    listClassName.ItemIndex := 0;
    listClassName.OnClick(listClassName);
  end;
end;

end.

