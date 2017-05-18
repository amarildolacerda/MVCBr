object ViewTemplateView: TViewTemplateView
  Left = 0
  Top = 0
  Caption = 'Editor'
  ClientHeight = 418
  ClientWidth = 462
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 399
    Width = 462
    Height = 19
    Color = clGradientInactiveCaption
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 462
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 1
    ExplicitLeft = 280
    ExplicitTop = 112
    ExplicitWidth = 185
    DesignSize = (
      462
      41)
    object SpeedButton1: TSpeedButton
      Left = 434
      Top = 1
      Width = 23
      Height = 23
      Anchors = [akTop, akRight, akBottom]
      Caption = 'x'
      Flat = True
      OnClick = SpeedButton1Click
    end
  end
end
