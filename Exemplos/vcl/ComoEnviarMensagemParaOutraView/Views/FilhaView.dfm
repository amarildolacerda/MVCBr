object FilhaView: TFilhaView
  Left = 0
  Top = 0
  Caption = 'Minha Tabsheet Filha'
  ClientHeight = 368
  ClientWidth = 588
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 104
    Top = 40
    Width = 393
    Height = 177
    Caption = 'View Filha'
    TabOrder = 0
  end
  object Button1: TButton
    Left = 56
    Top = 249
    Width = 241
    Height = 25
    Caption = 'Trocar tab da view mae (Tab1)'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 328
    Top = 249
    Width = 241
    Height = 25
    Caption = 'Trocar tab da view mae (Tab2)'
    TabOrder = 2
    OnClick = Button2Click
  end
end
