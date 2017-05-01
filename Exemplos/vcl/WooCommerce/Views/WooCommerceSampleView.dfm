object WooCommerceSampleView: TWooCommerceSampleView
  Left = 0
  Top = 0
  Caption = 'WooCommerceSampleView'
  ClientHeight = 587
  ClientWidth = 585
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LabeledEdit1: TLabeledEdit
    Left = 56
    Top = 72
    Width = 465
    Height = 21
    EditLabel.Width = 69
    EditLabel.Height = 13
    EditLabel.Caption = 'Consumer Key'
    TabOrder = 0
    Text = 'ck_5e3308a628aeae400f366b7551b7031b2d938f4b'
  end
  object LabeledEdit2: TLabeledEdit
    Left = 56
    Top = 114
    Width = 465
    Height = 21
    EditLabel.Width = 82
    EditLabel.Height = 13
    EditLabel.Caption = 'Consumer Secret'
    TabOrder = 1
    Text = 'cs_85e0e6904977caa43c186720e24e30f99b4ade4e'
  end
  object Button1: TButton
    Left = 56
    Top = 141
    Width = 97
    Height = 25
    Caption = 'products/count'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 56
    Top = 296
    Width = 465
    Height = 257
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
  object LabeledEdit3: TLabeledEdit
    Left = 56
    Top = 32
    Width = 465
    Height = 21
    EditLabel.Width = 42
    EditLabel.Height = 13
    EditLabel.Caption = 'BaseURL'
    TabOrder = 4
    Text = 'http://hotstore.com.br'
  end
  object Button2: TButton
    Left = 159
    Top = 142
    Width = 75
    Height = 25
    Caption = 'products'
    TabOrder = 5
    OnClick = Button2Click
  end
  object LabeledEdit4: TLabeledEdit
    Left = 56
    Top = 184
    Width = 121
    Height = 21
    EditLabel.Width = 52
    EditLabel.Height = 13
    EditLabel.Caption = 'ID Produto'
    TabOrder = 6
    Text = '2711'
  end
  object Button3: TButton
    Left = 178
    Top = 182
    Width = 75
    Height = 25
    Caption = 'Get/{ID}'
    TabOrder = 7
    OnClick = Button3Click
  end
  object LabeledEdit5: TLabeledEdit
    Left = 258
    Top = 183
    Width = 129
    Height = 21
    EditLabel.Width = 27
    EditLabel.Height = 13
    EditLabel.Caption = 'Pre'#231'o'
    TabOrder = 8
  end
  object Button4: TButton
    Left = 393
    Top = 181
    Width = 75
    Height = 25
    Caption = 'Alterar Pre'#231'o'
    TabOrder = 9
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 56
    Top = 211
    Width = 75
    Height = 25
    Caption = 'Orders'
    TabOrder = 10
    OnClick = Button5Click
  end
end
