object NewMVCAppView: TNewMVCAppView
  Left = 0
  Top = 0
  Caption = 'NewMVCAppView'
  ClientHeight = 292
  ClientWidth = 857
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
  object Button1: TButton
    Left = 400
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Dialog'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 255
    Width = 288
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object Button2: TButton
    Left = 296
    Top = 254
    Width = 81
    Height = 25
    Caption = 'Enviar'
    TabOrder = 2
    OnClick = Button2Click
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 369
    Height = 240
    ActivePage = TabSheet1
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'Mensagens'
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 361
        Height = 212
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Lines.Strings = (
          'Memo1')
        TabOrder = 0
      end
    end
  end
  object Button3: TButton
    Left = 400
    Top = 63
    Width = 75
    Height = 25
    Caption = 'PageView'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 400
    Top = 94
    Width = 75
    Height = 25
    Caption = 'RESTful'
    TabOrder = 5
    OnClick = Button4Click
  end
  object PageViewAdapter: TVCLPageViewManager
    PageControl = PageControl1
    Left = 48
    Top = 104
  end
end
