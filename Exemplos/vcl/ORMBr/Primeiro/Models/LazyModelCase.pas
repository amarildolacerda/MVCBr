unit LazyModelCase;

interface

uses
   MVCBr.Interf, MVCBr.Model, MVCBr.Patterns.Lazy;

type

   IClienteLazyModel = interface(IModel)
     ['{EFB0B9FF-D4F0-4B7D-920E-F88C9A7B4A88}']
   end;

   TClienteLazyModel = class(TModelFactory,IClienteLazyModel)

   end;



implementation

end.
