{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/04/2017 12:19:36                                  // }
{ //************************************************************// }
unit Filha.Controller.Interf;

///
/// <summary>
/// IFilhaController
/// Interaface de acesso ao object factory do controller
/// </summary>
///
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IFilhaController = interface(IController)
    ['{ED2D00D2-CB23-4EBA-A229-E3BF4A1AB8A8}']
    // incluir especializações aqui
   procedure TrocarMensagemPanel( AMsg:string );

  end;

Implementation

end.
