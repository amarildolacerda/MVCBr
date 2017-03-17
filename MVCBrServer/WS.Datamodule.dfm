object WSDatamodule: TWSDatamodule
  OldCreateOrder = False
  Height = 350
  Width = 353
  object FDManager1: TFDManager
    SilentMode = True
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    AfterLoadConnectionDefFile = FDManager1AfterLoadConnectionDefFile
    Left = 48
    Top = 32
  end
  object FDConnection1: TFDConnection
    ConnectionName = 'MVBr_Firebird'
    Params.Strings = (
      'Database=mvcbr'
      'User_Name=sysdba'
      'Password=masterkey'
      'Port=3050'
      'Server=localhost'
      'DriverID=FB')
    LoginPrompt = False
    Left = 168
    Top = 32
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 88
    Top = 96
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    DriverID = 'FB'
    Left = 80
    Top = 176
  end
  object FDSchemaAdapter1: TFDSchemaAdapter
    Left = 184
    Top = 168
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 120
    Top = 256
  end
end
