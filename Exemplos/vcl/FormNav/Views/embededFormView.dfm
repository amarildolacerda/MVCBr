object embededFormView: TembededFormView
  Left = 0
  Top = 0
  Caption = 'embededFormView'
  ClientHeight = 231
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnViewEvent = FormFactoryViewEvent
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 505
    Height = 41
    Align = alTop
    Caption = 'tab  VIEW'
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 505
    Height = 190
    Align = alClient
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
end
