object MongoDBModelView: TMongoDBModelView
  Left = 0
  Top = 0
  Caption = 'MongoDBModelView'
  ClientHeight = 489
  ClientWidth = 548
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormFactoryCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 16
    Top = 56
    Width = 513
    Height = 121
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button1: TButton
    Left = 16
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 1
    OnClick = Button1Click
  end
  object DBGrid2: TDBGrid
    Left = 16
    Top = 224
    Width = 513
    Height = 120
    DataSource = DataSource2
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button2: TButton
    Left = 16
    Top = 196
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 120
    Top = 196
    Width = 75
    Height = 25
    Caption = 'apply'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 32
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Count'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 392
    Width = 513
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 6
  end
  object Button5: TButton
    Left = 113
    Top = 361
    Width = 75
    Height = 25
    Caption = 'Limit 2'
    TabOrder = 7
    OnClick = Button5Click
  end
  object FDMemTable1: TFDMemTable
    BeforePost = FDMemTable1BeforePost
    BeforeDelete = FDMemTable1BeforeDelete
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 224
    Top = 64
    object FDMemTable1codigo: TStringField
      FieldName = 'codigo'
      Size = 18
    end
    object FDMemTable1nome: TStringField
      FieldName = 'nome'
      Size = 50
    end
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 312
    Top = 72
  end
  object DataSource2: TDataSource
    DataSet = MVCBrMongoDataset1
    Left = 416
    Top = 256
  end
  object MVCBrMongoConnection1: TMVCBrMongoConnection
    Host = 'localhost'
    Database = 'mvcbrDB'
    Left = 144
    Top = 264
  end
  object MVCBrMongoDataset1: TMVCBrMongoDataset
    CollectionName = 'produtos'
    KeyFields = 'codigo'
    Connection = MVCBrMongoConnection1
    FieldDefs = <
      item
        Name = 'codigo'
        DataType = ftString
        Size = 18
      end
      item
        Name = 'nome'
        DataType = ftString
        Size = 50
      end>
    Active = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 296
    Top = 256
    object MVCBrMongoDataset1codigo: TStringField
      FieldName = 'codigo'
      Size = 18
    end
    object MVCBrMongoDataset1nome: TStringField
      FieldName = 'nome'
      Size = 50
    end
  end
end
