unit uDbBaseClass;

interface

uses
  Data.DB,
  sysutils,
  System.Variants,
  Data.SqlExpr,
  Spring.Container,
  uBasicFieldsClass,
  System.ZLib,System.Classes;

type
  TdbBase = class(TInterfacedObject)
  private

    FQuery: TSQLQuery;
    FTableName: string;
    function GetDBConnection: TSQLConnection;
    procedure SetDBConnection(const Value: TSQLConnection);
    function GetQuery: TSQLQuery;
  public
    FDBConnection: TSQLConnection;
    constructor Create(Connection: TSQLConnection; sTableName: string);
    destructor Destroy; override;

    function GetInsertString(oInstance : TBasicFieldsClass; AttributeFilter : string = ''; UID : Integer = -1) :  string;
    function GetDInsertString(oInstance : TBasicFieldsClass; AttributeFilter : string = '') :  string;
    function GetUpdateString(oInstance : TBasicFieldsClass; UID : Integer; AttributeFilter : string = '') : string;
    function GetDeleteString(UID : Integer) : string;
    function GetLastInsertID: Integer;

    function GetQueryMaster(QueryComment: String; ParamNames,
    ParamValues: array of string;QuoteParamValues: Boolean = True) : string;

    function GetReportQuery(ReportName: String; ParamNames,
    ParamValues: array of string;QuoteParamValues: Boolean = True) : string;

    function ReplaceParams(OrgString : string;ParamNames, ParamValues: array of Variant; IsQuote : Boolean = False) : string;

    function GetFieldVal(SearchTable: String; SearchField: String;
    SearchValue: String; ReturnField: String; DefaultRetValue: Variant;
    ExactMatch: Boolean; ANDCondition: String = ''): Variant;

    function SQLDate(DateTime: TDateTime; WithQuotes: Boolean = False;
    WithTime: Boolean = False): String;

    function GetModBy(SessionID : string): Integer;
    function GetSessionVal(SessionID, SParam : string): string;
    function ZCompressString(aText: string; aCompressionLevel: TZCompressionLevel): string;

    property DBConnection: TSQLConnection read GetDBConnection write SetDBConnection;
    property Query: TSQLQuery read GetQuery ;
    property TableName: string read FTableName write FTableName;
  end;


implementation

uses
  system.rtti,REST.Json,System.JSON;
{ TBaseDB }

constructor TdbBase.Create(Connection: TSQLConnection; sTableName: string);
begin
  FDBConnection := Connection;
  FTableName := sTableName;
  FQuery := TSQLQuery.Create(nil);
  FQuery.SQLConnection := FDBConnection;
end;

destructor TdbBase.Destroy;
begin
  FQuery.Free;
  inherited;
end;

function TdbBase.GetDBConnection: TSQLConnection;
begin
  Result := FDBConnection;
end;

function TdbBase.GetDeleteString(UID: Integer): string;
var
  I               : Integer;
  DeletedValue    ,
  DeletedRecord   : string;
begin
  Query.Active := False;
  Query.SQL.Text := 'select * from '+FTableName+' where UID = '+UID.ToString;
  Query.Open;

  for I := 0 to Query.FieldCount - 1 do
  begin
   DeletedValue := DeletedValue + Query.Fields[I].FieldName +': '+ VarToStr(Query.Fields[I].Value);
   DeletedValue := DeletedValue + ', ';
  end;
  DeletedRecord := DeletedValue;
  DeletedValue := '';

  if FTableName <> 'trnListings' then
  begin
    Query.Close;
    Query.SQL.Text := 'insert into trndeletedrecinfo(Tablename,DeletedUID,Remarks) values('+QuotedStr(TableName)+','+UID.ToString+','+QuotedStr(DeletedRecord)+')';
    Query.ExecSQL;
  end;

  Result := ' delete from ' + FTableName + ' where UID = ' + UID.ToString;
end;

function TdbBase.GetDInsertString(oInstance: TBasicFieldsClass;
  AttributeFilter: string): string;
var
  ctx       : TRttiContext;
  t         : TRttiType;
  p         : TRttiProperty;
  a         : TCustomAttribute;
  Fields    : string;
  Values    : string;
begin
  ctx := TRttiContext.Create;
  try
    t := ctx.GetType(oInstance.ClassType);
    for p in t.GetProperties do
    begin
      for a in p.GetAttributes do
      begin
        if a is TFunctionalityAttribute then
          if Pos(AttributeFilter, TFunctionalityAttribute(a).FunctionalityName) <= 0 then
            Break;

        if a is TDatabaseFieldAttribute then
        begin
          Fields := Fields + TDatabaseFieldAttribute(a).FieldName + ',';
          case TDatabaseFieldAttribute(a).FieldType of
            ftString:
              Values := Values + QuotedStr(p.GetValue(oInstance).ToString) + ',';
            ftDateTime:
              Values := Values + QuotedStr(FormatDateTime('yyyy-MM-dd hh:mm:ss', StrToDateTime(p.GetValue(oInstance).ToString))) + ',';
          else
              Values := Values + p.GetValue(oInstance).ToString + ',';
          end;
        end;
      end;
    end;
  finally
    Fields := Fields.Remove(Fields.Length-1, 1);
    Values := Values.Remove(Values.Length-1, 1);
    ctx.Free;
  end;

  Result := ' insert into ' + TableName + '(' + Fields + ')' + ' values ('+Values+')';
end;

function TdbBase.GetFieldVal(SearchTable, SearchField, SearchValue,
  ReturnField: String; DefaultRetValue: Variant; ExactMatch: Boolean;
  ANDCondition: String): Variant;
var
  ForExactMatch1     : String;
  ForExactMatch2     : String;
begin
  if ExactMatch then
  begin
    ForExactMatch1 := ' = ';
    ForExactMatch2 := '';
  end
  else
  begin
    ForExactMatch1 := ' like ';
    ForExactMatch2 := '%';
  end;

  Query.Close;
  Query.SQL.Text :=' select distinct ' + ReturnField + ' from ' + SearchTable +
  ' where ' + SearchField + ForExactMatch1 + QuotedStr(SearchValue + ForExactMatch2) + ANDCondition;
  Query.Open;

  if Query.FieldByName(ReturnField).Value <> Null then
    Result := Query.FieldByName(ReturnField).Value
  else
    Result := DefaultRetValue;
end;

function TdbBase.GetInsertString(oInstance: TBasicFieldsClass; AttributeFilter : string; UID : Integer): string;
var
  ctx       : TRttiContext;
  t         : TRttiType;
  p         : TRttiProperty;
  a         : TCustomAttribute;
  Fields    : string;
  Values    : string;
begin
  ctx := TRttiContext.Create;
  try
    t := ctx.GetType(oInstance.ClassType);
    for p in t.GetProperties do
    begin
      for a in p.GetAttributes do
      begin
        if a is TFunctionalityAttribute then
          if Pos(AttributeFilter, TFunctionalityAttribute(a).FunctionalityName) <= 0 then
            Break;

        if a is TDatabaseFieldAttribute then
        begin
          if Pos('"'+LowerCase(TDatabaseFieldAttribute(a).FieldName)+'":',LowerCase(oInstance.JsonString)) > 0 then
          begin
            Fields := Fields + TDatabaseFieldAttribute(a).FieldName + ',';
            case TDatabaseFieldAttribute(a).FieldType of
              ftString:
                Values := Values + QuotedStr(p.GetValue(oInstance).ToString) + ',';
              ftDateTime:
                Values := Values + QuotedStr(FormatDateTime('yyyy-MM-dd hh:mm:ss', StrToDateTime(p.GetValue(oInstance).ToString))) + ',';
            else
                Values := Values + p.GetValue(oInstance).ToString + ',';
            end;
          end;
        end;
      end;
    end;
  finally
    Fields := Fields.Remove(Fields.Length-1, 1);
    Values := Values.Remove(Values.Length-1, 1);

    //Incase If UID needs tobe put manually. (Required for marketplace)
    if UID > 0 then
    begin
      Fields := Fields + ',UID';
      Values := Values + ','+UID.ToString;
    end;

    ctx.Free;
  end;

  Result := ' insert into ' + TableName + '(' + Fields + ')' + ' values ('+Values+')';
end;

function TdbBase.GetLastInsertID: Integer;
begin
  Query.SQL.Text := 'select max(UID) LastUID from ' + FTableName;
  Query.Open;
  Result := Query.FieldByName('LastUID').AsInteger; // query passed and UID returned
end;

function TdbBase.GetModBy(SessionID : string): Integer;
begin
end;

function TdbBase.GetQuery: TSQLQuery;
begin
  Result := FQuery;
end;

function TdbBase.GetQueryMaster(QueryComment: String; ParamNames,
  ParamValues: array of string;QuoteParamValues: Boolean = True): string;
var
  S         : String;
  I         : Integer;
begin
  Query.Close;
  Query.SQL.Text := 'select QueryStatement from mstQueries where QueryComment = ' + QuotedStr(QueryComment);
  Query.Open;
  S := Query.FieldByName('QueryStatement').AsString;

  for I := 0 to High(ParamNames) do
    if QuoteParamValues then
      S := StringReplace(S, ParamNames[I], QuotedStr(ParamValues[I]), [rfIgnoreCase, rfReplaceAll])
    else
      S := StringReplace(S, ParamNames[I], ParamValues[I], [rfIgnoreCase, rfReplaceAll]);

  Result := S;
end;

function TdbBase.GetReportQuery(ReportName: String; ParamNames,
  ParamValues: array of string; QuoteParamValues: Boolean): string;
var
  S         : String;
  I         : Integer;
begin
  Query.Close;
  Query.SQL.Text := 'select ReportQuery from mstReportQueries where ReportName = ' + QuotedStr(ReportName);
  Query.Open;
  S := Query.FieldByName('ReportQuery').AsString;

  for I := 0 to High(ParamNames) do
    if QuoteParamValues then
      S := StringReplace(S, ParamNames[I], QuotedStr(ParamValues[I]), [rfIgnoreCase, rfReplaceAll])
    else
      S := StringReplace(S, ParamNames[I], ParamValues[I], [rfIgnoreCase, rfReplaceAll]);

  Result := S;
end;

function TdbBase.GetSessionVal(SessionID, SParam: string): string;
begin
end;

function TdbBase.GetUpdateString(oInstance: TBasicFieldsClass; UID : Integer; AttributeFilter : string): string;
var
  ctx           : TRttiContext;
  t             : TRttiType;
  p             : TRttiProperty;
  a             : TCustomAttribute;
  Value         : string;
  UpdateString  : string;
begin
  ctx := TRttiContext.Create;
  try
    t := ctx.GetType(oInstance.ClassType);
    for p in t.GetProperties do
    begin
      for a in p.GetAttributes do
      begin
        if a is TFunctionalityAttribute then
          if Pos(AttributeFilter, TFunctionalityAttribute(a).FunctionalityName) <= 0 then
            Break;

        if a is TDatabaseFieldAttribute then
        begin
          case TDatabaseFieldAttribute(a).FieldType of
            ftDateTime:
              Value := QuotedStr(FormatDateTime('yyyy-MM-dd hh:mm:ss', StrToDateTime(p.GetValue(oInstance).ToString))) + ',';
            ftTime:
              Value := QuotedStr(FormatDateTime('hh:mm', StrToTime(p.GetValue(oInstance).ToString))) + ',';
            ftString:
              Value := QuotedStr(p.GetValue(oInstance).ToString) + ',';
          else
            Value := p.GetValue(oInstance).ToString + ',';
          end;

          if Pos('"'+LowerCase(TDatabaseFieldAttribute(a).FieldName)+'":',LowerCase(oInstance.JsonString)) > 0 then
            UpdateString := UpdateString + TDatabaseFieldAttribute(a).FieldName+' = '+ Value
        end;
      end;
    end;
  finally
    UpdateString := UpdateString.Remove(UpdateString.Length-1, 1);
    ctx.Free;
  end;

  Result := ' update ' + FTableName + ' set ' +UpdateString+ ' where UID = ' + UID.ToString;
end;

function TdbBase.ReplaceParams(OrgString : string; ParamNames,
  ParamValues: array of Variant; IsQuote : Boolean): string;
var
  I         : Integer;
begin
  for I := 0 to High(ParamNames) do
  begin
    if IsQuote =  True then
      OrgString := StringReplace(OrgString, ParamNames[I], QuotedStr(ParamValues[I]), [rfIgnoreCase, rfReplaceAll])
    else
      OrgString := StringReplace(OrgString, ParamNames[I], ParamValues[I], [rfIgnoreCase, rfReplaceAll]);
  end;


  Result := OrgString;
end;

procedure TdbBase.SetDBConnection(const Value: TSQLConnection);
begin
  FDBConnection := Value;
end;

function TdbBase.SQLDate(DateTime: TDateTime; WithQuotes,
  WithTime: Boolean): String;
begin
  if DateTime > 0 then
  begin
    if WithTime then
      Result := FormatDateTime('yyyy-mm-dd hh:mm:ss', DateTime)
    else
      Result := FormatDateTime('yyyy-mm-dd', DateTime);
  end
  else
    Result := '1899-12-31 00:00:00';

  if WithQuotes then
    Result := QuotedStr(Result);
end;

function TdbBase.ZCompressString(aText: string;
  aCompressionLevel: TZCompressionLevel): string;
var
  strInput,
  strOutput: TStringStream;
  Zipper: TZCompressionStream;
begin
  Result:= '';
  strInput:= TStringStream.Create(aText);
  strOutput:= TStringStream.Create;
  try
    Zipper:= TZCompressionStream.Create(strOutput);
    try
      Zipper.CopyFrom(strInput, strInput.Size);
    finally
      Zipper.Free;
    end;
    Result:= strOutput.DataString;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

end.
