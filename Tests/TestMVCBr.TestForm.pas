unit TestMVCBr.TestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  MVCBr.View,MVCBr.FormView,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TTesteFormView = class(TFormFactory)
  private
    { Private declarations }
  public
    { Public declarations }
    function GetShowModalStub:boolean;
  end;

var
  TesteFormView: TTesteFormView;

implementation

{$R *.dfm}

{ TTesteFormView }

function TTesteFormView.GetShowModalStub: boolean;
begin
  result := GetShowModal;
end;

end.
