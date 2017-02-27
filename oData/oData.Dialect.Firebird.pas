unit oData.Dialect.Firebird;

interface

uses System.Classes, System.SysUtils, oData.Interf, oData.Dialect;

type
  TODataDialectFirebird = class(TODataDialect)
  public
    function createQuery(oData: IODataDecode; AFilter: string;
      const AInLineCount: boolean = false): string; override;

  end;

implementation

uses oData.Model;

{ TODataDialectFirebird }

function TODataDialectFirebird.createQuery(oData: IODataDecode; AFilter: string;
  const AInLineCount: boolean = false): string;
var
  FWhere, FCollectionFinal, FKeys, FOrderBy, FFields: string;
  FGroupBy: string;
  AResource: IJsonODastaServiceResource;
  ARelationResource: IJsonODastaServiceResource;
  ARelation: IJsonODataServiceRelation;
  LLevel: Integer;
  child: IODataDecode;
  sourceKey, targetKey, command: string;
begin
  inherited createQuery(oData, AFilter, AInLineCount);
  result := 'select ';
  FWhere := '';
  AResource := GetResource(oData.Resource);
  FGroupBy := oData.GroupBy;
  FCollection := AResource.collection;
  FCollectionFinal := FCollection;
  if AInLineCount = false then
  begin
    if oData.Top > 0 then
      result := result + ' first ' + oData.Top.ToString;
    if oData.Skip > 0 then
      result := result + ' skip ' + oData.Skip.ToString;
    FFields := oData.Select;
    if FFields = '' then
      FFields := AResource.fields;

  end
  else
    result := result + ' count(*) N__Count ';

  result := result + '{%fields} from ' + FCollection;

  if FFields <> '' then
    FFields := stringReplace(FFields, oData.Resource + '.', FCollection + '.',
      [rfReplaceAll]);

  if FGroupBy <> '' then
    FGroupBy := stringReplace(FGroupBy, oData.Resource + '.', FCollection + '.',
      [rfReplaceAll]);

  // relations
  child := oData;
  if child.ResourceParams.Count > 0 then
  begin
    FKeys := GetWhereFromParams(child, FCollectionFinal, AResource.keyID);
    if FWhere <> '' then
      FWhere := '(' + FWhere + ') and (' + FKeys + ')'
    else
      FWhere := FKeys;
  end;

  if child.hasChild then
  begin
    child := child.child;
    repeat
      // resource pertence ao ultimo resource

      ARelation := AResource.relation(child.Resource);
      if assigned(ARelation) then
      begin
        ARelationResource := GetResource(child.Resource);
        sourceKey := ARelation.sourceKey;
        targetKey := ARelation.targetKey;
        command := ARelation.join;
        FCollectionFinal := ARelationResource.collection;

        if FFields <> '' then
          FFields := stringReplace(FFields, child.Resource + '.',
            FCollectionFinal + '.', [rfReplaceAll]);

        if FGroupBy <> '' then
          FGroupBy := stringReplace(FGroupBy, child.Resource + '.',
            FCollectionFinal + '.', [rfReplaceAll]);

        if command <> '' then
          result := result + ' ' + command
        else
          result := result + ' join ' + FCollectionFinal + ' on (' + FCollection
            + '.' + sourceKey + '=' + FCollectionFinal + '.' + targetKey + ')';

        if child.ResourceParams.Count > 0 then
        begin
          FKeys := GetWhereFromParams(child, FCollectionFinal,
            ARelationResource.keyID);
          if FWhere <> '' then
            FWhere := '(' + FWhere + ') and (' + FKeys + ')'
          else
            FWhere := FKeys;
        end;

      end;
      child := child.child;
      if not assigned(child) then
        break;
    until child.hasChild;
  end;

  if AFilter <> '' then
  begin
    if FWhere <> '' then
      FWhere := '(' + FWhere + ') and ';
    FWhere := FWhere + AFilter;
  end;

  if FWhere <> '' then
    result := result + ' where ' + FWhere;

  if FGroupBy <> '' then
    result := result + ' group by ' + FGroupBy;

  if AInLineCount = false then
  begin
    FOrderBy := oData.OrderBy;
    if FOrderBy <> '' then
      result := result + ' order by ' + FOrderBy;
  end;

  if FFields = '' then
    FFields := '*';
  result := stringReplace(result, '{%fields}', FFields, []);

end;

end.
