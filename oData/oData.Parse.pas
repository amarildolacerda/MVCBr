unit oData.Parse;

interface

uses System.Classes, System.SysUtils, System.Generics.collections,
  oData.Engine, oData.Interf;

type

  TTokenKind = (ptNone, ptIdentifier, ptNull, ptSpace, ptComma, ptSlash,
    ptOData, ptOpen, ptClose, ptParams, ptParamsAnd, ptEqual, ptFilter,
    ptSelect, ptOrderBy, ptTop, ptSkip, ptSkipToken, ptExpand, ptInLineCount,
    ptGroupBy, ptOperNe { not equal } , ptOperLt { less than } ,
    ptOperGe { greater or equal } , ptOperGt { greater than } ,
    ptOperAnd { and } , ptOperOr { or } , ptOperNot { not } ,
    ptOperAdd { add } , ptOperSub { subtract } , ptOperMul { multiply } ,
    ptOperDiv { divide } , ptOperMod { find remainder } ,
    ptFuncFloor { floor } , ptFuncCeiling { ceiling } ,
    ptFuncLength { length } , ptFuncTrim { trim } , ptFuncToUpper { toupper } ,
    ptFuncSubstringOf { substringof } , ptFuncToLower { tolower } ,
    ptFuncEndsWith { endswith } , ptFuncStartsWith { startswith } ,
    ptFuncYear { year } , ptFuncMonth { month } , ptFuncDay { day } ,
    ptFuncHour { hour } , ptFuncMinute { minute } , ptFuncSecond { second } ,
    ptOrderByDesc { desc } );

  {
    - add,sub,mul,div,mod -> can use only in $filter   not  $select

  }

  TODataParse = class(TInterfacedObject, IODataParse)
  private
    FUrl: string;
    token: string;
    FParseCol: integer;
    FLevel: integer;
    FOData: IODataDecode;
    FCurrentOData: IODataDecode;

    function isToken(tken: string): boolean;
    procedure NextToken(AClear: boolean = false; AUntil: TTokenKind = ptNone);
    function TestNextToken: string;
    function IsNullToken(AChr: Char): boolean;
    function isTokenType(tk: TTokenKind): boolean;
    function IsNull: boolean;
    function GetToken: string;
    procedure ParseCollectionParams;
    procedure ParseCollections;
    procedure ParseParams;
    procedure SetOData(const Value: TODataDecode);
    function GetOData: IODataDecode;
  public
    constructor create;
    destructor destroy; override;
    property oData: IODataDecode read GetOData; // write SetOData;
    function isTokenIsJunk(const tk: TTokenKind): boolean;
    procedure whileIn(AArry: Array of TTokenKind);
    procedure FindToken(tk: TTokenKind);
  public
    procedure Parse(URL: string); virtual;
    procedure DoCollectionInsert(ACurrent: IODataDecode); virtual;
    function Select: string; virtual;
  end;

implementation

{ TODataParse }

var
  FTokenKindArray: TDictionary<string, TTokenKind>;

function TODataParse.isToken(tken: string): boolean;
begin
  result := FTokenKindArray.ContainsKey(tken);
end;

function TODataParse.isTokenIsJunk(const tk: TTokenKind): boolean;
begin
  result := tk in [ptOData];
end;

function TODataParse.isTokenType(tk: TTokenKind): boolean;
var
  t: TTokenKind;
begin
  result := false;
  if FTokenKindArray.TryGetValue(token, t) then
    result := t = tk
  else
    result := (token <> '') and (tk = ptIdentifier);
end;

constructor TODataParse.create;
begin
  inherited;
  FOData := TODataDecode.create(self);
end;

destructor TODataParse.destroy;
begin
  FOData := nil;
  inherited;
end;

procedure TODataParse.DoCollectionInsert(ACurrent: IODataDecode);
begin

end;

procedure TODataParse.FindToken(tk: TTokenKind);
var
  sToken: string;
  t: TTokenKind;
begin
  sToken := '';
  repeat
    sToken := sToken + FUrl[FParseCol];
    inc(FParseCol);
    if isToken(FUrl[FParseCol]) then
      if FTokenKindArray.TryGetValue(sToken, t) then
        if tk = t then
          break;
    if IsNull then
      break;
  until false;
end;

function TODataParse.GetOData: IODataDecode;
begin
  result := FOData;
end;

function TODataParse.GetToken: string;
begin
  result := token;
  token := '';
end;

function TODataParse.IsNull: boolean;
begin
  result := IsNullToken(FUrl[FParseCol]);
end;

function TODataParse.IsNullToken(AChr: Char): boolean;
begin
  result := AChr = chr(0);
end;

procedure TODataParse.NextToken(AClear: boolean = false;
  AUntil: TTokenKind = ptNone);
var
  tk, tkj: TTokenKind;
  tmp: string;
  b: boolean;
begin
  if AClear then
    token := '';
  repeat
    if IsNullToken(FUrl[FParseCol]) then
      exit;

    if (AUntil <> ptNone) then
      if FTokenKindArray.TryGetValue(FUrl[FParseCol], tkj) then
      begin
        if tkj = AUntil then
          break;
      end;

    b := true;
    if (AUntil <> ptNone) then
    begin
      FTokenKindArray.TryGetValue(tmp, tkj);
      if tkj = AUntil then
        break
      else
      begin
        if tkj <> ptNone then
          tmp := '';
        b := false;
        // continue;
      end;
    end;

    if (FUrl[FParseCol] <> ' ') or (AUntil <> ptNone) then
    begin
      token := token + FUrl[FParseCol];
      tmp := tmp + FUrl[FParseCol];
    end;
    inc(FParseCol);

    if (AUntil = ptNone) then
      if FTokenKindArray.TryGetValue(FUrl[FParseCol], tkj) then
        if tkj in [ptSpace, ptOpen, ptClose, ptComma, ptEqual, ptParamsAnd,
          ptParams] then
          break;

  until isToken(token) and b;

  if not FTokenKindArray.TryGetValue(token, tk) then
  begin
    exit;
  end;

  if tk = ptSlash then
  begin
    if FTokenKindArray.TryGetValue(TestNextToken, tkj) then
    begin
      if isTokenIsJunk(tkj) then
      begin
        NextToken;
      end;
    end;
  end;

  if tk = ptNull then
    exit;

  if isTokenIsJunk(tk) then
  begin
    token := '';
    NextToken;
  end;

end;

procedure TODataParse.ParseCollections;
begin
  GetToken; // clear;
  NextToken;
  FCurrentOData := FOData.GetLevel(FLevel, true);
  FCurrentOData.Resource := GetToken;
  if FCurrentOData.Resource = '' then
    exit;

  FCurrentOData.ResourceParams.clear;
  if not IsNull then
    ParseCollectionParams;
  DoCollectionInsert(FCurrentOData);
  if IsNull then
    exit;
  if isTokenType(ptParams) then
  begin
    ParseParams;
    exit;
  end;
  inc(FLevel);
  ParseCollections;
end;

procedure TODataParse.ParseParams;
var
  s, k: string;
  tk: TTokenKind;
begin
  NextToken(true);
  s := GetToken;
  NextToken(true);
  if isTokenType(ptEqual) then
  begin
    NextToken(true, ptParamsAnd);
    k := GetToken;
    if FTokenKindArray.TryGetValue(s, tk) then
    begin
      case tk of
        ptGroupBy:
          oData.GroupBy := k;
        ptSelect:
          oData.Select := k;
        ptFilter:
          oData.Filter := k;
        ptOrderBy:
          oData.OrderBy := k;
        ptTop:
          oData.top := strtoIntDef(k, 0);
        ptSkip:
          oData.Skip := strtoIntDef(k, 0);
        ptSkipToken:
          oData.SkipToken := k;
        ptInLineCount:
          oData.InLineCount := k;
        ptExpand:
          oData.Expand := k;
      end;
    end;

    // FOData.ResourceParams.AddPair(s, k); // QueryParams.Add(s, k);
  end;
  NextToken(true);
  if IsNull then
    exit;
  if isTokenType(ptParamsAnd) then
  begin
    ParseParams;
  end;
end;

function TODataParse.Select: string;
begin
  result := oData.Select;
end;

procedure TODataParse.SetOData(const Value: TODataDecode);
begin
  FOData := Value;
end;

procedure TODataParse.Parse(URL: string);
begin
  FLevel := 0;
  FUrl := URL + chr(0);
  FParseCol := 1;
  ParseCollections;
  if isTokenType(ptParams) then
    ParseParams;
end;

procedure TODataParse.ParseCollectionParams;
var
  s: String;
  i: integer;
begin
  whileIn([ptSpace]);
  NextToken;
  i := 0;
  if isTokenType(ptOpen) then
  begin
    repeat
      if IsNull then
        break;
      inc(i);
      GetToken; // clear;
      whileIn([ptSpace]);
      NextToken;
      if isTokenType(ptClose) then
        break;
      s := GetToken;
      FCurrentOData.ResourceParams.AddPair('P' + IntToStr(i), s);
      whileIn([ptSpace, ptComma]);
      if isTokenType(ptComma) then
        continue;
    until isTokenType(ptClose);
    if isTokenType(ptClose) then
      NextToken(true);
  end;
end;

function TODataParse.TestNextToken: string;
var
  i: integer;
begin
  result := token;
  i := FParseCol;
  repeat
    if IsNullToken(FUrl[i]) then
      break;
    result := result + FUrl[i];
    inc(i);
  until isToken(result);
end;

procedure TODataParse.whileIn(AArry: array of TTokenKind);
var
  t: string;
  tk: TTokenKind;
  tmp: TTokenKind;
  b: boolean;
begin
  repeat
    t := t + FUrl[FParseCol];
    b := false;
    if FTokenKindArray.TryGetValue(t, tk) then
      for tmp in AArry do
      begin
        if (tk = tmp) then
        begin
          b := true;
          break;
        end;
      end;
    if not b then
      exit;
    inc(FParseCol);
  until isToken(t);
end;

initialization

FTokenKindArray := TDictionary<string, TTokenKind>.create;
FTokenKindArray.Add(',', ptComma);
FTokenKindArray.Add(chr(0), ptNull);
FTokenKindArray.Add('/', ptSlash);
FTokenKindArray.Add('/OData/', ptOData);
FTokenKindArray.Add('OData.svc/', ptOData);
FTokenKindArray.Add('(', ptOpen);
FTokenKindArray.Add(')', ptClose);
FTokenKindArray.Add(' ', ptSpace);
FTokenKindArray.Add('?', ptParams);
FTokenKindArray.Add('&', ptParamsAnd);
FTokenKindArray.Add('=', ptEqual);
FTokenKindArray.Add('$filter', ptFilter);
FTokenKindArray.Add('$select', ptSelect);
FTokenKindArray.Add('$orderby', ptOrderBy);
FTokenKindArray.Add('$top', ptTop);
FTokenKindArray.Add('$skip', ptSkip);
FTokenKindArray.Add('$skiptoken', ptSkipToken);
FTokenKindArray.Add('$inlinecount', ptInLineCount);
FTokenKindArray.Add('$expand', ptExpand);
FTokenKindArray.Add('groupby', ptGroupBy);

finalization

FTokenKindArray.free;

end.
