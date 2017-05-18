{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/05/2017 23:41:17                                  // }
{ //************************************************************// }
unit EditorTextoView.Controller.Interf;

///
/// <summary>
/// IEditorTextoViewController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IEditorTextoViewController = interface(IController)
    ['{6AD690D3-BF1B-4E93-9F2D-38B9285FA05F}']
    // incluir especializações aqui
  end;

Implementation

end.
