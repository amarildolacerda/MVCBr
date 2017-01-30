object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'MainView'
  ClientHeight = 321
  ClientWidth = 549
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 8
    Top = 24
    Width = 533
    Height = 225
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object btAbrir: TButton
    Left = 368
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 466
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 2
  end
end
