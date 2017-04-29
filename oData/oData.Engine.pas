{//************************************************************//}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 03/03/2017                                           //}
{//************************************************************//}
unit oData.Engine;

interface

uses System.Classes, System.SysUtils, System.Generics.Collections,
  oData.Collections, IdURI,
  oData.Interf;

type

  TODataOperators = record
    Value: string;
    class function new(const AText: string): TODataOperators; static;
    function add(AString: string): TODataOperators;
    function &and: TODataOperators;
    function &or: TODataOperators;
    function &not: TODataOperators;
    function &open: TODataOperators;
    function &close: TODataOperators;
    function &enClose: TODataOperators;
    function &equal(const AValue: string): TODataOperators;
    function &notEqual(const AValue: string): TODataOperators;
    function &lessThan(const AValue: string): TODataOperators;
    function &lessOrEqual(const AValue: string): TODataOperators;
    function &greaterThan(const AValue: String): TODataOperators;
    function &greaterOrEqual(const AValue: String): TODataOperators;
    function length(const AValue: String): TODataOperators;
    function trim(const AValue: string): TODataOperators;
    function substringOf(const AValue: string; AField: string): TODataOperators;
    function endsWith(const AField, AValue: string): TODataOperators;
    function startsWith(const AField, AValue: string): TODataOperators;
    function year(const AValue: string): TODataOperators;
    function month(const AValue: string): TODataOperators;
    function day(const AValue: string): TODataOperators;
  end;

  TODataError = record
  public
    class function create(cod: integer; mess: string): string; static;
  end;

  TODataDecode = class(TInterfacedObject, IODataDecode)
  private
    FLock: TObject;
    FSelect: string;
    FFilter: string;
    FOrderBy: string;
    FSkip: integer;
    FExpand: string;
    FTop: integer;
    FFormat: string;
    FResource: string;
    FSkipToken: string;
    FInLineCount: string;
    FResourceParams: IODataDecodeParams;
    FBaseURL: string;
    FGroupBy: string;
    FSearch: string;
    Fdebug: string;
    procedure SetSelect(const Value: string);
    procedure SetFilter(const Value: string);
    procedure SetOrderBy(const Value: string);
    procedure SetSkip(const Value: integer);
    procedure SetExpand(const Value: string);
    procedure SetTop(const Value: integer);
    procedure SetFormat(const Value: string);
    procedure SetResource(const Value: string);
    procedure SetInLineCount(const Value: string);
    procedure SetSkipToken(const Value: string);
    function GetExpand: string;
    function GetFilter: string;
    function GetFormat: string;
    function GetInLineCount: string;
    function GetOrderBy: string;
    function GetResource: string;
    function GetSelect: string;
    function GetSkip: integer;
    function GetSkipToken: string;
    function GetTop: integer;
    function GetResourceParams: IODataDecodeParams;
    procedure SetBaseURL(const Value: string);
    procedure SetGroupBy(const Value: string);
    function GetGroupBy: string;
    procedure SetSearch(const Value: string);
    function GetSearch: string;
    procedure Setdebug(const Value: string);
    function GetDebug: string;
  protected
    FChild: IODataDecode;
    FExpandItem: TDictionary<string, IODataDecode>;
    function This: TObject; virtual;
    function Lock: IODataDecode;
    procedure Unlock;
  public
    FParse: IODataParse;
    function GetParse: IODataParse;

    constructor create(AParse: IODataParse); virtual;
    destructor destroy; override;
    function hasChild: boolean;
    function Child: IODataDecode;
    function newChild: IODataDecode;

    function hasExpand: boolean;
    function ExpandItem(const idx: integer): IODataDecode;
    function ExpandCount: integer;
    function newExpand(const ACollection: string): IODataDecode;

    // define collection do request
    property BaseURL: string read FBaseURL write SetBaseURL;
    property Resource: string read GetResource write SetResource;
    property ResourceParams: IODataDecodeParams read GetResourceParams;
    function GetLevel(FLevel: integer; AAutoCreate: boolean = true)
      : IODataDecode;

    // write SetResourceParams;
    // define a list of fields
    property &Select: string read GetSelect write SetSelect;
    // define filter (aka where)
    property &Filter: string read GetFilter write SetFilter;
    property &Search:string read GetSearch write SetSearch;

    // define orderby
    property &OrderBy: string read GetOrderBy write SetOrderBy;
    // expands relation collections
    property &Expand: string read GetExpand write SetExpand;
    // format response  (suport only json for now)
    property &Format: string read GetFormat write SetFormat;
    // pagination
    property &Skip: integer read GetSkip write SetSkip;
    property &Top: integer read GetTop write SetTop;
    property &SkipToken: string read GetSkipToken write SetSkipToken;
    property &InLineCount: string read GetInLineCount write SetInLineCount;
    property &Debug:string read GetDebug write SetDebug;
    property &GroupBy: string read GetGroupBy write SetGroupBy;
    function ToString: string; virtual;

  end;

implementation

uses System.JSON;
{ TODataDecode }

function TODataDecode.Child: IODataDecode;
begin
  result := FChild;
end;

function TODataDecode.hasChild: boolean;
begin
  result := assigned(FChild);
end;

function TODataDecode.hasExpand: boolean;
begin
  result := FExpandItem.Count > 0;
end;

function TODataDecode.Lock: IODataDecode;
begin
  System.TMonitor.Enter(FLock);
  result := self;
end;

function TODataDecode.newChild: IODataDecode;
begin
  if not hasChild then
    FChild := TODataDecode.create(FParse);
  result := FChild;
end;

function TODataDecode.newExpand(const ACollection: string): IODataDecode;
begin
  result := TODataDecode.create(FParse);
  result.Resource := ACollection;
  FExpandItem.add(ACollection, result);
end;

constructor TODataDecode.create(AParse: IODataParse);
begin
  inherited create;
  FLock := TObject.create;
  FParse := AParse;
  FBaseURL := '/';
  FResourceParams := TODataDictionay.create;
  FExpandItem := TDictionary<string, IODataDecode>.create;
end;

function TODataDecode.ToString: string;
var
  i: integer;
  p: string;
  query: TStringList;
  procedure add(key, Value: string);
  begin
    if Value <> '' then
    begin
      query.add(key + '=' + Value);
    end;
  end;
  procedure addInt(key: string; Value: integer);
  begin
    if Value <> 0 then
    begin
      query.add(key + '=' + Value.ToString);
    end;
  end;

begin
  result := FBaseURL + Resource;
  p := '';
  for i := 0 to FResourceParams.Count - 1 do
  begin
    if i > 0 then
      p := p + ',';
    p := FResourceParams.ValueOfIndex(i);
  end;
  if p <> '' then
    result := result + '(' + p + ')';

  query := TStringList.create;
  try
    query.Delimiter := '&';
    add('$select', Select);
    add('$filter', Filter);
    addInt('$skip', Skip);
    addInt('$top', top);
    add('$skiptoken', SkipToken);
    add('$inlinecount', InLineCount);
    add('$expand', Expand);
    add('$format', Format);
    add('$debug',Debug);
    if query.Count > 0 then
      result := result + '?' + query.DelimitedText;
  finally
    query.Free;
  end;

end;

procedure TODataDecode.Unlock;
begin
  System.TMonitor.Exit(FLock);
end;

destructor TODataDecode.destroy;
begin
  FLock.Free;
  FExpandItem.Free;
  inherited;
end;

function TODataDecode.ExpandCount: integer;
begin
  result := FExpandItem.Count;
end;

function TODataDecode.ExpandItem(const idx: integer): IODataDecode;
begin
  result := FExpandItem.Values.ToArray[idx];
end;

function TODataDecode.GetDebug: string;
begin
   result := Fdebug;
end;

function TODataDecode.GetExpand: string;
begin
  result := FExpand;
end;

function TODataDecode.GetFilter: string;
begin
  result := TIdURI.URLDecode( FFilter );
end;

function TODataDecode.GetFormat: string;
begin
  result := FFormat;
end;

function TODataDecode.GetGroupBy: string;
begin
  result := TIdURI.URLDecode(FGroupBy);
end;

function TODataDecode.GetInLineCount: string;
begin
  result := FInLineCount;
end;

function TODataDecode.GetLevel(FLevel: integer; AAutoCreate: boolean = true)
  : IODataDecode;
var
  i: integer;
  cur: TODataDecode;
begin
  cur := self;
  for i := 1 to FLevel do
  begin
    if cur.hasChild then
      cur := TODataDecode(cur.Child.This)
    else
      cur := TODataDecode(cur.newChild.This);
    if i = FLevel then
    begin
      break;
    end;
  end;
  result := cur;
end;

function TODataDecode.GetOrderBy: string;
begin
  result := TIdURI.URLDecode(FOrderBy);
end;

function TODataDecode.GetParse: IODataParse;
begin
  result := FParse;
end;

function TODataDecode.GetResource: string;
begin
  result := FResource;
end;

function TODataDecode.GetResourceParams: IODataDecodeParams;
begin
  result := FResourceParams;
end;

function TODataDecode.GetSearch: string;
begin
  result := TIdURI.URLDecode(FSearch);
end;

function TODataDecode.GetSelect: string;
begin
  result := TIdURI.URLDecode(FSelect);
end;

function TODataDecode.GetSkip: integer;
begin
  result := FSkip;
end;

function TODataDecode.GetSkipToken: string;
begin
  result := FSkipToken;
end;

function TODataDecode.GetTop: integer;
begin
  result := FTop;
end;

procedure TODataDecode.SetBaseURL(const Value: string);
begin
  FBaseURL := Value;
end;

procedure TODataDecode.Setdebug(const Value: string);
begin
  Fdebug := Value;
end;

procedure TODataDecode.SetExpand(const Value: string);
begin
  FExpand := Value;
end;

procedure TODataDecode.SetFilter(const Value: string);
begin
  FFilter := Value;
end;

procedure TODataDecode.SetFormat(const Value: string);
begin
  FFormat := Value;
end;

procedure TODataDecode.SetGroupBy(const Value: string);
begin
  FGroupBy := Value;
end;

procedure TODataDecode.SetInLineCount(const Value: string);
begin
  FInLineCount := Value;
end;

procedure TODataDecode.SetOrderBy(const Value: string);
begin
  FOrderBy := Value;
end;

procedure TODataDecode.SetResource(const Value: string);
begin
  FResource := Value;
end;

{ procedure TODataDecode.SetResourceParams(const Value: TDictionary<>);
  begin
  FResourceParams := Value;
  end;
}
procedure TODataDecode.SetSearch(const Value: string);
begin
  FSearch := Value;
end;

procedure TODataDecode.SetSelect(const Value: string);
begin
  FSelect := Value;
end;

procedure TODataDecode.SetSkip(const Value: integer);
begin
  FSkip := Value;
end;

procedure TODataDecode.SetSkipToken(const Value: string);
begin
  FSkipToken := Value;
end;

procedure TODataDecode.SetTop(const Value: integer);
begin
  FTop := Value;
end;

function TODataDecode.This: TObject;
begin
  result := self;
end;

{ TODataOperators }

function TODataOperators.open: TODataOperators;
begin
  result.Value := Value + '(';
end;

function TODataOperators.enClose: TODataOperators;
begin
  result.Value := '(' + Value + ')';
end;

function TODataOperators.endsWith(const AField, AValue: string)
  : TODataOperators;
begin
  result.Value := Value + ' endswith(' + AField + ',' + AValue + ')';
end;

function TODataOperators.&or: TODataOperators;
begin
  result.Value := Value + ' or';
end;

function TODataOperators.startsWith(const AField, AValue: string)
  : TODataOperators;
begin
  result.Value := Value + ' startswith(' + AField + ',' + AValue + ')';
end;

function TODataOperators.substringOf(const AValue: string; AField: string)
  : TODataOperators;
begin
  result.Value := Value + ' substringof(' + AValue + ',' + AField + ')';
end;

function TODataOperators.trim(const AValue: string): TODataOperators;
begin
  result.Value := Value + ' trim(' + AValue + ')';
end;

function TODataOperators.year(const AValue: string): TODataOperators;
begin
  result.Value := Value + ' year(' + AValue + ')';
end;

function TODataOperators.&not: TODataOperators;
begin
  result.Value := Value + ' not';
end;

function TODataOperators.add(AString: string): TODataOperators;
begin
  result.Value := Value + ' ' + AString;
end;

function TODataOperators.&and: TODataOperators;
begin
  result.Value := Value + ' and';
end;

function TODataOperators.close: TODataOperators;
begin
  result.Value := Value + ')';
end;

function TODataOperators.day(const AValue: string): TODataOperators;
begin
  result.Value := Value + ' day(' + AValue + ')';
end;

function TODataOperators.equal(const AValue: string): TODataOperators;
begin
  result.Value := Value + ' eq ' + (AValue);
end;

function TODataOperators.greaterOrEqual(const AValue: String): TODataOperators;
begin
  result.Value := Value + ' ge ' + (AValue);
end;

function TODataOperators.greaterThan(const AValue: String): TODataOperators;
begin
  result.Value := Value + ' gt ' + (AValue);
end;

function TODataOperators.length(const AValue: String): TODataOperators;
begin
  result.Value := Value + ' length(' + AValue + ')';
end;

function TODataOperators.lessOrEqual(const AValue: string): TODataOperators;
begin
  result.Value := Value + ' le ' + (AValue);
end;

function TODataOperators.lessthan(const AValue: string): TODataOperators;
begin
  result.Value := Value + ' lt ' + (AValue);
end;

function TODataOperators.month(const AValue: string): TODataOperators;
begin
  result.Value := Value + ' month(' + AValue + ')';
end;

class function TODataOperators.new(const AText: string): TODataOperators;
begin
  result.Value := AText;
end;

function TODataOperators.notequal(const AValue: string): TODataOperators;
begin
  result.Value := Value + ' ne ' + (AValue);
end;

{ TODataError }

class function TODataError.create(cod: integer; mess: string): string;
var
  js: TJsonObject;
  j: TJsonObject;
  jm: TJsonObject;
begin
  js := TJsonObject.create As TJsonObject;
  try
    j := TJsonObject.create;
    j.AddPair('code', cod.ToString);
    jm := TJsonObject.create As TJsonObject;
    jm.AddPair('lang', 'pt_br');
    jm.AddPair('value', mess);
    j.AddPair('message', jm);
    js.AddPair('error', j);

    result := js.ToJSON;
  finally
    js.Free;
  end;
end;

end.
