{ *************************************************************************** }
{ }
{ Projeto MVCBr }
{ Coder: Amarildo Lacerda }
{ }
{ *************************************************************************** }
{ }
{ Licensed under the Apache License, Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. }
{ You may obtain a copy of the License at }
{ }
{ http://www.apache.org/licenses/LICENSE-2.0 }
{ }
{ Unless required by applicable law or agreed to in writing, software }
{ distributed under the License is distributed on an "AS IS" BASIS, }
{ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{ See the License for the specific language governing permissions and }
{ limitations under the License. }
{ }
{ *************************************************************************** }
{
  Objetivo: base para popular um dataset
}
{ *************************************************************************** }
{
  Alterações:
  16/04/2017 - por amarildo lacerda
  . = altera link de TODataBuilder para TODataCustomBuilder
  . + criar parametros  Params
  . + evento OnGetParams
}

unit MVCBr.ODataDatasetAdapter;

interface

uses System.Classes, System.SysUtils,
  System.JSON, System.Variants,
  System.Generics.Collections, Data.DB,
  MVCBr.IdHTTPRestClient, oData.Comp.Client,
  MVCBr.Common,
  IdHTTP;

type

  TAdapterResponserType = (pureJSON);
  TODataGetResourceParams = procedure(sender: TObject; var AResource: string) of object;

  TODataDatasetAdapter = class(TComponent)
  private
    FOrigemFieldNameList: TStringList;
    FChanges: TJsonArray;
    FJsonValue: TJsonValue;
    FDataset: TDataset;
    FResponseJSON: TIdHTTPRestClient;
    FRootElement: string;
    FResponseType: TAdapterResponserType;
    FBuilder: TODataCustomBuilder;
    FOnBeforeApplyUpdate, FOnAfterApplyUpdate: TNotifyEvent;
    FBeforeOpenDelegate: TProc<TDataset>;
    FOnGetParams: TODataGetResourceParams;
    FParams: TParams;
    procedure SetDataset(const Value: TDataset);
    procedure SetActive(const Value: boolean);
    procedure SetResponseJSON(const Value: TIdHTTPRestClient);
    procedure SetRootElement(const Value: string);
    function GetActive: boolean;
    procedure SetResponseType(const Value: TAdapterResponserType);
    procedure SetBuilder(const Value: TODataCustomBuilder);
    procedure SetOnBeforeApplyUpdate(const Value: TNotifyEvent);
    procedure SetOnAfterApplyUpdate(const Value: TNotifyEvent);
    class procedure CreateFieldByProperties(FDataset: TDataset; AJSONProp: TJsonValue; FFieldList: TStrings);
    procedure SetOnGetParams(const Value: TODataGetResourceParams);
    procedure SetParams(const Value: TParams);

  protected
    FResourceKeys: string;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;

  public
    constructor create(AOwner: TComponent); override;
    destructor destroy; override;
    function Execute: boolean;
    procedure DoGetParams(var AURI: string); virtual;
    class procedure FillDatasetFromJSONValue(ARootElement: string; ADataset: TDataset; AJSON: TJsonValue; AResponseType: TAdapterResponserType;
      ADelegate: TProc<TDataset>; FFieldList: TStrings; AKeys: String); virtual;
    class procedure DatasetFromJsonObject(FDataset: TDataset; AJSON: TJsonValue; FFieldList: TStrings);
    procedure CreateDatasetFromJson(AJSON: string);
    class procedure CreateFieldsFromJson(FDataset: TDataset; AJSONArray: TJsonValue); static;
    class procedure CreateFieldsFromJsonRow(FDataset: TDataset; AJSON: TJsonObject); static;

    // Array's changes
    property Changes: TJsonArray read FChanges;
    procedure AddChanges(ATypeChange: TRowSetChangeType; AJsonRow: TJsonValue);
    procedure AddRowSet(ATypeChange: TRowSetChangeType; ADataset: TDataset);
    function UpdatesPending: boolean;
    procedure ClearChanges;
    procedure ApplyUpdates(AProc: TFunc<TJsonArray, boolean>; AMethod: TIdHTTPRestMethod = rmPATCH); overload;
    procedure ApplyUpdates; overload;
    function ResourceName: string;
    function ResourceKeys: string;
    procedure BeforeOpenDelegate(AProc: TProc<TDataset>);
  published
    property Builder: TODataCustomBuilder read FBuilder write SetBuilder;
    Property Active: boolean read GetActive write SetActive;
    Property Dataset: TDataset read FDataset write SetDataset;
    Property Params: TParams read FParams write SetParams;
    Property ResponseJSON: TIdHTTPRestClient read FResponseJSON write SetResponseJSON;
    Property RootElement: string read FRootElement write SetRootElement;
    Property ResponseType: TAdapterResponserType read FResponseType write SetResponseType default pureJSON;
    property OnBeforeApplyUpdates: TNotifyEvent read FOnBeforeApplyUpdate write SetOnBeforeApplyUpdate;
    property OnAfterApplyUpdates: TNotifyEvent read FOnAfterApplyUpdate write SetOnAfterApplyUpdate;
    property OnGetParams: TODataGetResourceParams read FOnGetParams write SetOnGetParams;
  end;

implementation

uses
  System.JSON.Helper, ObjectsMappers,
  System.Classes.Helper,
  System.DateUtils,
  System.Rtti;

{ TIdHTTPDataSetAdapter }

procedure TODataDatasetAdapter.AddChanges(ATypeChange: TRowSetChangeType; AJsonRow: TJsonValue);
begin
  (AJsonRow as TJsonObject).addPair('rowstate', TDatarowChangeTypeName[ATypeChange]);
  FChanges.AddElement(AJsonRow);
end;

procedure TODataDatasetAdapter.ApplyUpdates(AProc: TFunc<TJsonArray, boolean>; AMethod: TIdHTTPRestMethod = rmPATCH);
begin

  if assigned(FOnBeforeApplyUpdate) then
    FOnBeforeApplyUpdate(self);

  if assigned(AProc) then
  begin
    if AProc(FChanges) then
    begin
      ClearChanges;
      if assigned(FOnAfterApplyUpdate) then
        FOnAfterApplyUpdate(self);
    end;
  end
  else if assigned(FBuilder) then
    if FBuilder.ApplyUpdates(FChanges, AMethod) then
    begin
      ClearChanges;
      if assigned(FOnAfterApplyUpdate) then
        FOnAfterApplyUpdate(self);
    end;
end;

procedure TODataDatasetAdapter.AddRowSet(ATypeChange: TRowSetChangeType; ADataset: TDataset);
var
  js: TJsonObject;
begin
  js := TJsonObject.create;
  Mapper.DataSetToJSONObject(ADataset, js, false, nil, fpLowerCase);
  AddChanges(ATypeChange, js);
end;

procedure TODataDatasetAdapter.ApplyUpdates;
begin
  ApplyUpdates(nil);
end;

procedure TODataDatasetAdapter.BeforeOpenDelegate(AProc: TProc<TDataset>);
begin
  FBeforeOpenDelegate := AProc;
end;

procedure TODataDatasetAdapter.ClearChanges;
begin
  while FChanges.Count > 0 do
    FChanges.Remove(0);

end;

constructor TODataDatasetAdapter.create(AOwner: TComponent);
begin
  inherited;
  FParams := TParams.create;
  FOrigemFieldNameList := TStringList.create;
  FChanges := TJsonArray.create;
end;

procedure TODataDatasetAdapter.CreateDatasetFromJson(AJSON: string);
var
  ja: TJsonArray;
  function GetStringListFromJson(ja: TJsonArray): string;
  var
    j: TJsonValue;
  begin
    for j in ja do
    begin
      if result <> '' then
        result := result + ';';
      result := result + j.Value
    end;
  end;

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

  if FJsonValue.TryGetValue<TJsonArray>('keys', ja) then
  begin
    FResourceKeys := GetStringListFromJson(ja);
  end;

  FillDatasetFromJSONValue(FRootElement, FDataset, FJsonValue, ResponseType, FBeforeOpenDelegate, FOrigemFieldNameList, FResourceKeys);
end;

class procedure TODataDatasetAdapter.CreateFieldsFromJsonRow(FDataset: TDataset; AJSON: TJsonObject);
var
  jv: TJsonPair;
  LFieldName: string;
  v: TValue;
  jtype: TJsonType;
begin
  for jv in AJSON do
  begin
    LFieldName := jv.JsonString.Value;
    if (FDataset.FieldDefs.IndexOf(LFieldName) >= 0) then
      continue; // a coluna ja existe no dataset.
    jtype := TJsonObject.GetJsonType(jv.JsonValue);
    case jtype of
      jtNumber:
        FDataset.FieldDefs.Add(LFieldName, ftFloat);
      jtTrue, jtFalse:
        FDataset.FieldDefs.Add(LFieldName, ftBoolean);
      jtDatetime, jtDate:
        FDataset.FieldDefs.Add(LFieldName, ftDateTime);
      jtString:
        FDataset.FieldDefs.Add(LFieldName, ftString, 255);
      jtUnknown, jtBytes:
        FDataset.FieldDefs.Add(LFieldName, ftBlob);
    end;
  end;
end;

class procedure TODataDatasetAdapter.CreateFieldByProperties(FDataset: TDataset; AJSONProp: TJsonValue; FFieldList: TStrings);
var
  jp: TJsonPair;
  jv: TJsonValue;
  LFieldName: string;
  LType: string;
  LSize, n: integer;
  LRequired: boolean;
  LPrecision: integer;
  LScale: integer;
begin
  with FDataset do
    for jp in AJSONProp.asObject do
    begin
      LFieldName := jp.JsonString.Value.ToLower;
      if assigned(FFieldList) then
        FFieldList.Add(LFieldName);
      n := FDataset.FieldDefs.IndexOf(LFieldName);
      if n < 0 then
      begin
        if not jp.JsonValue.TryGetValue<string>('Type', LType) then
          continue;
        jp.JsonValue.TryGetValue<integer>('MaxLength', LSize);
        jp.JsonValue.TryGetValue<boolean>('Nullable', LRequired);
        LType := LType.ToLower;
        if LType = 'string' then
        begin
          FieldDefs.Add(LFieldName, ftString, LSize, LRequired);
        end
        else if LType = 'float' then
        begin
          jp.JsonValue.TryGetValue<integer>('Precision', LPrecision);
          jp.JsonValue.TryGetValue<integer>('Scale', LScale);
          FieldDefs.Add(LFieldName, ftFloat, 0, LRequired);
        end
        else if LType = 'datetime' then
        begin
          FieldDefs.Add(LFieldName, ftDateTime, 0, LRequired);
        end;
        n := FDataset.FieldDefs.IndexOf(LFieldName);
      end;
    end;

end;

class procedure TODataDatasetAdapter.CreateFieldsFromJson(FDataset: TDataset; AJSONArray: TJsonValue);
var
  LJSONValue: TJsonValue;
  ja: TJsonArray;
  jo: TJsonObject;
  fld: TField;
begin
  AJSONArray.TryGetValue(ja);
  Assert(assigned(ja)); // nao passou um json valido ?

  LJSONValue := ja.Get(0); // pega a primeira linha do json

  if assigned(LJSONValue) then
  begin
    jo := TJsonObject.ParseJSONValue(LJSONValue.ToJSON) as TJsonObject;
    CreateFieldsFromJsonRow(FDataset, jo);
  end;
  Assert(FDataset.FieldDefs.Count > 0, 'Não retornou colunas de dados'); // nao tem nenhum linha de dados ?

end;

class procedure TODataDatasetAdapter.DatasetFromJsonObject(FDataset: TDataset; AJSON: TJsonValue; FFieldList: TStrings);
  procedure AddJSONDataRow(const AJsonValue: TJsonValue);
  var
    LValue: variant;
    LJSONValue: TJsonValue;
    LField: TField;
    i: integer;
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
        if not AJsonValue.TryGetValue<TJsonValue>(LPath, LJSONValue) then
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
          else if LField.DataType = ftFloat then
          begin
            LField.AsFloat := LValue;
            continue;
          end
          else if LField.DataType = ftCurrency then
          begin
            LField.AsCurrency := LValue;
            continue;
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
      begin
        FDataset.Open;
      end;
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
      while FDataset.Eof = false do
        FDataset.Delete;
{$ENDIF}
    end;

    if { FDataset.FieldDefs.Count = 0 } not FDataset.Active then
      CreateFieldsFromJson(FDataset, AJSON);

    if (FDataset.FieldDefs.Count > 0) and (FDataset.Active = false) then
      FDataset.Open
    else
      raise Exception.create('Não há dados para mostrar');

    if FDataset.FieldDefs.Count > 0 then
      AddJSONDataRows(AJSON)
    else
      UpdateDataset(AJSON);
    FDataset.first;

  finally
    FDataset.EnableControls;
  end;
end;

destructor TODataDatasetAdapter.destroy;
begin
  FChanges.DisposeOf;
  FOrigemFieldNameList.DisposeOf;
  FParams.DisposeOf;
  inherited;
end;

procedure TODataDatasetAdapter.DoGetParams(var AURI: string);
var
  i: integer;
  prm: TParam;
  v: string;
  ds: TDataset;
  /// checa se tem um MasterSource
  function GetMasterSource(ADs: TDataset): TDataset;
  var
    v: TValue;
    o: TObject;
  begin
    result := nil;
    /// usa RTTI para pegar o MasterSource
    v := FDataset.ContextProperties['MasterSource'];
    if v.IsObject then
    begin
      o := v.asObject;
      if o.InheritsFrom(TDatasource) then
        result := TDatasource(v.asObject).Dataset;
    end;
  end;
  procedure FillParamValue;
  var
    fld: TField;
  begin
    if not assigned(ds) then
      exit;
    // pegar o valor do Mastersource;
    fld := ds.FindField(prm.name);
    if not assigned(fld) then
      exit;
    prm.DataType := fld.DataType;
    prm.Value := fld.Value;
  end;

begin
  /// varre os params para pegar o valor do MasterSource
  for i := 0 to FParams.Count - 1 do
  begin
    prm := FParams.items[i];
    ds := GetMasterSource(FDataset);
    FillParamValue;
    if prm.IsNull then
      continue;
    case prm.DataType of
      ftSmallint, ftInteger, ftCurrency, ftFloat, ftBCD:
        v := prm.Value;
    else
      v := quotedStr(prm.Value);
    end;
    AURI := StringReplace(AURI, '{' + prm.name + '}', v, [rfReplaceAll, rfIgnoreCase]);
  end;
  /// chama evento para completar os parametros
  if assigned(FOnGetParams) then
    FOnGetParams(self, AURI);
end;

function TODataDatasetAdapter.Execute: boolean;
var
  FURI: string;
begin
  if assigned(FJsonValue) then
    FJsonValue.DisposeOf;
  FJsonValue := nil;

  result := false;

  if assigned(FBuilder) then
  begin
    FBuilder.ToString;
    FURI := FBuilder.URI;
    ///  checa se tem parametros - MasterDetail
    if FURI.Contains('{') then
      DoGetParams(FURI);
    result := FBuilder.Execute(
      procedure
      begin
        if assigned(FDataset) then
          CreateDatasetFromJson('');
      end, FURI);
  end
  else if assigned(FResponseJSON) then
    result := FResponseJSON.Execute(
      procedure
      begin
        if assigned(FDataset) then
          CreateDatasetFromJson('');
      end);
end;

class procedure TODataDatasetAdapter.FillDatasetFromJSONValue(ARootElement: string; ADataset: TDataset; AJSON: TJsonValue; AResponseType: TAdapterResponserType;
ADelegate: TProc<TDataset>; FFieldList: TStrings; AKeys: String);
var
{$IFDEF REST}
  Adpter: TCustomJSONDataSetAdapter;
{$ENDIF}
  ji: TJsonPair;
  achei: boolean;
  jo: TJsonObject;
  jv: TJsonArray;

{$IFDEF REST}
  procedure LoadWithReflect(Const AJSON: TJsonObject; achou: integer);
  var
    LDataSets: TFDJSONDatasets;
    memDs: TFDMemTable;
  begin
    LDataSets := TFDJSONDatasets.create;
    TFDJSONInterceptor.JSONObjectToDataSets(AJSON, LDataSets);

    if ADataset.InheritsFrom(TFDMemTable) then
    begin // é um FdMemTable
      TFDMemTable(ADataset).AppendData(TFDJSONDataSetsReader.GetListValue(LDataSets, achou));
    end
    else
    begin
      // cria um MemTable de passagem
      memDs := TFDMemTable.create(nil);
      try
        TFDMemTable(memDs).AppendData(TFDJSONDataSetsReader.GetListValue(LDataSets, achou));
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
  fld: TField;
  s: string;
begin

  if ADataset.Active then
    ADataset.Close;

  case AResponseType of
    pureJSON:
      begin
        /// checa se tem algum field que não foi carregado no DEFs.
        /// se houver alguma lista de fields definidas pelo coder.
        for fld in ADataset.Fields do
        begin
          fld.ProviderFlags := fld.ProviderFlags - [pfInUpdate, pfInWhere];
          if ADataset.FieldDefs.IndexOf(fld.FieldName) >= 0 then
            continue;
          ADataset.FieldDefs.Add(fld.FieldName, fld.DataType, fld.Size, fld.Required);
        end;

        if AJSON.TryGetValue('properties', _jv) then
        begin
          CreateFieldByProperties(ADataset, _jv, FFieldList);
        end;
        if AJSON.TryGetValue(ARootElement, _jv) then
        else
          _jv := AJSON;

        if assigned(ADelegate) then
          ADelegate(ADataset);

        DatasetFromJsonObject(ADataset, _jv, FFieldList);
        s := ';' + AKeys.ToLower + ';';
        for fld in ADataset.Fields do
        begin
          if FFieldList.IndexOf(fld.FieldName) >= 0 then
            fld.ProviderFlags := fld.ProviderFlags + [pfInUpdate];
          if s.Contains(';' + fld.FieldName.ToLower + ';') then
            fld.ProviderFlags := fld.ProviderFlags + [pfInWhere];
        end;
      end;

  end;
end;

function TODataDatasetAdapter.GetActive: boolean;
begin
  if assigned(FDataset) then
    result := FDataset.Active;
end;

procedure TODataDatasetAdapter.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  if (AOperation = TOperation.opRemove) then
  begin
    if AComponent = FResponseJSON then
      FResponseJSON := nil;
    if AComponent = FDataset then
      FDataset := nil;
    if AComponent = FBuilder then
      FBuilder := nil;
  end;
  inherited;

end;

function TODataDatasetAdapter.ResourceKeys: string;
begin
  result := FResourceKeys;
end;

function TODataDatasetAdapter.ResourceName: string;
begin
  if assigned(FBuilder) then
    result := FBuilder.ResourceName;
end;

procedure TODataDatasetAdapter.SetActive(const Value: boolean);
begin
  if assigned(FDataset) then
    FDataset.Active := Value;
end;

procedure TODataDatasetAdapter.SetBuilder(const Value: TODataCustomBuilder);
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

procedure TODataDatasetAdapter.SetOnAfterApplyUpdate(const Value: TNotifyEvent);
begin
  FOnAfterApplyUpdate := Value;
end;

procedure TODataDatasetAdapter.SetOnBeforeApplyUpdate(const Value: TNotifyEvent);
begin
  FOnBeforeApplyUpdate := Value;
end;

procedure TODataDatasetAdapter.SetOnGetParams(const Value: TODataGetResourceParams);
begin
  FOnGetParams := Value;
end;

procedure TODataDatasetAdapter.SetParams(const Value: TParams);
begin
  FParams := Value;
end;

procedure TODataDatasetAdapter.SetResponseJSON(const Value: TIdHTTPRestClient);
begin
  FResponseJSON := Value;
end;

procedure TODataDatasetAdapter.SetResponseType(const Value: TAdapterResponserType);
begin
  FResponseType := Value;
end;

procedure TODataDatasetAdapter.SetRootElement(const Value: string);
begin
  FRootElement := Value;
end;

function TODataDatasetAdapter.UpdatesPending: boolean;
begin
  result := FChanges.Count > 0;
end;

end.
