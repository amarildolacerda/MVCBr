object Form61: TForm61
  Left = 0
  Top = 0
  Caption = 'Form61'
  ClientHeight = 493
  ClientWidth = 806
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    806
    493)
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 217
    Height = 401
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'nome'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'codigo'
        Visible = True
      end>
  end
  object DBGrid2: TDBGrid
    Left = 231
    Top = 8
    Width = 562
    Height = 401
    DataSource = DataSource2
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Memo1: TMemo
    Left = 8
    Top = 415
    Width = 785
    Height = 74
    Anchors = [akLeft, akTop, akBottom]
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object ODataFDMemTable1: TODataFDMemTable
    FieldDefs = <
      item
        Name = 'codigo'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'nome'
        DataType = ftString
        Size = 128
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    KeyFields = 'codigo'
    UpdateTable = 'grupos'
    Left = 64
    Top = 192
  end
  object ODataDatasetBuilder1: TODataDatasetBuilder
    Dataset = ODataFDMemTable1
    Params = <>
    BaseURL = 'http://localhost:8080'
    ServicePrefix = '/OData'
    Service = '/OData.svc'
    ResourceName = 'grupos'
    Resource = <
      item
        Resource = 'grupos'
        ResourceParams = <>
      end>
    TopRows = 0
    SkipRows = 0
    Count = False
    Left = 64
    Top = 320
  end
  object DataSource1: TDataSource
    DataSet = ODataFDMemTable1
    OnDataChange = DataSource1DataChange
    Left = 64
    Top = 248
  end
  object ODataFDMemTable2: TODataFDMemTable
    AfterInsert = ODataFDMemTable2AfterInsert
    FieldDefs = <>
    IndexDefs = <>
    MasterSource = DataSource1
    MasterFields = 'codigo'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    UpdateTable = 'grupos'
    Left = 296
    Top = 176
    object ODataFDMemTable2codigo: TStringField
      FieldName = 'codigo'
      Required = True
      Size = 30
    end
    object ODataFDMemTable2descricao: TStringField
      FieldName = 'descricao'
      ProviderFlags = [pfInUpdate]
      Required = True
      Size = 128
    end
    object ODataFDMemTable2grupo: TStringField
      FieldName = 'grupo'
      ProviderFlags = [pfInUpdate]
      Required = True
      Size = 10
    end
    object ODataFDMemTable2unidade: TStringField
      FieldName = 'unidade'
      ProviderFlags = [pfInUpdate]
      Required = True
      Size = 5
    end
    object ODataFDMemTable2preco: TFloatField
      FieldName = 'preco'
      ProviderFlags = [pfInUpdate]
      Required = True
    end
  end
  object ODataDatasetBuilder2: TODataDatasetBuilder
    Dataset = ODataFDMemTable2
    Params = <
      item
        DataType = ftString
        Name = 'codigo'
        ParamType = ptUnknown
      end>
    BaseURL = 'http://localhost:8080'
    ServicePrefix = '/OData'
    Service = '/OData.svc'
    ResourceName = 'produtos'
    Resource = <
      item
        Resource = 'produtos'
        ResourceParams = <>
      end>
    Filter = 'grupo eq {codigo}'
    TopRows = 0
    SkipRows = 0
    Count = False
    AfterExecute = ODataDatasetBuilder2AfterExecute
    Left = 296
    Top = 248
  end
  object DataSource2: TDataSource
    DataSet = ODataFDMemTable2
    Left = 288
    Top = 88
  end
  object FDQuery1: TFDQuery
    Left = 384
    Top = 304
  end
end
