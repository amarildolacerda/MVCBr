{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/07/2017 20:32:19                                  // }
{ //************************************************************// }

Unit builder.Model.Interf;

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
  IBuilderModel = interface(IModel)
    ['{F349B7C1-A9E1-4F2E-B71B-7944674CCBF0}']
    // incluir aqui as especializações
  end;

Implementation

end.
