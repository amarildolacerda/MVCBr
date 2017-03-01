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

uses oData.ServiceModel;

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
  ATop: Integer;
  FLastFields: String;
begin
  oData.Lock;
  try
    inherited createQuery(oData, AFilter, AInLineCount);
    result := 'select ';
    FWhere := '';
    AResource := GetResource(oData.Resource);
    FGroupBy := oData.GroupBy;
    FCollection := AResource.collection;
    FCollectionFinal := FCollection;
    ATop := oData.Top;
    if ATop = 0 then
      ATop := AResource.maxpagesize;
    if AInLineCount = false then
    begin
      if ATop > 0 then
        result := result + ' first ' + ATop.ToString;
      if oData.Skip > 0 then
        result := result + ' skip ' + oData.Skip.ToString;
      FFields := oData.Select;
      if FFields = '' then
        FFields := AResource.fields;

    end
    else
      FFields := ' count(*) N__Count ';

    FLastFields := '';

    result := result + ' {%fields} from ' + FCollection + ' as ' +
      oData.Resource;

    // relations
    child := oData;
    if child.ResourceParams.Count > 0 then
    begin
      FKeys := GetWhereFromParams(child, oData.Resource, AResource.keyID);
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
          FLastFields := ARelationResource.fields;

          if command <> '' then
            result := result + ' ' + command
          else
            result := result + ' join ' + FCollectionFinal + ' as ' +
              child.Resource + ' on (' + oData.Resource + '.' + sourceKey + '='
              + child.Resource + '.' + targetKey + ')';

          if child.ResourceParams.Count > 0 then
          begin
            FKeys := GetWhereFromParams(child, child.Resource,
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

    if (FLastFields <> '') and (not AInLineCount) then
      FFields := FLastFields;
    if FFields = '' then
      FFields := '*';
    result := stringReplace(result, '{%fields}', FFields, []);
  finally
    oData.Unlock;
  end;

end;

end.
