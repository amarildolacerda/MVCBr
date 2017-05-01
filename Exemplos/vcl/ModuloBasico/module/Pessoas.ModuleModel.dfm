object PessoasModuleModel: TPessoasModuleModel
  OldCreateOrder = False
  Height = 291
  Width = 516
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 32
    Top = 32
  end
  object FDTable1: TFDTable
    Connection = FDConnection1
    UpdateOptions.UpdateTableName = 'cadastro'
    TableName = 'cadastro'
    Left = 40
    Top = 112
    object FDTable1Codigo: TIntegerField
      FieldName = 'Codigo'
    end
    object FDTable1Nome: TStringField
      FieldName = 'Nome'
      Size = 50
    end
  end
  object DataSource1: TDataSource
    DataSet = FDTable1
    Left = 240
    Top = 128
  end
end
