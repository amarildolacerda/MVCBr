object CRUDProdutosView: TCRUDProdutosView
  Left = 0
  Top = 0
  Caption = 'CRUDProdutosView'
  ClientHeight = 421
  ClientWidth = 604
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 40
    Top = 77
    Width = 556
    Height = 278
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button1: TButton
    Left = 40
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 144
    Top = 49
    Width = 75
    Height = 25
    Caption = 'Apply Update'
    TabOrder = 2
    OnClick = Button2Click
  end
  object DataSource1: TDataSource
    DataSet = ODataFDMemTable1
    Left = 96
    Top = 104
  end
  object ODataDatasetBuilder1: TODataDatasetBuilder
    Dataset = ODataFDMemTable1
    Params = <>
    BaseURL = 'http://localhost:8080'
    ServicePrefix = '/OData'
    Service = '/OData.svc'
    ResourceName = 'produtos'
    Resource = <
      item
        Resource = 'produtos'
        ResourceParams = <>
      end>
    TopRows = 0
    SkipRows = 0
    Count = False
    Left = 336
    Top = 16
  end
  object ODataFDMemTable1: TODataFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'codigo'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'descricao'
        DataType = ftString
        Size = 128
      end
      item
        Name = 'grupo'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'unidade'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'preco'
        DataType = ftFloat
      end
      item
        Name = 'figura'
        DataType = ftString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    KeyFields = 'codigo'
    UpdateTable = 'produtos'
    Left = 472
    Top = 24
    object ODataFDMemTable1codigo: TStringField
      FieldName = 'codigo'
      Size = 30
    end
    object ODataFDMemTable1descricao: TStringField
      FieldName = 'descricao'
      Size = 128
    end
    object ODataFDMemTable1grupo: TStringField
      FieldName = 'grupo'
      Size = 10
    end
    object ODataFDMemTable1unidade: TStringField
      FieldName = 'unidade'
      Size = 5
    end
    object ODataFDMemTable1preco: TFloatField
      FieldName = 'preco'
    end
    object ODataFDMemTable1figura: TStringField
      FieldName = 'figura'
      ProviderFlags = [pfInUpdate]
      Size = 255
    end
  end
end
