object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'MainView'
  ClientHeight = 166
  ClientWidth = 444
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
    Top = 32
    Width = 50
    Height = 13
    Caption = 'Valida'#231#245'es'
  end
  object Edit1: TEdit
    Left = 32
    Top = 51
    Width = 233
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 32
    Top = 89
    Width = 75
    Height = 25
    Caption = 'EAN'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 113
    Top = 89
    Width = 75
    Height = 25
    Caption = 'CPF/CNPJ'
    TabOrder = 2
    OnClick = Button2Click
  end
end
