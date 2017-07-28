object ObserverSenderView: TObserverSenderView
  Left = 0
  Top = 0
  Caption = 'ObserverSenderView'
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
    Left = 8
    Top = 64
    Width = 225
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 250
    Top = 62
    Width = 75
    Height = 25
    Caption = 'SendJson'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 336
    Top = 62
    Width = 75
    Height = 25
    Caption = 'Send Text'
    TabOrder = 2
    OnClick = Button2Click
  end
end
