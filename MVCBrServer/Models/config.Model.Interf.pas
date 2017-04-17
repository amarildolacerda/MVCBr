{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 14/04/2017 23:40:09                                  // }
{ //************************************************************// }
Unit config.Model.Interf;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

uses System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  // %Interf,
  MVCBr.Controller;

Type
  // Interface de acesso ao model
  IconfigModel = interface(IModel)
    ['{2A60505C-2057-4DF4-8364-67040A0B03B3}']
    // incluir aqui as especializações
  end;

Implementation

end.
