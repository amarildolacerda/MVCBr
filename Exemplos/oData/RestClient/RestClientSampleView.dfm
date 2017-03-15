object RestClientSampleView: TRestClientSampleView
  Left = 0
  Top = 0
  Caption = 'RestClientSampleView'
  ClientHeight = 434
  ClientWidth = 892
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
    Left = 24
    Top = 32
    Width = 465
    Height = 361
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
        FieldName = 'grupo'
        Width = 118
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nome'
        Visible = True
      end>
  end
  object Memo1: TMemo
    Left = 512
    Top = 32
    Width = 377
    Height = 361
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 511
    Top = 5
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object RESTClient1: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    AcceptEncoding = 'gzip'
    BaseURL = 'http://localhost:8886'
    Params = <>
    HandleRedirects = True
    Left = 184
    Top = 288
  end
  object RESTRequest1: TRESTRequest
    AcceptEncoding = 'gzip'
    Client = RESTClient1
    Params = <>
    Resource = 'OData/OData.svc/grupos'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 112
    Top = 288
  end
  object RESTResponse1: TRESTResponse
    ContentType = 'application/json; odata.metadata=minimal'
    Left = 272
    Top = 288
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Active = True
    Dataset = FDMemTable1
    FieldDefs = <>
    ResponseJSON = RESTResponse1
    RootElement = 'value'
    Left = 208
    Top = 224
  end
  object FDMemTable1: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'grupo'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'nome'
        DataType = ftWideString
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
    Left = 104
    Top = 208
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 216
    Top = 176
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 440
    Top = 224
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 560
    Top = 232
  end
end
