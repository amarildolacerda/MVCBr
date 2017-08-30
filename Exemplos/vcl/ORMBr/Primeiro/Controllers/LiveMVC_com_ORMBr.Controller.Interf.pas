{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 29/08/2017 22:34:39                                  // }
{ //************************************************************// }

unit LiveMVC_com_ORMBr.Controller.Interf;

///
/// <summary>
/// ILiveMVC_com_ORMBrController
/// Interaface de acesso ao object factory do controller
/// </summary>
{ auth }
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  ILiveMVC_com_ORMBrController = interface(IController)
    ['{B0D63E2A-A8E1-4888-A36B-0A940A629626}']
    // incluir especializações aqui
  end;

Implementation

end.
