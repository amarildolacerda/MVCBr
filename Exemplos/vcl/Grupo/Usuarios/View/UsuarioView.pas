unit UsuarioView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  MVCBr.View,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TUsuarioForm = class(TFormFactory)
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UsuarioForm: TUsuarioForm;

implementation

{$R *.dfm}

procedure TUsuarioForm.FormDestroy(Sender: TObject);
begin
   showmessage('destroy');
end;

procedure TUsuarioForm.FormShow(Sender: TObject);
begin
   caption :=Caption+ self.name;
end;

end.
