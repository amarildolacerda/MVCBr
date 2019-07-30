{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.Parse;

interface

uses System.Classes, System.SysUtils, System.Generics.collections,
  oData.Engine, oData.Interf;

type

  TTokenKind = (ptNone, ptIdentifier, ptNull, ptQuotation, ptSpace, ptComma,
    ptSlash, ptOData, ptOpen, ptClose, ptParams, ptParamsAnd, ptEqual, ptFilter,
    ptFind, ptSearch, ptSelect, ptOrderBy, ptTop, ptSkip, ptSkipToken, ptExpand,
    ptInLineCount, ptDebug, ptCount, ptGroupBy, ptOperNe { not equal } ,
    ptOperLt { less than } , ptOperLe { less equal } ,
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
  TSetTokenKind = set of TTokenKind;

  TODataParse = class(TOwnedInterfacedObject, IODataParse)
  private
    FUrl: string;
    token: string;
    FParseCol: integer;
    FLevel: integer;
    FOData: TODataDecodeAbstract;
    FCurrentOData: TODataDecodeAbstract;
    FTokenKindArray: TDictionary<string, TTokenKind>;
    function isToken(tken: string): boolean;
    procedure NextToken(AClear: boolean = false;
      AUntil: TSetTokenKind = [ptNone]);
    function TestNextToken: string;
    function toToken(txt: string): TTokenKind; virtual;
    function IsNullToken(AChr: Char): boolean;
    function isTokenType(tk: TTokenKind): boolean;
    function IsNull: boolean;
    function GetToken: string;
    procedure ParseCollectionParams;
    procedure ParseCollections;
    procedure ParseParams;
    procedure ParseExpand(const ATexto: string);
    procedure NextExpand;
    procedure SetOData(const Value: TODataDecode);
    function GetOData: TODataDecodeAbstract;
    function GetNextToken: string;
  public
    constructor create;
    destructor destroy; override;
    procedure Release;

    property oData: TODataDecodeAbstract read GetOData; // write SetOData;
    function isTokenIsJunk(const tk: TTokenKind): boolean;
    procedure whileIn(AArry: Array of TTokenKind);
    procedure FindToken(tk: TTokenKind);
  public
    function this: TObject;
    procedure ParseURL(URL: string); virtual;
    procedure ParseURLParams(prms: string); virtual;
    procedure DoCollectionInsert(ACurrent: IODataDecode); virtual;
    function Select: string; virtual;
    class function OperatorToString(txt: String): string;
  end;

implementation

uses System.NetEncoding;

{ TODataParse }


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
  FTokenKindArray.Add('<=', ptOperLe);
  FTokenKindArray.Add('<', ptOperLt);
  FTokenKindArray.Add('<>', ptOperNe);
  FTokenKindArray.Add('>', ptOperGt);
  FTokenKindArray.Add('>=', ptOperGe);
  FTokenKindArray.Add('eq', ptEqual);
  FTokenKindArray.Add('le', ptOperLe);
  FTokenKindArray.Add('lt', ptOperLt);
  FTokenKindArray.Add('ne', ptOperNe);
  FTokenKindArray.Add('gt', ptOperGt);
  FTokenKindArray.Add('ge', ptOperGe);
  FTokenKindArray.Add('$filter', ptFilter);
  FTokenKindArray.Add('find', ptFind); // comando literal
  FTokenKindArray.Add('$search', ptSearch);
  FTokenKindArray.Add('$select', ptSelect);
  FTokenKindArray.Add('$orderby', ptOrderBy);
  FTokenKindArray.Add('$order', ptOrderBy);
  FTokenKindArray.Add('$top', ptTop);
  FTokenKindArray.Add('$skip', ptSkip);
  FTokenKindArray.Add('$skiptoken', ptSkipToken);
  FTokenKindArray.Add('$inlinecount', ptInLineCount);
  FTokenKindArray.Add('$count', ptCount);
  FTokenKindArray.Add('$expand', ptExpand);
  FTokenKindArray.Add('group', ptGroupBy);
  FTokenKindArray.Add('groupby', ptGroupBy);
  FTokenKindArray.Add('$group', ptGroupBy);
  FTokenKindArray.Add('debug', ptDebug);
  FTokenKindArray.Add('''', ptQuotation);
  FTokenKindArray.Add('and', ptOperAnd);
  FTokenKindArray.Add('or', ptOperOr);

end;

destructor TODataParse.destroy;
begin
  if assigned(FOData) then
    FOData.free;
  FOData := nil;
  if assigned(FCurrentOData) then
    FCurrentOData.free;
  FCurrentOData := nil;
  inherited;
  FTokenKindArray.Free;
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

function TODataParse.GetOData: TODataDecodeAbstract;
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

procedure TODataParse.NextExpand;
var
  LLevel: integer;
  procedure ExpandParams(oData: TODataDecodeAbstract);
  var
    s: string;
    p: integer;
  begin
    p := 0;
    repeat
      NextToken(true);
      if isTokenType(ptClose) then
        break;
      if IsNull then
        exit;
      s := GetToken;
      if (toToken(TestNextToken) = ptClose) and (p = 0) then
      begin
        inc(p);
        TODataDecode(oData).ResourceParams.AddPair('__P' + intToStr(p), s);
      end;

      if (toToken(s) = ptFilter) then
      begin
        NextToken(true);
        NextToken(true, [ptClose, ptComma]);
        s := GetToken;
        oData.Filter := s;
        continue;
      end;

      if (toToken(s) = ptFind) then
      begin
        NextToken(true);
        NextToken(true, [ptClose, ptComma]);
        s := GetToken;
        oData.Find := s;
        continue;
      end;

      if (toToken(s) = ptSelect) then
      begin
        NextToken(true);
        NextToken(true, [ptClose, ptOperAnd]);
        s := GetToken;
        oData.Select := s;
        continue;
      end;

    until false;
  end;

var
  s: string;
  procedure NextExpandItem(rstAbst: TODataDecodeAbstract);
  begin
    NextToken(true);
    s := GetToken;
    if s = '' then
      exit;

    if toToken(s) = ptComma then
      dec(LLevel) // virgula... novo item de mesmo nivel
    else if toToken(s) = ptSlash then
      inc(LLevel); // se for uma barra, crim um sub-item

    if toToken(s) in [ptComma, ptSlash] then
    begin
      NextToken(true);
      s := GetToken;
    end;

    if s <> '' then
    begin
      if (LLevel <= 0) or (not assigned(rstAbst)) then
      begin
        rstAbst := oData.newExpand(s);
        LLevel := 0;
      end
      else
      begin
        rstAbst := TODataDecode(rstAbst).newExpand(s);
      end;
    end;

    if isTokenType(ptNull) then
      exit;
    NextToken;
    if isTokenType(ptOpen) then
      ExpandParams(rstAbst);
    if IsNull then
      exit;
    inc(LLevel);
    NextExpandItem(rstAbst);
  end;

begin
  LLevel := 0;
  NextExpandItem(nil);

end;

procedure TODataParse.NextToken(AClear: boolean = false;
  AUntil: TSetTokenKind = [ptNone]);
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

    if (AUntil <> [ptNone]) then
      if FTokenKindArray.TryGetValue(FUrl[FParseCol], tkj) then
      begin
        if tkj in AUntil then
          break;
      end;

    b := true;
    if (AUntil <> [ptNone]) then
    begin
      FTokenKindArray.TryGetValue(tmp, tkj);
      if tkj in AUntil then
        break
      else
      begin
        if tkj <> ptNone then
          tmp := '';
        b := false;
        // continue;
      end;
    end;

    if (FUrl[FParseCol] <> ' ') or (AUntil <> [ptNone]) then
    begin
      token := token + FUrl[FParseCol];
      tmp := tmp + FUrl[FParseCol];
    end;
    inc(FParseCol);

    if (AUntil = [ptNone]) then
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

  if tk = ptOData then
  begin
    NextToken(true, [ptSlash]);
  end;

  if isTokenIsJunk(tk) then
  begin
    token := '';
    NextToken;
  end;

end;

class function TODataParse.OperatorToString(txt: String): string;
begin
  result := '';
  if txt = '' then
    exit;

  result := stringReplace(txt, ' lt ', ' < ', [rfReplaceAll]);
  result := stringReplace(result, ' ne ', ' <> ', [rfReplaceAll]);
  result := stringReplace(result, ' gt ', ' > ', [rfReplaceAll]);
  result := stringReplace(result, ' ge ', ' >= ', [rfReplaceAll]);
  result := stringReplace(result, ' le ', ' <= ', [rfReplaceAll]);
  result := stringReplace(result, ' eq ', ' = ', [rfReplaceAll]);
  result := stringReplace(result, ' mul ', ' * ', [rfReplaceAll]);
  result := stringReplace(result, ' div ', ' / ', [rfReplaceAll]);
  result := stringReplace(result, ' sub ', ' - ', [rfReplaceAll]);
  result := stringReplace(result, ' add ', ' + ', [rfReplaceAll]);
end;

procedure TODataParse.ParseCollections;
var
  rt: string;
begin
  GetToken; // clear;
  NextToken;
  FCurrentOData := TODataDecode(FOData).GetLevel(FLevel, true);
  rt := GetToken;
  if rt = '/' then
  begin
    NextToken(true, [ptSlash, ptOpen, ptParams]);
    rt := GetToken;
  end;
  FCurrentOData.Resource := rt;
  if FCurrentOData.Resource = '' then
    exit;

  FCurrentOData.ResourceParams.clear;
  if not IsNull then
    ParseCollectionParams;
  // DoCollectionInsert(FCurrentOData);
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

procedure TODataParse.ParseExpand(const ATexto: string);
var
  LOldUrl: string;
  LOldCol: integer;
begin
  LOldUrl := FUrl;
  LOldCol := FParseCol;
  try
    FUrl := ATexto + chr(0);
    FParseCol := 1;
    NextExpand;
  finally
    FUrl := LOldUrl;
    FParseCol := LOldCol;
  end;
end;

procedure TODataParse.ParseURLParams(prms: string);
begin
  if prms = '' then
    exit;

  with TURLEncoding.create do
    try
      prms := Decode(prms);
    finally
      free;
    end;

  FUrl := prms + chr(0);
  FParseCol := 1;

  // if isTokenType(ptParams) then
  ParseParams;

  if FOData.Expand <> '' then
    ParseExpand(FOData.Expand);

end;

procedure TODataParse.ParseParams;
var
  s, k: string;
  tk: TTokenKind;
begin
  NextToken(true);
  s := GetToken;

  if FTokenKindArray.TryGetValue(s, tk) then
    case tk of
      ptCount:
        oData.inLineCount := 'true';
    end;

  NextToken(true);
  if isTokenType(ptEqual) then
  begin
    NextToken(true, [ptParamsAnd]);
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
        ptFind:
          oData.Find := k;
        ptSearch:
          oData.Search := k;
        ptOrderBy:
          oData.OrderBy := k;
        ptTop:
          oData.top := strtoIntDef(k, 0);
        ptSkip:
          oData.Skip := strtoIntDef(k, 0);
        ptSkipToken:
          oData.SkipToken := k;
        ptInLineCount:
          if sametext(k, 'allpages') then
            oData.inLineCount := 'true';
        ptCount:
          if sametext(k, 'true') then
            oData.inLineCount := 'true'; // compatibilidade versão V2 com V4
        ptExpand:
          oData.Expand := k;
        ptDebug:
          oData.Debug := k;
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

procedure TODataParse.Release;
begin
  FCurrentOData := nil;
  DisposeOf();
end;

function TODataParse.Select: string;
begin
  result := oData.Select;
end;

procedure TODataParse.SetOData(const Value: TODataDecode);
begin
  FOData := Value;
end;

procedure TODataParse.ParseURL(URL: string);
begin
  FLevel := 0;
  FUrl := URL.Substring(16) + chr(0);
  FParseCol := 1;
  ParseCollections;
end;

function TODataParse.GetNextToken: string;
var
  old: integer;
  oldtoken: string;
begin
  old := FParseCol;
  oldtoken := token;
  try
    NextToken(true);
    result := token;
  finally
    FParseCol := old;
    token := oldtoken;
  end;
end;

procedure TODataParse.ParseCollectionParams;
var
  s: String;
  i: integer;
  nome, AOperator: string;
  AOperatorLink: string;
  isQuotation: boolean;
  LLevel: integer;
  LLevelClose: integer;
LABEL Loop1;
begin
  whileIn([ptSpace]);
  NextToken;

  i := 0;
  LLevel := 0;
  LLevelClose := 0;

Loop1:
  if isTokenType(ptOpen) then
  begin
    inc(LLevelClose);
    repeat
      AOperatorLink := '';
      isQuotation := false;
      if IsNull then
        break;
      inc(i);
      GetToken; // clear;
      whileIn([ptSpace]);
      NextToken;
      nome := '__P' + intToStr(i);
      AOperator := '=';

      if toToken(token) = ptQuotation then
      begin
        isQuotation := true;
        NextToken(true, [ptQuotation]);
      end;

      if FCurrentOData.ResourceParams.Count > 0 then
      begin

        if toToken(token) in [ptComma, ptOperAnd, ptOperOr] then
        begin
          if toToken(token) in [ptComma] then
            AOperatorLink := ' and '
          else
          begin
            NextToken;
            AOperatorLink := ' ' + GetToken + ' ';
          end;
          NextToken;
        end;
      end;

      if isTokenType(ptOpen) then
        goto Loop1;

      if isTokenType(ptClose) then
      begin
        dec(LLevelClose);
        if LLevelClose <= 0 then
          break
      end;

      if toToken(GetNextToken) in [ptEqual, ptOperNe, ptOperLt, ptOperGe,
        ptOperGt, ptOperLe] then
      begin
        nome := GetToken;
        NextToken;
        AOperator := OperatorToString(' ' + GetToken + ' '); // clear;
        NextToken;
        if isTokenType(ptQuotation) then
        begin
          isQuotation := true;
          NextToken(true, [ptQuotation]);
        end;
      end;

      inc(LLevel);

      s := GetToken;
      if isQuotation then
        s := QuotedStr(s);

      FCurrentOData.ResourceParams.AddPair(nome, s);
      FCurrentOData.ResourceParams.AddOperatorLink(AOperatorLink);
      FCurrentOData.ResourceParams.AddOperator(AOperator);
      whileIn([ptSpace, ptComma, ptQuotation]);
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

function TODataParse.this: TObject;
begin
  result := self;
end;

function TODataParse.toToken(txt: string): TTokenKind;
begin
  FTokenKindArray.TryGetValue(txt, result);
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


finalization



end.
