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
  Alterações:
     05/05/2017 - trocado TJsonBoolean para compatibilidade com XE8; por: Wolnei Simões
}

unit System.JsonFiles;

interface

uses System.Classes, System.SysUtils, System.Rtti, System.Json, {Rest.Json,}
  System.IOUtils,
  System.TypInfo;

type
  TMemJsonFile = class(TInterfacedObject)
  private
    FEncoding: TEncoding;
    FFileName: string;
    FJson: TJsonObject;
    FAutoSave: boolean;
    FModified: boolean;
    procedure SetAutoSave(const Value: boolean);
    procedure SetModified(const Value: boolean);
  protected
    // base
    procedure WriteValue(const Section, Ident: string; Value: TValue); virtual;
    function ReadValue(const Section, Ident: string; Default: Variant)
      : Variant; virtual;
  public

    procedure LoadValues; virtual;
    constructor Create(AFilename: string); overload; virtual;
    constructor Create(const AFilename: string; const AEncoding: TEncoding);
      overload; virtual;

    destructor Destroy; override;
    property FileName: string read FFileName write FFileName;
    procedure ReadSection(const Section: string; Strings: TStrings); overload;
    function ReadSection(const Section: string): TJsonObject; overload;
    function ReadSectionJsonValue(const Section: TJsonObject; Ident: string)
      : TJsonValue;

    procedure ReadSections(Strings: TStrings); virtual;
    procedure ReadSectionValues(const Section: string;
      Strings: TStrings); virtual;

    procedure WriteString(const Section, Ident: string; Value: string); virtual;
    procedure WriteInteger(const Section, Ident: string;
      Value: Integer); virtual;
    procedure WriteDateTime(const Section, Ident: string;
      Value: TDateTime); virtual;
    procedure WriteBool(const Section, Ident: string; Value: boolean); virtual;
    procedure WriteFloat(const Section, Ident: string; Value: double); virtual;
    function ReadString(const Section, Ident, Default: string): string; virtual;
    function ReadInteger(const Section, Ident: string; Default: Integer)
      : Integer; virtual;
    function ReadBool(const Section, Ident: string; Default: boolean)
      : boolean; virtual;
    function ReadDatetime(const Section, Ident: string; Default: TDateTime)
      : TDateTime; virtual;
    function ReadFloat(const Section, Ident: string; Default: double)
      : double; virtual;
    procedure DeleteKey(const Section, Ident: String); virtual;
    procedure EraseSection(const Section: string); virtual;

    // RTTI
    procedure ReadObject(const ASection: string; AObj: TObject);
    procedure WriteObject(const ASection: string; AObj: TObject);

    procedure Clear;
    procedure UpdateFile; virtual;
    property Modified: boolean read FModified write SetModified;
    property AutoSave: boolean read FAutoSave write SetAutoSave;

    // Json
    function ToJson: string;
    procedure FromJson(AJson: string);

  end;

  TJsonFile = class(TMemJsonFile)
  public
    procedure UpdateFile; override;
    procedure LoadValues; override;
  end;

implementation

// System.IniFiles
uses System.DateUtils;
{ TMemJsonFiles }

type
  TJsonObjectHelper = class helper for TJsonObject
  public
    function Find(Section: string): TJsonValue;
  end;

  TValueHelper = record helper for TValue
  private
    function IsNumeric: boolean;
    function IsInteger: boolean;
    function IsDate: boolean;
    function IsDateTime: boolean;
    function IsBoolean: boolean;
    function AsDouble: double;
    function IsFloat: boolean;
    function AsFloat: Extended;
  end;

function ISODateTimeToString(ADateTime: TDateTime): string;
begin
  result := DateToISO8601(ADateTime);
end;

function ISOStrToDateTime(DateTimeAsString: string): TDateTime;
begin
  TryISO8601ToDate(DateTimeAsString, result);
end;

function TValueHelper.IsNumeric: boolean;
begin
  result := Kind in [tkInteger, tkChar, tkEnumeration, tkFloat,
    tkWChar, tkInt64];
end;

function TValueHelper.IsBoolean: boolean;
begin
  result := TypeInfo = System.TypeInfo(boolean);
end;

function TValueHelper.IsInteger: boolean;
begin
  result := TypeInfo = System.TypeInfo(Integer);
end;

function TValueHelper.IsDate: boolean;
begin
  result := TypeInfo = System.TypeInfo(TDate);
end;

function TValueHelper.IsDateTime: boolean;
begin
  result := TypeInfo = System.TypeInfo(TDateTime);
end;

procedure TMemJsonFile.Clear;
begin
  FreeAndNil(FJson);
  FJson := TJsonObject.Create;
end;

constructor TMemJsonFile.Create(AFilename: string);
begin
  Create(AFilename, nil);
end;

constructor TMemJsonFile.Create(const AFilename: string;
  const AEncoding: TEncoding);
begin
  inherited Create;
  FFileName := AFilename;
  FAutoSave := true;
  FJson := TJsonObject.Create;
  FEncoding := AEncoding;
{$IFNDEF MSWINDOWS)}
  if extractFileName(AFilename) = AFilename then
    FFileName := TPath.Combine(TPath.GetHomePath, AFilename);
{$ENDIF}
  LoadValues;
end;

procedure TMemJsonFile.DeleteKey(const Section, Ident: String);
var
  sec: TJsonObject;
begin
  sec := ReadSection(Section);
  if assigned(sec) then
  begin
    sec.RemovePair(Ident);
    FModified := true;
  end;
end;

destructor TMemJsonFile.Destroy;
begin
  if AutoSave and Modified then
    UpdateFile;
  FJson.Free;
  inherited;
end;

procedure TMemJsonFile.EraseSection(const Section: string);
begin
  FJson.RemovePair(Section);
  FModified := true;
end;

procedure TMemJsonFile.FromJson(AJson: string);
begin
  FreeAndNil(  FJson   );
  FJson := TJsonObject.ParseJSONValue(StringReplace(StringReplace(AJson,#13#10,'',[rfReplaceAll]),#9,'',[rfReplaceAll])) as TJsonObject;
  FModified := false;
end;

procedure TMemJsonFile.LoadValues;
begin
end;

function TValueHelper.AsDouble: double;
begin
  result := AsType<double>;
end;

function TValueHelper.IsFloat: boolean;
begin
  result := Kind = tkFloat;
end;

function TValueHelper.AsFloat: Extended;
begin
  result := AsType<Extended>;
end;

procedure TMemJsonFile.WriteObject(const ASection: string; AObj: TObject);
var
  aCtx: TRttiContext;
  AFld: TRttiProperty;
  AValue: TValue;
begin
  aCtx := TRttiContext.Create;
  try
    for AFld in aCtx.GetType(AObj.ClassType).GetProperties do
    begin
      if AFld.Visibility in [mvPublic] then
      begin
        AValue := AFld.GetValue(AObj);
        if AValue.IsDate or AValue.IsDateTime then
          WriteString(ASection, AFld.Name, ISODateTimeToString(AValue.AsDouble))
        else if AValue.IsBoolean then
          WriteBool(ASection, AFld.Name, AValue.AsBoolean)
        else if AValue.IsInteger then
          WriteInteger(ASection, AFld.Name, AValue.AsInteger)
        else if AValue.IsFloat or AValue.IsNumeric then
          WriteFloat(ASection, AFld.Name, AValue.AsFloat)
        else
          WriteString(ASection, AFld.Name, AValue.ToString);
      end;
    end;
  finally
    aCtx.Free;
  end;
end;

procedure TMemJsonFile.ReadObject(const ASection: string; AObj: TObject);
var
  aCtx: TRttiContext;
  AFld: TRttiProperty;
  AValue, ABase: TValue;
begin
  aCtx := TRttiContext.Create;
  try
    for AFld in aCtx.GetType(AObj.ClassType).GetProperties do
    begin
      if AFld.Visibility in [mvPublic] then
      begin
        ABase := AFld.GetValue(AObj);
        AValue := AFld.GetValue(AObj);
        if ABase.IsDate or ABase.IsDateTime then
          AValue := ISOStrToDateTime(ReadString(ASection, AFld.Name,
            ISODateTimeToString(ABase.AsDouble)))
        else if ABase.IsBoolean then
          AValue := ReadBool(ASection, AFld.Name, ABase.AsBoolean)
        else if ABase.IsInteger then
          AValue := ReadInteger(ASection, AFld.Name, ABase.AsInteger)
        else if ABase.IsFloat or ABase.IsNumeric then
          AValue := ReadFloat(ASection, AFld.Name, ABase.AsFloat)
        else
          AValue := ReadString(ASection, AFld.Name, ABase.asString);
        AFld.SetValue(AObj, AValue);
      end;
    end;
  finally
    aCtx.Free;
  end;
end;

procedure TJsonFile.LoadValues;
var
  Size: Integer;
  Buffer: TBytes;
  Stream: TFileStream;
begin
  // copy from Ssytem.IniFiles .TIniFiles (embarcadero)
  try
    if (FFileName <> '')  and FileExists(FFileName)  then
    begin
      try
        Stream := TFileStream.Create(FFileName, fmOpenRead);
        try
          // Load file into buffer and detect encoding
          Size := Stream.Size - Stream.Position;
          SetLength(Buffer, Size);
          Stream.Read(Buffer[0], Size);
          Size := TEncoding.GetBufferEncoding(Buffer, FEncoding);

          // Load strings from buffer
          FromJson(FEncoding.GetString(Buffer, Size, Length(Buffer) - Size));
        finally
          Stream.Free;
        end;
      except
        Clear;
      end;
    end;
  finally
    Modified := false;
  end;
end;

procedure TMemJsonFile.SetAutoSave(const Value: boolean);
begin
  FAutoSave := Value;
end;

procedure TMemJsonFile.SetModified(const Value: boolean);
begin
  FModified := Value;
end;

function TMemJsonFile.ToJson: string;
begin
  result := FJson.ToJson;
end;

procedure TMemJsonFile.UpdateFile;
begin

end;

procedure TJsonFile.UpdateFile;
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.Text := ToJson;
    List.SaveToFile(FFileName, FEncoding);
  finally
    List.Free;
  end;
  Modified := false;
end;

procedure TMemJsonFile.ReadSection(const Section: string; Strings: TStrings);
var
  sec: TJsonObject;
  v: TJsonPair;
begin
  Strings.Clear;
  sec := ReadSection(Section);
  if not assigned(sec) then
    exit;
  for v in sec do
  begin
    Strings.Add(v.JsonString.Value);
  end;

end;

function TMemJsonFile.ReadBool(const Section, Ident: string;
  Default: boolean): boolean;
begin
   result := false;
end;

function TMemJsonFile.ReadDatetime(const Section, Ident: string;
  Default: TDateTime): TDateTime;
var
  v: Variant;
begin
  v := ReadValue(Section, Ident, ISODateTimeToString(Default));
  result := ISOStrToDateTime(v);
end;

function TMemJsonFile.ReadFloat(const Section, Ident: string;
  Default: double): double;
var
  v: Variant;
begin
  v := ReadValue(Section, Ident, Default);
  result := StrToFloatDef(v, 0);
end;

function TMemJsonFile.ReadInteger(const Section, Ident: string;
  Default: Integer): Integer;
var
  v: Variant;
begin
  v := ReadValue(Section, Ident, Default);
  result := StrToIntDef(v, 0);
end;

function TMemJsonFile.ReadSection(const Section: string): TJsonObject;
var
  v: TJsonValue;
begin
  result := nil;
  v := nil;
  FJson.TryGetValue<TJsonValue>(Section, v);
  if assigned(v) then
    result := v as TJsonObject;
end;

procedure TMemJsonFile.ReadSections(Strings: TStrings);
var
  v: TJsonPair;
begin
  Strings.Clear;
  for v in FJson do
  begin
    Strings.Add(v.JsonString.Value);
  end;
end;

function TMemJsonFile.ReadSectionJsonValue(const Section: TJsonObject;
  Ident: string): TJsonValue;
begin
  result := nil;
  Section.TryGetValue<TJsonValue>(Ident, result);
end;

procedure TMemJsonFile.ReadSectionValues(const Section: string;
  Strings: TStrings);
var
  v: TJsonPair;
  j: TJsonObject;
begin
  Strings.Clear;
  j := ReadSection(Section);
  if not assigned(j) then
    exit;
  for v in j do
  begin
    Strings.Add(v.JsonString.Value + '=' + v.JsonValue.Value);
  end;
end;

function TMemJsonFile.ReadString(const Section, Ident, Default: string): string;
var
  v: Variant;
begin
  result := Default;
  v := ReadValue(Section, Ident, Default);
  result := v;
end;

function TMemJsonFile.ReadValue(const Section, Ident: string;
  Default: Variant): Variant;
var
  j: TJsonObject;
  v: TJsonValue;
begin
  result := Default;
  j := ReadSection(Section);
  if not assigned(j) then
    exit;

  v := j.Find(Ident);
  if not assigned(v) then
    exit;
  result := v.Value;

end;

procedure TMemJsonFile.WriteBool(const Section, Ident: string; Value: boolean);
begin
  WriteValue(Section, Ident, Value);
end;

procedure TMemJsonFile.WriteDateTime(const Section, Ident: string;
  Value: TDateTime);
begin
  WriteValue(Section, Ident, ISODateTimeToString(Value));
end;

procedure TMemJsonFile.WriteFloat(const Section, Ident: string; Value: double);
begin
  WriteValue(Section, Ident, Value);
end;

procedure TMemJsonFile.WriteInteger(const Section, Ident: string;
  Value: Integer);
begin
  WriteValue(Section, Ident, Value);
end;

procedure TMemJsonFile.WriteString(const Section, Ident: string; Value: string);
begin
  WriteValue(Section, Ident, Value);
end;

procedure TMemJsonFile.WriteValue(const Section, Ident: string; Value: TValue);
var
  AArray: TJsonObject;
  AValue: TJsonValue;
  procedure Add;
  begin
    if Value.IsInteger then
      AArray.AddPair(Ident, TJSONNumber.Create(Value.AsInteger))
    else if Value.IsDate or Value.IsDateTime then
      AArray.AddPair(Ident, ISODateTimeToString(Value.AsExtended))
    else if Value.IsBoolean then
      begin
          if Value.AsBoolean then
               AArray.AddPair(Ident, TJSONTrue.Create() )
          else AArray.AddPair(Ident, TJSONFalse.Create() )
      end
    else if Value.IsNumeric then
      AArray.AddPair(Ident, TJSONNumber.Create(Value.AsExtended))
    else
      AArray.AddPair(Ident, Value.asString)
  end;

begin
  AArray := ReadSection(Section);
  if not assigned(AArray) then
  begin
    AArray := TJsonObject.Create;
    FJson.AddPair(Section, AArray)
  end;

  AValue := ReadSectionJsonValue(AArray, Ident);
  if not assigned(AValue) then
    Add
  else
  begin
    AArray.RemovePair(Ident);
    Add;
  end;
  FModified := true;
end;

{ TJsonObjectHelper }

function TJsonObjectHelper.Find(Section: string): TJsonValue;
begin
  result := FindValue(Section);
end;

end.
