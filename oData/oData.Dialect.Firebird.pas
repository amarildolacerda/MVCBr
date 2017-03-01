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
  sourceKey, targetKey, FJoin: string;
  ATop: Integer;
  FLastFields: String;
  FFieldsReq:string;
begin
  oData.Lock;
  try
    inherited createQuery(oData, AFilter, AInLineCount);
    result := 'select ';
    FWhere := '';
    AResource := GetResource(oData.Resource); /// busca no metadata os parametros
    FGroupBy := oData.GroupBy;  /// pega groupby do metadata
    FCollection := AResource.collection;  /// pega a tabela associada no metadata
    FCollectionFinal := FCollection;  /// tmp para ultima tabela avalidada
    ATop := oData.Top;
    if ATop = 0 then
      ATop := AResource.maxpagesize;  /// se nao for requisitado TOP, pegar o constante no metadata
    if AInLineCount = false then
    begin
      if ATop > 0 then
        result := result + ' first ' + ATop.ToString;   /// $top
      if oData.Skip > 0 then
        result := result + ' skip ' + oData.Skip.ToString;  /// $skip
      FFieldsReq := oData.Select;    /// $select
      FLastFields := AResource.fields;

    end
    else
      FFieldsReq := ' count(*) N__Count ';   // quando inlinecount=allpages - fazer um count

    FLastFields := '';

    result := result + ' {%fields} from ' + FCollection + ' as ' +
      oData.Resource;                                                   /// monta o select  primeira tabela

    // relations
    child := oData;
    if child.ResourceParams.Count > 0 then       /// checa se tem parameteros   ex:   grupos('07')
    begin
      FKeys := GetWhereFromParams(child, oData.Resource, AResource.keyID);  /// gera a where para o parametro
      if FWhere <> '' then
        FWhere := '(' + FWhere + ') and (' + FKeys + ')'
      else
        FWhere := FKeys;
    end;

    if child.hasChild then  /// tem JOINs ?
    begin             /// gerar os JOINs
      child := child.child;
      repeat
        // resource pertence ao ultimo resource

        ARelation := AResource.relation(child.Resource);   /// procura o relacionamento "relation" no metadata
        if assigned(ARelation) then
        begin           /// achou um relation
          ARelationResource := GetResource(child.Resource); /// busca os dados de resource para o relation solicitado (master)
          sourceKey := ARelation.sourceKey;
          targetKey := ARelation.targetKey;
          FJoin := ARelation.join;
          FCollectionFinal := ARelationResource.collection;
          FLastFields := ARelationResource.fields;   /// pega lista de colunas default para o master do relation

          if FJoin <> '' then
            result := result + ' ' + FJoin    /// se tem um join - usa
          else
            result := result + ' join ' + FCollectionFinal + ' as ' +
              child.Resource + ' on (' + oData.Resource + '.' + sourceKey + '='
              + child.Resource + '.' + targetKey + ')';   /// quando nao tem JOIN monta um

          if child.ResourceParams.Count > 0 then
          begin                                  /// para paramentos passado no relation:   exemplo:   produtos('1')
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
          break;                     /// tem mais relation em cascata - se nao tem sai do repeat
      until child.hasChild;    /// vai para o proximo relation
    end;

    if AFilter <> '' then
    begin          /// $filter
      if FWhere <> '' then
        FWhere := '(' + FWhere + ') and ';
      FWhere := FWhere + AFilter;
    end;

    if FWhere <> '' then
      result := result + ' where ' + FWhere;

    if FGroupBy <> '' then               /// url: groupby=xxx
      result := result + ' group by ' + FGroupBy;

    if AInLineCount = false then
    begin
      FOrderBy := oData.OrderBy;
      if FOrderBy <> '' then
        result := result + ' order by ' + FOrderBy;   /// url:   $orderby
    end;

    if (FLastFields <> '') and (not AInLineCount) then
      FFields := FLastFields;   /// usa o ultimo

    if FFieldsReq<>'' then
      FFields := FFieldsReq;   // manter o que foi requisitado na url - nao usar o ultimo

    if FFields = '' then
      FFields := '*';      /// se nao foi indicado nenhum field - usa *
    result := stringReplace(result, '{%fields}', FFields, []);
  finally
    oData.Unlock;
  end;

end;

end.
