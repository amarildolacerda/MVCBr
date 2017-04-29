{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017 11:35:19                                  // }
{ //************************************************************// }
unit WSConfig.Controller.Interf;

///
/// <summary>
/// IWSConfigController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IWSConfigController = interface(IController)
    ['{ACD79195-5779-4A74-BA8C-5024A9B082A6}']
    // incluir especializações aqui
    function ConnectionString: string;
    function GetPort:integer;
  end;

Implementation

end.
