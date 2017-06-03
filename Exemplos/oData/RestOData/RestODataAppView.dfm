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
    Resource = '/produtos'
    ResourcePrefix = '/OData/OData.svc'
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
    Left = 64
    Top = 112
  end
  object ODataDatasetAdapter1: TODataDatasetAdapter
    Builder = ODataBuilder1
    Active = True
    Dataset = FDMemTable1
    Params = <>
    ResponseJSON = IdHTTPRestClient1
    RootElement = 'value'
    Left = 64
    Top = 232
  end
  object FDMemTable1: TFDMemTable
    Active = True
    BeforePost = FDMemTable1BeforePost
    AfterPost = FDMemTable1AfterPost
    BeforeDelete = FDMemTable1BeforeDelete
    FieldDefs = <
      item
        Name = 'codigo'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'descricao'
        DataType = ftString
        Size = 80
      end
      item
        Name = 'codfor'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'nomefor'
        DataType = ftString
        Size = 80
      end
      item
        Name = 'grupo'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'descgrupo'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'quant'
        DataType = ftFloat
      end
      item
        Name = 'quant2'
        DataType = ftFloat
      end
      item
        Name = 'qminima'
        DataType = ftFloat
      end
      item
        Name = 'ultima'
        DataType = ftDateTime
      end
      item
        Name = 'ucompra'
        DataType = ftDateTime
      end
      item
        Name = 'unidade'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'descprod'
        DataType = ftFloat
      end
      item
        Name = 'similarx'
        DataType = ftString
        Size = 10
      end
      item
        Name = 's_n'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'comissao'
        DataType = ftFloat
      end
      item
        Name = 'marca'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'codst'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'descst'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'obs'
        DataType = ftMemo
      end
      item
        Name = 'modelo'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'externo'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'dif_cod'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'codmarca'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'nomemarca'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'compmarca'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'locacao'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'codigoabc'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'liberado'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'uquant'
        DataType = ftFloat
      end
      item
        Name = 'tamanho'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'cor'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'subgrupo'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'ncm'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'cest'
        DataType = ftString
        Size = 7
      end
      item
        Name = 'st_crt'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'st_crt_saida'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'autor'
        DataType = ftString
        Size = 80
      end
      item
        Name = 'dtembalado'
        DataType = ftDateTime
      end
      item
        Name = 'dtvalidade'
        DataType = ftDateTime
      end
      item
        Name = 'nrregistro'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'tipo_servico'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'princ_ativo'
        DataType = ftString
        Size = 80
      end
      item
        Name = 'pis'
        DataType = ftFloat
      end
      item
        Name = 'cofins'
        DataType = ftFloat
      end
      item
        Name = 'ean_trib'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'descricao_original'
        DataType = ftString
        Size = 80
      end
      item
        Name = 'tipo_produto'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'cfop_contab'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'cfop_base'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'cfop_saida'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'cod_anp'
        DataType = ftString
        Size = 9
      end
      item
        Name = 'codif'
        DataType = ftString
        Size = 21
      end
      item
        Name = 'qtd_inicio'
        DataType = ftFloat
      end
      item
        Name = 'sped_entradas'
        DataType = ftFloat
      end
      item
        Name = 'sped_saidas'
        DataType = ftFloat
      end
      item
        Name = 'sped_saldo'
        DataType = ftFloat
      end
      item
        Name = 'serie_venda'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'inativo'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'tipo_kit'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'kg_por_mt'
        DataType = ftFloat
      end
      item
        Name = 'pesavel'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'tipo_locar'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'referencia'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'embalagem'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'permite_desconto'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'quant_davpre'
        DataType = ftFloat
      end
      item
        Name = 'id_produto'
        DataType = ftFloat
      end
      item
        Name = 'compra'
        DataType = ftFloat
      end
      item
        Name = 'dolar'
        DataType = ftFloat
      end
      item
        Name = 'custo'
        DataType = ftFloat
      end
      item
        Name = 'venda'
        DataType = ftFloat
      end
      item
        Name = 'ipi'
        DataType = ftFloat
      end
      item
        Name = 'icms'
        DataType = ftFloat
      end
      item
        Name = 'frete'
        DataType = ftFloat
      end
      item
        Name = 'cf'
        DataType = ftFloat
      end
      item
        Name = 'margem'
        DataType = ftFloat
      end
      item
        Name = 'fracao'
        DataType = ftFloat
      end
      item
        Name = 'aferido'
        DataType = ftFloat
      end
      item
        Name = 'p1'
        DataType = ftFloat
      end
      item
        Name = 'p2'
        DataType = ftFloat
      end
      item
        Name = 'p3'
        DataType = ftFloat
      end
      item
        Name = 'p4'
        DataType = ftFloat
      end
      item
        Name = 'vendfrac'
        DataType = ftFloat
      end>
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
