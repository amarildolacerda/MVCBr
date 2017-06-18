{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 18/06/2017 16:01:18                                  // }
{ //************************************************************// }
unit ObserverSender.Controller.Interf;

///
/// <summary>
/// IObserverSenderController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IObserverSenderController = interface(IController)
    ['{AA97E79D-A6A3-43E1-9B9A-C2F4A878F39A}']
    // incluir especializações aqui
  end;

Implementation

end.
