unit oData.Dialect;

interface

uses System.Classes, System.SysUtils, oData.Model, oData.Interf;

Type

  TODataDialect = class(TInterfacedObject, IODataDialect)
  private
  protected
    FCollection: string;
    FOData: IODataDecode;
  public
    function Collection: string; virtual;
    function createQuery(AValue: IODataDecode; AFilter: string;
      const AInLineCount: boolean = false): string; virtual;
    function GetResource(AResource: string)
      : IJsonODastaServiceResource; virtual;
    function Relation(AResource: string; ARelation: String)
      : IJsonObject; virtual;
    function GetWhereFromParams(alias,keys: string): string; virtual;
  end;

  TODataDialectClass = class of TODataDialect;

implementation

{ TODataDialectClass }

{ TODataDialect }

function TODataDialect.GetResource(AResource: string)
  : IJsonODastaServiceResource;
begin
  result := ODataServices.resource(AResource);
  if not assigned(result) then
    raise Exception.Create('Serviço não disponível para o resource: ' +
      AResource);
end;

function TODataDialect.GetWhereFromParams(AOData:IODataDecode;alias:string; keys: string): string;
var
  s: string;
  i: integer;
  str: TStringList;
begin
  result := '';
  str := TStringList.Create;
  try
    str.Delimiter :=',';
    str.DelimitedText := keys;
    if str.Count=0 then
       exit;
    for i := 0 to AOData.ResourceParams.Count - 1 do
    begin
      s := AOData.ResourceParams.ValueOfIndex(i);
      if result <>'' then
         result := result + ' and ';
      if i<str.count then
         result := result +alias+'.'+str[i]+' = '+s;
    end;
  finally
    str.Free;
  end;
end;

function TODataDialect.Collection: string;
begin
  result := FCollection;
end;

function TODataDialect.createQuery(AValue: IODataDecode; AFilter: string;
  const AInLineCount: boolean): string;
begin
  inherited Create;
  FOData := AValue;
end;

function TODataDialect.Relation(AResource, ARelation: String)
  : IJsonObject;
var
  rs: IJsonODastaServiceResource;
begin
  try
    rs := GetResource(AResource);
    result := TInterfacedJsonObject.New( rs.Relation(ARelation).JSON );
    if not assigned(result) then
      raise Exception.Create('Serviços não disponível para o resource detalhe: '
        + ARelation);
  except
    result := nil;
  end;
end;

end.
