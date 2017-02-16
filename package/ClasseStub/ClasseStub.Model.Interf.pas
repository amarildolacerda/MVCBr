{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/02/2017 22:22:59                                  // }
{ //************************************************************// }
Unit ClasseStub.Model.Interf;

///
/// <summary>
/// Interface de acesso ao Model
/// O uso de interface permite diminuir o
/// acoplamento entre UNITs
/// </summary>
///
interface

Uses MVCBr.Interf, MVCBr.Model;

Type
  ///
  /// Interface para o Model
  ///
  IClasseStubModel = interface(IModel)
    ['{52D64F96-5D63-4DC3-B186-B017AB1CD286}']
    // metodos  <TClasseStub<TInterface; T: Class>                                                                    //
    // functions  <TClasseStub<TInterface; T: Class>                                                                    //
    function GetCaption(): string;
  end;

Implementation

end.
