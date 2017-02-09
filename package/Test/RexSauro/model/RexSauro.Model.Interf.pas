{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br                                // }
{ //************************************************************// }
{ // Data: 09/02/2017 20:39:40                                  // }
{ //************************************************************// }
Unit RexSauro.Model.Interf;

interface

Uses MVCBr.Interf, MVCBr.Model;

Type
  IRexSauroModel = interface(IModel)
    ['{2581EAB7-0FCE-48C5-8A77-BD4C76971078}']
    // metodos  <TRexSauro                                                                    //
    procedure execute();
    procedure Execute2(const A: integer; texto: string);
    procedure Execute3(const A: integer; texto: string);
    // functions  <TRexSauro                                                                    //
    function GetTexto(): string;
    function GetItem(item: integer): string;
  end;

Implementation

end.
