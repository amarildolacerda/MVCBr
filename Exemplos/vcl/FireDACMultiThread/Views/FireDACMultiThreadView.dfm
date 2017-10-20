object FireDACMultiThreadView: TFireDACMultiThreadView
  Left = 0
  Top = 0
  Caption = 'FireDACMultiThreadView'
  ClientHeight = 497
  ClientWidth = 575
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 575
    Height = 225
    Align = alTop
    ExplicitTop = -6
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 552
    Height = 129
    Lines.Strings = (
      'Regras b'#225'sicas para usar Multi-Thread com FireDAC'
      '-------------------------------------------------------------'
      '1. Cada chamada ao banco deve ser isolada;'
      '2. Criar um conex'#227'o para cada uma das opera'#231#245'es;'
      '3. Ativar Async Mode na FDQuery;'
      '3. Monitorar se a opera'#231#227'o foi concluida;'
      '4. Sair da opera'#231#227'o notificando o c'#243'digo de chamada (Generics);')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 159
    Top = 143
    Width = 145
    Height = 25
    Caption = 'Query (Clone)'
    TabOrder = 1
    OnClick = Button1Click
  end
  object DBNavigator1: TDBNavigator
    Left = 8
    Top = 177
    Width = 240
    Height = 25
    TabOrder = 2
  end
  object Button2: TButton
    Left = 8
    Top = 143
    Width = 145
    Height = 25
    Caption = 'Query'
    TabOrder = 3
    OnClick = Button2Click
  end
  object GridPanel1: TGridPanel
    Left = 0
    Top = 225
    Width = 575
    Height = 176
    Align = alTop
    Caption = 'GridPanel1'
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <>
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    TabOrder = 4
  end
  object Button3: TButton
    Left = 310
    Top = 143
    Width = 147
    Height = 25
    Caption = 'For (loop)'
    TabOrder = 5
    OnClick = Button3Click
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from produtos')
    Left = 64
    Top = 240
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=MVCBr'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    Connected = True
    Left = 64
    Top = 288
  end
end
