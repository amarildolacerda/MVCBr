{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 19/02/2017 19:38:52                                  // }
{ //************************************************************// }
unit dBowser.Controller.Interf;

///
/// <summary>
/// IdBowserController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IdBowserController = interface(IController)
    ['{24B79278-4F07-42EA-BFB5-7C119B8E3824}']
    // incluir especializações
    procedure AddPage(AURL: string);
  end;

Implementation

end.
