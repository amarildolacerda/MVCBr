unit MVCBr.ODataDatasetAdapter;

interface

uses System.Classes, System.SysUtils,
  System.JSON, System.Variants,
  System.Generics.Collections, Data.DB,
  MVCBr.IdHTTPRestClient, oData.Comp.Client,
  IdHTTP;

type

  TAdapterResponserType = (pureJSON);

  TODataDatasetAdapter = class(TComponent)
  private
    FJsonValue: TJsonValue;
    FActive: boolean;
    FDataset: TDataset;
    FResponseJSON: TIdHTTPRestClient;
    FRootElement: string;
    FResponseType: TAdapterResponserType;
    FBuilder: TODataBuilder;
    procedure SetDataset(const Value: TDataset);
    procedure SetActive(const Value: boolean);
    procedure SetResponseJSON(const Value: TIdHTTPRestClient);
    procedure SetRootElement(const Value: string);
    function GetActive: boolean;
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;
    procedure SetResponseType(const Value: TAdapterResponserType);
    procedure SetBuilder(const Value: TODataBuilder);

  public
    function Execute: boolean;
    class procedure FillDatasetFromJSONValue(ARootElement: string;
      ADataset: TDataset; AJSON: TJsonValue;
      AResponseType: TAdapterResponserType); virtual;
    class procedure DatasetFromJsonObject(FDataset: TDataset;
      AJSON: TJsonValue);
    procedure CreateDatasetFromJson(AJSON: string);
    class procedure CreateFieldsFromJson(FDataset: TDataset;
      AJSONArray: TJsonValue); static;
    class procedure CreateFieldsFromJsonRow(FDataset: TDataset;
      AJSON: TJsonObject); static;
  published
    property Builder: TODataBuilder read FBuilder write SetBuilder;
    Property Active: boolean read GetActive write SetActive;
    Property Dataset: TDataset read FDataset write SetDataset;
    Property ResponseJSON: TIdHTTPRestClient read FResponseJSON
      write SetResponseJSON;
    Property RootElement: string read FRootElement write SetRootElement;
    Property ResponseType: TAdapterResponserType read FResponseType
      write SetResponseType default pureJSON;
  end;

implementation

uses // FireDac.Comp.Client, FireDac.Comp.Dataset, {Data.FireDACJSONReflect,}
  System.DateUtils, System.Rtti {,REST.Response.Adapter};

{ TIdHTTPDataSetAdapter }

procedure TODataDatasetAdapter.CreateDatasetFromJson(AJSON: string);
begin
  Assert(assigned(FDataset), 'Não atribuiu o Dataset');
  if (AJSON <> '') and (AJSON <> FResponseJSON.Content) then
  begin
    if assigned(FJsonValue) then
      FJsonValue.DisposeOf;
    FJsonValue := nil;
  end;
  if AJSON = '' then
    AJSON := FResponseJSON.Content;
  Assert(AJSON <> '', 'Não há representação JSON para processar');

  if not assigned(FJsonValue) then
    FJsonValue := TJsonObject.ParseJSONValue(AJSON) as TJsonObject;
  Assert(assigned(FJsonValue), 'Não é uma representação JSON válida');
  FillDatasetFromJSONValue(FRootElement, FDataset, FJsonValue, ResponseType);
end;

type
  TJsonTypes = (jtInteger, jtNumber, jtString, jtBoolean, jtDatetime);

class procedure TODataDatasetAdapter.CreateFieldsFromJsonRow(FDataset: TDataset;
  AJSON: TJsonObject);
var
  jv: TJsonPair;
  LFieldName: string;
  v: TValue;
  jtype: TJsonTypes;
begin
  for jv in AJSON do
  begin
    LFieldName := jv.JsonString.Value;
    jtype := jtString;
    case jtype of
      jtInteger:
        FDataset.FieldDefs.Add(LFieldName, ftInteger);
      jtNumber:
        FDataset.FieldDefs.Add(LFieldName, ftFloat);
      jtBoolean:
        FDataset.FieldDefs.Add(LFieldName, ftBoolean);
      jtDatetime:
        FDataset.FieldDefs.Add(LFieldName, ftDateTime);
    else
      FDataset.FieldDefs.Add(LFieldName, ftString, 255);
    end;
  end;
end;

class procedure TODataDatasetAdapter.CreateFieldsFromJson(FDataset: TDataset;
  AJSONArray: TJsonValue);
var
  LJSONValue: TJsonValue;
  ja: TJsonArray;
  jo: TJsonObject;
begin
  AJSONArray.TryGetValue(ja);
  Assert(assigned(ja)); // nao passou um json valido ?

  Assert(ja.Count > 0); // nao tem nenhum linha de dados ?

  LJSONValue := ja.Get(0); // pega a primeira linha do json
  Assert(assigned(LJSONValue));

  jo := TJsonObject.ParseJSONValue(LJSONValue.ToJSON) as TJsonObject;
  CreateFieldsFromJsonRow(FDataset, jo);

end;

class procedure TODataDatasetAdapter.DatasetFromJsonObject(FDataset: TDataset;
  AJSON: TJsonValue);
  procedure AddJSONDataRow(const AJSONValue: TJsonValue);
  var
    LValue: variant;
    LJSONValue: TJsonValue;
    LField: TField;
    i: Integer;
    LPath: string;
    LDateTime: TDateTime;
  begin
    Assert(FDataset <> nil);
    FDataset.Append;
    try
      for i := 0 to FDataset.Fields.Count - 1 do
      begin
        LField := FDataset.Fields[i];
        LPath := lowercase(LField.FieldName);
        if not AJSONValue.TryGetValue<TJsonValue>(LPath, LJSONValue) then
          LJSONValue := nil;
        if (LJSONValue = nil) then
          LValue := System.Variants.Null
        else if (LJSONValue IS TJSONFalse) then
          LValue := false
        else if (LJSONValue IS TJSONTrue) then
          LValue := True
        else if (LJSONValue IS TJSONNull) then
          LValue := System.Variants.Null
        else if (LJSONValue IS TJsonObject) then
          LValue := LJSONValue.ToString
        else if (LJSONValue IS TJsonArray) then
          LValue := LJSONValue.ToString
        else if LJSONValue IS TJSONString then
        begin
          LValue := LJSONValue.Value;
          if LField.DataType = ftDateTime then
          begin
            if TryISO8601ToDate(LJSONValue.Value, LDateTime) then
              LValue := LDateTime
          end
          else if LField.DataType = ftTime then
          begin
            if TryISO8601ToDate(LJSONValue.Value, LDateTime) then
              LValue := TTime(TimeOf(LDateTime))
          end
          else if LField.DataType = ftDate then
          begin
            if TryISO8601ToDate(LJSONValue.Value, LDateTime) then
              LValue := TDate(DateOf(LDateTime));
          end
        end
        else
          LValue := LJSONValue.Value;

        LField.Value := LValue;
      end;
    finally
      FDataset.Post;
    end;
  end;
  procedure AddJSONDataRows(const AJSON: TJsonValue);
  var
    LJSONValue: TJsonValue;
  begin
    if AJSON is TJsonArray then
    begin
      // Multiple rows
      for LJSONValue in TJsonArray(AJSON) do
        AddJSONDataRow(LJSONValue);
    end
    else
      AddJSONDataRow(AJSON);

  end;

  procedure UpdateDataset(AJSON: TJsonValue);
  var
    LContext: TRTTIContext;
    LType: TRTTIType;
    LMethod: TRTTIMethod;
  begin
    Assert(assigned(FDataset));
    Assert(assigned(AJSON));

    if not FDataset.Active then
    begin
      if not FDataset.Active then
      begin
        LType := LContext.GetType(FDataset.ClassType);
        if LType <> nil then
        begin
          LMethod := LType.GetMethod('CreateDataSet');
          if (LMethod <> nil) and (Length(LMethod.GetParameters) = 0) then
            LMethod.Invoke(FDataset, []);
        end;
      end;
      if not FDataset.Active then
        FDataset.Open;
    end;

    AddJSONDataRows(AJSON);
  end;

begin
  FDataset.DisableControls;
  try

    if FDataset.Active then
    begin
{$IFDEF MSWINDOWS}
      FDataset.Close;
{$ENDIF}
{$IFNDEF MSWINDOWS}
      while Dataset.Eof = false do
        Dataset.Delete;
{$ENDIF}
    end;

    if FDataset.FieldDefs.Count = 0 then
      CreateFieldsFromJson(FDataset, AJSON);

    if (FDataset.FieldDefs.Count > 0) and (FDataset.Active = false) then
      FDataset.Open;

    if FDataset.FieldDefs.Count > 0 then
      AddJSONDataRows(AJSON)
    else
      UpdateDataset(AJSON);

    FDataset.first;
  finally
    FDataset.EnableControls;
  end;
end;

function TODataDatasetAdapter.Execute: boolean;
begin
  if assigned(FJsonValue) then
    FJsonValue.DisposeOf;
  FJsonValue := nil;

  result := false;

  if assigned(FBuilder) then
  begin
    result := FBuilder.Execute(
      procedure
      begin
        if assigned(FDataset) then
          CreateDatasetFromJson('');
      end);
  end
  else if assigned(FResponseJSON) then
    result := FResponseJSON.Execute(
      procedure
      begin
        if assigned(FDataset) then
          CreateDatasetFromJson('');
      end);
end;

class procedure TODataDatasetAdapter.FillDatasetFromJSONValue
  (ARootElement: string; ADataset: TDataset; AJSON: TJsonValue;
AResponseType: TAdapterResponserType);
var
{$IFDEF REST}
  Adpter: TCustomJSONDataSetAdapter;
{$ENDIF}
  ji: TJsonPair;
  achei: boolean;
  jo: TJsonObject;
  jv: TJsonArray;

{$IFDEF REST}
  procedure LoadWithReflect(Const AJSON: TJsonObject; achou: Integer);
  var
    LDataSets: TFDJSONDatasets;
    memDs: TFDMemTable;
  begin
    LDataSets := TFDJSONDatasets.create;
    TFDJSONInterceptor.JSONObjectToDataSets(AJSON, LDataSets);

    if ADataset.InheritsFrom(TFDMemTable) then
    begin // é um FdMemTable
      TFDMemTable(ADataset).AppendData
        (TFDJSONDataSetsReader.GetListValue(LDataSets, achou));
    end
    else
    begin
      // cria um MemTable de passagem
      memDs := TFDMemTable.create(nil);
      try
        TFDMemTable(memDs).AppendData
          (TFDJSONDataSetsReader.GetListValue(LDataSets, achou));
        TFDDataset(ADataset).Close;
        TFDDataset(ADataset).CachedUpdates := True;
        TFDDataset(ADataset).Data := memDs.Data;
        TFDDataset(ADataset).CancelUpdates;
      finally
        memDs.DisposeOf;
      end;
    end;

  end;
{$ENDIF}

var
  // achou,i: Integer;
  // _jo: TJsonObject;
  _jv: TJsonValue;
begin

  case AResponseType of
    pureJSON:
      begin
        if AJSON.TryGetValue(ARootElement, _jv) then
        else
          _jv := AJSON;
        DatasetFromJsonObject(ADataset, _jv);
      end;

    (* reflectJSON:
      begin
      {$IFDEF REST}
      Adpter := TCustomJSONDataSetAdapter.create(nil);
      try
      achou := 0;
      i := 0;
      jv := nil;
      jo := AJSON as TJsonObject;
      for ji in jo do
      begin
      if sametext(ji.JsonString.Value, ARootElement) then
      begin
      achou := i;
      AJSON.TryGetValue(ARootElement, jv);
      break;
      end;
      inc(i);
      end;

      if not assigned(jv) then
      AJSON.TryGetValue(jv);
      Adpter.Dataset := ADataset;
      {$IFDEF REST}
      LoadWithReflect(((jv as TJsonValue) as TJsonObject), achou);
      {$ENDIF}
      finally
      Adpter.DisposeOf;
      end;
      {$ENDIF}
      end;
    *) end;
end;

function TODataDatasetAdapter.GetActive: boolean;
begin
  result := FActive;
end;

procedure TODataDatasetAdapter.Notification(AComponent: TComponent;
AOperation: TOperation);
begin
  if (AOperation = TOperation.opRemove) then
  begin
    if AComponent = FResponseJSON then
      FResponseJSON := nil;
    if AComponent = FDataset then
      FDataset := nil;
  end;
  inherited;

end;

procedure TODataDatasetAdapter.SetActive(const Value: boolean);
begin
  FActive := Value;
end;

procedure TODataDatasetAdapter.SetBuilder(const Value: TODataBuilder);
begin
  FBuilder := Value;
  if assigned(FBuilder) then
    if assigned(FBuilder.RestClient) then
      self.ResponseJSON := FBuilder.RestClient;

end;

procedure TODataDatasetAdapter.SetDataset(const Value: TDataset);
begin
  FDataset := Value;
end;

procedure TODataDatasetAdapter.SetResponseJSON(const Value: TIdHTTPRestClient);
begin
  FResponseJSON := Value;
end;

procedure TODataDatasetAdapter.SetResponseType(const Value
  : TAdapterResponserType);
begin
  FResponseType := Value;
end;

procedure TODataDatasetAdapter.SetRootElement(const Value: string);
begin
  FRootElement := Value;
end;

end.
