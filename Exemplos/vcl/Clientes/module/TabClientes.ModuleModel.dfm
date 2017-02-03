object TabClientesModuleModel: TTabClientesModuleModel
  OldCreateOrder = False
  Height = 417
  Width = 597
  object FDConnection1: TFDConnection
    Params.Strings = (
      'ConnectionDef=SQLEstoque')
    Connected = True
    Left = 72
    Top = 56
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from ctgrupo')
    Left = 184
    Top = 56
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 272
    Top = 56
  end
end
