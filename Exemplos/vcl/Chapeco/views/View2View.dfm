object View2View: TView2View
  Left = 0
  Top = 0
  Caption = 'View2View'
  ClientHeight = 231
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 48
    Top = 54
    Width = 330
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 384
    Top = 54
    Width = 75
    Height = 25
    Caption = 'Enviar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 48
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Notify'
    TabOrder = 2
    OnClick = Button2Click
  end
end
