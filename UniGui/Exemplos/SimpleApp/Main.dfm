object MainForm: TMainForm
  Left = 0
  Top = 0
  ClientHeight = 310
  ClientWidth = 505
  Caption = 'MainForm'
  OldCreateOrder = False
  MonitoredKeys.Keys = <>
  OnCreate = UniFormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object UniPanel1: TUniPanel
    Left = 32
    Top = 16
    Width = 417
    Height = 41
    Hint = ''
    TabOrder = 0
    Caption = 'HELLO WORLD'
  end
  object UniPageControl1: TUniPageControl
    Left = 32
    Top = 110
    Width = 417
    Height = 193
    Hint = ''
    TabOrder = 1
  end
  object UniButton1: TUniButton
    Left = 32
    Top = 79
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'AddFrame'
    TabOrder = 2
    OnClick = UniButton1Click
  end
  object UniButton2: TUniButton
    Left = 112
    Top = 79
    Width = 75
    Height = 25
    Hint = ''
    Caption = 'Call Model'
    TabOrder = 3
    OnClick = UniButton2Click
  end
end
