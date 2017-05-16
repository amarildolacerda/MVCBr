{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 05/05/2017 14:43:06                                  // }
{ //************************************************************// }
unit SuiteCRMSample.Controller.Interf;

///
/// <summary>
/// ISugarCRMSampleController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  ISuiteCRMSampleController = interface(IController)
    ['{49BE5F21-F378-4B45-82DB-E542CB57DD68}']
    // incluir especializações aqui
  end;

Implementation

end.
