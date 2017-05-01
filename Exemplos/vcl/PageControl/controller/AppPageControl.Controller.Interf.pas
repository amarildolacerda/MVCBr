{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 13/02/2017 23:07:44                                  // }
{ //************************************************************// }
unit AppPageControl.Controller.Interf;

///
/// <summary>
/// IAppPageControlController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IAppPageControlController = interface(IController)
    ['{59E9AD23-BD49-4F01-9ABC-4C3893A97FC8}']
    // incluir especializações aqui
    procedure AddView(AViewController:TGuid);
  end;

Implementation

end.
