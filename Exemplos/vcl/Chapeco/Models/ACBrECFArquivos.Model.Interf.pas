{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 09/07/2017 19:19:43                                  // }
{ //************************************************************// }

Unit ACBrECFArquivos.Model.Interf;
///
/// <summary>
/// Interface de acesso ao Model
/// O uso de interface permite diminuir o
/// acoplamento entre UNITs
/// </summary>
///

interface

Uses MVCBr.Interf, MVCBr.Model, ACBrPAFClass;

Type

  ///
  /// Interface para o Model
  ///
  IACBrECFArquivosModel = interface(IModel)
    ['{37435A92-DF02-45A4-93F1-46408C8106EE}']
    // metodos  <TACBrECFArquivos                                                                    //
    procedure SetObject(Index: Integer; Item: TACBrECFArquivo);
    procedure Insert(Index: Integer; Obj: TACBrECFArquivo);
    // functions  <TACBrECFArquivos                                                                    //
    function Add(Obj: TACBrECFArquivo): Integer;overload;
    function Add(Nome: String): Integer;overload;
  end;

Implementation

end.
