{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 26/03/2017 11:56:19                                  // }
{ //************************************************************// }
Unit RegrasNegocios.Model.Interf;

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
  IRegrasNegociosModel = interface(IModel)
    ['{B36E14DA-FAC6-421B-80C6-C53A11B7B39D}']
    // incluir aqui as especializações
    function Validar(txt: string): boolean;
  end;

Implementation

end.
