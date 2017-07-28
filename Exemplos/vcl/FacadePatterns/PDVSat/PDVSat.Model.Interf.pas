{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 04/07/2017 22:36:18                                  // }
{ //************************************************************// }
Unit PDVSat.Model.Interf;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  System.Rtti,
  MVCBr.Controller;

Type
  // Interface de acesso ao model
  IPDVSatModel = interface(IModel)
    ['{3C07817B-B72C-4C80-8B10-DF749D612E17}']
    // incluir aqui as especializações
    function ExecutarComando(AComando: TValue; AParametro: TValue): boolean;

  end;

Implementation

end.
