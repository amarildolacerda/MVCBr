{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.ServiceModel;

interface

Uses System.Classes, System.SysUtils, System.JSON, System.JSON.Helper,
  oData.Interf,
  System.Generics.Collections;

type

  IJsonODataServiceRelation = interface(IJsonObject)
    ['{9AFBD592-E0FE-488F-96E8-44B7551E528C}']
    function resource: string;
    function sourceKey: string;
    function targetKey: string;
    function join: string;
  end;

  TJsonODataServiceRelation = class(TInterfacedJson, IJsonODataServiceRelation)
  public
    class function New(AJson: TJsonValue): IJsonODataServiceRelation;
    function resource: string;
    function sourceKey: string;
    function targetKey: string;
    function join: string;
  end;

  IJsonODataServiceRelations = interface(IJsonObject)
    ['{307129D3-0E66-4BDE-BC65-146A0FD434C6}']
  end;

  TJsonODataServiceRelations = class(TInterfacedJson,
    IJsonODataServiceRelations)
  public
    class function New(AJson: TJsonValue): IJsonODataServiceRelations;
    function resource(AName: string): IJsonODataServiceRelation;
  end;

  IJsonODataServiceExpand = interface(IJsonObject)
    ['{D010F6F6-D4D0-47DF-AD8D-701085DDA22F}']
  end;

  TJsonODataServiceExpand = class(TInterfacedJson, IJsonODataServiceExpand)
  public
    class function New(AJson: TJsonValue): IJsonODataServiceExpand;
    function resource: string;
    function filter: string;
  end;

  IJsonODataServiceExpands = interface(IJsonObject)
    ['{04CE6D28-A21A-4A21-8FFB-A9FC8C245064}']
  end;

  TJsonODataServiceExpands = class(TInterfacedJson, IJsonODataServiceExpands)
    class function New(AJson: TJsonValue): IJsonODataServiceExpands;
    function expand(AName: string): IJsonODataServiceExpand;
  end;

  IJsonODataServiceResource = interface(IJsonObject)
    ['{F78C1EEF-24B4-49CD-BA33-0BEB7F7F98F9}']
    function resource: string;
    function collection: string;
    function Roles: string;
    function &fields: string;
    function keyID: string;
    function GetPrimaryKey: string;
    procedure SetPrimaryKey(const AKeys: string);
    property primaryKey: string read GetPrimaryKey write SetPrimaryKey;
    function method: string;
    function searchFields: string;
    function relations: IJsonODataServiceRelations;
    function maxpagesize: integer;
    function relation(AName: string): IJsonODataServiceRelation;
    function &join: string;
    function Expands: IJsonODataServiceExpands;
  end;

  TJsonODataServiceResource = class(TInterfacedJson, IJsonODataServiceResource)
  private
    FPrimaryKey: string;
    procedure SetPrimaryKey(const Value: string);
    function GetPrimaryKey: string;
  public
    class function New(AJson: TJsonValue;AOwned: boolean = true): IJsonODataServiceResource;
    function resource: string;
    function collection: string;
    function fields: string;
    function keyID: string;
    function method: string;
    function Roles: string;
    function searchFields: string;
    function maxpagesize: integer;
    function relations: IJsonODataServiceRelations;
    function relation(AName: string): IJsonODataServiceRelation;
    function Expands: IJsonODataServiceExpands;
    function expand(AName: string): IJsonODataServiceExpand;
    function &join: string;
    property primaryKey: string read GetPrimaryKey write SetPrimaryKey;

  end;

  TODataServices = class;

  IODataServices = interface
    ['{051E22D6-6BB1-4C35-A1DA-9885360283CD}']
    procedure LoadFromJsonFile(AJson: String);
    procedure SaveToJsonFile(AJson: string);
    function resource(AName: string): IJsonODataServiceResource;
    function hasResource(AName: String): boolean;
    function LockJson: TJsonObject;
    procedure UnlockJson;
    function ResourceList: TJsonArray;
    procedure reload;
    procedure RegisterResource(AResource: string; ACollection: string;
      AKeyID: string; AMaxPageSize: integer; AFields: String; AJoin: String;
      AMethod: String; ARelations: TJsonValue);
    function This: TODataServices;
    procedure Clear;
  end;

  TODataServices = class(TInterfacedObject, IODataServices)
  private
    FLock: TObject;
    FFileJson: string;
    FJson: TJsonObject;
    procedure LoadFromJsonFile(AJson: String);
    procedure SaveToJsonFile(AJson: string);
    procedure EndJson;

  const
    root: string = 'OData.Services';
  public
    constructor create; virtual;
    destructor destroy; override;
    function LockJson: TJsonObject; virtual;
    procedure UnlockJson; virtual;
    class function TryGetODataService(Js: TJsonObject; out res: TJsonArray)
      : boolean; static;
    procedure Clear;
    function This: TODataServices;
    function hasResource(AName: String): boolean; virtual;
    function resource(AName: string): IJsonODataServiceResource; virtual;

    function ResourceList: TJsonArray;
    function GetRoot: TJsonArray;
    class function ExpandFilePath(APath: string): string;
    procedure reload;
    procedure RegisterResource(AResource: string; ACollection: string;
      AKeyID: string; AMaxPageSize: integer; AFields: String; AJoin: String;
      AMethod: String; ARelations: TJsonValue);
    class procedure Invalidate;
  end;

function RegisterODataCustomServiceLoad(AProc: TProc;
  ASubstituir: boolean = true): boolean;

var
  ODataServices: IODataServices;

implementation

uses System.IOUtils;
// uses VCL.Dialogs;
{ TODataServices }

var
  ODataConfig: string;

var
  FoDataServiceCustomLoad: TProc;

function RegisterODataCustomServiceLoad(AProc: TProc;
  ASubstituir: boolean = true): boolean;
begin
  result := false;
  if (not ASubstituir) and assigned(FoDataServiceCustomLoad) then
    exit;
  FoDataServiceCustomLoad := AProc;
  result := true;
end;

procedure TODataServices.Clear;
begin
  FFileJson := '';
  freeAndNil(FJson);
end;

constructor TODataServices.create;
begin
  inherited;
  FLock := TObject.create;
end;

class function TODataServices.TryGetODataService(Js: TJsonObject;
  out res: TJsonArray): boolean;
var
  p: TJsonPair;
begin
  result := false;
  for p in Js do
    if p.JsonString.Value.Equals('OData.Services') then
    begin
      res := p.JsonValue.AsArray;
      result := true;
      exit;
    end;
end;

destructor TODataServices.destroy;
var
  j: TJsonPair;
  function RemoveObject(JSON: TJsonPair): boolean;
  var
    jArr: TJsonArray;
    arr: TJsonValue;
    o: TObject;
  begin
    result := false;
    if JSON.JsonValue is TJsonArray then
    begin
      jArr := JSON.JsonValue as TJsonArray;
      while jArr.Count > 0 do
      begin
        try
          o := jArr.Items[0];
          jArr.Remove(0);
          if o is TJsonArray then
            RemoveObject(o as TJsonPair);
          o.free;
        except
        end;
      end;
      result := true;
    end;
  end;

begin
  for j in FJson do
  begin
    RemoveObject(j);
  end;
  freeAndNil(FJson);
  freeAndNil(FLock);
  inherited;
end;

class function TODataServices.ExpandFilePath(APath: string): string;
var
  old: String;
begin
  old := ODataConfig;
  if APath <> '' then
    SetODataConfigFilePath(APath);
  ODataConfig := GetODataConfigFilePath + 'oData.ServiceModel.json';
  result := ODataConfig;
  if result <> old then
  begin
    ODataServices.This.LockJson;
    try
      ODataServices.Clear;
      ODataServices.LoadFromJsonFile(result);
      ODataServices.This.EndJson;
    finally
      ODataServices.This.UnlockJson;
    end;
  end;
end;

function TODataServices.GetRoot: TJsonArray;
var
  j: TJsonValue;
begin
  result := nil;
  with LockJson do
    try
      j := GetValue(root);
      if assigned(j) then
        result := j as TJsonArray;
    finally
      UnlockJson;
    end;
end;

function TODataServices.hasResource(AName: String): boolean;
var
  jr: TJsonArray;
  it: TJsonValue;
  LValue: String;
begin
  result := false;
  jr := GetRoot;
  with LockJson do
    try
      if assigned(jr) then
      begin
        for it in jr do
        begin
          if it.TryGetValue<string>('resource', LValue) then
          begin
            result := LValue = AName;
            if result then
              exit;
          end;
        end;
      end;
    finally
      UnlockJson;
    end;
end;

class procedure TODataServices.Invalidate;
var
  old: String;
begin
  old := ExtractFilePath(ODataConfig);
  ODataConfig := '';
  self.ExpandFilePath(old);
end;

procedure TODataServices.LoadFromJsonFile(AJson: String);
var
  str: TStringList;
  LJson: TJsonObject;
  LServiceLocal: TJsonArray;
  LImport: TJsonArray;
  jv: TJsonValue;
  jvService: TJsonValue;
  LServiceMain: TJsonArray;
  achei: boolean;
  pair: TJsonPair;
  LPath, s: String;
  LElement: TJsonValue;
  obj:TObject;
begin
  try
    if not assigned(FJson) then
    begin
      FJson := TJsonObject.create;
      FFileJson := AJson;
    end;
    str := TStringList.create;
    try
      if fileExists(AJson) then
      begin
        LPath := ExtractFilePath(AJson);
        str.LoadFromFile(AJson);
        LJson := TJsonObject.ParseJSONValue(str.Text) as TJsonObject;
        try
          if not assigned(FJson) then
            raise Exception.create('Metadata inv�lido <' + AJson +
              '>, revisar o JSON do metadata');
          if LJson.TryGetValue<TJsonArray>('import', LImport) then
          begin
            obj := LJson.RemovePair('import');
          end;
          if not TryGetODataService(FJson, LServiceMain) then
          begin
            freeAndNil(FJson);
            FJson := TJsonObject.ParseJSONValue(LJson.toJson) as TJsonObject;
          end
          else
          begin
            if TryGetODataService(LJson, LServiceLocal) then
              for jv in LServiceLocal do
              begin // carregar;
                achei := false;
                for jvService in LServiceMain do
                begin
                  if jvService.s('resource').Equals(jv.s('resource')) then
                  begin
                    achei := true;
                    break;
                  end;
                end;
                if not achei then
                begin
                  LElement := TJsonObject.ParseJSONValue(jv.toJson);
                  LElement.owned := true;
                  (LServiceMain).AddElement(LElement);
                  // adiciona item importado
                end;
              end;
          end;
          if assigned(LImport) then
            for jv in LImport do
            begin
              s := TPath.Combine(LPath, jv.Value.replace('/',
                TPath.DirectorySeparatorChar));
              LoadFromJsonFile(s);
            end;
        finally
          freeAndNil(obj);
          freeAndNil(LJson);
        end;
      end;

    finally
      str.free;
    end;
  except
    on e: Exception do
    begin
      // showMessage('Cant load services (' + AJson + ')');
      raise Exception.create('Cant load services (' + AJson + ') /*' +
        e.message + '*/');
    end;
  end;
end;

function TODataServices.LockJson: TJsonObject;
begin
  System.TMonitor.Enter(FLock);
  result := FJson;
end;

procedure TODataServices.RegisterResource(AResource, ACollection,
  AKeyID: string; AMaxPageSize: integer; AFields, AJoin, AMethod: String;
  ARelations: TJsonValue);
var
  LServices: TJsonArray;
  LResource: TJsonObject;
begin
  if hasResource(AResource) then
    exit;
  LServices := GetRoot;
  if not assigned(LServices) then
    exit;
  LResource := TJsonObject.create as TJsonObject;
  try
    LResource.addPair('resource', AResource);
    LResource.addPair('collection', ACollection);
    LResource.addPair('keyID', AKeyID);
    LResource.addPair('maxpagesize', AMaxPageSize);
    LResource.addPair('fields', AFields);
    LResource.addPair('join', AJoin);
    LResource.addPair('method', AMethod);
    LResource.addPair('roles', 'NONE');
    if assigned(ARelations) then
      LResource.addPair('relation', ARelations);
  finally
    LockJson;
    try
      LServices.Add(LResource);
    finally
      UnlockJson;
    end;
  end;
end;

procedure TODataServices.EndJson;
begin

  if assigned(FoDataServiceCustomLoad) then
    FoDataServiceCustomLoad;

  with FJson do
  begin
    addPair('supports.$filter', 'yes');
    addPair('supports.$select', 'yes');
    addPair('supports.groupby', 'yes');
    addPair('supports.$orderby', 'yes');
    addPair('supports.$format', 'json');
    addPair('supports.$top', 'yes');
    addPair('supports.$skip', 'yes');
    addPair('supports.$inlinecount', 'yes');
    addPair('supports.$skiptoken', 'no');
    addPair('odata.ServiceFile', FFileJson);
  end;

end;

procedure TODataServices.reload;
begin
  LockJson;
  try
    ODataConfig := GetODataConfigFilePath + 'oData.ServiceModel.json';
    Clear;
    LoadFromJsonFile(FFileJson);
    EndJson;
  finally
    UnlockJson;
  end;
end;

function TODataServices.resource(AName: string): IJsonODataServiceResource;
var
  jr: TJsonArray;
  it: TJsonValue;
  LValue: String;
begin
  result := nil;
  with LockJson do
    try
      jr := GetValue(root) as TJsonArray;
      if assigned(jr) then
      begin
        for it in jr do
        begin
          if it.TryGetValue<string>('resource', LValue) then
          begin
            if LValue = AName then
            begin
              result := TJsonODataServiceResource.create(it.toJson, true);
              exit;
            end;
          end;
        end;
      end;
    finally
      UnlockJson;
    end;
  if not assigned(jr) then
    raise Exception.create('N�o encontrei o root "' + root +
      '" para os resources em: ' + FFileJson);
end;

function TODataServices.ResourceList: TJsonArray;
var
  rt: TJsonArray;
  it: TJsonValue;
  arr: TJsonArray;
  jv: TJsonObject;
  s: string;
begin
  rt := GetRoot;
  arr := TJsonArray.create;
  for it in rt do
  begin
    s := it.GetValue<string>('resource');
    jv := TJsonObject.create;
    jv.addPair('resource', s);
    arr.AddElement(jv);
  end;
  result := arr;
end;

procedure TODataServices.SaveToJsonFile(AJson: string);
begin
  FJson.SaveToFile(AJson);
end;

function TODataServices.This: TODataServices;
begin
  result := self;
end;

procedure TODataServices.UnlockJson;
begin
  System.TMonitor.exit(FLock);
end;

{ TJsonResource }

function TJsonODataServiceResource.collection: string;
begin
  JSON.TryGetValue<string>('collection', result);
end;

function TJsonODataServiceResource.expand(AName: string)
  : IJsonODataServiceExpand;
var
  r: IJsonODataServiceExpands;
  rst: TJsonValue;
  it: TJsonValue;
  ja: TJsonArray;
  s: String;
begin
  result := nil;
  r := Expands;
  if assigned(r) then
  begin
    ja := r.JSON as TJsonArray;
    for it in ja do
    begin
      it.TryGetValue<string>('resource', s);
      if s = AName then
      begin
        result := TJsonODataServiceExpand.New(it);
        exit;
      end;
    end;
  end;
end;

function TJsonODataServiceResource.Expands: IJsonODataServiceExpands;
var
  jo: TJsonValue;
  jv: TJsonValue;
begin
  result := nil;
  jv := JSON.GetValue<TJsonValue>('expands');
  jo := TJsonObject.ParseJSONValue(jv.toJson);
  if assigned(jo) then
  begin
    result := TJsonODataServiceExpands.New(jo);
  end;
end;

function TJsonODataServiceResource.fields: string;
begin
  JSON.TryGetValue<string>('fields', result);
end;

function TJsonODataServiceResource.GetPrimaryKey: string;
begin
  result := FPrimaryKey;
end;

function TJsonODataServiceResource.join: string;
begin
  JSON.TryGetValue<string>('join', result);
end;

function TJsonODataServiceResource.keyID: string;
begin
  JSON.TryGetValue<string>('keyID', result);
end;

function TJsonODataServiceResource.maxpagesize: integer;
begin
  if not JSON.TryGetValue<integer>('maxpagesize', result) then
    result := 0;
end;

function TJsonODataServiceResource.method: string;
begin
  JSON.TryGetValue<string>('method', result);
end;

class function TJsonODataServiceResource.New(AJson: TJsonValue;
  AOwned: boolean = true): IJsonODataServiceResource;
var
  j: TJsonODataServiceResource;
begin
  j := TJsonODataServiceResource.create(AJson.ToString,AOWned);
  result := j;
end;

function TJsonODataServiceResource.relation(AName: string)
  : IJsonODataServiceRelation;
var
  r: IJsonODataServiceRelations;
  rst: TJsonValue;
  it: TJsonValue;
  ja: TJsonArray;
  s: String;
begin
  result := nil;
  r := relations;
  if assigned(r) then
  begin
    ja := r.JSON as TJsonArray;
    for it in ja do
    begin
      it.TryGetValue<string>('resource', s);
      if s = AName then
      begin
        result := TJsonODataServiceRelation.New(it);
        exit;
      end;
    end;
  end;
end;

function TJsonODataServiceResource.relations: IJsonODataServiceRelations;
var
  jo: TJsonValue;
  jv: TJsonValue;
begin
  result := nil;
  jv := JSON.GetValue<TJsonValue>('relations');
  jo := TJsonObject.ParseJSONValue(jv.toJson);
  if assigned(jo) then
  begin
    result := TJsonODataServiceRelations.New(jo);
  end;
end;

function TJsonODataServiceResource.resource: string;
begin
  JSON.TryGetValue<string>('resource', result);
end;

function TJsonODataServiceResource.Roles: string;
begin
  JSON.TryGetValue<string>('roles', result);
end;

function TJsonODataServiceResource.searchFields: string;
begin
  JSON.TryGetValue<string>('searchFields', result);
end;

procedure TJsonODataServiceResource.SetPrimaryKey(const Value: string);
begin
  FPrimaryKey := Value;
end;

{ TJsonODataServiceRelation }

function TJsonODataServiceRelation.join: string;
begin
  JSON.TryGetValue<string>('join', result);
end;

class function TJsonODataServiceRelation.New(AJson: TJsonValue)
  : IJsonODataServiceRelation;
var
  j: TJsonODataServiceRelation;
begin
  j := TJsonODataServiceRelation.create;
  j.FJson := AJson;
  result := j;
end;

function TJsonODataServiceRelation.resource: string;
begin
  JSON.TryGetValue<string>('resource', result);
end;

function TJsonODataServiceRelation.sourceKey: string;
begin
  JSON.TryGetValue<string>('sourceKey', result);

end;

function TJsonODataServiceRelation.targetKey: string;
begin
  JSON.TryGetValue<string>('targetKey', result);
end;

{ TJsonODataServiceRelations }

class function TJsonODataServiceRelations.New(AJson: TJsonValue)
  : IJsonODataServiceRelations;
var
  j: TJsonODataServiceRelations;
begin
  j := TJsonODataServiceRelations.create;
  j.FJson := AJson;
  result := j;
end;

function TJsonODataServiceRelations.resource(AName: string)
  : IJsonODataServiceRelation;
var
  arr: TJsonArray;
  it: TJsonValue;
  jo: TJsonObject;
  rs: string;
begin
  arr := AsArray;
  result := nil;
  if assigned(arr) then
    for it in arr do
    begin
      if it.TryGetValue<string>('resource', rs) then
      begin
        if rs = AName then
        begin
          result := TJsonODataServiceRelation.New(it as TJsonObject);
          exit;
        end;
      end;
    end;
end;

{ TJsonODataServiceExpand }

function TJsonODataServiceExpand.filter: string;
begin
  JSON.TryGetValue<string>('filter', result);
end;

class function TJsonODataServiceExpand.New(AJson: TJsonValue)
  : IJsonODataServiceExpand;
begin

end;

function TJsonODataServiceExpand.resource: string;
begin
  JSON.TryGetValue<string>('resource', result);
end;

{ TJsonODataServiceExpands }

function TJsonODataServiceExpands.expand(AName: string)
  : IJsonODataServiceExpand;
var
  arr: TJsonArray;
  it: TJsonValue;
  jo: TJsonObject;
  rs: string;
begin
  arr := AsArray;
  result := nil;
  if assigned(arr) then
    for it in arr do
    begin
      if it.TryGetValue<string>('resource', rs) then
      begin
        if rs = AName then
        begin
          result := TJsonODataServiceExpand.New(it as TJsonObject);
          exit;
        end;
      end;
    end;
end;

class function TJsonODataServiceExpands.New(AJson: TJsonValue)
  : IJsonODataServiceExpands;
begin

end;

initialization

ODataServices := TODataServices.create;
TODataServices.ExpandFilePath('');

finalization

ODataServices := nil;

end.
