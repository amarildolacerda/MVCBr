object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'MainView'
  ClientHeight = 490
  ClientWidth = 772
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 24
    Top = 48
    Width = 257
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 105
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 24
    Top = 96
    Width = 75
    Height = 25
    Caption = 'CEP'
    TabOrder = 2
  end
  object DBGrid1: TDBGrid
    Left = 24
    Top = 136
    Width = 713
    Height = 321
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button3: TButton
    Left = 206
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 624
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Recarregar'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 464
    Top = 96
    Width = 154
    Height = 25
    Caption = 'Recarregar Codigo'
    TabOrder = 6
    OnClick = Button5Click
  end
  object MainMenu1: TMainMenu
    Left = 304
    Top = 8
    object ProcurarEndereo1: TMenuItem
      Caption = 'Procurar Endere'#231'o'
      OnClick = ProcurarEndereo1Click
    end
  end
end
