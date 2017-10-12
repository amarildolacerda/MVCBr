{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 10/10/2017 23:23:58                                  // }
{ //************************************************************// }

unit MongoDBModel.Controller.Interf;

///
/// <summary>
/// IMongoDBModelController
/// Interaface de acesso ao object factory do controller
/// </summary>
{ auth }
interface

uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF} {$ENDIF}
  System.Classes, MVCBr.Interf;

type
  IMongoDBModelController = interface(IController)
    ['{934B900B-1942-423F-BE75-AF0F38B5F5EB}']
    // incluir especializações aqui
  end;

Implementation

end.
