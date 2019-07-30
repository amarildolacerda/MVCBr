{ *************************************************************************** }
{ }
{ }
{ Copyright (C) Amarildo Lacerda }
{ }
{ https://github.com/amarildolacerda }
{ }
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
  Altera�oes:
  28/01/16 - Primeira vers�o publicada
  29/01/16 - corre��o DoLoopEvent;

}

unit Data.DB.Helper;

interface

uses Classes, SysUtils, DB, System.JSON, System.JSON.Helper;

type

  TDatasetHelper = class helper for TDataset
  private
    function GetValues(fldName: string): Variant;
    procedure SetValues(fldName: string; const Value: Variant);
  public
    Function OpenAnonimous(proc: TProc): TDataset;
    procedure Run(AProc: TProc<TDataset>);
    procedure Append(AEvent: TProc<TDataset>); overload;
    procedure Append(AEvent: TProc); overload;
    procedure Post(AEvent: TProc); overload;
    procedure Post(AEvent: TProc<TDataset>); overload;
    function ToJson(AAlias: string = ''): String;
    function ToJsonObject(AAlias: string): TJsonObject;
    procedure ChangeAllValuesTo(AFieldName: string; AValue: Variant); overload;
    procedure ChangeAllValuesTo(AFieldName: string; AValue: Variant;
      AConfirm: TFunc<boolean>); overload;
    procedure ChangeAllValuesTo(AFieldName: string; AValue: Variant;
      AConfirm: TFunc<TDataset, boolean>); overload;
    procedure AppendFromJson(sJson: string);
    procedure CopyFromJson(sJosn: string);
    procedure JsonToRecord(sJson: string; AAppend: boolean); overload;
    procedure FromJsonObject(oJson: TJsonObject; AAppend: boolean;
      ignoreNulls: boolean = true); overload;
    procedure DoLoopEvent(AEvent: TProc); overload;
    procedure DoLoopEvent(AEvent: TProc<TDataset>); overload;
    procedure ForEach(AEvent: TFunc<TDataset, boolean>); overload;
    procedure ForEach(AEvent: TProc); overload;
    procedure ForEach(AEvent: TProc<TDataset>); overload;
    function Sum(AField: string): double;
    function Max(AField: string): Variant;
    function Min(AField: string): Variant;
    function ToMinimus(AField: string; AValue: double): double;
    function ToMaximus(AField: string; AValue: double): double;
    function ToBetween(AField: string; AMinimus: double;
      AMaximus: double): double;
    procedure DoEventIf(AFieldName: string; AValue: Variant;
      AEvent: TProc); overload;
    procedure DoEventIf(AFieldName: string; AValue: Variant;
      AEvent: TProc<TDataset>); overload;
    procedure Value(AField: string; AValue: Variant); overload;
    function Value(AField: string): Variant; overload;
    procedure AppendRecords(ADataSet: TDataset);
    function FieldMask(fld: String; mask: string): TDataset;
    function FieldTitle(AFld: string; ATitle: string): TDataset;
    function FieldChanged(fld: string): boolean;
    function Editing: boolean;
    property Values[fldName: string]: Variant read GetValues write SetValues;
  end;

  TFieldsHack = class(TFields)
  public
    procedure FillFromJson(AJson: string);
  end;

  TFieldsHelper = class helper for TFields
  private
  public
    function JsonObject(var AJSONObject: TJsonObject;
      const ANulls: boolean = true; AFields: string = '';
      const AChangedOnly: boolean = false; AKeyFields: string = ''): integer;
    function ToJson(const ANulls: boolean = true; const AFields: string = '';
      const AChangedOnly: boolean = false;
      const AKeyFields: string = ''): string;
    function JsonValue(AFields: string = ''): TJsonValue;
    procedure FillFromJson(AJson: string);
  end;

  TFieldHelper = class helper for TField
  public
    function Round(ADec: integer): TField;
    function Trunc: TField;
    function FromStream(stream: TStream): TField;
    function ToStream(stream: TStream): TField;
    function Changed: boolean;
    function asJsonPair: TJsonPair;
  end;

implementation

uses System.Math, System.DateUtils,
  SqlTimSt, FmtBcd, System.Variants,
  Soap.EncdDecd;

function TDatasetHelper.FieldChanged(fld: string): boolean;
var
  fd: TField;
begin
  result := false;
  fd := FindField(fld);
  if fd = nil then
    exit;
  try
    if VarIsNull(fd.OldValue) and VarIsNull(fd.Value) then
      exit;
  except
  end;
  if not(State in [dsEdit, dsInsert]) then
    exit;
  try
    if State in [dsEdit] then
      if fd.OldValue = fd.Value then
        exit;
    if State in [dsInsert] then
      if VarIsNull(fd.Value) then
        exit;
    result := true;
  except
  end;
end;

procedure TDatasetHelper.ChangeAllValuesTo(AFieldName: string; AValue: Variant);
begin
  ChangeAllValuesTo(AFieldName, AValue,
    function: boolean
    begin
      result := true;
    end);
end;

procedure TDatasetHelper.Append(AEvent: TProc<TDataset>);
begin
  Append;
  AEvent(self);
end;

procedure TDatasetHelper.Append(AEvent: TProc);
begin
  Append(
    procedure(ds: TDataset)
    begin
      AEvent;
    end);
end;

procedure TDatasetHelper.AppendFromJson(sJson: string);
begin
  JsonToRecord(sJson, true);
end;

function TDatasetHelper.OpenAnonimous(proc: TProc): TDataset;
begin
  result := self;
  open;
  if active and assigned(proc) then
    proc;
end;

procedure TDatasetHelper.AppendRecords(ADataSet: TDataset);
var
  book: TBookMark;
begin
  book := GetBookmark;
  try
    DisableControls;
    ADataSet.first;
    while ADataSet.Eof = false do
    begin
      Append;
      CopyFields(ADataSet);
      Post;
      ADataSet.next;
    end;
  finally
    GotoBookmark(book);
    FreeBookmark(book);
    EnableControls;
  end;
end;

procedure TDatasetHelper.ChangeAllValuesTo(AFieldName: string; AValue: Variant;
AConfirm: TFunc<boolean>);
var
  book: TBookMark;
  fld: TField;
begin
  fld := FindField(AFieldName);
  if fld = nil then
    exit;
  book := GetBookmark;
  DisableControls;
  try
    first;
    while Eof = false do
    begin
      if AConfirm then
      begin
        if fld.Calculated then
          FieldByName(AFieldName).Value := AValue
        else if FieldByName(AFieldName).Value <> AValue then
        begin
          Edit;
          FieldByName(AFieldName).Value := AValue;
          Post;
        end;
      end;
      next;
    end;
  finally
    if BookmarkValid(book) then
      GotoBookmark(book);
    FreeBookmark(book);
    EnableControls;
  end;
end;

procedure TDatasetHelper.CopyFromJson(sJosn: string);
begin
  JsonToRecord(sJosn, false);
end;

procedure TDatasetHelper.DoLoopEvent(AEvent: TProc<TDataset>);
var
  book: TBookMark;
begin
  book := GetBookmark;
  try
    DisableControls;
    first;
    while Eof = false do
    begin
      AEvent(self);
      next;
    end;
  finally
    GotoBookmark(book);
    FreeBookmark(book);
    EnableControls;
  end;
end;

function TDatasetHelper.Editing: boolean;
begin
  result := State in dsEditModes;
end;

function TDatasetHelper.FieldTitle(AFld, ATitle: string): TDataset;
var
  f: TField;
begin
  f := FindField(AFld);
  if not assigned(f) then
    exit;
  f.DisplayLabel := ATitle;
end;

procedure TDatasetHelper.ForEach(AEvent: TProc<TDataset>);
begin
  self.ForEach(
    function(snd: TDataset): boolean
    begin
      AEvent(snd);
      result := false;
    end);
end;

procedure TDatasetHelper.ForEach(AEvent: TProc);
begin
  self.ForEach(
    function(snd: TDataset): boolean
    begin
      AEvent;
      result := false;
    end);
end;

procedure TDatasetHelper.ForEach(AEvent: TFunc<TDataset, boolean>);
var
  book: TBookMark;
begin
  book := GetBookmark;
  try
    DisableControls;
    first;
    while Eof = false do
    begin
      { if TThread.Current.CheckTerminated then
        break;
      }
      if AEvent(self) then
        exit;
      /// TRUE - Finaliza   FALSE - Continua
      next;
    end;
  finally
    GotoBookmark(book);
    FreeBookmark(book);
    EnableControls;
  end;
end;

function TDatasetHelper.FieldMask(fld, mask: string): TDataset;
var
  f: TField;
begin
  result := self;
  f := FindField(fld);
  if not assigned(f) then
    exit;
  case f.DataType of
    ftFloat, ftCurrency:
      TFloatField(f).DisplayFormat := mask;
    ftDate:
      TDateField(f).DisplayFormat := mask;
    ftDateTime:
      TDateTimeField(f).DisplayFormat := mask;
    ftString:
      begin
        // TStringField(f).DisplayLabel := mask;  ( isto altera o label do item )
        TStringField(f).EditMask := mask;
      end;
  end;
end;

procedure TDatasetHelper.DoEventIf(AFieldName: string; AValue: Variant;
AEvent: TProc);
begin
  DoEventIf(AFieldName, AValue,
    procedure(ds: TDataset)
    begin
      AEvent;
    end);
end;

procedure TDatasetHelper.DoLoopEvent(AEvent: TProc);
begin
  DoLoopEvent(
    procedure(ds: TDataset)
    begin
      AEvent;
    end);
end;

procedure TDatasetHelper.DoEventIf(AFieldName: string; AValue: Variant;
AEvent: TProc<TDataset>);
var
  book: TBookMark;
  fld: TField;
begin
  if not assigned(AEvent) then
    exit;
  fld := FindField(AFieldName);
  if fld = nil then
    exit;
  book := GetBookmark;
  DisableControls;
  try
    first;
    while Eof = false do
    begin
      if FieldByName(AFieldName).Value = AValue then
        AEvent(self) // quando exclui uma linha, ja salta para o item seguinte.
        // o next fica por conta da rotina que chamou;
      else
        next; // nao excluir nada, apontar para o proximo
    end;
  finally
    if BookmarkValid(book) and (Eof <> bof) then
    begin
      GotoBookmark(book);
    end;
    FreeBookmark(book);
    EnableControls;
  end;
end;

procedure TDatasetHelper.Run(AProc: TProc<TDataset>);
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      if assigned(AProc) then
        AProc(self);
    end).Start;
end;

function TDatasetHelper.ToMaximus(AField: string; AValue: double): double;
begin
  result := FieldByName(AField).asFloat;
  if FieldByName(AField).asFloat > AValue then
  begin
    result := AValue;
    if (State in dsEditModes) then
      FieldByName(AField).asFloat := result;
  end;
end;

function TDatasetHelper.ToMinimus(AField: string; AValue: double): double;
begin
  result := FieldByName(AField).asFloat;
  if FieldByName(AField).asFloat < AValue then
  begin
    result := AValue;
    if (State in dsEditModes) then
      FieldByName(AField).asFloat := result;
  end;
end;

procedure TDatasetHelper.SetValues(fldName: string; const Value: Variant);
begin
  FieldByName(fldName).Value := Value;
end;

function TDatasetHelper.Sum(AField: string): double;
var
  rt: double;
begin
  rt := 0;
  ForEach(
    procedure
    begin
      rt := rt + FieldByName(AField).asFloat;
    end);
  exit(rt);
end;

procedure TDatasetHelper.JsonToRecord(sJson: string; AAppend: boolean);
var
  o: TJsonObject;
begin
  o := TJsonObject.Parse(sJson);
  try
    FromJsonObject(o, AAppend);
  finally
    o.Free;
  end;
end;

function TDatasetHelper.Max(AField: string): Variant;
var
  r: Variant;
  inited: boolean;
begin
  inited := false;
  ForEach(
    procedure
    begin
      if (not inited) and (not FieldByName(AField).isnull) then
      begin
        r := FieldByName(AField).Value;
        inited := true;
      end;
      if inited and (not FieldByName(AField).isnull) then
      begin
        if r < FieldByName(AField).Value then
          r := FieldByName(AField).Value;
      end;
    end);
end;

function TDatasetHelper.Min(AField: string): Variant;
var
  r: Variant;
  inited: boolean;
begin
  inited := false;
  ForEach(
    procedure
    begin
      if (not inited) and (not FieldByName(AField).isnull) then
      begin
        r := FieldByName(AField).Value;
        inited := true;
      end;
      if inited and (not FieldByName(AField).isnull) then
      begin
        if r > FieldByName(AField).Value then
          r := FieldByName(AField).Value;
      end;
    end);
end;

procedure TDatasetHelper.FromJsonObject(oJson: TJsonObject; AAppend: boolean;
ignoreNulls: boolean = true);
var
  inEditing: boolean;
  k: IJson;
  A: TJSONArray;
  j: integer;
  i: integer;
  procedure FromJsonX;
  var
    fld: TField;
    sName: string;
    sValue: string;
  begin
    for fld in Fields do
    begin
      if k.Contains(fld.FieldName.ToLower) then
      begin
        sName := fld.FieldName.ToLower;
        if not(State in [dsEdit, dsInsert]) then
          if AAppend then
            Append
          else
            Edit;

        if ignoreNulls and k.isnull(sName) then
          continue;

        if k.isnull(sName) then
          fld.clear
        else
          case fld.DataType of
            ftDate, ftDateTime, ftTime:
              begin
                sValue := k.S(sName);
                if sValue.Contains('T') then
                  fld.asDateTime := ISO8601ToDate(sValue)
                else
                  fld.asDateTime := ISO8601ToDate(sValue);
              end;
            ftTimeStamp:
              fld.Value := strToDateTimeDef(ISODateTimeToString(k.D(sName)), 0);
            ftFloat:
              fld.Value := k.D(sName);
          else
            fld.Value := k.V(sName);
          end;

        inc(i);
      end;
    end;
  end;

begin
  i := 0;
  A := nil;
  if oJson.Contains('result') then
    oJson.TryGetValue<TJSONArray>('result', A);

  if assigned(A) then
  begin
    if not AAppend then
    begin
      if A.Length > 1 then
        raise exception.Create
          ('Muitas linhas para substituir do json (permitido 1)');
    end;
  end
  else
  begin
    k := oJson;
    inEditing := State in [dsInsert, dsEdit];
    FromJsonX;
    if (i > 0) and (not inEditing) and (State in [dsEdit, dsInsert]) then
      Post;
    exit;
  end;

  inEditing := State in [dsInsert, dsEdit];
  for j := 0 to A.Length - 1 do
  begin
    k := A.Get(j) as TJsonObject;
    i := 0;
    FromJsonX;
    if (i > 0) and (not inEditing) and (State in [dsEdit, dsInsert]) then
      Post;
  end;
end;

function TDatasetHelper.GetValues(fldName: string): Variant;
begin
  result := FieldByName(fldName).Value;
end;

procedure TDatasetHelper.Post(AEvent: TProc);
begin
  Post(
    procedure(ds: TDataset)
    begin
      AEvent;
    end);
end;

procedure TDatasetHelper.Post(AEvent: TProc<TDataset>);
begin
  AEvent(self);
  Post;
end;

function TDatasetHelper.ToBetween(AField: string;
AMinimus, AMaximus: double): double;
begin
  result := FieldByName(AField).asFloat;
  if result < AMinimus then
    result := AMinimus;
  if result > AMaximus then
    result := AMaximus;
  if (State in dsEditModes) and (FieldByName(AField).asFloat <> result) then
    FieldByName(AField).asFloat := result;
end;

function TDatasetHelper.ToJson(AAlias: string = ''): String;
begin
  result := ToJsonObject(AAlias).ToJson;
end;

function TDatasetHelper.ToJsonObject(AAlias: string): TJsonObject;
var
  book: TBookMark;
  // lst: TStringList; //
  LJson: TJSONArray;
  LRow: TJsonObject;
  n: integer;
begin
  book := GetBookmark;
  try
    // lst := TStringList.Create;
    result := TJsonObject.Create;
    LJson := TJSONArray.Create;
    try
      // lst.Delimiter := ',';
      DisableControls;
      n := 0;
      first;
      while Eof = false do
      begin
        inc(n);
        LRow := TJsonObject.Create;
        LRow.addPair('RowId', n);

        Fields.JsonObject(LRow, false);
        // lst.Add(Fields.ToJson(false));
        LJson.AddElement(LRow);
        next;
      end;
      // result := '[' + lst.DelimitedText + ']';
      // result := LJson.ToJSON;
      if AAlias = '' then
        result := TJsonObject(LJson)
      else
        result.addPair(AAlias, LJson);
    finally
      // lst.Free;
      // LJson.Free;
    end;
  finally
    EnableControls;
    GotoBookmark(book);
    FreeBookmark(book);
  end;

end;

procedure TDatasetHelper.Value(AField: string; AValue: Variant);
begin
  FieldByName(AField).Value := AValue;
end;

function TDatasetHelper.Value(AField: string): Variant;
begin
  result := FieldByName(AField).Value;
end;

{ TFieldsHelper }

procedure TFieldsHack.FillFromJson(AJson: string);
var
  j: TJsonObject;
  V: TJsonValue;
  jp: TJsonPair;
  it: TField;
  key: string;
  fs: TFormatSettings;
  MS: TMemoryStream;
  SS: TStringStream;
begin
  try
    j := TJsonObject.Parse(AJson);
    try
      for it in self do
      begin
        try
          key := lowercase(it.FieldName);
          jp := j.Get(key);
          if assigned(jp) then
            if not(jp.JsonValue is TJSONNull) then
              V := j.Get(key).JsonValue;
          if (not assigned(jp)) or (not assigned(V)) or
            (jp.JsonValue is TJSONNull) then
          begin
            it.clear;
            continue;
          end;

          case it.DataType of
            TFieldType.ftInteger, TFieldType.ftAutoInc, TFieldType.ftSmallint,
              TFieldType.ftShortint:
              begin
                it.AsInteger := (V as TJSONNumber).AsInt;
              end;
            TFieldType.ftLargeint:
              begin
                it.AsLargeInt := (V as TJSONNumber).AsInt64;
              end;
            TFieldType.ftSingle, TFieldType.ftFloat:
              begin
                it.asFloat := (V as TJSONNumber).AsDouble;
              end;
            ftString, ftWideString, ftMemo, ftWideMemo:
              begin
                it.AsString := (V as TJSONString).Value;
              end;
            TFieldType.ftDate:
              begin
                it.asDateTime := ISOStrToDate((V as TJSONString).Value);
              end;
            TFieldType.ftDateTime:
              begin
                it.asDateTime := ISOStrToDateTime((V as TJSONString).Value);
              end;
            TFieldType.ftTimeStamp:
              begin
                it.AsSQLTimeStamp :=
                  StrToSQLTimeStamp((V as TJSONString).Value);
              end;
            TFieldType.ftCurrency:
              begin
                fs.DecimalSeparator := '.';
{$IF CompilerVersion <= 27}
                it.AsCurrency := StrToCurr((V as TJSONString).Value, fs);
{$ELSE} // Delphi XE7 introduces method "ToJSON" to fix some old bugs...
                it.AsCurrency := StrToCurr((V as TJSONNumber).ToJson, fs);
{$ENDIF}
              end;
            TFieldType.ftFMTBcd:
              begin
                it.AsBcd := DoubleToBcd((V as TJSONNumber).AsDouble);
              end;
            TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftStream:
              begin
                MS := TMemoryStream.Create;
                try
                  SS := TStringStream.Create((V as TJSONString).Value,
                    TEncoding.ASCII);
                  try
                    DecodeStream(SS, MS);
                    MS.Position := 0;
                    TBlobField(it).LoadFromStream(MS);
                  finally
                    SS.Free;
                  end;
                finally
                  MS.Free;
                end;
              end;
            // else
            // raise EMapperException.Create('Cannot find type for field ' + key);

          end;
        except
        end;

      end;
    finally
      FreeAndNil(j);
    end;
  except
    on e: exception do
      raise exception.Create(e.message + '(' + key + ')');
  end;
end;

function TFieldsHelper.ToJson(const ANulls: boolean = true;
const AFields: string = ''; const AChangedOnly: boolean = false;
const AKeyFields: string = ''): string;
var
  AJSONObject: TJsonObject;
begin
  AJSONObject := TJsonObject.Create;
  try
    JsonObject(AJSONObject, ANulls, AFields, AChangedOnly, AKeyFields);
    result := AJSONObject.ToString;
  finally
    AJSONObject.Free;
  end;
end;

procedure TFieldsHelper.FillFromJson(AJson: string);
begin
  TFieldsHack(self).FillFromJson(AJson);
end;


function TFieldsHelper.JsonObject(var AJSONObject: TJsonObject;
const ANulls: boolean = true; AFields: string = '';
const AChangedOnly: boolean = false; AKeyFields: string = ''): integer;
var
  i: integer;
  key: string;
  ts: TSQLTimeStamp;
  MS: TMemoryStream;
  SS: TStringStream;
  it: TField;
  function FieldValid: boolean;
  begin
    result := (AFields = '') or
      (pos(',' + lowercase(it.FieldName) + ',', AFields) > 0);
  end;

begin
  if AFields <> '' then
    AFields := ',' + lowercase(AFields.Replace(';', ',')) + ',';
  if AKeyFields <> '' then
    AKeyFields := ',' + lowercase(AKeyFields.Replace(';', ',')) + ',';

  result := 0;
  if not assigned(AJSONObject) then
    raise exception.Create('Error Message, not init JSONOject ');

  for it in self do
  begin
    if not FieldValid then
      continue;

    if AChangedOnly and (not it.Changed) and
      (not AKeyFields.Contains(it.FieldName.ToLower)) then
      continue;

    key := lowercase(it.FieldName);
    if not ANulls then
      if it.isnull or it.AsString.IsEmpty then
      begin
        continue;
      end;
    if it.isnull then
    begin
      AJSONObject.addPair(key, TJSONNull.Create);
      continue;
    end;

    case it.DataType of
      TFieldType.ftInteger, TFieldType.ftAutoInc, TFieldType.ftSmallint,
        TFieldType.ftShortint:
        begin
          if (not ANulls) and (it.AsInteger = 0) then
            continue;
          AJSONObject.addPair(key, TJSONNumber.Create(it.AsInteger));
        end;
      TFieldType.ftLargeint:
        begin
          if (not ANulls) and (it.AsInteger = 0) then
            continue;
          AJSONObject.addPair(key, TJSONNumber.Create(it.AsLargeInt));
        end;
      TFieldType.ftSingle, TFieldType.ftFloat, TFieldType.ftExtended :
        begin
          if (not ANulls) and (it.asFloat = 0) then
            continue;
          AJSONObject.addPair(key, TJSONNumber.Create(it.asFloat));
        end;
      ftWideString, ftMemo, ftWideMemo:
        AJSONObject.addPair(key, it.AsWideString);
      ftString:
        AJSONObject.addPair(key, it.AsString.Replace('\', '\\',
          [rfReplaceAll]));
      TFieldType.ftDate:
        begin
          if (not ANulls) and (Trunc(it.asFloat) = 0) then
            continue;
          AJSONObject.addPair(key, ISODateToString(it.asDateTime));
        end;
      TFieldType.ftDateTime:
        begin
          if (not ANulls) and (Trunc(it.asFloat) = 0) then
            continue;
          AJSONObject.addPair(key, ISODateTimeToString(it.asDateTime));
        end;
      TFieldType.ftTimeStamp:
        begin
          ts := it.AsSQLTimeStamp;
          AJSONObject.addPair(key,
            SQLTimeStampToStr('yyyy-mm-dd hh:nn:ss', ts));
        end;
      TFieldType.ftCurrency:
        begin
          if (not ANulls) and (it.asFloat = 0) then
            continue;
          AJSONObject.addPair(key, TJSONNumber.Create(it.AsCurrency));
        end;
      TFieldType.ftBCD, TFieldType.ftFMTBcd:
        begin
          if (not ANulls) and (Trunc(it.asFloat) = 0) then
            continue;
          AJSONObject.addPair(key, TJSONNumber.Create(BcdToDouble(it.AsBcd)));
        end;
      TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftStream:
        begin
          MS := TMemoryStream.Create;
          try
            TBlobField(it).SaveToStream(MS);
            MS.Position := 0;
            SS := TStringStream.Create('', TEncoding.ASCII);
            try
              EncodeStream(MS, SS);
              SS.Position := 0;
              AJSONObject.addPair(key, SS.DataString);
            finally
              SS.Free;
            end;
          finally
            MS.Free;
          end;
        end;

    end;
    inc(result);
  end;
end;

function TFieldsHelper.JsonValue(AFields: string = ''): TJsonValue;
var
  S: string;
begin
  S := ToJson(false, AFields);
  result := TJsonObject.ParseJSONValue(S);
end;

{ TFieldHelper }

function TFieldHelper.asJsonPair: TJsonPair;
var
  key: string;
  jv: TJsonValue;
  ts: TSQLTimeStamp;
  MS: TMemoryStream;
  SS: TStringStream;
begin
  key := lowercase(FieldName);
  jv := nil;
  case DataType of
    TFieldType.ftInteger, TFieldType.ftAutoInc, TFieldType.ftSmallint,
      TFieldType.ftShortint:
      begin
        jv := TJSONNumber.Create(AsInteger);
      end;
    TFieldType.ftLargeint:
      begin
        jv := TJSONNumber.Create(AsLargeInt);
      end;
    TFieldType.ftSingle, TFieldType.ftFloat:
      begin
        jv := TJSONNumber.Create(asFloat);
      end;
    ftWideString, ftMemo, ftWideMemo:
      jv := TJSONString.Create(AsWideString);
    ftString:
      jv := TJSONString.Create(AsString.Replace('\', '\\', [rfReplaceAll]));
    TFieldType.ftDate:
      begin
        jv := TJSONString.Create(ISODateToString(asDateTime));
      end;
    TFieldType.ftDateTime:
      begin
        jv := TJSONString.Create(ISODateTimeToString(asDateTime));
      end;
    TFieldType.ftTimeStamp:
      begin
        ts := AsSQLTimeStamp;
        jv := TJSONString.Create(SQLTimeStampToStr('yyyy-mm-dd hh:nn:ss', ts));
      end;
    TFieldType.ftCurrency:
      begin
        jv := TJSONNumber.Create(AsCurrency);
      end;
    TFieldType.ftBCD, TFieldType.ftFMTBcd:
      begin
        jv := TJSONNumber.Create(BcdToDouble(AsBcd));
      end;
    TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftStream:
      begin
        MS := TMemoryStream.Create;
        try
          TBlobField(self).SaveToStream(MS);
          MS.Position := 0;
          SS := TStringStream.Create('', TEncoding.ASCII);
          try
            EncodeStream(MS, SS);
            SS.Position := 0;
            jv := TJSONString.Create(SS.DataString);
          finally
            SS.Free;
          end;
        finally
          MS.Free;
        end;
      end;

  end;

  if jv <> nil then
    result := TJsonPair.Create(key, jv);

end;

function TFieldHelper.Changed: boolean;
begin
  if (DataSet.State in [dsInsert]) and (not isnull) then
    exit(true);
  if DataSet.State in [dsEdit] then
    if Value <> OldValue then
      exit(true);
  exit(false);
end;

function TFieldHelper.FromStream(stream: TStream): TField;
begin
  result := self;
  TBlobField(self).LoadFromStream(stream);
end;

function RoundFloat(AValor: double; ACasaDecimal: integer): double;
var
  Ls: string;
  S: string;
begin
  try
    AValor := SimpleRoundTo(AValor, -(ACasaDecimal + 2));
    // resolver caso:  1,42xxxe-15

    result := AValor;
    if ACasaDecimal < 0 then
      exit;
    S := S.PadRight(ACasaDecimal, '0');
    Ls := '0.' + S;
    if ACasaDecimal = 0 then
      Ls := '0';
    Ls := formatFloat(Ls, AValor);
    result := StrToFloatDef(Ls, 0);
  except
    result := 0;
  end;
end;

function TFieldHelper.Round(ADec: integer): TField;
begin
  if DataType in [ftFloat, ftCurrency, ftBCD] then
    asFloat := RoundFloat(asFloat, ADec);
end;

function TFieldHelper.ToStream(stream: TStream): TField;
begin
  result := self;
  TBlobField(self).SaveToStream(stream);
end;

function TFieldHelper.Trunc: TField;
begin
  if DataType in [ftFloat, ftCurrency, ftBCD] then
    asFloat := System.Trunc(asFloat)
end;

procedure TDatasetHelper.ChangeAllValuesTo(AFieldName: string; AValue: Variant;
AConfirm: TFunc<TDataset, boolean>);
var
  book: TBookMark;
  fld: TField;
begin
  fld := FindField(AFieldName);
  if fld = nil then
    exit;
  book := GetBookmark;
  DisableControls;
  try
    first;
    while Eof = false do
    begin
      if AConfirm(self) then
      begin
        if fld.Calculated then
          FieldByName(AFieldName).Value := AValue
        else if FieldByName(AFieldName).Value <> AValue then
        begin
          Edit;
          FieldByName(AFieldName).Value := AValue;
          Post;
        end;
      end;
      next;
    end;
  finally
    if BookmarkValid(book) then
      GotoBookmark(book);
    FreeBookmark(book);
    EnableControls;
  end;
end;

{ TFieldsHack }

end.
