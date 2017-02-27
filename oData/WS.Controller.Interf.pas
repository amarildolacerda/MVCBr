{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/02/2017 22:07:42                                  // }
{ //************************************************************// }
unit WS.Controller.Interf;

///
/// <summary>
/// IWSController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IWSController = interface(IController)
    ['{169FBB86-7D34-4450-8F96-4973B3153413}']
    // incluir especializações aqui
  end;

Implementation

end.
