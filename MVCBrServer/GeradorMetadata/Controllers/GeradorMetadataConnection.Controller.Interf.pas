{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 23/05/2017 22:40:48                                  // }
{ //************************************************************// }
unit GeradorMetadataConnection.Controller.Interf;

///
/// <summary>
/// IGeradorMetadataConnectionController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IGeradorMetadataConnectionController = interface(IController)
    ['{4F4D02E6-AC0A-4ED7-9E5E-F0C5F8760422}']
    // incluir especializações aqui
  end;

Implementation

end.
