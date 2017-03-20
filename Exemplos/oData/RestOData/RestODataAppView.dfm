object RestODataAppView: TRestODataAppView
  Left = 0
  Top = 0
  Caption = 'RestODataAppView'
  ClientHeight = 377
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 10
    Top = 14
    Width = 633
    Height = 345
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
        FieldName = 'codigo'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'descricao'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'grupo'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'unidade'
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'preco'
        Width = 120
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 658
    Top = 26
    Width = 75
    Height = 25
    Caption = 'GET'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 658
    Top = 72
    Width = 75
    Height = 25
    Caption = 'ApplyUpdates'
    TabOrder = 2
    OnClick = Button2Click
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 184
    Top = 176
  end
  object IdHTTPRestClient1: TIdHTTPRestClient
    BaseURL = 'http://localhost:8080'
    Resource = 
      '/produtos?$select=codigo,descricao,grupo,unidade,preco&$filter=g' +
      'rupo eq '#39'1'#39
    ResourcePreffix = '/OData/OData.svc'
    AcceptCharset = 'UTF-8'
    Accept = 'application/json, text/plain, text/html'
    AcceptEncoding = 'gzip'
    Timeout = 360000
    Left = 64
    Top = 168
  end
  object ODataBuilder1: TODataBuilder
    RestClient = IdHTTPRestClient1
    BaseURL = 'http://localhost:8080'
    ServicePreffix = '/OData'
    Service = '/OData.svc'
    Resource = <
      item
        Resource = 'produtos'
        ResourceParams = <>
      end>
    TopRows = 0
    SkipRows = 0
    Count = False
    Left = 64
    Top = 112
  end
  object ODataDatasetAdapter1: TODataDatasetAdapter
    Builder = ODataBuilder1
    Active = False
    Dataset = FDMemTable1
    ResponseJSON = IdHTTPRestClient1
    RootElement = 'value'
    Left = 64
    Top = 232
  end
  object FDMemTable1: TFDMemTable
    BeforePost = FDMemTable1BeforePost
    AfterPost = FDMemTable1AfterPost
    BeforeDelete = FDMemTable1BeforeDelete
    FieldDefs = <>
    IndexDefs = <>
    BeforeApplyUpdates = FDMemTable1BeforeApplyUpdates
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 184
    Top = 112
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 408
    Top = 160
  end
end
