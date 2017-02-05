unit TestMVCBr.TestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  MVCBr.View,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TTesteFormView = class(TFormFactory)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TesteFormView: TTesteFormView;

implementation

{$R *.dfm}

end.
