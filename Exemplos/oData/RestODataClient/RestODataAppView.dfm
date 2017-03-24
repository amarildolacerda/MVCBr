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
    DataSet = ODataFDMemTable1
    Left = 120
    Top = 152
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 408
    Top = 160
  end
  object ODataDatasetBuilder1: TODataDatasetBuilder
    BaseURL = 'http://localhost:8080'
    ServicePreffix = '/OData'
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
    Dataset = ODataFDMemTable1
    Left = 112
    Top = 232
  end
  object ODataFDMemTable1: TODataFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 120
    Top = 80
  end
end
