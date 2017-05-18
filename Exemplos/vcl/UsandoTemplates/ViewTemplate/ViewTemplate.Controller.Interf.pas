{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/05/2017 23:22:03                                  // }
{ //************************************************************// }
unit ViewTemplate.Controller.Interf;

///
/// <summary>
/// IViewTemplateController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IViewTemplateController = interface(IController)
    ['{58144B43-F302-4A54-B7EA-0B8715E8FDBF}']
    // incluir especializações aqui
  end;

Implementation

end.
