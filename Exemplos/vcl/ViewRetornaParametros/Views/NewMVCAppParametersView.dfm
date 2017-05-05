object NewMVCAppParametersView: TNewMVCAppParametersView
  Left = 0
  Top = 0
  Caption = 'NewMVCAppParametersView'
  ClientHeight = 453
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 24
    Width = 377
    Height = 409
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 400
    Top = 48
    Width = 131
    Height = 25
    Caption = 'Chamar segundo VIEW'
    TabOrder = 1
    OnClick = Button1Click
  end
end
