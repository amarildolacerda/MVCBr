Unit ACBrUtils.Model.Interf;

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
  IACBrUtilsModel = interface(IModel)
    ['{927AED25-18B1-460C-BFA2-02DAD162F11E}']
    // incluir aqui as especializações
    function EAN13Valido(CodEAN13: String): Boolean;

  end;

Implementation

end.
