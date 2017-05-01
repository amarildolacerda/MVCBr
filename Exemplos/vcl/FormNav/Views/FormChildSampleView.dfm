object FormChildSampleView: TFormChildSampleView
  Left = 0
  Top = 0
  Caption = 'FormChildSampleView'
  ClientHeight = 463
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 79
    Width = 75
    Height = 25
    Caption = 'Open VIEW'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Panel1: TPanel
    Left = 8
    Top = 32
    Width = 457
    Height = 41
    Caption = 'MAIN'
    TabOrder = 1
  end
  object Button2: TButton
    Left = 8
    Top = 110
    Width = 75
    Height = 25
    Caption = 'call MODEL'
    TabOrder = 2
    OnClick = Button2Click
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 168
    Width = 459
    Height = 265
    ActivePage = TabSheet1
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
    end
  end
  object Button3: TButton
    Left = 264
    Top = 79
    Width = 179
    Height = 25
    Caption = 'ShowEvent'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 264
    Top = 110
    Width = 179
    Height = 25
    Caption = 'ShowEvent .. to 1 VIEW'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 264
    Top = 141
    Width = 179
    Height = 25
    Caption = 'ShowEvent to Controller'
    TabOrder = 6
    OnClick = Button5Click
  end
end
