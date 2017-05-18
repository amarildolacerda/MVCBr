inherited NavegadorView: TNavegadorView
  Caption = 'NavegadorView'
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 44
    Width = 456
    Height = 352
    Align = alClient
    BorderStyle = bsNone
    DataSource = DataSource1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object FDMemTable1: TFDMemTable
    Active = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 80
    Top = 112
    object FDMemTable1ID: TIntegerField
      FieldName = 'ID'
    end
    object FDMemTable1Texto: TStringField
      FieldName = 'Texto'
      Size = 30
    end
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 176
    Top = 120
  end
end
