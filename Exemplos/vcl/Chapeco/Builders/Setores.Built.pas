{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/07/2017 01:03:28                                  // }
{ //************************************************************// }

Unit Setores.Built;

interface

uses System.Classes, System.SysUtils,
  MVCBr.Patterns.Builder, System.RTTI;

Type

  TSetoresModelSubClass = class(TMVCBrBuilderLazyItem)
  public
    [weak]
    function Execute(AParam: TValue)
      : IMVCBrBuilderItem<TValue, TValue>; override;
  end;

Implementation

// sample to insert into Builder CreateSubClasses
// add( 'command', TSetoresModelSubClass);
function TSetoresModelSubClass.Execute(AParam: TValue)
  : IMVCBrBuilderItem<TValue, TValue>;
begin
  /// implements here
end;

end.
