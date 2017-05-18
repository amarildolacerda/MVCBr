unit EditorTexto.view;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  MVCBr.Interf,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ViewTemplateView, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons;

type

  IEditorTextoView = interface(IView)
    ['{FC6D61AE-47BF-456F-A0A4-12D377A98794}']
  end;

  TEditorTextoView = class(TViewTemplateView, IEditorTextoView)
    RichEdit1: TRichEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditorTextoView: TEditorTextoView;

implementation

{$R *.dfm}

end.
