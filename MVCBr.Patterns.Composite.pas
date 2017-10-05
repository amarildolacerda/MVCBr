unit MVCBr.Patterns.Composite;

interface

uses System.Classes, System.SysUtils,
  MVCBr.Patterns.Lazy,
  System.Generics.Collections;

Type

  TMVCBrComposite<T> = Class(TThreadList<T>)
  End;

implementation

end.
