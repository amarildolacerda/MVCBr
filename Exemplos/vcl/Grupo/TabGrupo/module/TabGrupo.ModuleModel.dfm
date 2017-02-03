object TabGrupoModuleModel: TTabGrupoModuleModel
  OldCreateOrder = False
  Height = 192
  Width = 261
  object FDConnection1: TFDConnection
    Params.Strings = (
      'ConnectionDef=SQLEstoque')
    Connected = True
    LoginPrompt = False
    Left = 48
    Top = 40
  end
  object FDQuery1: TFDQuery
    AfterScroll = FDQuery1AfterScroll
    Connection = FDConnection1
    SQL.Strings = (
      'select * from ctgrupo')
    Left = 152
    Top = 40
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 136
    Top = 120
  end
end
