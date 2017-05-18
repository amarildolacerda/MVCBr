{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/05/2017 23:56:34                                  // }
{ //************************************************************// }
unit NavegadorView.Controller.Interf;

///
/// <summary>
/// INavegadorViewController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  INavegadorViewController = interface(IController)
    ['{E5071D35-6C12-4AA5-9E55-9E9453B0D9BE}']
    // incluir especializações aqui
  end;

Implementation

end.
