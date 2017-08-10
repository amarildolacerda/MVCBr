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
  Alteraçoes:
  28/01/16 - Primeira versão publicada
  29/01/16 - correção DoLoopEvent;

}

unit Data.DB.Helper;

interface

uses Classes, SysUtils, DB, System.JSON, System.JSON.Helper;

type

  TDatasetHelper = class helper for TDataset
  private
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
    procedure FromJsonObject(oJson: TJsonObject; AAppend: boolean); overload;
    procedure DoLoopEvent(AEvent: TProc); overload;
    procedure DoLoopEvent(AEvent: TProc<TDataset>); overload;
    procedure ForEach(AEvent: TFunc<TDataset, boolean>);
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
  end;

  TFieldsHelper = class helper for TFields
  private
  public
    function JsonObject(var AJSONObject: TJsonObject;
      ANulls: boolean = true): integer;
    function ToJson(ANulls: boolean = true): string;
    function JsonValue: TJsonValue;
    procedure FormJson(AJson: string);
  end;

  TFieldHelper = class helper for TField
    function Round(ADec: integer): TField;
    function Trunc: TField;
    function FromStream(stream: TStream): TField;
    function ToStream(stream: TStream): TField;
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

procedure TDatasetHelper.FromJsonObject(oJson: TJsonObject; AAppend: boolean);
var
  k: IJson;
  A: TJSONArray;
  j: integer;
  fld: TField;
  i: integer;
begin

  if oJson.Contains('result') = false then
    raise exception.Create('Não possui tag "result" no json');

  oJson.TryGetValue<TJSONArray>('result', A);

  if not AAppend then
  begin
    if A.Length > 1 then
      raise exception.Create
        ('Muitas linhas para substituir do json (permitido 1)');
  end;

  for j := 0 to A.Length - 1 do
  begin
    k := A.Get(j) as TJsonObject;
    i := 0;
    for fld in Fields do
    begin
      if k.Contains(lowercase(fld.FieldName)) then
      begin
        if not(State in [dsEdit, dsInsert]) then
          if AAppend then
            Append
          else
            Edit;
        fld.Value := k.V(lowercase(fld.FieldName));
        inc(i);
      end;
    end;
    if State in [dsEdit, dsInsert] then
      Post;
  end;
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

procedure TFieldsHelper.FormJson(AJson: string);
var
  j: TJsonObject;
  V: TJsonValue;
  jp: TJSONPair;
  it: TField;
  key: string;
  fs: TFormatSettings;
  MS: TMemoryStream;
  SS: TStringStream;

begin
  j := TJsonObject.Parse(AJson);
  try
    for it in self do
    begin
      key := lowercase(it.FieldName);
      jp := j.Get(key);
      if assigned(jp) then
        if not(jp.JsonValue is TJSONNull) then
          V := j.Get(key).JsonValue;
      if not assigned(V) then
      begin
        it.Clear;
        Continue;
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
            it.AsFloat := (V as TJSONNumber).AsDouble;
          end;
        ftString, ftWideString, ftMemo, ftWideMemo:
          begin
            it.AsString := (V as TJSONString).Value;
          end;
        TFieldType.ftDate:
          begin
            it.AsDateTime := ISOStrToDate((V as TJSONString).Value);
          end;
        TFieldType.ftDateTime:
          begin
            it.AsDateTime := ISOStrToDateTime((V as TJSONString).Value);
          end;
        TFieldType.ftTimeStamp:
          begin
            it.AsSQLTimeStamp := StrToSQLTimeStamp((V as TJSONString).Value);
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

    end;

  finally
    FreeAndNil(j);
  end;
end;

function TFieldsHelper.ToJson(ANulls: boolean = true): string;
var
  AJSONObject: TJsonObject;
begin
  AJSONObject := TJsonObject.Create;
  try
    JsonObject(AJSONObject, ANulls);
    result := AJSONObject.ToString;
  finally
    AJSONObject.Free;
  end;
end;

function TFieldsHelper.JsonObject(var AJSONObject: TJsonObject;
ANulls: boolean = true): integer;
var
  i: integer;
  key: string;
  ts: TSQLTimeStamp;
  MS: TMemoryStream;
  SS: TStringStream;
  it: TField;
begin
  result := 0;
  if not assigned(AJSONObject) then
    raise exception.Create('Error Message, not init JSONOject ');

  for it in self do
  begin
    key := lowercase(it.FieldName);
    if it.IsNull then
    begin
      if not ANulls then
        Continue;
      AJSONObject.addPair(key, TJSONNull.Create);
      Continue;
    end;

    case it.DataType of
      TFieldType.ftInteger, TFieldType.ftAutoInc, TFieldType.ftSmallint,
        TFieldType.ftShortint:
        AJSONObject.addPair(key, TJSONNumber.Create(it.AsInteger));
      TFieldType.ftLargeint:
        begin
          AJSONObject.addPair(key, TJSONNumber.Create(it.AsLargeInt));
        end;
      TFieldType.ftSingle, TFieldType.ftFloat:
        AJSONObject.addPair(key, TJSONNumber.Create(it.AsFloat));
      ftWideString, ftMemo, ftWideMemo:
        AJSONObject.addPair(key, it.AsWideString);
      ftString:
        AJSONObject.addPair(key, it.AsString.Replace('\', '\\',
          [rfReplaceAll]));
      TFieldType.ftDate:
        AJSONObject.addPair(key, ISODateToString(it.AsDateTime));
      TFieldType.ftDateTime:
        AJSONObject.addPair(key, ISODateTimeToString(it.AsDateTime));
      TFieldType.ftTimeStamp:
        begin
          ts := it.AsSQLTimeStamp;
          AJSONObject.addPair(key,
            SQLTimeStampToStr('yyyy-mm-dd hh:nn:ss', ts));
        end;
      TFieldType.ftCurrency:
        AJSONObject.addPair(key, TJSONNumber.Create(it.AsCurrency));
      TFieldType.ftBCD, TFieldType.ftFMTBcd:
        AJSONObject.addPair(key, TJSONNumber.Create(BcdToDouble(it.AsBcd)));
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

function TFieldsHelper.JsonValue: TJsonValue;
var
  s: string;
begin
  s := ToJson;
  result := TJsonObject.ParseJSONValue(s);
end;

{ TFieldHelper }

function TFieldHelper.FromStream(stream: TStream): TField;
begin
  result := self;
  TBlobField(self).LoadFromStream(stream);
end;

function RoundFloat(AValor: Double; ACasaDecimal: integer): Double;
var
  Ls: string;
  s: string;
begin
  try
    AValor := SimpleRoundTo(AValor, -(ACasaDecimal + 2));
    // resolver caso:  1,42xxxe-15

    result := AValor;
    if ACasaDecimal < 0 then
      exit;
    s := s.PadRight(ACasaDecimal, '0');
    Ls := '0.' + s;
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
    AsFloat := RoundFloat(AsFloat, ADec);
end;

function TFieldHelper.ToStream(stream: TStream): TField;
begin
  result := self;
  TBlobField(self).SaveToStream(stream);
end;

function TFieldHelper.Trunc: TField;
begin
  if DataType in [ftFloat, ftCurrency, ftBCD] then
    AsFloat := System.Trunc(AsFloat)
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

end.
