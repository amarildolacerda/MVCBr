object EditorView: TEditorView
  Left = 0
  Top = 0
  Caption = 'EditorView'
  ClientHeight = 231
  ClientWidth = 505
  OnCloseQuery = FormCloseQuery
  object RichEdit1: TRichEdit
    Left = 0
    Top = 0
    Width = 505
    Height = 231
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Zoom = 100
  end
end
