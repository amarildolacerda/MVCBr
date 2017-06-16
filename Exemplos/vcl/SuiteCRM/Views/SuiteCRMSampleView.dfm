object SugarCRMSampleView: TSugarCRMSampleView
  Left = 0
  Top = 0
  Caption = 'SugarCRMSampleView'
  ClientHeight = 456
  ClientWidth = 768
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    768
    456)
  PixelsPerInch = 96
  TextHeight = 13
  object LabeledEdit1: TLabeledEdit
    Left = 40
    Top = 24
    Width = 393
    Height = 21
    EditLabel.Width = 42
    EditLabel.Height = 13
    EditLabel.Caption = 'BaseURL'
    TabOrder = 0
    Text = 'http://intranet1.wbagestao.com.br:8887/suiteCRM'
  end
  object LabeledEdit2: TLabeledEdit
    Left = 40
    Top = 64
    Width = 393
    Height = 21
    EditLabel.Width = 73
    EditLabel.Height = 13
    EditLabel.Caption = 'PrefixResource'
    TabOrder = 1
    Text = '/service/v4_1/rest.php'
  end
  object LabeledEdit3: TLabeledEdit
    Left = 40
    Top = 112
    Width = 121
    Height = 21
    EditLabel.Width = 22
    EditLabel.Height = 13
    EditLabel.Caption = 'User'
    TabOrder = 2
    Text = 'admin'
  end
  object LabeledEdit4: TLabeledEdit
    Left = 167
    Top = 112
    Width = 121
    Height = 21
    EditLabel.Width = 46
    EditLabel.Height = 13
    EditLabel.Caption = 'Password'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 40
    Top = 160
    Width = 121
    Height = 25
    Caption = 'Login'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 458
    Top = 8
    Width = 302
    Height = 266
    Lines.Strings = (
      'Memo1')
    TabOrder = 5
  end
  object Button2: TButton
    Left = 167
    Top = 155
    Width = 75
    Height = 25
    Caption = 'Criar Conta'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 243
    Top = 186
    Width = 75
    Height = 25
    Caption = 'Get Conta'
    TabOrder = 7
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 241
    Top = 163
    Width = 211
    Height = 21
    TabOrder = 8
    Text = '17e90f76-589f-8526-daee-590fb9b8185b'
  end
  object Button4: TButton
    Left = 167
    Top = 186
    Width = 75
    Height = 25
    Caption = 'Count'
    TabOrder = 9
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 321
    Top = 187
    Width = 75
    Height = 25
    Caption = 'List'
    TabOrder = 10
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 40
    Top = 186
    Width = 121
    Height = 25
    Caption = 'get_user_id'
    TabOrder = 11
    OnClick = Button6Click
  end
  object DBGrid1: TDBGrid
    Left = -2
    Top = 288
    Width = 762
    Height = 169
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource1
    TabOrder = 12
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object LabeledEdit5: TLabeledEdit
    Left = 40
    Top = 232
    Width = 177
    Height = 21
    EditLabel.Width = 39
    EditLabel.Height = 13
    EditLabel.Caption = 'M'#243'dulos'
    TabOrder = 13
    Text = 'Accounts'
  end
  object Button7: TButton
    Left = 218
    Top = 228
    Width = 178
    Height = 25
    Caption = 'get_module_fields'
    TabOrder = 14
    OnClick = Button7Click
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 648
    Top = 16
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 616
    Top = 160
  end
  object RESTSocialMemTableAdapter1: TRESTSocialMemTableAdapter
    DataSet = FDMemTable1
    RootElement = 'result'
    Left = 512
    Top = 64
  end
end
