{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/07/2017 01:33:25                                  // }
{ //************************************************************// }

Unit Setores10.Built;

interface

uses System.Classes, System.SysUtils,
  MVCBr.BuilderModel,
  MVCBr.Patterns.Builder, System.RTTI;

Type

  TSetores10Built = class(TBuiltObjectFactory)
  public
    [weak]
    function Execute(AParam: TValue): TBuiltResult; override;
  end;

Implementation

// sample to insert into Builder CreateSubClasses
// add( 'command', TSetores10Built);

function TSetores10Built.Execute(AParam: TValue): TBuiltResult;
begin

  /// implements here

end;

end.
