inherited EditorTextoView: TEditorTextoView
  Caption = 'Editor Texto'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    Height = 25
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 462
    ExplicitHeight = 25
  end
  object RichEdit1: TRichEdit
    AlignWithMargins = True
    Left = 5
    Top = 30
    Width = 452
    Height = 364
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    BorderStyle = bsNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'RichEdit1')
    ParentFont = False
    TabOrder = 2
    Zoom = 100
    ExplicitLeft = 0
    ExplicitTop = 41
    ExplicitWidth = 462
    ExplicitHeight = 358
  end
end
