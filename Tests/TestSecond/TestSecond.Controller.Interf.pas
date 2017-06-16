{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/06/2017 21:47:37                                  // }
{ //************************************************************// }
unit TestSecond.Controller.Interf;

///
/// <summary>
/// ITestSecondController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  ITestSecondController = interface(IController)
    ['{9FEA790D-644B-4E15-958F-C02DA5CFB6AB}']
    // incluir especializações aqui
    function GetStubInt:integer;
    procedure IncContador;
  end;

  ITestSecondController2 = interface(ITestSecondController)
    ['{2D130CFE-B3D8-45E1-8996-55681F43889E}']
    function GetStubInt2:integer;
  end;

Implementation

end.
