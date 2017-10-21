object UniFrame1: TUniFrame1
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object UniPanel1: TUniPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Hint = ''
    Align = alClient
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    Caption = 'Hello Frame'
    ExplicitLeft = 24
    ExplicitTop = 48
    ExplicitWidth = 256
    ExplicitHeight = 128
    DesignSize = (
      320
      240)
    object UniButton1: TUniButton
      Left = 242
      Top = 3
      Width = 75
      Height = 25
      Hint = ''
      Caption = 'Close'
      Anchors = [akTop, akRight]
      TabOrder = 1
      OnClick = UniButton1Click
    end
    object UniButton2: TUniButton
      Left = 4
      Top = 2
      Width = 75
      Height = 25
      Hint = ''
      Caption = 'Time'
      TabOrder = 2
      OnClick = UniButton2Click
    end
  end
end
