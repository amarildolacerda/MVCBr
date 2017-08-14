{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 09/07/2017 21:16:53                                  // }
{ //************************************************************// }

unit SegundoForm.Controller.Interf;

///
/// <summary>
/// ISegundoFormController
/// Interaface de acesso ao object factory do controller
/// </summary>
{ auth }
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  ISegundoFormController = interface(IController)
    ['{747AD6F8-0901-4376-ADA9-6D8FFDF28070}']
    // incluir especializações aqui
  end;

Implementation

end.
