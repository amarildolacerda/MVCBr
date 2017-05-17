program Project32;

uses
  Vcl.Forms,
  MVCBr.ApplicationController,
  masterDetailView in 'masterDetailView.pas' {Form61},
  masterDetail.Controller in 'Controllers\masterDetail.Controller.pas';

{$R *.res}

begin
  ApplicationController.Run(TmaterDetailController.New,
    function: boolean
    begin
      result := true;
    end);

end.
