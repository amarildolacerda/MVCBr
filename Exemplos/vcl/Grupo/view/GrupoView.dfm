object GrupoView: TGrupoView
  Left = 0
  Top = 0
  Caption = 'GrupoView'
  ClientHeight = 343
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 8
    Width = 37
    Height = 13
    Caption = 'Localiza'
  end
  object Label2: TLabel
    Left = 352
    Top = 37
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 56
    Width = 393
    Height = 273
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Edit1: TEdit
    Left = 24
    Top = 27
    Width = 217
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 247
    Top = 25
    Width = 75
    Height = 25
    Caption = 'GO'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 432
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Usuario'
    TabOrder = 3
    OnClick = Button2Click
  end
end
