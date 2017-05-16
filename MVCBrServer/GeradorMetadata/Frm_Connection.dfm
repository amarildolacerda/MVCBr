object FrmConnection: TFrmConnection
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Configuration Connection'
  ClientHeight = 350
  ClientWidth = 412
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 406
    Height = 344
    Align = alClient
    Caption = 'Criar Conex'#227'o'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Calibri'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 0
    ExplicitHeight = 334
    object Label1: TLabel
      Left = 36
      Top = 69
      Width = 47
      Height = 19
      Caption = 'Server:'
    end
    object Label2: TLabel
      Left = 16
      Top = 134
      Width = 67
      Height = 19
      Caption = 'DataBase:'
    end
    object Label3: TLabel
      Left = 49
      Top = 166
      Width = 34
      Height = 19
      Caption = 'User:'
    end
    object Label4: TLabel
      Left = 16
      Top = 198
      Width = 67
      Height = 19
      Caption = 'Password:'
    end
    object Label5: TLabel
      Left = 37
      Top = 30
      Width = 46
      Height = 19
      Caption = 'Driver:'
    end
    object Label6: TLabel
      Left = 15
      Top = 263
      Width = 68
      Height = 19
      Caption = 'Descri'#231#227'o:'
    end
    object SpeedButton1: TSpeedButton
      Left = 360
      Top = 131
      Width = 26
      Height = 26
      Caption = '...'
      OnClick = SpeedButton1Click
    end
    object Label7: TLabel
      Left = 50
      Top = 102
      Width = 33
      Height = 19
      Caption = 'Port:'
    end
    object Label8: TLabel
      Left = 16
      Top = 232
      Width = 69
      Height = 19
      Caption = 'VendorLib:'
    end
    object SpeedButton2: TSpeedButton
      Left = 360
      Top = 228
      Width = 26
      Height = 26
      Caption = '...'
      OnClick = SpeedButton2Click
    end
    object DBComboBox1: TDBComboBox
      Left = 95
      Top = 27
      Width = 145
      Height = 27
      Style = csDropDownList
      DataField = 'CNN_Type'
      DataSource = FrmPrincipal.DTS_CNN
      Items.Strings = (
        'MSSQL'
        'Firebird'
        'Interbase'
        'Oracle'
        'MySQL'
        'SQLite'
        'PostgreSQL')
      TabOrder = 0
      OnChange = DBComboBox1Change
    end
    object DBEdit1: TDBEdit
      Left = 95
      Top = 260
      Width = 264
      Height = 27
      DataField = 'CNN_Name'
      DataSource = FrmPrincipal.DTS_CNN
      TabOrder = 7
    end
    object DBEdit2: TDBEdit
      Left = 95
      Top = 66
      Width = 186
      Height = 27
      DataField = 'CNN_Server'
      DataSource = FrmPrincipal.DTS_CNN
      TabOrder = 1
    end
    object DBEdit3: TDBEdit
      Left = 95
      Top = 131
      Width = 264
      Height = 27
      DataField = 'CNN_Database'
      DataSource = FrmPrincipal.DTS_CNN
      TabOrder = 3
    end
    object DBEdit4: TDBEdit
      Left = 95
      Top = 163
      Width = 164
      Height = 27
      DataField = 'CNN_UserName'
      DataSource = FrmPrincipal.DTS_CNN
      TabOrder = 4
    end
    object DBEdit5: TDBEdit
      Left = 95
      Top = 195
      Width = 164
      Height = 27
      DataField = 'CNN_Password'
      DataSource = FrmPrincipal.DTS_CNN
      PasswordChar = '*'
      TabOrder = 5
    end
    object btnSalvar: TBitBtn
      Left = 95
      Top = 298
      Width = 100
      Height = 25
      Caption = 'Salvar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF97433F97433FB59A9BB59A9BB59A9BB5
        9A9BB59A9BB59A9BB59A9B93303097433FFF00FFFF00FFFF00FFFF00FF97433F
        D66868C66060E5DEDF92292A92292AE4E7E7E0E3E6D9DFE0CCC9CC8F201FAF46
        4697433FFF00FFFF00FFFF00FF97433FD06566C25F5FE9E2E292292A92292AE2
        E1E3E2E6E8DDE2E4CFCCCF8F2222AD464697433FFF00FFFF00FFFF00FF97433F
        D06565C15D5DECE4E492292A92292ADFDDDFE1E6E8E0E5E7D3D0D28A1E1EAB44
        4497433FFF00FFFF00FFFF00FF97433FD06565C15B5CEFE6E6EDE5E5E5DEDFE0
        DDDFDFE0E2E0E1E3D6D0D2962A2AB24A4A97433FFF00FFFF00FFFF00FF97433F
        CD6263C86060C96767CC7272CA7271C66969C46464CC6D6CCA6667C55D5DCD65
        6597433FFF00FFFF00FFFF00FF97433FB65553C27B78D39D9CD7A7A5D8A7A6D8
        A6A5D7A09FD5A09FD7A9A7D8ABABCC666797433FFF00FFFF00FFFF00FF97433F
        CC6667F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9CC66
        6797433FFF00FFFF00FFFF00FF97433FCC6667F9F9F9F9F9F9F9F9F9F9F9F9F9
        F9F9F9F9F9F9F9F9F9F9F9F9F9F9CC666797433FFF00FFFF00FFFF00FF97433F
        CC6667F9F9F9CDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDF9F9F9CC66
        6797433FFF00FFFF00FFFF00FF97433FCC6667F9F9F9F9F9F9F9F9F9F9F9F9F9
        F9F9F9F9F9F9F9F9F9F9F9F9F9F9CC666797433FFF00FFFF00FFFF00FF97433F
        CC6667F9F9F9CDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDF9F9F9CC66
        6797433FFF00FFFF00FFFF00FF97433FCC6667F9F9F9F9F9F9F9F9F9F9F9F9F9
        F9F9F9F9F9F9F9F9F9F9F9F9F9F9CC666797433FFF00FFFF00FFFF00FFFF00FF
        97433FF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F99743
        3FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ModalResult = 1
      ParentFont = False
      TabOrder = 8
      OnClick = btnSalvarClick
    end
    object btnCancel: TBitBtn
      Left = 206
      Top = 298
      Width = 100
      Height = 25
      Caption = 'Cancelar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 9
      OnClick = btnCancelClick
    end
    object DBEdit6: TDBEdit
      Left = 95
      Top = 99
      Width = 164
      Height = 27
      DataField = 'CNN_Port'
      DataSource = FrmPrincipal.DTS_CNN
      TabOrder = 2
    end
    object DBEdit7: TDBEdit
      Left = 95
      Top = 227
      Width = 264
      Height = 27
      DataField = 'CNN_VendorLib'
      DataSource = FrmPrincipal.DTS_CNN
      TabOrder = 6
    end
  end
  object OD: TOpenDialog
    FileName = 'Todos'
    Filter = '*.*'
    Left = 339
    Top = 43
  end
end
