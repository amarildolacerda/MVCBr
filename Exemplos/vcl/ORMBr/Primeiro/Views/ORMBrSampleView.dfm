object ORMBrSampleView: TORMBrSampleView
  Left = 0
  Top = 0
  Caption = 'ORMBrSampleView'
  ClientHeight = 434
  ClientWidth = 681
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormFactoryShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 16
    Top = 48
    Width = 657
    Height = 313
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button1: TButton
    Left = 16
    Top = 367
    Width = 121
    Height = 25
    Caption = 'ApplyUpdates'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 17
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 2
    OnClick = Button2Click
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 224
    Top = 160
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 440
    Top = 200
  end
end
