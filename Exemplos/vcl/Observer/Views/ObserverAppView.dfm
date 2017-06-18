object ObserverAppView: TObserverAppView
  Left = 0
  Top = 0
  Caption = 'ObserverAppView'
  ClientHeight = 370
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormFactoryCreate
  OnViewEvent = FormFactoryViewEvent
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 200
    Width = 688
    Height = 170
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 40
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Abrir Sender'
    TabOrder = 1
    OnClick = Button1Click
  end
end
