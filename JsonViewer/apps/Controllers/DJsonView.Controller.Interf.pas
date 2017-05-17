{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/05/2017 14:05:02                                  // }
{ //************************************************************// }
unit DJsonView.Controller.Interf;

///
/// <summary>
/// IDJsonViewController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IDJsonViewController = interface(IController)
    ['{8450B8FF-C7E8-49F1-8FEA-C73073F45B92}']
    // incluir especializações aqui
  end;

Implementation

end.
