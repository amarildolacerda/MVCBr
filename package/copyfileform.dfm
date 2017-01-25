object FormCopyFile: TFormCopyFile
  Left = 214
  Top = 407
  BorderStyle = bsDialog
  Caption = 'Copiando'
  ClientHeight = 120
  ClientWidth = 355
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblFrom: TLabel
    Left = 27
    Top = 77
    Width = 310
    Height = 13
    AutoSize = False
    Caption = 'De:'
  end
  object Animate1: TAnimate
    Left = 24
    Top = 8
    Width = 272
    Height = 60
    Active = True
    CommonAVI = aviCopyFiles
    StopFrame = 34
  end
end
