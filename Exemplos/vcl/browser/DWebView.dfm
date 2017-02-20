object DWebView: TDWebView
  Left = 0
  Top = 0
  Caption = 'DWebView'
  ClientHeight = 380
  ClientWidth = 937
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
  object SpeedButton1: TSpeedButton
    Left = 464
    Top = 200
    Width = 23
    Height = 22
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 29
    Width = 937
    Height = 351
    Align = alClient
    TabOrder = 0
    ExplicitTop = 41
    ExplicitHeight = 339
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 937
    Height = 29
    Align = alTop
    TabOrder = 1
    object SpeedButton2: TSpeedButton
      Left = 913
      Top = 1
      Width = 23
      Height = 27
      Align = alRight
      Caption = '?'
      OnClick = SpeedButton2Click
      ExplicitLeft = 456
      ExplicitTop = 8
      ExplicitHeight = 22
    end
    object Edit1: TEdit
      Left = 24
      Top = 4
      Width = 369
      Height = 21
      TabOrder = 0
    end
    object Button1: TButton
      Left = 399
      Top = 2
      Width = 75
      Height = 25
      Caption = 'Ir'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object VCLPageViewManager1: TVCLPageViewManager
    PageControl = PageControl1
    Left = 48
    Top = 96
  end
end
