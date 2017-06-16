program nestedproperties_ok;

{$APPTYPE CONSOLE}
{$R *.res}


uses
  System.SysUtils,
  System.Generics.Collections,
  ObjectsMappers,
  PersonU in '..\jsoncase\PersonU.pas', System.JSON;

type
  TPeople = TObjectList<TPerson>;

  TData = class
  private
    FPeople: TObjectList<TPerson>;
    FPerson: TPerson;
    procedure SetPerson(const Value: TPerson);
  public
    [MapperListOf(TPerson)]
    property People: TPeople read FPeople write FPeople;
    property Person: TPerson read FPerson write SetPerson;
    constructor Create;
    destructor Destroy; override;
  end;

procedure Main;
var
  lData: TData;
  P: TPerson;
  lJObj: TJSONObject;
  lNewData: TData;
begin
  lData := TData.Create;
  try
    P := TPerson.Create;
    lData.People.Add(P);
    P.FirstName := 'Daniele';
    P.LastName := 'Teti';
    P.DateOfBirth := EncodeDate(1979, 5, 2);

    P := TPerson.Create;
    lData.People.Add(P);
    P.FirstName := 'Peter';
    P.LastName := 'Parker';
    P.DateOfBirth := EncodeDate(1989, 5, 2);

    lData.Person.FirstName := 'Bruce';
    lData.Person.LastName := 'Banner';
    lData.Person.DateOfBirth := EncodeDate(1959, 5, 2);

    lJObj := Mapper.ObjectToJSONObject(lData);
    try
      WriteLn(lJObj.ToJSON);
      lNewData := Mapper.JSONObjectToObject<TData>(lJObj);
      try
        WriteLn(Mapper.ObjectToJSONObjectString(lData));
      finally
        lNewData.Free;
      end;
    finally
      lJObj.Free;
    end;

  finally
    lData.Free;
  end;
end;

{ TData }

constructor TData.Create;
begin
  inherited;
  FPeople := TObjectList<TPerson>.Create(true);
  FPerson := TPerson.Create;
end;

destructor TData.Destroy;
begin
  FPerson.Free;
  FPeople.Free;
  inherited;
end;

procedure TData.SetPerson(const Value: TPerson);
begin
  FPerson := Value;
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
