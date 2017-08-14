{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/07/2017 00:45:10                                  // }
{ //************************************************************// }

Unit SetoresS.Model;

interface

uses System.Classes, System.SysUtils,
  MVCBr.Patterns.Builder, System.RTTI;

Type

  TSetoresSModelSubClass = class(TMVCBrBuilderLazyItem)
  public
    [weak]
    function Execute(AParam: TValue)
      : IMVCBrBuilderItem<TValue, TValue>; override;
  end;

Implementation

// sample to insert into Builder CreateSubClasses
// add( 'command', TSetoresSModelSubClass);

{ TSetoresSModelSubClass }

function TSetoresSModelSubClass.Execute(
  AParam: TValue): IMVCBrBuilderItem<TValue, TValue>;
begin

end;

end.
