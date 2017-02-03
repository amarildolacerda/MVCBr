Unit Validacoes.Model.Interf;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

uses Classes, forms, SysUtils, MVCBr.Interf, MVCBr.Model,
  // %Interf,
  MVCBr.Controller;

Type
  // Interface de acesso ao model
  IValidacoesModel = interface(IModel)
    ['{6FF09EE0-D901-4329-83A1-FE09EA60F1BA}']
    // incluir aqui as especializações

    function ValidarCEP(aCEP: string): Boolean;



  end;

Implementation

end.
