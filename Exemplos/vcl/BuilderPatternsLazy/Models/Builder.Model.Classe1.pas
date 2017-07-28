unit Builder.Model.Classe1;

interface

Uses System.Classes, System.SysUtils,
     System.RTTI,
     MVCBr.Interf, MVCBr.Model, MVCBr.Patterns.Builder;


type

     TSubClass1Item = class(TMVCBrBuilderObject)
       public
          function Execute(AParam:TValue):TValue;override;
     end;



implementation

{ TSubClass1Item }

function TSubClass1Item.Execute(AParam: TValue): TValue;
begin
    result := 'Class 1 Execute';
end;

end.
