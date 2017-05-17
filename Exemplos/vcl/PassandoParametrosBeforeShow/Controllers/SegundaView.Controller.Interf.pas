{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/05/2017 23:00:33                                  // }
{ //************************************************************// }
unit SegundaView.Controller.Interf;

///
/// <summary>
/// ISegundaViewController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  ISegundaViewController = interface(IController)
    ['{43F58364-5C23-4B11-846F-82FCDB9480D8}']
    // incluir especializações aqui
  end;

Implementation

end.
