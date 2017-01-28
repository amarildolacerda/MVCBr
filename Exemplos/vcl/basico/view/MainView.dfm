object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'MainView'
  ClientHeight = 102
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 84
    Height = 13
    Caption = 'ValidarCPF/CNPJ:'
  end
  object Edit1: TEdit
    Left = 32
    Top = 43
    Width = 289
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 327
    Top = 41
    Width = 75
    Height = 25
    Caption = 'Validar'
    TabOrder = 1
    OnClick = Button1Click
  end
end
