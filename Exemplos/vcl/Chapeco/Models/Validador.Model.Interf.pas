{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 11/08/2017 10:23:50                                  // }
{ //************************************************************// }

Unit Validador.Model.Interf;

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
  IValidadorModel = interface(IModel)
    ['{22502FBE-405D-40AB-8B3D-F6F3941C4F02}']
    // incluir aqui as especializações
  end;

Implementation

end.
