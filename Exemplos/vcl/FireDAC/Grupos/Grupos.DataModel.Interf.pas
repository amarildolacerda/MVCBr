Unit Grupos.DataModel.Interf;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

uses Classes, forms, SysUtils, MVCBr.Interf, MVCBr.FireDACModel,
  MVCBr.FireDACModel.Interf,
  // %Interf,
  MVCBr.Controller;

Type
  // Interface de acesso ao model
  IGruposDataModel = interface(IFireDacModel)
    ['{39FEB4BC-9960-44FF-B852-7B97589762F1}']
    // incluir aqui as especializações
  end;

Implementation

end.
