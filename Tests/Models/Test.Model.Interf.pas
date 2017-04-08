{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 08/04/2017 11:23:33                                  // }
{ //************************************************************// }
Unit Test.Model.Interf;

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
  ITestModel = interface(IModel)
    ['{C501968E-7458-4B5C-99D9-EFFFF5D452C5}']
    // incluir aqui as especializações
  end;

Implementation

end.
