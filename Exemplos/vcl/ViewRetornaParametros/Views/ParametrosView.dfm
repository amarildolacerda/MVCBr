object ParametrosView: TParametrosView
  Left = 0
  Top = 0
  Caption = 'ParametrosView'
  ClientHeight = 244
  ClientWidth = 471
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabeledEdit1: TLabeledEdit
    Left = 32
    Top = 40
    Width = 225
    Height = 21
    EditLabel.Width = 24
    EditLabel.Height = 13
    EditLabel.Caption = 'From'
    TabOrder = 0
  end
  object Button1: TButton
    Left = 374
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 3
    OnClick = Button1Click
  end
  object LabeledEdit2: TLabeledEdit
    Left = 32
    Top = 88
    Width = 225
    Height = 21
    EditLabel.Width = 12
    EditLabel.Height = 13
    EditLabel.Caption = 'To'
    TabOrder = 1
  end
  object LabeledEdit3: TLabeledEdit
    Left = 32
    Top = 136
    Width = 417
    Height = 21
    EditLabel.Width = 36
    EditLabel.Height = 13
    EditLabel.Caption = 'Subject'
    TabOrder = 2
  end
end
