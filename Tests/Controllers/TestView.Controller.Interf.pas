{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 08/04/2017 10:52:00                                  // }
{ //************************************************************// }
unit TestView.Controller.Interf;

///
/// <summary>
/// ITestViewController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  ITestViewController = interface(IController)
    ['{B1F27152-F9D8-4E21-854C-63E68AF87E5C}']
    // incluir especializações aqui
  end;

Implementation

end.
