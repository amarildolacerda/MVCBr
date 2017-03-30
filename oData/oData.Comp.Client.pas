{

  Amarildo Lacerda
  12/03/2017

  TODataBuilder - Delphi IDE component

}
unit oData.Comp.Client;

interface

uses System.Classes, System.RTTI,
  System.SysUtils,
  System.Generics.Collections,
  Data.DB, System.JSON,
  MVCBr.idHTTPRestClient;

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
    function GetItems(idx: Integer): TODataResouceParam;
    procedure SetItems(idx: Integer; const Value: TODataResouceParam);
  public
    constructor create(AOwner: TComponent);
    function GetOwner: TPersistent; override;
    property Items[idx: Integer]: TODataResouceParam read GetItems
      write SetItems;
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
    function GetItems(idx: Integer): TODataResourceItem;
    procedure SetItems(idx: Integer; const Value: TODataResourceItem);
  public
    function Add: TODataResourceItem;
    constructor create(AOwner: TComponent);
    procedure addResource(tx: String);
    function GetOwner: TPersistent; override;
    property Items[idx: Integer]: TODataResourceItem read GetItems
      write SetItems;
  end;

  TODataBuilder = class(TComponent)
  private
    FSelect: string;
    FFilter: string;
    FTop: Integer;
    FSkip: Integer;
    FCount: boolean;
    FResource: TODataResourceItems;
    FBaseURL: string;
    FService: string;
    FServicePrefix: string;
    FExpand: string;
    FOrder: string;
    FRestClient: TIdHTTPRestClient;
    FURI: string;
    FAfterExecute, FBeforeExecute, FOnBeforeApplyUpdate, FOnAfterApplyUpdate
      : TNotifyEvent;
    procedure SetSelect(const Value: string);
    procedure SetFilter(const Value: string);
    procedure SetTop(const Value: Integer);
    procedure SetSkip(const Value: Integer);
    procedure SetCount(const Value: boolean);
    procedure SetResource(const Value: TODataResourceItems);
    procedure SetBaseURL(const Value: string);
    procedure SetService(const Value: string);
    procedure SetServicePrefix(const Value: string);
    procedure SetExpand(const Value: string);
    procedure AddSqlResource(var Result: string; AResource: TODataResourceItem);
    procedure SetRestClient(const Value: TIdHTTPRestClient);
    procedure SetOnBeforeApplyUpdate(const Value: TNotifyEvent);
    procedure SetOnAfterApplyUpdate(const Value: TNotifyEvent);
    procedure WriteOnBeforeApplyUpdate(const Value: TNotifyEvent);
    procedure SetOrder(const Value: string);
    procedure SetResourceName(const Value: string);
    function GetResourceName: string;
    procedure SetAfterExecute(const Value: TNotifyEvent);
    procedure SetBeforeExecute(const Value: TNotifyEvent);
  protected
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;

  public
    constructor create(AOwner: TComponent); override;
    destructor destroy; override;
    function ToString: string; virtual;
    function addResource(AResource: string): TODataResourceItem; virtual;
    function execute: boolean; overload; virtual;
    function execute(AProc: TProc): boolean; overload; virtual;
    function ApplyUpdates(AChanges: TJsonArray;
      AMethod: TIdHTTPRestMethod = rmPATCH): boolean; virtual;
  published
    property URI: string read FURI;
    property RestClient: TIdHTTPRestClient read FRestClient write SetRestClient;
    property BaseURL: string read FBaseURL write SetBaseURL;
    property ServicePrefix: string read FServicePrefix
      write SetServicePrefix;
    property Service: string read FService write SetService;
    property ResourceName: string read GetResourceName write SetResourceName;
    property Resource: TODataResourceItems read FResource write SetResource;
    property &Select: string read FSelect write SetSelect;
    property &Filter: string read FFilter write SetFilter;
    property &TopRows: Integer read FTop write SetTop;
    property &SkipRows: Integer read FSkip write SetSkip;
    property &Count: boolean read FCount write SetCount;
    property &Expand: string read FExpand write SetExpand;
    property &Order: string read FOrder write FOrder;
    property OnBeforeApplyUpdates: TNotifyEvent read FOnBeforeApplyUpdate
      write WriteOnBeforeApplyUpdate;
    property OnAfterApplyUpdates: TNotifyEvent read FOnAfterApplyUpdate
      write SetOnAfterApplyUpdate;
    property BeforeExecute: TNotifyEvent read FBeforeExecute
      write SetBeforeExecute;
    property AfterExecute: TNotifyEvent read FAfterExecute
      Write SetAfterExecute;
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
  i: Integer;
begin
  Result := Result + '/' + AResource.Resource;
  p := '';
  // for it in AResource.FResourceParams.Items do
  for i := 0 to AResource.FResourceParams.Count - 1 do
  begin
    it := TODataResouceParam(AResource.FResourceParams.Items[i]);
    if p <> '' then
      p := p + ',';
    v := it.Value;
    case it.Datatype of
      ftString, ftFixedChar, ftWideString, ftFixedWideChar:
        v := QuotedStr(v);
      ftDate, ftDateTime:
        v := QuotedStr(DateToISO8601(StrToDateTimeDef(v, 0)));

    end;
    if it.FName.Trim<>'' then
       p := p + it.FName + '=' + v
    else
       p := p + v;
  end;
  if p <> '' then
    Result := Result + '(' + p + ')';
end;

function TODataBuilder.ApplyUpdates(AChanges: TJsonArray;
  AMethod: TIdHTTPRestMethod = rmPATCH): boolean;
var
  rest: TIdHTTPRestClient;
begin
  Result := false;
  if AChanges.Count = 0 then
    exit;

  rest := TIdHTTPRestClient.create(self);
  try
    if Assigned(FRestClient) then
    begin
      rest.IdHTTP.Request.CustomHeaders.AddStrings
        (FRestClient.IdHTTP.Request.CustomHeaders);
      rest.AcceptCharset := FRestClient.AcceptCharset;
      rest.AcceptEncoding := FRestClient.AcceptEncoding;
      rest.Accept := FRestClient.Accept;
    end;
    rest.Method := AMethod;
    rest.Body.Add(AChanges.ToString);
    rest.BaseURL := self.BaseURL;
    rest.Resource := '/' + TODataResourceItem(FResource.Items[0]).Resource;
    rest.ResourcePrefix := self.FServicePrefix + self.FService;
    if Assigned(FOnBeforeApplyUpdate) then
      FOnBeforeApplyUpdate(self);
    Result := rest.execute(
      procedure
      begin
        if Assigned(FOnAfterApplyUpdate) then
          FOnAfterApplyUpdate(self);
      end);
  finally
    rest.Free;
  end;
end;

constructor TODataBuilder.create(AOwner: TComponent);
begin
  inherited;
  FResource := TODataResourceItems.create(self);
  if (csDesigning in ComponentState) and (FBaseURL = '') then
  begin
    FBaseURL := 'http://localhost:8080';
    FServicePrefix := '/OData';
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
  Result := false;
  ToString;
  if Assigned(FBeforeExecute) then
    FBeforeExecute(self);
  if Assigned(FRestClient) then
    Result := FRestClient.execute(AProc);

  if Result then
    if Assigned(FAfterExecute) then
      FAfterExecute(self);
end;

function TODataBuilder.GetResourceName: string;
begin
  if FResource.Count > 0 then
    Result := FResource.Items[0].Resource
  else
    Result := '';
end;

procedure TODataBuilder.Notification(AComponent: TComponent;
AOperation: TOperation);
begin
  inherited;
  if AOperation = TOperation.opRemove then
    if AComponent = FRestClient then
      FRestClient := nil;

end;

function TODataBuilder.execute: boolean;
begin
  Result := execute(nil);
end;

procedure TODataBuilder.SetAfterExecute(const Value: TNotifyEvent);
begin
  FAfterExecute := Value;
end;

procedure TODataBuilder.SetBaseURL(const Value: string);
begin
  FBaseURL := Value;
end;

procedure TODataBuilder.SetBeforeExecute(const Value: TNotifyEvent);
begin
  FBeforeExecute := Value;
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

procedure TODataBuilder.SetOnAfterApplyUpdate(const Value: TNotifyEvent);
begin
  FOnAfterApplyUpdate := Value;
end;

procedure TODataBuilder.SetOnBeforeApplyUpdate(const Value: TNotifyEvent);
begin
  FOnBeforeApplyUpdate := Value;
end;

procedure TODataBuilder.SetOrder(const Value: string);
begin
  FOrder := Value;
end;

procedure TODataBuilder.SetResource(const Value: TODataResourceItems);
begin
  FResource := Value;
end;

procedure TODataBuilder.SetResourceName(const Value: string);
begin

  // if ComponentState in [csReading,csWriting,csLoading] then
  // exit;

  if csDesigning in ComponentState then
  begin // stub para mostar o valor no component
    if FResource.Count = 0 then
      FResource.Add;
  end;

  if FResource.Count > 0 then
    FResource.Items[0].Resource := Value;

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

procedure TODataBuilder.SetServicePrefix(const Value: string);
begin
  FServicePrefix := Value;
end;

procedure TODataBuilder.SetSkip(const Value: Integer);
begin
  FSkip := Value;
end;

procedure TODataBuilder.SetTop(const Value: Integer);
begin
  FTop := Value;
end;

function TODataBuilder.ToString: string;
var
  i: Integer;
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
    it := TODataResourceItem(FResource.Items[i]);
    AddSqlResource(Result, it);
  end;
  addUrlParams('$select', Select);
  addUrlParams('$filter', Filter);
  if topRows > 0 then
    addUrlParams('$top', topRows.ToString);
  if SkipRows > 0 then
    addUrlParams('$skip', SkipRows.ToString);

  addUrlParams('$order', Order);
  addUrlParams('$expand', Expand);
  if Count then
    addUrlParams('$count', 'true');
  if p <> '' then
    Result := Result + '?' + p;

  FURI := Result;
  Result := FBaseURL + FServicePrefix + FService + Result;

  if Assigned(FRestClient) then
  begin
    FRestClient.BaseURL := self.BaseURL;
    FRestClient.Resource := self.FURI;
    FRestClient.ResourcePrefix := self.ServicePrefix + self.Service;
  end;

end;

procedure TODataBuilder.WriteOnBeforeApplyUpdate(const Value: TNotifyEvent);
begin
  FOnBeforeApplyUpdate := Value;
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
  FResourceParams.Free;
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

function TODataResourceItems.GetItems(idx: Integer): TODataResourceItem;
begin
  Result := TODataResourceItem(inherited Items[idx]);
end;

function TODataResourceItems.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TODataResourceItems.SetItems(idx: Integer;
const Value: TODataResourceItem);
begin
  inherited Items[idx] := Value;
end;

{ TODataResourceParams }

constructor TODataResourceParams.create(AOwner: TComponent);
begin
  inherited create(TODataResouceParam);
  FOwner := AOwner;
end;

function TODataResourceParams.GetItems(idx: Integer): TODataResouceParam;
begin
  Result := TODataResouceParam(inherited Items[idx]);
end;

function TODataResourceParams.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TODataResourceParams.SetItems(idx: Integer;
const Value: TODataResouceParam);
begin
  inherited Items[idx] := Value;
end;

end.
