object WinNotificationAppView: TWinNotificationAppView
  Left = 0
  Top = 0
  Caption = 'WinNotificationAppView'
  ClientHeight = 132
  ClientWidth = 523
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
    Left = 32
    Top = 64
    Width = 369
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 407
    Top = 62
    Width = 75
    Height = 25
    Caption = 'send'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 408
    Top = 95
    Width = 75
    Height = 25
    Caption = 'class notify'
    TabOrder = 2
    OnClick = Button2Click
  end
end
