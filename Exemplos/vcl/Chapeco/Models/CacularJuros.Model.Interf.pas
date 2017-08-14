{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 09/07/2017 21:26:14                                  // }
{ //************************************************************// }

Unit CacularJuros.Model.Interf;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}

interface

uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  // %Interf,
  MVCBr.Controller;

Type
  // Interface de acesso ao model
  ICacularJurosModel = interface(IModel)
    ['{2D209016-2512-4A94-B0DC-3875AC7D68B9}']
    // incluir aqui as especializações
    function Calcular: double;
  end;

Implementation

end.
