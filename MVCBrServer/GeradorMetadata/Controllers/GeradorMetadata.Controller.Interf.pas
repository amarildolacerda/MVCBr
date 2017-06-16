{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 23/05/2017 22:22:46                                  // }
{ //************************************************************// }
unit GeradorMetadata.Controller.Interf;

///
/// <summary>
/// IGeradorMetadataController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IGeradorMetadataController = interface(IController)
    ['{AD9F80E5-AD43-47BF-A30E-494972842108}']
    // incluir especializações aqui
    procedure CDS_CNN_cancel;
    procedure CDS_CNN_Post;
  end;

Implementation

end.
