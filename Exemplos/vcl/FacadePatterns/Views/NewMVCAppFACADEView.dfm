object NewMVCAppFACADEView: TNewMVCAppFACADEView
  Left = 0
  Top = 0
  Caption = 'NewMVCAppFACADEView'
  ClientHeight = 435
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup1: TRadioGroup
    Left = 16
    Top = 24
    Width = 185
    Height = 97
    Caption = 'Processos'
    Items.Strings = (
      'Processo 1'
      'Processo 2'
      'Processo 3')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 16
    Top = 127
    Width = 185
    Height = 25
    Caption = 'executar processo'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 176
    Width = 405
    Height = 233
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object Button2: TButton
    Left = 240
    Top = 32
    Width = 173
    Height = 25
    Caption = 'Salvar Status'
    TabOrder = 3
    OnClick = Button2Click
  end
end
