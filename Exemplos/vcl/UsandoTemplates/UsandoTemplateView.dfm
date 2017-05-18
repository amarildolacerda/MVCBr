object UsandoTemplateView: TUsandoTemplateView
  Left = 0
  Top = 0
  Caption = 'UsandoTemplateView'
  ClientHeight = 422
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 41
    Width = 472
    Height = 381
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 505
    ExplicitHeight = 190
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 472
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 505
    object Button1: TButton
      Left = 16
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Editor'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 90
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Navegador'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object VCLPageViewManager1: TVCLPageViewManager
    PageControl = PageControl1
    Left = 152
    Top = 112
  end
end
