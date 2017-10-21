{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/07/2017 20:30:26                                  // }
{ //************************************************************// }

unit BuilderLazy.Controller.Interf;

///
/// <summary>
/// IBuilderLazyController
/// Interaface de acesso ao object factory do controller
/// </summary>
{ auth }
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IBuilderLazyController = interface(IController)
    ['{AA46D4C8-3583-4895-B030-3B53899F4A97}']
    // incluir especializações aqui
  end;

Implementation

end.
