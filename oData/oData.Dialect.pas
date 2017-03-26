{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.Dialect;

interface

uses System.Classes, System.SysUtils, oData.ServiceModel,
  System.JSON, System.Generics.Collections,
  oData.JSON, oData.Interf;

const
  cODataRowState = 'rowstate';
  cODataModified = 'modified';
  cODataDeleted = 'deleted';
  cODataInserted = 'inserted';

Type

  TODataDialect = class(TInterfacedObject, IODataDialect)
  private
  protected
    FKeyID: string;
    FResource: IJsonODastaServiceResource;
    FCollection: string;
    FResourceName: string;
    FOData: IODataDecode;
    function GetResource: IInterface; overload;
    function createDeleteQuery(oData: IODataDecode; AJson: TJsonValue;
      AKeys: string): string; virtual;
    function createGETQuery(oData: IODataDecode; AFilter: string;
      const AInLineCount: Boolean = false): string; virtual;
    function CreatePostQuery(oData: IODataDecode; AJson: TJsonValue)
      : String; virtual;
    function createPATCHQuery(oData: IODataDecode; AJson: TJsonValue;
      AKeys: string): String; virtual;

    procedure CreateGroupBy(var Result: string; FGroupBy: string); virtual;
    procedure CreateOrderBy(oData: IODataDecode; const AInLineCount: Boolean;
      var Result: string); virtual;
    procedure CreateCrossJoin(oData: IODataDecode; var Result, FWhere: string;
      AResource: IJsonODastaServiceResource; FCollectionFinal: string;
      var FLastFields: string; child: IODataDecode; FKeys: string); virtual;
    procedure CreateFilter(AFilter: string; var FWhere: string); virtual;
    function TopCmdAfterSelectStmt(nTop, nSkip: integer): string; virtual;
    function TopCmdAfterFromStmt(nTop, nSkip: integer): string; virtual;
    function TopCmdStmt: string; virtual;
    function SkipCmdStmt: string; virtual;
    procedure CreateTopSkip(var Result: string; nTop, nSkip: integer); virtual;
    procedure &and(var Result: string); virtual;
    procedure &or(var Result: string); virtual;
  public
    function Collection: string; virtual;
    function GetResource(AResource: string): IInterface; overload; virtual;
    function Relation(AResource: string; ARelation: String)
      : IJsonObject; virtual;
    function GetWhereFromJson(const AJson: TJsonValue): String; virtual;
    function GetWhereFromParams(AOData: IODataDecode; alias, keys: string)
      : string; virtual;
    function GetInsertFromJson(AJson: TJsonValue): string; virtual;
    function GetUpdateFromJson(AJson: TJsonValue): string; virtual;
  end;

  TODataDialectClass = class of TODataDialect;

  TODataIgnoreColumns = class(TStringList)
  public
    procedure AddItem(AResource: string; AColumnName: string);
    function IndexOfItem(AResource: string; AColumnName: string): integer;
  end;

var
  ODataIgnoreColumns: TODataIgnoreColumns;

implementation

uses System.JSON.Helper, oData.parse, oData.Engine;

function iff(b: Boolean; t, f: string): string;
begin
  if b then
    Result := t
  else
    Result := f;
end;

{ TODataDialectClass }

{ TODataDialect }

function TODataDialect.GetInsertFromJson(AJson: TJsonValue): string;
var
  js: IJsonObject;
  p: TJsonPair;
  cols, params: string;
begin
  Result := '';
  js := TInterfacedJsonObject.New(AJson as TJSONObject, false);
  if (not assigned(AJson)) then
    raise Exception.Create(TODataError.Create(400,
      'JSON inválido para gerar INSERT'));
  cols := '';
  params := '';
  for p in js.JSONObject do
  begin
    if (p.JsonString.Value = cODataRowState) or
      (ODataIgnoreColumns.IndexOfItem(FResourceName, p.JsonString.Value) >= 0)
    then
      continue;

    if TInterfacedJsonObject.GetJsonType(p)=jtNull then
       continue;


    if cols <> '' then
    begin
      cols := cols + ',';
      params := params + ',';
    end;

    cols := cols + p.JsonString.Value;

    case TInterfacedJsonObject.GetJsonType(p) of
      jtNumber:
        params := params + p.JsonValue.Value;
    else
      params := params + QuotedStr(p.JsonValue.Value);
    end;
  end;
  Result := '(' + cols + ') values(' + params + ')';
end;

function TODataDialect.GetResource: IInterface;
begin
  Result := FResource;
end;

function TODataDialect.GetResource(AResource: string): IInterface;
begin
  Result := ODataServices.resource(AResource);
  if not assigned(Result) then
    raise Exception.Create('Serviço não disponível para o resource: ' +
      AResource);
  FResourceName := AResource;
end;

function TODataDialect.GetUpdateFromJson(AJson: TJsonValue): string;
var
  js: IJsonObject;
  p: TJsonPair;
  cols: string;
begin
  Result := '';
  js := TInterfacedJsonObject.New(AJson as TJSONObject, false);
  if (not assigned(AJson)) then
    raise Exception.Create(TODataError.Create(400,
      'JSON inválido para gerar UPDATE'));
  cols := '';
  for p in js.JSONObject do
  begin
    if (p.JsonString.Value = cODataRowState) or
      (ODataIgnoreColumns.IndexOfItem(FResourceName, p.JsonString.Value) >= 0)
    then
      continue;

    if TInterfacedJsonObject.GetJsonType(p) = jtNull then
       continue;

    if cols <> '' then
    begin
      cols := cols + ',';
    end;

    case TInterfacedJsonObject.GetJsonType(p) of
      jtNumber:
        cols := cols + p.JsonString.Value + '=' + p.JsonValue.Value;
    else
      cols := cols + p.JsonString.Value + '=' + QuotedStr(p.JsonValue.Value);
    end;
  end;
  Result := 'Set ' + cols;
end;

function TODataDialect.GetWhereFromJson(const AJson: TJsonValue): String;
var
  js: IJsonObject;
  p: TJsonPair;
begin
  Result := '';
  if AJson = nil then
    exit;

  js := TInterfacedJsonObject.New(AJson as TJSONObject, false);
  if (not assigned(AJson)) then
    raise Exception.Create(TODataError.Create(400,
      'JSON inválido para gerar Where'));
  for p in js.JSONObject do
  begin
    if (p.JsonString.Value = cODataRowState) or
      (ODataIgnoreColumns.IndexOfItem(FResourceName, p.JsonString.Value) >= 0)
    then
      continue;
    if Result <> '' then
      Result := Result + ' and ';
    case TInterfacedJsonObject.GetJsonType(p) of
      jtNumber:
        Result := Result + p.JsonString.Value + '=' + p.JsonValue.Value;
    else
      Result := Result + p.JsonString.Value + '=' +
        QuotedStr(p.JsonValue.Value);
    end;

  end;
end;

function TODataDialect.GetWhereFromParams(AOData: IODataDecode; alias: string;
  keys: string): string;
var
  s: string;
  key: string;
  reqKey: string;
  i: integer;
  str: TStringList;

begin
  Result := '';
  str := TStringList.Create;
  try
    str.Delimiter := ',';
    str.DelimitedText := keys;
    if str.Count = 0 then
      exit;
    for i := 0 to AOData.ResourceParams.Count - 1 do
    begin
      s := AOData.ResourceParams.ValueOfIndex(i);
      if Result <> '' then
        Result := Result + AOData.ResourceParams.OperatorLinkOfIndex(i);
      if i < str.Count then
        key := str[i];
      reqKey := AOData.ResourceParams.KeyOfIndex(i);
      if copy(reqKey, 1, 3) <> '__P' then
        key := reqKey;
      if i <= str.Count then
        Result := Result + iff(alias <> '', alias + '.', '') + key +
          AOData.ResourceParams.OperatorOfIndex(i) + s;
    end;
  finally
    str.Free;
  end;
  Result := TODataParse.OperatorToString(Result);
end;

procedure TODataDialect.&or(var Result: string);
begin
  if Result <> '' then
    Result := '(' + Result + ') or ';
end;

procedure TODataDialect.&and(var Result: string);
begin
  if Result <> '' then
    Result := '(' + Result + ') and '
end;

function TODataDialect.Collection: string;
begin
  Result := FCollection;
end;

procedure TODataDialect.CreateGroupBy(var Result: string; FGroupBy: string);
begin
  if FGroupBy <> '' then
    Result := Result + ' group by ' + FGroupBy;
end;

function TODataDialect.CreatePostQuery(oData: IODataDecode;
  AJson: TJsonValue): String;
var
  AResource: IJsonODastaServiceResource;
  FIns: string;
begin
  if not assigned(AJson) then
    raise Exception.Create(TODataError.Create(500,
      'Não enviou dados a serem inseridos'));
  AResource := GetResource(oData.resource) as IJsonODastaServiceResource;

  if not AResource.method.Contains('POST') then
    raise Exception.Create(TODataError.Create(403,
      'Método solicitado não autorizado'));

  Result := 'insert into ' + AResource.Collection;
  FIns := GetInsertFromJson(AJson);
  if FIns = '' then
    raise Exception.Create(TODataError.Create(500,
      'Não é um conjunto JSON válido'));

  Result := Result + ' ' + FIns;
end;

procedure TODataDialect.CreateOrderBy(oData: IODataDecode;
  const AInLineCount: Boolean; var Result: string);
var
  FOrderBy: string;
begin
  if AInLineCount = false then
  begin
    FOrderBy := oData.OrderBy;
    if FOrderBy <> '' then
      Result := Result + ' order by ' + FOrderBy;
  end;
end;

function TODataDialect.createPATCHQuery(oData: IODataDecode; AJson: TJsonValue;
  AKeys: string): String;
var
  AResource: IJsonODastaServiceResource;
  FUpdate: string;
  FWhere, FWhere2: string;
  child: IODataDecode;
  FKeys, sKeys: string;
  AValue: TJsonValue;
  js: IJsonObject;
  jv: TJsonValue;
  str: TStringList;
begin
  if not assigned(AJson) then
    raise Exception.Create(TODataError.Create(500,
      'Não enviou dados a serem inseridos'));
  AResource := GetResource(oData.resource) as IJsonODastaServiceResource;

  if (not AResource.method.contains('PUT')) and (not  AResource.method.contains('PATCH'))
  then
    raise Exception.Create(TODataError.Create(403,
      'Método solicitado não autorizado'));

  Result := 'update ' + AResource.Collection;
  FUpdate := GetUpdateFromJson(AJson);
  if FUpdate = '' then
    raise Exception.Create(TODataError.Create(500,
      'Não é um conjunto JSON válido'));

  Result := Result + ' ' + FUpdate;

  FWhere := oData.Filter;

  child := oData;
  if child.ResourceParams.Count > 0 then
  /// checa se tem parameteros   ex:   grupos ('07')
  begin
    FKeys := GetWhereFromParams(child, '', AResource.keyID);
    /// gera a where para o parametro
    if FWhere <> '' then
      FWhere := '(' + FWhere + ') and (' + FKeys + ')'
    else
      FWhere := FKeys;

  end;

  FWhere2 := '';
  FKeys := AKeys;
  if (FWhere = '') and (FKeys <> '') then
  begin
    str := TStringList.Create;
    try
      str.Delimiter := ',';
      str.DelimitedText := FKeys;
      for sKeys in str do
      begin
        js := TInterfacedJsonObject.New(AJson, false);
        if assigned(AJson) then
        begin
          jv := js.JSONObject.GetValue(sKeys);
          if assigned(jv) then
          begin
            if FWhere2 <> '' then
              FWhere2 := FWhere2 + ' and ';
            case TInterfacedJsonObject.GetJsonType(jv) of
              jtNumber:
                FWhere2 := FWhere2 + sKeys + '=' + jv.Value;
            else
              FWhere2 := FWhere2 + sKeys + '=' + QuotedStr(jv.Value);
            end;
          end;
        end;
      end;
    finally
      str.Free;
    end;
  end;

  if (FWhere2 <> '') then
  begin
    if FWhere <> '' then
      FWhere := '(' + FWhere + ') and ';
    FWhere := FWhere + FWhere2;
  end;

  if FWhere = '' then
    raise Exception.Create(TODataError.Create(403,
      'Não permitidido excluir todas as linhas'));

  Result := Result + ' where ' + FWhere;

end;

procedure TODataDialect.CreateFilter(AFilter: string; var FWhere: string);
begin
  if AFilter <> '' then
  begin
    /// $filter
    if FWhere <> '' then
      FWhere := '(' + FWhere + ') and ';
    FWhere := FWhere + AFilter;
  end;
end;

procedure TODataDialect.CreateCrossJoin(oData: IODataDecode; var Result: string;
  var FWhere: string; AResource: IJsonODastaServiceResource;
  FCollectionFinal: string; var FLastFields: string; child: IODataDecode;
  FKeys: string);
var
  ARelation: IJsonODataServiceRelation;
  ARelationResource: IJsonODastaServiceResource;
  sourceKey: string;
  targetKey: string;
  FJoin: string;
begin
  if child.hasChild then
  /// tem JOINs ?
  begin
    /// gerar os JOINs
    child := child.child;
    repeat
      // resource pertence ao ultimo resource
      ARelation := AResource.Relation(child.resource);
      /// procura o relacionamento "relation" no metadata
      if assigned(ARelation) then
      begin
        /// achou um relation
        ARelationResource := GetResource(child.resource)
          as IJsonODastaServiceResource;
        /// busca os dados de resource para o relation solicitado (master)
        sourceKey := ARelation.sourceKey;
        targetKey := ARelation.targetKey;
        FJoin := ARelation.join;
        FCollectionFinal := ARelationResource.Collection;
        FLastFields := ARelationResource.fields;
        /// pega lista de colunas default para o master do relation
        if FJoin <> '' then
          Result := Result + ' ' + FJoin
        else
          /// se tem um join - usa
          Result := Result + ' join ' + FCollectionFinal + ' as ' +
            child.resource + ' on (' + oData.resource + '.' + sourceKey + '=' +
            child.resource + '.' + targetKey + ')';
        /// quando nao tem JOIN monta um
        if child.ResourceParams.Count > 0 then
        begin
          /// para paramentos passado no relation:   exemplo:   produtos('1')
          FKeys := GetWhereFromParams(child, child.resource,
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
    until
    /// tem mais relation em cascata - se nao tem sai do repeat
      child.hasChild;
  end;
end;

function TODataDialect.createDeleteQuery(oData: IODataDecode; AJson: TJsonValue;
  AKeys: string): string;
var
  AResource: IJsonODastaServiceResource;
  child: IODataDecode;
  FWhere, FWhere2, FKeys: string;
begin
  AResource := GetResource(oData.resource) as IJsonODastaServiceResource;

  if not  AResource.method.Contains('DELETE') then
    raise Exception.Create(TODataError.Create(403,
      'Método solicitado não autorizado'));

  Result := 'delete from ' + AResource.Collection;
  FWhere := oData.Filter;

  if assigned(AJson) then
  begin
    FWhere2 := GetWhereFromJson(AJson);
    if FWhere2 <> '' then
    begin
      if FWhere <> '' then
        FWhere := FWhere + ' and ';
      FWhere := FWhere + FWhere2;
    end;
  end;

  // relations
  child := oData;

  if child.ResourceParams.Count > 0 then
  begin
    FKeys := GetWhereFromParams(child, '', AResource.keyID);
    /// gera a where para o parametro
    if FWhere <> '' then
      FWhere := '(' + FWhere + ') and (' + FKeys + ')'
    else
      FWhere := FKeys;
  end;

  if FWhere = '' then
    raise Exception.Create(TODataError.Create(403,
      'Não permitidido excluir todas as linhas'));

  Result := Result + ' where ' + FWhere;

end;

function TODataDialect.createGETQuery(oData: IODataDecode; AFilter: string;
  const AInLineCount: Boolean): string;
var
  FWhere, FCollectionFinal, FKeys, FFields: string;
  FGroupBy: string;
  LLevel: integer;
  child: IODataDecode;
  ATop, ASkip: integer;
  FLastFields: String;
  FFieldsReq: string;
begin
  FOData := oData;
  oData.Lock;
  try
    Result := 'select ';
    FWhere := '';
    FResource := GetResource(oData.resource) as IJsonODastaServiceResource;

    if FResource.method <> '' then
      if not FResource.method.Contains('GET') then
        raise Exception.Create(TODataError.Create(403,
          'Método solicitado não autorizado'));
    FKeyID := FResource.keyID;
    /// busca no metadata os parametros
    FGroupBy := oData.GroupBy;
    /// pega groupby do metadata
    FCollection := FResource.Collection;
    /// pega a tabela associada no metadata
    FCollectionFinal := FCollection;
    /// tmp para ultima tabela avalidada
    ATop := oData.Top;
    ASkip := oData.Skip;
    if ATop = 0 then
      ATop := FResource.maxpagesize;
    /// se nao for requisitado TOP, pegar o constante no metadata
    FLastFields := '';
    if AInLineCount = false then
    begin
      if (ATop > 0) or (ASkip > 0) then
        Result := Result + TopCmdAfterSelectStmt(ATop, ASkip);
      /// $select
      FFieldsReq := oData.Select;
      /// colunas definidas no metadata
      FLastFields := FResource.fields;
    end
    else
      FFieldsReq := ' count(*) N__Count ';
    // quando inlinecount=allpages - fazer um count

    Result := Result + ' {%fields} from ' + FCollection + ' as ' +
      oData.resource;
    /// monta o select  primeira tabela
    Result := Result + TopCmdAfterFromStmt(ATop, ASkip);

    if FResource.join <> '' then
      Result := Result + ' ' + FResource.join;

    // relations
    child := oData;
    if child.ResourceParams.Count > 0 then
    /// checa se tem parameteros   ex:   grupos ('07')
    begin
      FKeys := GetWhereFromParams(child, oData.resource, FResource.keyID);
      /// gera a where para o parametro
      if FWhere <> '' then
        FWhere := '(' + FWhere + ') and (' + FKeys + ')'
      else
        FWhere := FKeys;
    end;

    CreateCrossJoin(oData, Result, FWhere, FResource, FCollectionFinal,
      FLastFields, child, FKeys);

    CreateFilter(AFilter, FWhere);

    if FWhere <> '' then
      Result := Result + ' where ' + FWhere;

    CreateGroupBy(Result, FGroupBy);

    CreateOrderBy(oData, AInLineCount, Result);

    if (FLastFields <> '') and (not AInLineCount) then
      FFields := FLastFields;
    /// usa o ultimo

    if FFieldsReq <> '' then
      FFields := FFieldsReq;
    // manter o que foi requisitado na url - nao usar o ultimo

    if FFields = '' then
      FFields := '*';
    /// se nao foi indicado nenhum field - usa *
    Result := stringReplace(Result, '{%fields}', FFields, []);
  finally
    oData.Unlock;
  end;

end;

procedure TODataDialect.CreateTopSkip(var Result: string; nTop, nSkip: integer);
begin
  // mySql/firebird;
  Result := TopCmdStmt + nTop.ToString + ' ';
  if nSkip > 0 then
    Result := Result + SkipCmdStmt + nSkip.ToString;

end;

function TODataDialect.Relation(AResource, ARelation: String): IJsonObject;
var
  rs: IJsonODastaServiceResource;
begin
  try
    rs := GetResource(AResource) as IJsonODastaServiceResource;
    Result := TInterfacedJsonObject.New(rs.Relation(ARelation).JSON);
    if not assigned(Result) then
      raise Exception.Create('Serviços não disponível para o resource detalhe: '
        + ARelation);
  except
    Result := nil;
  end;
end;

function TODataDialect.SkipCmdStmt: string;
begin
  // mysql
  Result := ' ,';
end;

function TODataDialect.TopCmdAfterFromStmt(nTop, nSkip: integer): string;
begin
  // mySql;
  CreateTopSkip(Result, nTop, nSkip);
end;

function TODataDialect.TopCmdAfterSelectStmt(nTop, nSkip: integer): string;
begin
  // mysql
  Result := '';
end;

function TODataDialect.TopCmdStmt: string;
begin
  // mysql/firebird
  Result := ' Limit ';
end;

{ TODataIgnoreColumns }

procedure TODataIgnoreColumns.AddItem(AResource, AColumnName: string);
begin
  add(AResource + '.' + AColumnName);
end;

function TODataIgnoreColumns.IndexOfItem(AResource,
  AColumnName: string): integer;
begin
  Result := IndexOf(AResource + '.' + AColumnName);
end;

initialization

ODataIgnoreColumns := TODataIgnoreColumns.Create;

finalization

ODataIgnoreColumns.Free;

end.
