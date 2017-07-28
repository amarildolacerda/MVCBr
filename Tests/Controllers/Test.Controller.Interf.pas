{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 08/04/2017 10:34:47                                  // }
{ //************************************************************// }
unit Test.Controller.Interf;

///
/// <summary>
/// ITestController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  ITestController = interface(IController)
    ['{0BBB7F41-AD4C-4CB2-825D-ECB8F473BFDC}']
    // incluir especializações aqui
    procedure IncContador;
    function GetStubInt: Integer;
  end;

Implementation

end.
