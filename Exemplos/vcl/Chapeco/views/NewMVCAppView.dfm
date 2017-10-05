object NewMVCAppView: TNewMVCAppView
  Left = 0
  Top = 0
  Caption = 'NewMVCAppView'
  ClientHeight = 312
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormFactoryCreate
  OnDestroy = FormFactoryDestroy
  OnViewEvent = FormFactoryViewEvent
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 24
    Width = 369
    Height = 193
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 400
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Abrir'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 255
    Width = 288
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object Button2: TButton
    Left = 296
    Top = 254
    Width = 81
    Height = 25
    Caption = 'Enviar'
    TabOrder = 3
    OnClick = Button2Click
  end
end
