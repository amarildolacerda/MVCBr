{

  Amarildo Lacerda
  12/03/2017

  TODataBuilder - Delphi IDE component

}
unit oData.Comp.Client;

interface

uses System.Classes, System.RTTI, System.SysUtils, System.Generics.Collections,
  Data.DB,
  MVCBr.idHTTPRestClient,
  oData.Client.Builder;

Type

  TODataResouceParam = Class(TCollectionItem)
  private
    FName: string;
    FValue: string;
    FDatatype: TFieldType;
    procedure SetName(const Value: string);
    procedure SetValue(const Value: string);
    procedure SetDatatype(const Value: TFieldType);
  published
    property Name: string read FName write SetName;
    property Value: string read FValue write SetValue;
    property Datatype: TFieldType read FDatatype write SetDatatype;
  end;

  TODataResourceParams = class(TCollection)
  private
    FOwner: TComponent;
  public
    constructor create(AOwner: TComponent);
    function GetOwner: TPersistent; override;
  end;

  TODataResourceItem = class(TCollectionItem)
  private
    FResource: string;
    FResourceParams: TODataResourceParams;
    procedure SetResource(const Value: string);
    procedure SetResourceParams(const Value: TODataResourceParams);
  protected
    FOwner: TComponent;
  public
    constructor create(AItems: TCollection); override;
    destructor destroy; override;
    function AddParam(AName: String; AValue: TValue): TODataResouceParam;
  published
    property Resource: string read FResource write SetResource;
    property ResourceParams: TODataResourceParams read FResourceParams
      write SetResourceParams;
  end;

  TODataResourceItems = class(TCollection)
  private
    FOwner: TComponent;
  public
    function Add: TODataResourceItem;
    constructor create(AOwner: TComponent);
    procedure addResource(tx: String);
    function GetOwner: TPersistent; override;
  end;

  TODataBuilder = class(TComponent)
  private
    FSelect: string;
    FFilter: string;
    FTop: integer;
    FSkip: integer;
    FCount: boolean;
    FResource: TODataResourceItems;
    FBaseURL: string;
    FService: string;
    FServicePreffix: string;
    FExpand: string;
    FRestClient: TIdHTTPRestClient;
    FURI: string;
    procedure SetSelect(const Value: string);
    procedure SetFilter(const Value: string);
    procedure SetTop(const Value: integer);
    procedure SetSkip(const Value: integer);
    procedure SetCount(const Value: boolean);
    procedure SetResource(const Value: TODataResourceItems);
    procedure SetBaseURL(const Value: string);
    procedure SetService(const Value: string);
    procedure SetServicePreffix(const Value: string);
    procedure SetExpand(const Value: string);
    procedure AddSqlResource(var Result: string; AResource: TODataResourceItem);
    procedure SetRestClient(const Value: TIdHTTPRestClient);
  public
    constructor create(AOwner: TComponent); override;
    destructor destroy; override;
    function ToString: string;
    function addResource(AResource: string): TODataResourceItem;
    function execute: boolean;overload;
    function execute(AProc: TProc): boolean;overload;
  published
    property URI: string read FURI;
    property RestClient: TIdHTTPRestClient read FRestClient write SetRestClient;
    property BaseURL: string read FBaseURL write SetBaseURL;
    property ServicePreffix: string read FServicePreffix
      write SetServicePreffix;
    property Service: string read FService write SetService;
    property Resource: TODataResourceItems read FResource write SetResource;
    property &Select: string read FSelect write SetSelect;
    property &Filter: string read FFilter write SetFilter;
    property &TopRows: integer read FTop write SetTop;
    property &SkipRows: integer read FSkip write SetSkip;
    property &Count: boolean read FCount write SetCount;
    property &Expand: string read FExpand write SetExpand;
  end;

implementation

uses System.DateUtils;

{ TODataBuilder }

function TODataBuilder.addResource(AResource: string): TODataResourceItem;
var
  it: TODataResourceItem;
begin
  Result := TODataResourceItem(FResource.Add);
  Result.Resource := AResource;
end;

procedure TODataBuilder.AddSqlResource(var Result: string;
  AResource: TODataResourceItem);
var
  p, v: string;
  it: TODataResouceParam;
  i: integer;
begin
  Result := Result + '/' + AResource.Resource;
  p := '';
  // for it in AResource.FResourceParams.Items do
  for i := 0 to AResource.FResourceParams.Count - 1 do
  begin
    it := TODataResouceParam(AResource.FResourceParams.items[i]);
    if p <> '' then
      p := p + ',';
    v := it.Value;
    case it.Datatype of
      ftString, ftFixedChar, ftWideString, ftFixedWideChar:
        v := QuotedStr(v);
      ftDate, ftDateTime:
        v := QuotedStr(DateToISO8601(StrToDateTimeDef(v, 0)));

    end;
    p := p + it.FName + '=' + v;
  end;
  if p <> '' then
    Result := Result + '(' + p + ')';
end;

constructor TODataBuilder.create(AOwner: TComponent);
begin
  inherited;
  FResource := TODataResourceItems.create(self);
  if (csDesigning in ComponentState) and (FBaseURL = '') then
  begin
    FBaseURL := 'http://localhost:8080';
    FServicePreffix := '/OData';
    FService := '/OData.svc';
  end;

end;

destructor TODataBuilder.destroy;
begin
  FResource.DisposeOf;
  inherited;
end;

function TODataBuilder.execute(AProc: TProc): boolean;
begin
  ToString;
  if assigned(FRestClient) then
    Result := FRestClient.execute(AProc);

end;

function TODataBuilder.execute: boolean;
begin
  Result := execute(nil);
end;

procedure TODataBuilder.SetBaseURL(const Value: string);
begin
  FBaseURL := Value;
end;

procedure TODataBuilder.SetCount(const Value: boolean);
begin
  FCount := Value;
end;

procedure TODataBuilder.SetExpand(const Value: string);
begin
  FExpand := Value;
end;

procedure TODataBuilder.SetFilter(const Value: string);
begin
  FFilter := Value;
end;

procedure TODataBuilder.SetResource(const Value: TODataResourceItems);
begin
  FResource := Value;
end;

procedure TODataBuilder.SetRestClient(const Value: TIdHTTPRestClient);
begin
  FRestClient := Value;
end;

procedure TODataBuilder.SetSelect(const Value: string);
begin
  FSelect := Value;
end;

procedure TODataBuilder.SetService(const Value: string);
begin
  FService := Value;
end;

procedure TODataBuilder.SetServicePreffix(const Value: string);
begin
  FServicePreffix := Value;
end;

procedure TODataBuilder.SetSkip(const Value: integer);
begin
  FSkip := Value;
end;

procedure TODataBuilder.SetTop(const Value: integer);
begin
  FTop := Value;
end;

function TODataBuilder.ToString: string;
var
  i: integer;
  it: TODataResourceItem;
  p: string;
  procedure addUrlParams(AName: string; Txt: string);
  begin
    if Txt = '' then
      exit;
    if p <> '' then
      p := p + '&';
    p := p + AName + '=' + Txt;
  end;

begin
  p := '';
  Result := '';
  // for it in FResource do
  for i := 0 to FResource.Count - 1 do
  begin
    it := TODataResourceItem(FResource.items[i]);
    AddSqlResource(Result, it);
  end;
  addUrlParams('$select', Select);
  addUrlParams('$filter', Filter);
  if topRows > 0 then
    addUrlParams('$top', topRows.ToString);
  if SkipRows > 0 then
    addUrlParams('$skip', SkipRows.ToString);
  addUrlParams('$expand', Expand);
  if Count then
    addUrlParams('$count', 'true');
  if p <> '' then
    Result := Result + '?' + p;

  FURI := Result;
  Result := FBaseURL + FServicePreffix + FService + Result;

  if assigned(FRestClient) then
  begin
    FRestClient.BaseURL := self.BaseURL;
    FRestClient.Resource := self.FURI;
    FRestClient.ResourcePreffix := self.ServicePreffix + self.Service;
  end;

end;

{ TODataResouceParams }

procedure TODataResouceParam.SetDatatype(const Value: TFieldType);
begin
  FDatatype := Value;
end;

procedure TODataResouceParam.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TODataResouceParam.SetValue(const Value: string);
begin
  FValue := Value;
end;

{ TODataResourceItem }

function TODataResourceItem.AddParam(AName: String; AValue: TValue)
  : TODataResouceParam;
begin
  Result := TODataResouceParam(FResourceParams.Add);
  // TODataResouceParams.create(TODataResourceItems );
  Result.Name := AName;
  Result.Value := AValue.AsString;
end;

constructor TODataResourceItem.create(AItems: TCollection);
begin
  inherited;
  FResourceParams := TODataResourceParams.create(FOwner);
end;

destructor TODataResourceItem.destroy;
begin
  FResourceParams.free;
  inherited;
end;

procedure TODataResourceItem.SetResource(const Value: string);
begin
  FResource := Value;
end;

procedure TODataResourceItem.SetResourceParams(const Value
  : TODataResourceParams);
begin
  FResourceParams := Value;
end;

{ TODataResourceItems }

function TODataResourceItems.Add: TODataResourceItem;
begin
  Result := TODataResourceItem(inherited Add);
  Result.FOwner := self.FOwner;
end;

procedure TODataResourceItems.addResource(tx: String);
begin

end;

constructor TODataResourceItems.create(AOwner: TComponent);
begin
  inherited create(TODataResourceItem);
  FOwner := AOwner;
end;

function TODataResourceItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

{ TODataResourceParams }

constructor TODataResourceParams.create(AOwner: TComponent);
begin
  inherited create(TODataResouceParam);
  FOwner := AOwner;
end;

function TODataResourceParams.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

end.
