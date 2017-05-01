object ComoEnviarMensagemParaOutraViewView: TComoEnviarMensagemParaOutraViewView
  Left = 0
  Top = 0
  Caption = 'ComoEnviarMensagemParaOutraViewView'
  ClientHeight = 487
  ClientWidth = 585
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
    Left = 32
    Top = 64
    Width = 545
    Height = 345
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      ExplicitLeft = 0
      ExplicitTop = 64
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
    end
  end
  object Button1: TButton
    Left = 16
    Top = 16
    Width = 161
    Height = 25
    Caption = 'Abrir View Filha'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 36
    Top = 424
    Width = 429
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object Button2: TButton
    Left = 471
    Top = 422
    Width = 84
    Height = 25
    Caption = 'trocar caption'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 471
    Top = 451
    Width = 84
    Height = 25
    Caption = 'ShowEvent'
    TabOrder = 4
    OnClick = Button3Click
  end
  object VCLPageViewManager1: TVCLPageViewManager
    PageControl = PageControl1
    Left = 280
    Top = 16
  end
end
