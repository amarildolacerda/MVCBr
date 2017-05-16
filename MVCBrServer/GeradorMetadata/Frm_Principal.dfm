object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'ORMBr Generation ModelDB'
  ClientHeight = 640
  ClientWidth = 1090
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Splitter3: TSplitter
    Left = 265
    Top = 169
    Width = 5
    Height = 452
    AutoSnap = False
    Color = clSilver
    MinSize = 200
    ParentColor = False
    ResizeStyle = rsUpdate
    ExplicitLeft = 278
    ExplicitTop = 99
    ExplicitHeight = 522
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1090
    Height = 169
    Align = alTop
    TabOrder = 0
    object pnCONN: TPanel
      Left = 624
      Top = 1
      Width = 465
      Height = 167
      Align = alRight
      BevelOuter = bvNone
      BorderWidth = 5
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Panel9: TPanel
        Left = 5
        Top = 5
        Width = 455
        Height = 19
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Conex'#245'es'
        Color = clSilver
        ParentBackground = False
        TabOrder = 0
      end
      object pnCONN_NAV: TPanel
        Left = 5
        Top = 135
        Width = 455
        Height = 27
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object DBNavigator1: TDBNavigator
          Left = 0
          Top = 0
          Width = 89
          Height = 27
          DataSource = DTS_CNN
          VisibleButtons = [nbInsert, nbDelete]
          Align = alLeft
          TabOrder = 0
        end
        object btnConectar: TBitBtn
          Left = 327
          Top = 0
          Width = 128
          Height = 27
          Align = alRight
          Caption = 'Conectar'
          Glyph.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            0800000000000001000000000000000000000001000000010000FF00FF00393B
            3E000047000000490000004C00000052000001550100005B0100015F0100035B
            0500035C05000160010002660400016A010006660C00056A0800056E0C000373
            040003740600007F0000076F1100077011000E7A1A006F707300018802000C87
            1F000B8C1A001386220015A533001EB2350020C13A001AB641002CD34A0032DC
            6400004BC000004DC200004DC4000151C6000452CB000558D000075CD4000B64
            D700116ED7000D68E200116CE9001573E6001676E5001777E9001F81FF002489
            E9002083FE002184FF00268BFF00288FF8002D96FF003EABFF0042B2FF000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000242400000000000000000000242424252E3524000000000000
            000026262F38372E2400000000000000000024342A3136322400000000000000
            0000002437292C302400000000000000000000002432282B2400000000000000
            170100000024302824000000000F051701001717000024240000000005152105
            0017010000000000000000000A1F1B200501001701000000000000000A1F190F
            1805170100000000000000000A1C1A0C0A1305000000000000000000150F120D
            0C05050000000000000000161D0A0303030300000000000000000E1E12020000
            00000000000000000000050A0300000000000000000000000000}
          TabOrder = 1
          OnClick = btnConectarClick
        end
      end
      object Panel10: TPanel
        AlignWithMargins = True
        Left = 8
        Top = 58
        Width = 449
        Height = 74
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 3
        Color = clWhite
        Enabled = False
        ParentBackground = False
        TabOrder = 2
        object DBText3: TDBText
          AlignWithMargins = True
          Left = 6
          Top = 6
          Width = 437
          Height = 18
          Align = alTop
          DataField = 'CNN_Server'
          DataSource = DTS_CNN
          ExplicitLeft = 0
          ExplicitTop = 45
          ExplicitWidth = 340
        end
        object DBRichEdit1: TDBRichEdit
          AlignWithMargins = True
          Left = 6
          Top = 30
          Width = 437
          Height = 38
          Align = alClient
          BorderStyle = bsNone
          DataField = 'CNN_Database'
          DataSource = DTS_CNN
          ParentFont = True
          TabOrder = 0
          Zoom = 100
        end
      end
      object Combo_Connection: TComboBox
        Left = 5
        Top = 24
        Width = 455
        Height = 31
        Align = alTop
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Calibri'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnChange = Combo_ConnectionChange
      end
    end
    object pnConfig: TPanel
      Left = 1
      Top = 1
      Width = 623
      Height = 167
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 5
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 30
        Width = 75
        Height = 16
        Caption = 'Scope Name'
      end
      object Label2: TLabel
        Left = 8
        Top = 74
        Width = 80
        Height = 16
        Caption = 'Path Modelos'
      end
      object btnReverseAll: TButton
        Left = 4
        Top = 139
        Width = 255
        Height = 23
        Caption = 'Gerar Modelos Selecionados >>'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Calibri'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnReverseAllClick
      end
      object edtProjeto: TEdit
        Left = 8
        Top = 47
        Width = 121
        Height = 24
        TabOrder = 1
        Text = 'ormbr.model.'
      end
      object Panel2: TPanel
        Left = 5
        Top = 5
        Width = 613
        Height = 19
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Configura'#231#227'o'
        Color = clSilver
        ParentBackground = False
        TabOrder = 2
      end
      object edtPath: TEdit
        Left = 8
        Top = 91
        Width = 585
        Height = 24
        CharCase = ecLowerCase
        TabOrder = 3
        Text = '.\modelos'
      end
      object Button1: TButton
        Left = 265
        Top = 139
        Width = 328
        Height = 23
        Caption = 'Gerar oData.ServiceModel.json (MVCBr) >>'
        TabOrder = 4
        OnClick = Button1Click
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 621
    Width = 1090
    Height = 19
    Panels = <>
  end
  object pnDisplayCode: TPanel
    Left = 270
    Top = 169
    Width = 820
    Height = 452
    Align = alClient
    BevelOuter = bvNone
    BevelWidth = 5
    BorderWidth = 5
    ParentBackground = False
    TabOrder = 2
    object Panel5: TPanel
      Left = 5
      Top = 5
      Width = 810
      Height = 16
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Classes Modelos'
      TabOrder = 0
    end
    object PageControl1: TPageControl
      Left = 5
      Top = 21
      Width = 810
      Height = 426
      ActivePage = tabModel
      Align = alClient
      TabOrder = 1
      object tabModel: TTabSheet
        Caption = 'Modelo Classe'
        TabVisible = False
        object memModel: TMemo
          Left = 0
          Top = 0
          Width = 802
          Height = 416
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 169
    Width = 265
    Height = 452
    Align = alLeft
    BevelOuter = bvNone
    Padding.Left = 5
    Padding.Top = 5
    Padding.Right = 5
    Padding.Bottom = 5
    TabOrder = 3
    object Splitter1: TSplitter
      Left = 5
      Top = 281
      Width = 255
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      Color = clSilver
      ParentColor = False
      ExplicitLeft = -4
      ExplicitTop = 288
      ExplicitWidth = 153
    end
    object lstTabelas: TListBox
      Left = 5
      Top = 21
      Width = 255
      Height = 260
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = False
      MultiSelect = True
      ParentCtl3D = False
      TabOrder = 0
      OnClick = lstTabelasClick
    end
    object Panel4: TPanel
      Left = 5
      Top = 286
      Width = 255
      Height = 161
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object lstCampos: TListBox
        Left = 0
        Top = 16
        Width = 255
        Height = 145
        Hint = 'Right Click Mouse'
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Ctl3D = False
        ParentCtl3D = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 255
        Height = 16
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Campos'
        Ctl3D = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
      end
    end
    object Panel6: TPanel
      Left = 5
      Top = 5
      Width = 255
      Height = 16
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Tabelas'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      TabOrder = 2
    end
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 734
    Top = 308
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 496
    Top = 368
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 494
    Top = 314
  end
  object FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink
    Left = 494
    Top = 256
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 494
    Top = 204
  end
  object Entidade_: TFDTable
    Connection = FDConn
    FetchOptions.AssignedValues = [evRecsSkip, evRecsMax, evRowsetSize, evDetailServerCascade]
    FetchOptions.RowsetSize = 0
    FetchOptions.RecsSkip = 0
    FetchOptions.RecsMax = 0
    Left = 500
    Top = 426
  end
  object FDPhysSQLiteDriverLink2: TFDPhysSQLiteDriverLink
    Left = 936
    Top = 212
  end
  object Metadata: TFDMetaInfoQuery
    Connection = FDConn
    MetaInfoKind = mkForeignKeys
    BaseObjectName = 'sysdba'
    ObjectName = 'E01_FON'
    Left = 728
    Top = 254
  end
  object Fields: TFDMetaInfoQuery
    Connection = FDConn
    MetaInfoKind = mkForeignKeys
    Left = 734
    Top = 366
  end
  object Entidade: TFDQuery
    Connection = FDConn
    Left = 504
    Top = 496
  end
  object CDS_CNN: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterInsert = CDS_CNNAfterInsert
    BeforePost = CDS_CNNBeforePost
    AfterPost = CDS_CNNAfterPost
    AfterDelete = CDS_CNNAfterDelete
    OnNewRecord = CDS_CNNNewRecord
    Left = 448
    Top = 96
    object CDS_CNNCNN_Type: TStringField
      FieldName = 'CNN_Type'
    end
    object CDS_CNNCNN_Name: TStringField
      FieldName = 'CNN_Name'
      Size = 30
    end
    object CDS_CNNCNN_Server: TStringField
      FieldName = 'CNN_Server'
      Size = 500
    end
    object CDS_CNNCNN_Port: TIntegerField
      FieldName = 'CNN_Port'
    end
    object CDS_CNNCNN_Database: TStringField
      FieldName = 'CNN_Database'
      Size = 500
    end
    object CDS_CNNCNN_Schema: TStringField
      FieldName = 'CNN_Schema'
      Size = 50
    end
    object CDS_CNNCNN_UserName: TStringField
      FieldName = 'CNN_UserName'
      Size = 50
    end
    object CDS_CNNCNN_Password: TStringField
      FieldName = 'CNN_Password'
      Size = 50
    end
    object CDS_CNNCNN_VendorLib: TStringField
      FieldName = 'CNN_VendorLib'
      Size = 255
    end
  end
  object DTS_CNN: TDataSource
    AutoEdit = False
    DataSet = CDS_CNN
    Left = 504
    Top = 96
  end
  object FDConn: TFDConnection
    Left = 730
    Top = 198
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 679
    Top = 500
  end
end
