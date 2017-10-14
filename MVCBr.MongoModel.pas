unit MVCBr.MongoModel;
{ *************************************************************************** }
{ }
{ MVCBr é o resultado de esforços de um grupo }
{ }
{ Copyright (C) 2017 MVCBr }
{ }
{ amarildo lacerda }
{ http://www.tireideletra.com.br }
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

interface

uses
  System.classes, System.SysUtils,
  Data.DB,
  MVCBr.Interf, MVCBr.Model,
  MongoWire, MongoAuth3, JsonDoc,
  bsonDoc, bsonUtils, MVCBr.Patterns.Adapter;

type
  TMongoModelFactory = class;

  IJSONDocument = JsonDoc.IJSONDocument;

  IJSONDoc = interface(IJSONDocument)
    ['{4AC5C079-4EAC-4F28-BCA3-83794D899F36}']
    function ToJson: String;
  End;

  IJSONArray = JsonDoc.IJSONArray;
  IJSONDocArray = JsonDoc.IJSONDocArray;
  IMongoQuery = IMVCBrAdapter<TMongoWireQuery>;
  IBSONDocument = bsonDoc.IBSONDocument;

  TJSONDocument = class(JsonDoc.TJSONDocument, IJSONDoc)
  public
    class Function New: IJSONDocument; overload;
    class function New(const x: array of Variant): IJSONDocument; overload;
    class function BsonToJson(Doc: IBSONDocument): WideString;
    class function JSON(const x: Variant): IJSONDocument;
    function ToJson: String;
    class function AsArray(item: Variant): IJSONArray;
    class function NewDocArray: IJSONDocArray;
    class function ToDocArray(Doc: IJSONDocument): IJSONDocArray;
  end;

  TJSONDocArray = Class(JsonDoc.TJSONDocArray)
  public
    class function New: IJSONDocArray;
  end;

  IMongoModel = interface(IModel)
    ['{0A93DBFF-13C6-46A7-9A5D-C59551F32CB9}']
    function This: TMongoModelFactory;
    procedure SetDatabase(const Value: string);
    procedure SetHost(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetPort(const Value: integer);
    procedure SetUserName(const Value: string);
    function GetDatabase: string;
    function GetHost: string;
    function GetPassword: string;
    function GetPort: integer;
    function GetUserName: string;
    function Database(ADatabase: string): IMongoModel;
    function Host(AHost: String): IMongoModel;
    function Port(APort: integer): IMongoModel;
    function Password(APass: string): IMongoModel;
    function UserName(AUser: string): IMongoModel;
    function SetConnection(AConn: TMongoWire = nil): IMongoModel;
    /// mongo
    function MongoConnection: TMongoWire;
    function NewQuery: IMongoQuery;

    procedure SetActive(const Value: Boolean);
    function GetActive: Boolean;
    property Active: Boolean read GetActive write SetActive;

    function Get(const ACollection: String; const AWhere: IJSONDocument)
      : IJSONDocument; overload;
    function Get(const ACollection: String; const AJsonWhere: string)
      : IJSONDocument; overload;
    function Query(Const ACollection: String; const AWhere: IJSONDocument)
      : IJSONDocArray; overload;
    function Query(Const ACollection: String;
      const AArrayWhere: array of IJSONDocument): IJSONDocArray; overload;
    function FillDastaset(Doc: IJSONDocArray; ADataset: TDataset;
      AEventBoforePost: TProc = nil): integer;
    function GetDataset(ACollection: string;
      const AArrayWhere: array of IJSONDocument; ADataset: TDataset;
      AEvent: TProc = nil): integer; overload;
    function GetDataset(ACommand: IJSONDocument; ADataset: TDataset;
      AEvent: TProc = nil): integer; overload;

    procedure Update(const ACollection: String;
      const AWhere, ADoc: IJSONDocument; AUpsert: Boolean = false;
      AMultiUpdate: Boolean = false); overload;

    procedure Insert(const ACollection: WideString;
      const ADoc: IJSONDocument); overload;

    procedure Insert(const ACollection: WideString;
      const ADocs: array of IJSONDocument); overload;
    procedure Insert(const ACollection: WideString;
      const ADocs: IJSONDocArray); overload;
    procedure Delete(const ACollection: WideString; const AWhere: IJSONDocument;
      ASingleRemove: Boolean = true);
    function Ping: Boolean;
    procedure EnsureIndex(const ACollection: WideString;
      const AIndex: IJSONDocument; const AOptions: IJSONDocument = nil);

    function RunCommand(const ACmdObj: IJSONDocument): IJSONDocument;

    function Count(const ACollection: WideString): integer;
    function Distinct(const ACollection, AKey: WideString;
      const AQuery: IJSONDocument = nil): Variant;

    function Eval(const ACollection, AJSFn: WideString;
      const AArgs: array of Variant; ANoLock: Boolean = false): Variant;
    function AsArray(Doc: Variant): IJSONArray;
  end;

  TMongoExpression = record
  public
    class function like(AField: string; AText: string; AOptions: String = 'i')
      : IJSONDocument; static;
    class function contains(AField: string; AText: string;
      AOptions: String = 'i'): IJSONDocument; static;
    class function between(AField: string; AFrom, ATo: Variant)
      : IJSONDocument; static;
    class function gt(AField: string; AValue: Variant): IJSONDocument; static;
    class function gte(AField: string; AValue: Variant): IJSONDocument; static;
    class function lt(AField: string; AValue: Variant): IJSONDocument; static;
    class function lte(AField: string; AValue: Variant): IJSONDocument; static;
    class function eq(AField: string; AValue: Variant): IJSONDocument; static;
    class function ne(AField: string; AValue: Variant): IJSONDocument; static;
    class function search(AField: string; AString: string)
      : IJSONDocument; static;

  end;

  /// <summary>
  /// MongoModel
  /// </summary>
  TMongoModelFactory = class(TModelFactory, IMongoModel)
  private
    FPort: integer;
    FDatabase: string;
    FPassword: string;
    FHost: string;
    FUserName: string;
    FConnection: TMVCBrAdapter<TMongoWire>;
    FActive: Boolean;
    function SetConnection(AConn: TMongoWire = nil): IMongoModel;
    procedure SetActive(const Value: Boolean);
    function GetActive: Boolean;
    function GetSequence(FCollection, AMongoCampo: string): Int64;
  protected
    function OpenIfNeed: TMongoWire; virtual;
  public
    procedure SetDatabase(const Value: string); virtual;
    procedure SetHost(const Value: string); virtual;
    procedure SetPassword(const Value: string); virtual;
    procedure SetPort(const Value: integer); virtual;
    procedure SetUserName(const Value: string); virtual;
    function GetDatabase: string; virtual;
    function GetHost: string; virtual;
    function GetPassword: string; virtual;
    function GetPort: integer; virtual;
    function GetUserName: string; virtual;
    function Default: TMVCBrAdapter<TMongoWire>;
  public
    constructor Create; override;
    destructor Destroy; override;
    class function New(AController: IController; ADatabase: string = '')
      : IMongoModel; overload; virtual;
    class function New(AController: IController; AConnection: TMongoWire)
      : IMongoModel; overload; virtual;
    [weak]
    function This: TMongoModelFactory; virtual;
    function MongoConnection: TMongoWire;
    procedure Open;
    procedure Close;
    function NewQuery: IMongoQuery;
    /// Base
{$REGION "Base connections"}
    [weak]
    function Database(ADatabase: string): IMongoModel; virtual;
    [weak]
    function Host(AHost: String): IMongoModel; virtual;
    [weak]
    function Port(APort: integer): IMongoModel; virtual;
    [weak]
    function Password(APass: string): IMongoModel; virtual;
    [weak]
    function UserName(AUser: string): IMongoModel; virtual;
{$ENDREGION}
    [weak]
    property Active: Boolean read GetActive write SetActive;

    /// Operations
{$REGION "Mongo Base Operations"}
    /// <summary>
    /// Get retrieve data with AWhere conditions
    /// </summary>
    function Get(const ACollection: String; const AWhere: IJSONDocument)
      : IJSONDocument; overload;
    function Get(const ACollection: String; const AJsonWhere: string)
      : IJSONDocument; overload;
    function Query(Const ACollection: String; const AWhere: IJSONDocument)
      : IJSONDocArray; overload;
    function Query(Const ACollection: String;
      const AArrayWhere: array of IJSONDocument): IJSONDocArray; overload;

    function FillDastaset(Doc: IJSONDocArray; ADataset: TDataset;
      AEventBoforePost: TProc = nil): integer;
    function GetDataset(ACollection: string;
      const AArrayWhere: array of IJSONDocument; ADataset: TDataset;
      AEventBoforePost: TProc = nil): integer; overload;
    function GetDataset(ACommand: IJSONDocument; ADataset: TDataset;
      AEvent: TProc = nil): integer; overload;

    procedure Update(const ACollection: String;
      const AWhere, ADoc: IJSONDocument; AUpsert: Boolean = false;
      AMultiUpdate: Boolean = false);

    procedure Insert(const ACollection: WideString;
      const ADoc: IJSONDocument); overload;

    procedure Insert(const ACollection: WideString;
      const ADocs: array of IJSONDocument); overload;
    procedure Insert(const ACollection: WideString;
      const ADocs: IJSONDocArray); overload;
    procedure Delete(const ACollection: WideString; const AWhere: IJSONDocument;
      ASingleRemove: Boolean = true);
    function Ping: Boolean;
    procedure EnsureIndex(const ACollection: WideString;
      const AIndex: IJSONDocument; const AOptions: IJSONDocument = nil);

    function RunCommand(const ACmdObj: IJSONDocument): IJSONDocument;

    function Count(const ACollection: WideString): integer;
    function Distinct(const ACollection, AKey: WideString;
      const AQuery: IJSONDocument = nil): Variant;

    function Eval(const ACollection, AJSFn: WideString;
      const AArgs: array of Variant; ANoLock: Boolean = false): Variant;

    function AsArray(Doc: Variant): IJSONArray;

{$ENDREGION}
{$REGION "Samples Extends commands"}
    function QueryRegEx(ACollection, AField, AText: String): IJSONDocArray;
{$ENDREGION}
  end;

function MongoJSON: IJSONDocument; overload;
function MongoJSON(const x: array of Variant): IJSONDocument; overload;
function MongoJSON(const x: Variant): IJSONDocument; overload;

implementation

uses Data.DB.Helper, System.JSON, System.JSON.Helper;

function MongoJSON: IJSONDocument;
begin
  result := JsonDoc.JSON as IJSONDocument;
end;

function MongoJSON(const x: array of Variant): IJSONDocument; overload;
begin
  result := JSON(x) as IJSONDocument;
end;

function MongoJSON(const x: Variant): IJSONDocument; overload;
begin
  result := JSON(x) as IJSONDocument;
end;

{ TMongoModelFactory }

function TMongoModelFactory.AsArray(Doc: Variant): IJSONArray;
begin
  result := ja(Doc);
end;

procedure TMongoModelFactory.Close;
begin
  Active := false;
end;

function TMongoModelFactory.SetConnection(AConn: TMongoWire): IMongoModel;
begin
  result := self;
  if assigned(AConn) then
    FConnection.SetInstance(AConn, false { free on caller } );
end;

function TMongoModelFactory.Count(const ACollection: WideString): integer;
begin
  result := OpenIfNeed.Count(ACollection);
end;

constructor TMongoModelFactory.Create;
begin
  inherited;
  FDatabase := 'mvcbrDB';
  FHost := 'localhost';
  FPort := 27017;
end;

function TMongoModelFactory.Database(ADatabase: string): IMongoModel;
begin
  result := self;
  SetDatabase(ADatabase);
end;

function TMongoModelFactory.Default: TMVCBrAdapter<TMongoWire>;
begin

  if not assigned(FConnection) then
  begin
    FConnection := TMVCBrAdapter<TMongoWire>.Create(nil);
    FConnection.DelegateTo(
      function: TMongoWire
      begin
        result := TMongoWire.Create(FDatabase);
      end);

  end;

  if not FActive then
  begin
    SetDatabase(FDatabase);
    SetPort(FPort);
    SetPassword(FPassword);
    SetHost(FHost);
    SetUserName(FUserName);
  end;

  result := FConnection;
end;

procedure TMongoModelFactory.Delete(const ACollection: WideString;
const AWhere: IJSONDocument; ASingleRemove: Boolean);
begin
  OpenIfNeed.Delete(ACollection, AWhere, ASingleRemove);
end;

destructor TMongoModelFactory.Destroy;
begin
  if assigned(FConnection) then
  begin
    FConnection.DisposeOf;
    FConnection := nil;
  end;
  inherited;
end;

function TMongoModelFactory.Distinct(const ACollection, AKey: WideString;
const AQuery: IJSONDocument): Variant;
begin
  result := OpenIfNeed.Distinct(ACollection, AKey, AQuery);
end;

procedure TMongoModelFactory.EnsureIndex(const ACollection: WideString;
const AIndex, AOptions: IJSONDocument);
begin
  OpenIfNeed.EnsureIndex(ACollection, AIndex, AOptions);
end;

function TMongoModelFactory.Eval(const ACollection, AJSFn: WideString;
const AArgs: array of Variant; ANoLock: Boolean): Variant;
begin
  result := OpenIfNeed.Eval(ACollection, AJSFn, AArgs, ANoLock);
end;

function TMongoModelFactory.FillDastaset(Doc: IJSONDocArray; ADataset: TDataset;
AEventBoforePost: TProc): integer;
var
  i: integer;
  item: IJSONDocument;
begin
  if not ADataset.Active then
    ADataset.Active := true;

  ADataset.DisableControls;
  try
    for i := 0 to Doc.Count - 1 do
    begin
      item := TJSONDocument.JSON(Doc.item[i]);
      ADataset.append;
      ADataset.Fields.FillFromJson(item.ToString);
      if assigned(AEventBoforePost) then
        AEventBoforePost;
      ADataset.post;
    end;
    result := ADataset.RecordCount;
  finally
    ADataset.EnableControls;
  end;

end;

function TMongoModelFactory.Get(const ACollection: String;
const AWhere: IJSONDocument): IJSONDocument;
begin
  result := OpenIfNeed.Get(ACollection, AWhere) as IJSONDocument;
end;

function TMongoModelFactory.Get(const ACollection, AJsonWhere: string)
  : IJSONDocument;
begin
  result := Get(ACollection, JSON.Parse(AJsonWhere) as IJSONDocument);
end;

function TMongoModelFactory.GetActive: Boolean;
begin
  result := FActive;
end;

function TMongoModelFactory.GetDatabase: string;
begin
  result := FDatabase;
end;

function TMongoModelFactory.GetDataset(ACommand: IJSONDocument;
ADataset: TDataset; AEvent: TProc): integer;
var
  Doc: IJSONDocument;
  i: integer;
  item: IJSONDocument;
begin

  result := 0;
  OpenIfNeed;
  Doc := RunCommand(ACommand);

  if ADataset.FieldCount = 0 then
  begin
    { TODO: dinamics create fields }
  end;

  if not ADataset.Active then
    ADataset.Active := true;

  ADataset.DisableControls;
  try
    { for i := 0 to Doc.Count - 1 do
      begin
      item := TJSONDocument.JSON(Doc.item[i]);
      ADataset.append;
      ADataset.Fields.FillFromJson(item.ToString);
      if assigned(AEventBoforePost) then
      AEventBoforePost;
      ADataset.post;
      end;
    }
    result := ADataset.RecordCount;
  finally
    ADataset.EnableControls;
  end;

end;

function TMongoModelFactory.GetDataset(ACollection: string;
const AArrayWhere: array of IJSONDocument; ADataset: TDataset;
AEventBoforePost: TProc = nil): integer;
var
  Doc: IJSONDocArray;
  i: integer;
  item: IJSONDocument;
begin

  result := 0;
  OpenIfNeed;
  Doc := Query(ACollection, AArrayWhere);

  if ADataset.FieldCount = 0 then
  begin
    { TODO: dinamics create fields }
  end;

  result := FillDastaset(Doc, ADataset, AEventBoforePost);

end;

function TMongoModelFactory.GetHost: string;
begin
  result := FHost;
end;

function TMongoModelFactory.GetPassword: string;
begin
  result := FPassword;
end;

function TMongoModelFactory.GetPort: integer;
begin
  result := FPort;
end;

function TMongoModelFactory.GetUserName: string;
begin
  result := FUserName;
end;

function TMongoModelFactory.Host(AHost: String): IMongoModel;
begin
  result := self;
  SetHost(AHost);
end;

procedure TMongoModelFactory.Insert(const ACollection: WideString;
const ADocs: array of IJSONDocument);
begin
  OpenIfNeed.Insert(ACollection, ADocs);
end;

procedure TMongoModelFactory.Insert(const ACollection: WideString;
const ADoc: IJSONDocument);
begin
  OpenIfNeed.Insert(ACollection, ADoc);
end;

procedure TMongoModelFactory.Insert(const ACollection: WideString;
const ADocs: IJSONDocArray);
begin
  OpenIfNeed.Insert(ACollection, ADocs);
end;

function TMongoModelFactory.MongoConnection: TMongoWire;
begin
  result := Default.Adapter;
end;

class function TMongoModelFactory.New(AController: IController;
AConnection: TMongoWire): IMongoModel;
begin
  result := self.New(AController, '');
  with result.This do
  begin
    FConnection.SetInstance(AConnection, true);
  end;
end;

function TMongoModelFactory.NewQuery: IMongoQuery;
var
  r: TMVCBrAdapter<TMongoWireQuery>;
begin
  r := TMVCBrAdapter<TMongoWireQuery>.Create(nil);
  r.FreeOnExit := true;
  r.DelegateTo(
    function: TMongoWireQuery
    begin
      result := TMongoWireQuery.Create(FConnection.Adapter);
    end);
  result := r;
end;

procedure TMongoModelFactory.Open;
begin
  if not FActive then
    Active := true;
end;

function TMongoModelFactory.OpenIfNeed: TMongoWire;
begin
  self.Default;
  result := MongoConnection;
  if not Active then
    Open;
end;

class function TMongoModelFactory.New(AController: IController;
ADatabase: string): IMongoModel;
begin
  result := TMongoModelFactory.Create;
  result.Controller(AController);
  if ADatabase <> '' then
    result.SetDatabase(ADatabase);
end;

function TMongoModelFactory.Password(APass: string): IMongoModel;
begin
  result := self;
  SetPassword(APass);
end;

function TMongoModelFactory.Ping: Boolean;
begin
  result := MongoConnection.Ping;
end;

function TMongoModelFactory.Port(APort: integer): IMongoModel;
begin
  result := self;
  SetPort(APort);
end;

function TMongoModelFactory.Query(const ACollection: String;
const AWhere: IJSONDocument): IJSONDocArray;
var
  d: IJSONDocument;
  i: integer;
  q: TMongoWireQuery;
  r: TJSONDocArray;
begin
  d := JSON;
  OpenIfNeed;
  q := TMongoWireQuery.Create(MongoConnection);
  try
    r := TJSONDocArray.Create;
    with q do
    begin
      Query(ACollection, AWhere);
    end;
    while q.Next(d) do
    begin
      r.Add(d);
    end;
  finally
    q.free;
  end;
  result := r;
end;

function TMongoModelFactory.RunCommand(const ACmdObj: IJSONDocument)
  : IJSONDocument;
begin
  result := OpenIfNeed.RunCommand(ACmdObj);
end;

procedure TMongoModelFactory.SetActive(const Value: Boolean);
begin
  if not Value then
  begin
    if FActive then
      Default.Adapter.Close;
    FActive := false;
    exit;
  end;

  if (not FActive) and Value then
    with Default do
    begin
      Default.Adapter.Close;
      Adapter.Open(FHost, FPort);
      if not FActive then
      begin
        with Adapter do
        begin
          NameSpace := FDatabase;
          if (FUserName <> '') and (FPassword <> '') then
          begin
            MongoWireAuthenticate(Adapter, FUserName, FPassword);
          end;
        end;
      end;
      FActive := Value;
      exit;
    end;

end;

procedure TMongoModelFactory.SetDatabase(const Value: string);
begin
  FDatabase := Value;
end;

procedure TMongoModelFactory.SetHost(const Value: string);
begin
  FHost := Value;
end;

procedure TMongoModelFactory.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TMongoModelFactory.SetPort(const Value: integer);
begin
  FPort := Value;
end;

procedure TMongoModelFactory.SetUserName(const Value: string);
begin
  FUserName := Value;
end;

function TMongoModelFactory.This: TMongoModelFactory;
begin
  result := self;
end;

procedure TMongoModelFactory.Update(const ACollection: String;
const AWhere, ADoc: IJSONDocument; AUpsert, AMultiUpdate: Boolean);
begin
  OpenIfNeed.Update(ACollection, AWhere, ADoc, AUpsert, AMultiUpdate);
end;

function TMongoModelFactory.UserName(AUser: string): IMongoModel;
begin
  result := self;
  SetUserName(AUser);
end;

{ TJSONDocument }

class function TJSONDocument.New: IJSONDocument;
begin
  result := TJSONDocument.Create;
end;

class function TJSONDocument.AsArray(item: Variant): IJSONArray;
begin
  result := ja(item);
end;

class function TJSONDocument.BsonToJson(Doc: IBSONDocument): WideString;
begin
  result := bsonUtils.BsonToJson(Doc);
end;

class function TJSONDocument.JSON(const x: Variant): IJSONDocument;
begin
  result := MongoJSON(x);
end;

class function TJSONDocument.New(const x: array of Variant): IJSONDocument;
begin
  result := JsonDoc.JSON(x);
end;

class function TJSONDocument.NewDocArray: IJSONDocArray;
begin
  result := JSONDocArray;
end;

class function TJSONDocument.ToDocArray(Doc: IJSONDocument): IJSONDocArray;
begin
  result := JSONDocArray;
  result.Add(Doc);
end;

function TJSONDocument.ToJson: String;
begin
  result := ToString;
end;

{ TJSONDocArray }

class function TJSONDocArray.New: IJSONDocArray;
begin
  result := TJSONDocArray.Create;
end;

// System.Json.Helper;
function TMongoModelFactory.Query(const ACollection: String;
const AArrayWhere: array of IJSONDocument): IJSONDocArray;
var
  j: TJsonObject;
  i: integer;
  v: TJsonObject;
  p: TJsonPair;
  s: string;
begin
  j := TJsonObject.Create;
  try
    for i := low(AArrayWhere) to high(AArrayWhere) do
    begin
      try
        s := AArrayWhere[i].ToString;
        v := TJsonObject.ParseJSONValue(s) as TJsonObject;
        for p in v do
          j.AddPair(p);
      finally
      end;
    end;
    result := Query(ACollection, JSON.Parse(j.ToJson));
  finally
    j.free;
  end;
end;

function TMongoModelFactory.QueryRegEx(ACollection, AField, AText: String)
  : IJSONDocArray;
begin
  result := Query(ACollection, TMongoExpression.like(AField, AText));
end;

function TMongoModelFactory.GetSequence(FCollection,
  AMongoCampo: string): Int64;
Var
  d, dChave, e: IJSONDocument; // Obj BSON
  j: TJsonObject; // Obj JSON
  sField, sComand_Save, sComand_Modify: TStringBuilder;
  sCollectionSeq, sCollectionField: string;
  iRetorno: Int64;
begin
  // -- Gerando o Sequence para o AutoIncremento
  sField := TStringBuilder.Create;
  sComand_Save := TStringBuilder.Create;
  sComand_Modify := TStringBuilder.Create;
  j := TJsonObject.Create;
  try
    sComand_Save.clear;
    sComand_Modify.clear;
    sField.clear;
    sField.append('_id_').append(AnsiLowerCase(AMongoCampo));

    sCollectionSeq := '_sequence';
    sCollectionField := '_id';

    sComand_Save.append('{ findAndModify: "').append(sCollectionSeq)
      .append('", query: { ').append(sCollectionField).append(': "')
      .append(FCollection).append('" }, update: {').append(sCollectionField)
      .append(': "').append(FCollection).append('", ').append(sField.ToString)
      .append(': 0 }, upsert:true }');

    sComand_Modify.append('{ findAndModify: "').append(sCollectionSeq)
      .append('", query: { ').append(sCollectionField).append(': "')
      .append(FCollection).append('" }, update: { $inc: { ')
      .append(sField.ToString).append(': 1 } }, new:true }');

    j.AddPair(sCollectionField, TJSONString.Create(FCollection));
    dChave := JSON.Parse(j.ToJson);

    try
      d := Get(sCollectionSeq, dChave);
      iRetorno := StrToInt64(d[sField.ToString]);
    except
      d := JSON.Parse(sComand_Save.ToString);
      e := RunCommand(d);
    end;
    try
      d := JSON.Parse(sComand_Modify.ToString);
      e := RunCommand(d);

      // result := StrToInt(VarToStr(BSON(e['value'])[sField.ToString]));
      result := StrToInt(sField.ToString);

    except
      result := -1;
      raise EMongoException.Create
        ('Mongo: não foi possível gerar o AutoIncremento.');
    end;
  finally
    sField.free;
    sComand_Save.free;
    sComand_Modify.free;
    j.free;
  end;
end;

{ TMongoExpression }

class function TMongoExpression.between(AField: string; AFrom, ATo: Variant)
  : IJSONDocument;
begin
  result := JSON([AField, JSON(['$gte', AFrom, '$lte', ATo])]);
end;

class function TMongoExpression.contains(AField, AText: string;
AOptions: String = 'i'): IJSONDocument;
begin
  result := JSON([AField, JSON(['$regex', bsonRegExPrefix + '/' + AText,
    '$options', AOptions])])
end;

class function TMongoExpression.eq(AField: string; AValue: Variant)
  : IJSONDocument;
begin
  result := JSON([AField, JSON(['$eq', AValue])]);
end;

class function TMongoExpression.gt(AField: string; AValue: Variant)
  : IJSONDocument;
begin
  result := JSON([AField, JSON(['$gt', AValue])]);
end;

class function TMongoExpression.gte(AField: string; AValue: Variant)
  : IJSONDocument;
begin
  result := JSON([AField, JSON(['$gte', AValue])]);

end;

class function TMongoExpression.lt(AField: string; AValue: Variant)
  : IJSONDocument;
begin
  result := JSON([AField, JSON(['$lt', AValue])]);
end;

class function TMongoExpression.lte(AField: string; AValue: Variant)
  : IJSONDocument;
begin
  result := JSON([AField, JSON(['$lte', AValue])]);
end;

class function TMongoExpression.ne(AField: string; AValue: Variant)
  : IJSONDocument;
begin
  result := JSON([AField, JSON(['$ne', AValue])]);

end;

class function TMongoExpression.search(AField: string; AString: string)
  : IJSONDocument;
begin
  result := JSON([AField, JSON(['$search', AString])]);
end;

class function TMongoExpression.like(AField, AText: string;
AOptions: String = 'i'): IJSONDocument;
begin
  result := JSON([AField, JSON(['$regex', bsonRegExPrefix + '/^' + AText,
    '$options', AOptions])])
end;

end.
