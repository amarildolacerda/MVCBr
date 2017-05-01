{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/04/2017 22:28:42                                  // }
{ //************************************************************// }
unit masterDetail.Controller.Interf;

///
/// <summary>
/// ImaterDetailController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  ImaterDetailController = interface(IController)
    ['{CEB04DF6-3891-40A5-BA0B-7CF7A8E9909F}']
    // incluir especializações aqui
  end;

Implementation

end.
