{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.ServiceModel;

interface

Uses System.Classes, System.SysUtils, System.JSON, oData.JSON,
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

  TJsonODataServiceRelation = class(TInterfacedJsonObject,
    IJsonODataServiceRelation)
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

  TJsonODataServiceRelations = class(TInterfacedJsonObject,
    IJsonODataServiceRelations)
  public
    class function New(AJson: TJsonValue): IJsonODataServiceRelations;
    function resource(AName: string): IJsonODataServiceRelation;
  end;

  IJsonODataServiceExpand = interface(IJsonObject)
    ['{D010F6F6-D4D0-47DF-AD8D-701085DDA22F}']
  end;

  TJsonODataServiceExpand = class(TInterfacedJsonObject,
    IJsonODataServiceExpand)
  public
    class function New(AJson: TJsonValue): IJsonODataServiceExpand;
    function resource: string;
    function filter: string;
  end;

  IJsonODataServiceExpands = interface(IJsonObject)
    ['{04CE6D28-A21A-4A21-8FFB-A9FC8C245064}']
  end;

  TJsonODataServiceExpands = class(TInterfacedJsonObject,
    IJsonODataServiceExpands)
    class function New(AJson: TJsonValue): IJsonODataServiceExpands;
    function expand(AName: string): IJsonODataServiceExpand;
  end;

  IJsonODataServiceResource = interface(IJsonObject)
    ['{F78C1EEF-24B4-49CD-BA33-0BEB7F7F98F9}']
    function resource: string;
    function collection: string;
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

  TJsonODastaServiceResource = class(TInterfacedJsonObject,
    IJsonODataServiceResource)
  private
    FPrimaryKey: string;
    procedure SetPrimaryKey(const Value: string);
    function GetPrimaryKey: string;
  public
    class function New(AJson: TJsonValue): IJsonODataServiceResource;
    function resource: string;
    function collection: string;
    function fields: string;
    function keyID: string;
    function method: string;
    function searchFields: string;
    function maxpagesize: integer;
    function relations: IJsonODataServiceRelations;
    function relation(AName: string): IJsonODataServiceRelation;
    function Expands: IJsonODataServiceExpands;
    function Expand(AName: string): IJsonODataServiceExpand;
    function &join: string;
    property primaryKey: string read GetPrimaryKey write SetPrimaryKey;

  end;

  IODataServices = interface
    ['{051E22D6-6BB1-4C35-A1DA-9885360283CD}']
    procedure LoadFromJsonFile(AJson: String);
    function resource(AName: string): IJsonODataServiceResource;
    function hasResource(AName: String): boolean;
    function LockJson: TJsonObject;
    procedure UnlockJson;
    function ResourceList: TJsonArray;
    procedure reload;
  end;

  TODataServices = class(TInterfacedObject, IODataServices)
  private
    FLock: TObject;
    FFileJson: string;
    FJson: TJsonObject;

  const
    root: string = 'OData.Services';
  public
    constructor create; virtual;
    destructor destroy; override;
    function LockJson: TJsonObject; virtual;
    procedure UnlockJson; virtual;
    procedure LoadFromJsonFile(AJson: String);
    function hasResource(AName: String): boolean; virtual;
    function resource(AName: string): IJsonODataServiceResource; virtual;

    function ResourceList: TJsonArray;
    function GetRoot: TJsonArray;
    procedure reload;
  end;

var
  ODataServices: IODataServices;

implementation

// uses VCL.Dialogs;
{ TODataServices }

constructor TODataServices.create;
begin
  inherited;
  FLock := TObject.create;
end;

destructor TODataServices.destroy;
begin
  FreeAndNil(FJson);
  FreeAndNil(FLock);
  inherited;
end;

function TODataServices.GetRoot: TJsonArray;
begin
  with LockJson do
    try
      result := GetValue(root) as TJsonArray;
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
  try
    if assigned(jr) then
      with LockJson do
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

procedure TODataServices.LoadFromJsonFile(AJson: String);
var
  str: TStringList;
begin
  try
    FFileJson := AJson;
    FreeAndNil(FJson);
    str := TStringList.create;
    try
      if fileExists(AJson) then
      begin
        str.LoadFromFile(AJson);
        FJson := TJsonObject.ParseJSONValue(str.Text) as TJsonObject;
        if not assigned(FJson) then
          raise Exception.create
            ('Metadata inválido, revisar o JSON do metadata');
      end
      else
      begin
        FJson := TJsonObject.create;
        FJson.addPair('erro', 'Cand find oData Service <' + AJson + '>');
      end;

      with FJson do
      begin
        addPair('suports.$filter', 'yes');
        addPair('suports.$select', 'yes');
        addPair('suports.groupby', 'yes');
        addPair('suports.$orderby', 'yes');
        addPair('suports.$format', 'json');
        addPair('suports.$top', 'yes');
        addPair('suports.$skip', 'yes');
        addPair('suports.$inlinecount', 'yes');
        addPair('suports.$skiptoken', 'no');
        addPair('odata.ServiceFile', AJson);
      end;

    finally
      str.Free;
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

procedure TODataServices.reload;
begin
  LoadFromJsonFile(FFileJson);
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
              result := TJsonODastaServiceResource.New(it as TJsonObject);
              exit;
            end;
          end;
        end;
      end;
    finally
      UnlockJson;
    end;
  if not assigned(jr) then
    raise Exception.create('Não encontrei o root "' + root +
      '" para os resources');
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

procedure TODataServices.UnlockJson;
begin
  System.TMonitor.exit(FLock);
end;

{ TJsonResource }

function TJsonODastaServiceResource.collection: string;
begin
  JSON.TryGetValue<string>('collection', result);
end;

function TJsonODastaServiceResource.Expand(
  AName: string): IJsonODataServiceExpand;
var
  r: IJsonODataServiceExpands;
  rst: TJsonValue;
  it: TJsonValue;
  ja: TJsonArray;
  s: String;
begin
  result := nil;
  r := expands;
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

function TJsonODastaServiceResource.Expands: IJsonODataServiceExpands;
var
  jo: TJsonValue;
  jv: TJsonValue;
begin
  result := nil;
  jv := JSON.GetValue<TJsonValue>('expands');
  jo := TJsonObject.ParseJSONValue(jv.ToJSON);
  if assigned(jo) then
  begin
    result := TJsonODataServiceExpands.New(jo);
  end;
end;

function TJsonODastaServiceResource.fields: string;
begin
  JSON.TryGetValue<string>('fields', result);
end;

function TJsonODastaServiceResource.GetPrimaryKey: string;
begin
  result := FPrimaryKey;
end;

function TJsonODastaServiceResource.join: string;
begin
  JSON.TryGetValue<string>('join', result);
end;

function TJsonODastaServiceResource.keyID: string;
begin
  JSON.TryGetValue<string>('keyID', result);
end;

function TJsonODastaServiceResource.maxpagesize: integer;
begin
  if not JSON.TryGetValue<integer>('maxpagesize', result) then
    result := 0;
end;

function TJsonODastaServiceResource.method: string;
begin
  JSON.TryGetValue<string>('method', result);
end;

class function TJsonODastaServiceResource.New(AJson: TJsonValue)
  : IJsonODataServiceResource;
var
  j: TJsonODastaServiceResource;
begin
  j := TJsonODastaServiceResource.create;
  j.FJson := AJson;
  result := j;

end;

function TJsonODastaServiceResource.relation(AName: string)
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

function TJsonODastaServiceResource.relations: IJsonODataServiceRelations;
var
  jo: TJsonValue;
  jv: TJsonValue;
begin
  result := nil;
  jv := JSON.GetValue<TJsonValue>('relations');
  jo := TJsonObject.ParseJSONValue(jv.ToJSON);
  if assigned(jo) then
  begin
    result := TJsonODataServiceRelations.New(jo);
  end;
end;

function TJsonODastaServiceResource.resource: string;
begin
  JSON.TryGetValue<string>('resource', result);
end;

function TJsonODastaServiceResource.searchFields: string;
begin
  JSON.TryGetValue<string>('searchFields', result);
end;

procedure TJsonODastaServiceResource.SetPrimaryKey(const Value: string);
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

class function TJsonODataServiceExpand.New(
  AJson: TJsonValue): IJsonODataServiceExpand;
begin

end;

function TJsonODataServiceExpand.resource: string;
begin
  JSON.TryGetValue<string>('resource', result);
end;

{ TJsonODataServiceExpands }

function TJsonODataServiceExpands.expand(
  AName: string): IJsonODataServiceExpand;
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

class function TJsonODataServiceExpands.New(
  AJson: TJsonValue): IJsonODataServiceExpands;
begin

end;

initialization

ODataServices := TODataServices.create;
try
  ODataServices.LoadFromJsonFile(ExtractFilePath(ParamStr(0)) +
    'oData.ServiceModel.json');
except
end;

end.
