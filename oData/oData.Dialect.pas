{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.Dialect;

interface

uses System.Classes, System.SysUtils, oData.ServiceModel,
  System.JSON, System.JSON.Helper, System.Generics.Collections,
  oData.Engine, oData.Interf, System.SyncObjs;

const
  cODataRowState = 'rowstate';
  cODataModified = 'modified';
  cODataDeleted = 'deleted';
  cODataInserted = 'inserted';
  cODataModifiedORInserted = 'modifyORinsert';

Type

  TODataDialect = class(TInterfacedObject, IODataDialect)
  private
    FBaseWhere: string;
    function GetWhereFromKeys(AKeys: string; const AJson: TJsonValue): String;
    function GetUpdateFromJsonX(AJson: TJsonValue; aWhere: string)
      : string; virtual;
  protected
    FSkip: integer;
    FTop: integer;
    FKeyID: string;
    FResource: IJsonODataServiceResource;
    FCollection: string;
    FResourceName: string;
    FOData: TODataDecodeAbstract;
    function GetResource: IInterface; overload;
    function createDELETEQuery(oData: TODataDecodeAbstract; AJson: TJsonValue;
      AKeys: string; AResource: TObject): string; virtual;
    function createGETQuery(oData: TODataDecodeAbstract; AFilter: string;
      const AInLineCount: Boolean = false): string; virtual;
    function CreatePOSTQuery(oData: TODataDecodeAbstract; AJson: TJsonValue;
      AResource: TObject): String; virtual;

    function createPATCHQuery(oData: TODataDecodeAbstract; AJson: TJsonValue;
      AKeys: string; AResource: TObject): String; virtual;

    procedure CreateGroupBy(var Result: string; FGroupBy: string); virtual;
    procedure CreateOrderBy(oData: TODataDecodeAbstract;
      const AInLineCount: Boolean; var Result: string); virtual;
    procedure CreateCrossJoin(oData: TODataDecodeAbstract;
      var Result, FWhere: string; AResource: IJsonODataServiceResource;
      FCollectionFinal: string; var FLastFields: string;
      child: TODataDecodeAbstract; FKeys: string); virtual;
    procedure CreateFilter(AFilter: string; var FWhere: string); virtual;

    // $top / $skip support
    function TopCmdAfterSelectStmt(nTop, nSkip: integer): string; virtual;
    function TopCmdAfterFromStmt(nTop, nSkip: integer): string; virtual;
    function TopCmdAfterAtEndOfStmt(nTop, nSkip: integer): string; virtual;
    function TopCmdStmt: string; virtual;
    function SkipCmdStmt: string; virtual;
    procedure CreateTopSkip(var Result: string; nTop, nSkip: integer); virtual;

    function AfterCreateSQL(var SQL: string): Boolean; virtual;
    procedure &and(var Result: string); virtual;
    procedure &or(var Result: string); virtual;
  public
    procedure Release;
    function Collection: string; virtual;
    function GetResource(AResource: string): IInterface; overload; virtual;
    function Relation(AResource: string; ARelation: String)
      : IJsonObject; virtual;
    function GetWhereFromJson(const AJson: TJsonValue): String; virtual;
    function GetWhereFromParams(AOData: TODataDecodeAbstract;
      alias, keys: string): string; virtual;
    function GetInsertFromJson(AJson: TJsonValue): string; overload; virtual;
    class function GetInsertFromJson(FResourceName: string; AJson: TJsonValue)
      : string; overload; virtual;
    function GetUpdateFromJson(AJson: TJsonValue): string; overload; virtual;
  end;

  TODataDialectClass = class of TODataDialect;

  TODataIgnoreColumns = class(TStringList)
  public
    procedure AddItem(AResource: string; AColumnName: string);
    function IndexOfItem(AResource: string; AColumnName: string): integer;
  end;




implementation

uses oData.parse;

var
 _ODataIgnoreColumns : TODataIgnoreColumns;
 ODataIgnoreColumnsLock : TSpinLock;


function ODataIgnoreColumns(): TODataIgnoreColumns;
begin
  ODataIgnoreColumnsLock.Enter;
  try
    Result := _ODataIgnoreColumns;
  finally
   ODataIgnoreColumnsLock.Exit;
  end;
end;
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
begin
  Result := GetInsertFromJson(FResourceName, AJson);
end;

class function TODataDialect.GetInsertFromJson(FResourceName: string;
  AJson: TJsonValue): string;
var
  js: IJsonObject;
  p: TJsonPair;
  cols, params, v: string;
begin
  Result := '';
  js := TInterfacedJson.New(AJson.ToString,True);
  if (not assigned(AJson)) then
    raise Exception.Create(TODataError.Create(400,
      'JSON inv�lido para gerar INSERT'));
  cols := '';
  params := '';
  for p in js.JSONObject do
  begin
    if (p.JsonString.Value = cODataRowState) or
      (ODataIgnoreColumns.IndexOfItem(FResourceName, p.JsonString.Value) >= 0)
    then
      continue;

    if TInterfacedJson.GetJsonType(p) = jtNull then
      continue;

    if cols <> '' then
    begin
      cols := cols + ',';
      params := params + ',';
    end;

    cols := cols + p.JsonString.Value;

    case TInterfacedJson.GetJsonType(p) of
      jtNumber, jtString, jtTrue, jtFalse, jtDatetimeISO8601, jtDateTime:
        begin
          params := params + ':' + p.JsonString.Value;
          // p.JsonValue.Value.Replace(FormatSettings.DecimalSeparator,'.',[]);
        end;
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
    raise Exception.Create('Servi�o n�o dispon�vel para o resource: ' +
      AResource);
  FResourceName := AResource;
end;

function TODataDialect.GetUpdateFromJson(AJson: TJsonValue): string;
var
  js: IJsonObject;
  p: TJsonPair;
  AjsonObject : TJSONObject;
  cols: string;
  procedure local_addColumn(aCol: string);
  begin
    if cols <> '' then
    begin
      cols := cols + ', ';
    end;
    cols := cols + aCol
  end;

begin
  Result := '';
  cols := '';
  if (not assigned(AJson)) then
    raise Exception.Create(TODataError.Create(400,
      'JSON inv�lido para gerar UPDATE'));
  js := TInterfacedJSON.New(Ajson.ToString,True);
  for p in js.JSONObject do
  begin
    if (p.JsonString.Value = cODataRowState) or
      (ODataIgnoreColumns.IndexOfItem(FResourceName, p.JsonString.Value) >= 0)
    then
      continue;
    case TInterfacedJson.GetJsonType(p) of
      jtNumber, jtDateTime, jtString, jtDatetimeISO8601, jtTrue, jtFalse:
        begin
          // nao fazer update em colunas que fazem parte da where
          if pos(':' + p.JsonString.Value, FBaseWhere) = 0 then
            local_addColumn(p.JsonString.Value + '=' + ' :' +
              p.JsonString.Value);
        end;
      jtNull:
        ; // noop
    else
      local_addColumn(p.JsonString.Value + '=' + QuotedStr(p.JsonValue.Value));
    end;
  end;
  Result := 'Set ' + cols;
end;

function TODataDialect.GetUpdateFromJsonX(AJson: TJsonValue;
  aWhere: string): string;
begin
  FBaseWhere := aWhere;
  Result := GetUpdateFromJson(AJson);
end;

function TODataDialect.GetWhereFromKeys(AKeys: string;
  const AJson: TJsonValue): String;
var
  str: TStringList;
  sKeys: string;
  jv: TJsonValue;
begin
  Result := '';
  str := TStringList.Create;
  try
    str.Delimiter := ',';
    str.DelimitedText := AKeys;
    for sKeys in str do
    begin
      if assigned(AJson) then
      begin
        jv := (AJson as TJSONObject).GetValue(sKeys);
        if assigned(jv) then
        begin
          if Result <> '' then
            Result := Result + ' and ';
          case TInterfacedJson.GetJsonType(jv) of
            jtNumber, jtDateTime, jtDatetimeISO8601, jtString, jtTrue, jtFalse:
              Result := Result + sKeys + '= :' + sKeys;
            jtNull:
              begin // nothing
              end;
          else
            Result := Result + sKeys + '=' + QuotedStr(jv.Value);
          end;
        end;
      end;
    end;
  finally
    str.Free;
  end;

end;

function TODataDialect.GetWhereFromJson(const AJson: TJsonValue): String;
var
  js: IJsonObject;
  p: TJsonPair;
begin
  Result := '';
  if AJson = nil then
    exit;

  js := TInterfacedJson.New(AJson.ToString, True);
  if (not assigned(AJson)) then
    raise Exception.Create(TODataError.Create(400,
      'JSON inv�lido para gerar Where'));
  for p in js.JSONObject do
  begin
    if (p.JsonString.Value = cODataRowState) or
      (ODataIgnoreColumns.IndexOfItem(FResourceName, p.JsonString.Value) >= 0)
    then
      continue;
    if Result <> '' then
      Result := Result + ' and ';
    case TInterfacedJson.GetJsonType(p) of
      jtNumber:
        Result := Result + p.JsonString.Value + '=' + p.JsonValue.Value;
      jtNull:
        begin
          /// nothing
        end;
    else
      Result := Result + p.JsonString.Value + '=' +
        QuotedStr(p.JsonValue.Value);
    end;

  end;
end;

function TODataDialect.GetWhereFromParams(AOData: TODataDecodeAbstract;
  alias: string; keys: string): string;
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

function TODataDialect.AfterCreateSQL(var SQL: string): Boolean;
begin
  Result := false;
  /// nao alterou nada.
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

function TODataDialect.CreatePOSTQuery(oData: TODataDecodeAbstract;
  AJson: TJsonValue; AResource: TObject): String;
var
  FIns: string;
  LResource: TJsonODataServiceResource;
begin
  if not assigned(AJson) then
    raise Exception.Create(TODataError.Create(500,
      'N�o enviou dados a serem inseridos'));

  if AResource = nil then
    AResource := (GetResource(oData.resource)
      as IJsonODataServiceResource).this;

  LResource := TJsonODataServiceResource(AResource);

  if not LResource.method.Contains('POST') then
    raise Exception.Create(TODataError.Create(403,
      'M�todo solicitado n�o autorizado'));

  Result := 'insert into ' + LResource.Collection;
  FIns := GetInsertFromJson(AJson);
  if FIns = '' then
    raise Exception.Create(TODataError.Create(500,
      'N�o � um conjunto JSON v�lido'));

  Result := Result + ' ' + FIns;
end;

procedure TODataDialect.CreateOrderBy(oData: TODataDecodeAbstract;
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

function TODataDialect.createPATCHQuery(oData: TODataDecodeAbstract;
  AJson: TJsonValue; AKeys: string; AResource: TObject): String;
var
  FUpdate: string;
  FWhere, FWhere2: string;
  child: TODataDecodeAbstract;
  FKeys, sKeys: string;
  AValue: TJsonValue;
  js: IJsonObject;
  jv: TJsonValue;
  str: TStringList;
  LResource: TJsonODataServiceResource;
begin
  if not assigned(AJson) then
    raise Exception.Create(TODataError.Create(500,
      'N�o enviou dados a serem inseridos'));
  if not assigned(AResource) then
    AResource := (GetResource(oData.resource)
      as IJsonODataServiceResource).this;

  LResource := TJsonODataServiceResource(AResource);

  if (not LResource.method.Contains('PUT')) and
    (not LResource.method.Contains('PATCH')) then
    raise Exception.Create(TODataError.Create(403,
      'M�todo solicitado n�o autorizado'));

  Result := 'update ' + LResource.Collection;

  FWhere := oData.Filter;

  child := oData;
  if child.ResourceParams.Count > 0 then
  /// checa se tem parameteros   ex:   grupos ('07')
  begin
    FKeys := GetWhereFromParams(child, '', LResource.keyID);
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
    FWhere2 := GetWhereFromKeys(FKeys, AJson);
  end;

  if (FWhere2 <> '') then
  begin
    if FWhere <> '' then
      FWhere := '(' + FWhere + ') and ';
    FWhere := FWhere + FWhere2;
  end;

  if FWhere = '' then
    raise Exception.Create(TODataError.Create(403,
      'N�o permitidido excluir todas as linhas'));

  FUpdate := GetUpdateFromJsonX(AJson, FWhere);
  if FUpdate = '' then
    raise Exception.Create(TODataError.Create(500,
      'N�o � um conjunto JSON v�lido'));

  Result := Result + ' ' + FUpdate;

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

procedure TODataDialect.CreateCrossJoin(oData: TODataDecodeAbstract;
  var Result: string; var FWhere: string; AResource: IJsonODataServiceResource;
  FCollectionFinal: string; var FLastFields: string;
  child: TODataDecodeAbstract; FKeys: string);
var
  ARelation: IJsonODataServiceRelation;
  ARelationResource: IJsonODataServiceResource;
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
          as IJsonODataServiceResource;
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

function TODataDialect.createDELETEQuery(oData: TODataDecodeAbstract;
  AJson: TJsonValue; AKeys: string; AResource: TObject): string;
var
  i: integer;
  LResource: TJsonODataServiceResource;
  child: TODataDecodeAbstract;
  FWhere, FWhere2, FKeys: string;
  FKeysStrings: TStringList;
begin
  if AResource = nil then
    AResource := (GetResource(oData.resource)
      as IJsonODataServiceResource).this;

  LResource := TJsonODataServiceResource(AResource);

  if not LResource.method.Contains('DELETE') then
    raise Exception.Create(TODataError.Create(403,
      'M�todo solicitado n�o autorizado'));

  Result := 'delete from ' + LResource.Collection;
  FWhere := oData.Filter;

  FKeys := AKeys;
  FWhere2 := '';
  if (FWhere = '') and (FKeys <> '') then
  begin
    FWhere2 := GetWhereFromKeys(FKeys, AJson);
  end;
  if FWhere2 <> '' then
  begin
    if FWhere <> '' then
      FWhere := '(' + FWhere + ') ';
    FWhere := FWhere + FWhere2;
    FWhere2 := '';
  end;

  if FWhere = '' then
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
    FKeys := GetWhereFromParams(child, '', LResource.keyID);
    /// gera a where para o parametro
    if FWhere <> '' then
      FWhere := '(' + FWhere + ') and (' + FKeys + ')'
    else
      FWhere := FKeys;
  end;

  if FWhere = '' then
    raise Exception.Create(TODataError.Create(403,
      'N�o permitidido excluir todas as linhas'));

  Result := Result + ' where ' + FWhere;

end;

function TODataDialect.createGETQuery(oData: TODataDecodeAbstract;
  AFilter: string; const AInLineCount: Boolean): string;
var
  FWhere, FCollectionFinal, FKeys, FFields: string;
  FGroupBy: string;
  LLevel: integer;
  child: TODataDecodeAbstract;
  ATop, ASkip: integer;
  FLastFields: String;
  FFieldsReq: string;
begin
  FOData := oData;
  oData.Lock;
  try
    Result := 'select ';
    FWhere := '';
    FResource := GetResource(oData.resource) as IJsonODataServiceResource;

    if FResource.method <> '' then
      if not FResource.method.Contains('GET') then
        raise Exception.Create(TODataError.Create(403,
          'M�todo solicitado n�o autorizado'));
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
    if (ATop > 0) or (ASkip > 0) then
      Result := Result + TopCmdAfterAtEndOfStmt(ATop, ASkip);

  finally
    oData.Unlock;
  end;

end;

procedure TODataDialect.CreateTopSkip(var Result: string; nTop, nSkip: integer);
begin
  // mySql/firebird;
  Result := '';
  FTop := nTop;
  FSkip := nSkip;
  if nTop >= 0 then
    Result := TopCmdStmt + nTop.ToString + ' ';
  if nSkip > 0 then
    Result := Result + SkipCmdStmt + nSkip.ToString;

end;

function TODataDialect.Relation(AResource, ARelation: String): IJsonObject;
var
  rs: IJsonODataServiceResource;
begin
  try
    rs := GetResource(AResource) as IJsonODataServiceResource;
    Result := TInterfacedJson.New(rs.Relation(ARelation).JSON, True);
    if not assigned(Result) then
      raise Exception.Create('Servi�os n�o dispon�vel para o resource detalhe: '
        + ARelation);
  except
    Result := nil;
  end;
end;

procedure TODataDialect.Release;
begin

end;

function TODataDialect.SkipCmdStmt: string;
begin
  // mysql
  Result := ' ,';
end;

function TODataDialect.TopCmdAfterAtEndOfStmt(nTop, nSkip: integer): string;
begin
  Result := '';
  // CreateTopSkip(Result, nTop, nSkip);
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

_ODataIgnoreColumns := TODataIgnoreColumns.Create;
ODataIgnoreColumnsLock := TSPinLock.Create(False); //record
finalization

_ODataIgnoreColumns.Free;

end.
