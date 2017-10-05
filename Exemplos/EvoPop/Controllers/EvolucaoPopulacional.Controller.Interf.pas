{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 29/09/2017 21:07:49                                  // }
{ //************************************************************// }

unit EvolucaoPopulacional.Controller.Interf;

///
/// <summary>
/// IEvolucaoPopulacionalController
/// Interaface de acesso ao object factory do controller
/// </summary>
{ auth }
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IEvolucaoPopulacionalController = interface(IController)
    ['{3DBAEAF6-2359-42BF-9A36-7BB17EF60C6B}']
    // incluir especializações aqui
    procedure Notification(AName, ASubject, AMessage: string);
  end;

Implementation

end.
