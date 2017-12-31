program nestedproperties;

{$APPTYPE CONSOLE}
{$R *.res}


uses
  System.SysUtils,
  System.Generics.Collections,
  ObjectsMappers,
  PersonU in '..\jsoncase\PersonU.pas', System.JSON;

type
  TPeople = class(TObjectList<TPerson>)
  private
    FOtherPeople: TPeople;
  public
    property OtherPeople: TPeople read FOtherPeople write FOtherPeople;
  end;

procedure Main;
var
  lPeople: TPeople;
  P: TPerson;
  lJArr: TJSONArray;
begin
  lPeople := TPeople.Create(true);
  try
    P := TPerson.Create;
    P.FirstName := 'Daniele';
    P.LastName := 'Teti';
    P.DateOfBirth := date;
    lPeople.Add(P);
    lPeople.OtherPeople := TPeople.Create(true);
    try
      P := TPerson.Create;
      P.FirstName := 'Daniele';
      P.LastName := 'Teti';
      P.DateOfBirth := date;
      lPeople.OtherPeople.Add(P);
      lJArr := Mapper.ObjectToJSONArray(lPeople);
      try
        WriteLn(lJArr.ToJSON);
      finally
        lJArr.Free;
      end;

    finally
      lPeople.OtherPeople.Free;
    end;
  finally
    lPeople.Free;
  end;
end;

begin
  try
    Main;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
  if DebugHook <> 0 then
    ReadLn;

end.
