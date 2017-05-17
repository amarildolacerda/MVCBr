object JsonEditView: TJsonEditView
  Left = 0
  Top = 0
  Caption = 'Edit'
  ClientHeight = 437
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SynMemo1: TSynEdit
    Left = 0
    Top = 0
    Width = 465
    Height = 437
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 0
    BorderStyle = bsNone
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.ShowLineNumbers = True
    FontSmoothing = fsmNone
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 48
    Top = 88
  end
end
