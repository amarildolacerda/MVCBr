object WSConfigView: TWSConfigView
  Left = 0
  Top = 0
  Caption = 'Configura'#231#245'es'
  ClientHeight = 372
  ClientWidth = 376
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 24
    Top = 152
    Width = 329
    Height = 169
    Caption = 'Configura'#231#245'es do Banco de Dados'
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 26
      Width = 29
      Height = 13
      Caption = 'Driver'
    end
    object Label2: TLabel
      Left = 22
      Top = 53
      Width = 32
      Height = 13
      Caption = 'Server'
    end
    object Label3: TLabel
      Left = 22
      Top = 78
      Width = 46
      Height = 13
      Caption = 'Database'
    end
    object Label4: TLabel
      Left = 22
      Top = 107
      Width = 36
      Height = 13
      Caption = 'Usu'#225'rio'
    end
    object Label5: TLabel
      Left = 23
      Top = 134
      Width = 30
      Height = 13
      Caption = 'Senha'
    end
    object cbDriver: TComboBox
      Left = 72
      Top = 24
      Width = 137
      Height = 21
      TabOrder = 0
      Text = 'FB'
      TextHint = 'Driver para o fabricante do Banco de Dados'
      Items.Strings = (
        'FB'
        'MySQL')
    end
    object edServer: TEdit
      Left = 72
      Top = 51
      Width = 225
      Height = 21
      TabOrder = 1
      Text = 'localhost:3050'
      TextHint = 'Endere'#231'o do Servidor de Dados'
    end
    object edBancoDados: TEdit
      Left = 72
      Top = 77
      Width = 225
      Height = 21
      TabOrder = 2
      TextHint = 'Local/Identifica'#231#227'o do banco de dados'
    end
    object edUsuario: TEdit
      Left = 72
      Top = 104
      Width = 153
      Height = 21
      TabOrder = 3
      TextHint = 'Usu'#225'rio de login no banco da dados'
    end
    object edSenha: TEdit
      Left = 72
      Top = 131
      Width = 121
      Height = 21
      PasswordChar = '*'
      TabOrder = 4
      TextHint = 'Senha de acesso'
    end
  end
  object Button1: TButton
    Left = 278
    Top = 327
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object GroupBox2: TGroupBox
    Left = 24
    Top = 8
    Width = 329
    Height = 138
    Caption = 'Configura'#231#245'es do Servidor'
    TabOrder = 2
  end
end
