{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 05/05/2017 11:14:34                                  // }
{ //************************************************************// }
unit Parametros.Controller.Interf;

///
/// <summary>
/// IParametrosController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IParametrosController = interface(IController)
    ['{938ECD1B-6246-4FE9-A1BB-D6ECC4BED0BF}']
    // incluir especializações aqui
  end;

Implementation

end.
