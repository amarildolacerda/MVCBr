unit MVCBr.FDMongoDB;

interface

uses System.Classes, System.SysUtils, Data.DB,
  MVCBr.MongoModel,
  FireDAC.DatS, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Comp.Client,
  FireDAC.Comp.Dataset;

type

  TMVCBrMongoConnection = class(TComponent)
  private
    FParams: IMongoModel;
    FPort: integer;
    FDatabase: string;
    FPassword: string;
    FHost: string;
    FUserName: string;
    procedure SetParams(const Value: IMongoModel);
    procedure SetDatabase(const Value: string);
    procedure SetHost(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetPort(const Value: integer);
    procedure SetUserName(const Value: string);
    function GetActive: boolean;
    procedure SetActive(const Value: boolean);
  public
    function Default: TMVCBrMongoConnection;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Property Params: IMongoModel read FParams write SetParams;
    function RunCommand(ACommand: IJSONDocument): IJSONDocument;
  published
    property Active: boolean read GetActive write SetActive default false;
    property Host: string read FHost write SetHost;
    property Port: integer read FPort write SetPort default 27017;
    property Database: string read FDatabase write SetDatabase;
    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;
  end;

  TMVCBrMongoDataset = class(TFDCustomMemTable)
  private
    FConnection: TMVCBrMongoConnection;
    FLoading: boolean;
    FCollectionName: string;
    FKeyFields: string;
    procedure SetConnection(const Value: TMVCBrMongoConnection);
    procedure SetLoading(const Value: boolean);
    procedure SetCollectionName(const Value: string);
    procedure checkNil;
    procedure SetKeyFields(const Value: string);
    function GetKeyFieldsDoc(AFields: TFields): IJSONDocument;
    constructor Create(AOwner: TComponent); override;

    procedure DoUpdateRecord(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);

  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetActive(Value: boolean); override;

  public
    function Open(AWhereArray: array of Variant; AProcBeforePost: TProc = nil)
      : integer; overload;
    function OpenWithCommand(ACommand: IJSONDocument;
      AProcBeforePost: TProc = nil): integer; overload;
    procedure Open; reintroduce; overload;
    function Insert: boolean;
    function Update(const AWhereJson: array of Variant;
      AUpsert: boolean = false; AMUltiUpdate: boolean = false): boolean;
    function Post(const AWhereJson: Array of Variant): boolean;
    function Delete(const AWhereJson: Array of Variant): boolean;
    property Loading: boolean read FLoading write SetLoading;

    { TODO:
      function UpdatesPending: boolean;
      procedure ClearChanges;
      procedure CancelUpdates; reintroduce;
      procedure MergeChangeLog; reintroduce;
      property Changes: TJSONArray read GetChanges;
    }

  published
    property CollectionName: string read FCollectionName
      write SetCollectionName;
    property KeyFields: string read FKeyFields write SetKeyFields;

    property Connection: TMVCBrMongoConnection read FConnection
      write SetConnection;
    property FieldDefs;
    property Active;
    property Filter;
    property Filtered;
    property FormatOptions;
    property AutoCalcFields;
    property Adapter;
    property DataSetField;
    property DetailFields;
    property FieldOptions;
    property MasterFields;
    property MasterSource;
    property UpdateOptions;
    property LocalSQL;

  end;

Procedure Register;

implementation

uses System.JSON, Data.DB.Helper, Variants;

Procedure Register;
begin
  RegisterComponents('MVCBr', [TMVCBrMongoConnection, TMVCBrMongoDataset]);
end;

{ TMVCBrMongoDataset }

procedure TMVCBrMongoDataset.checkNil;
begin
  assert(Connection <> nil, 'Can not do anything without a connection');
end;

constructor TMVCBrMongoDataset.Create(AOwner: TComponent);
begin
  inherited;
  OnUpdateRecord := DoUpdateRecord;
end;

function TMVCBrMongoDataset.Delete(const AWhereJson: array of Variant): boolean;
begin
  checkNil;
end;

procedure TMVCBrMongoDataset.DoUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  AAction := TFDErrorAction.eaApplied;
  if FLoading then
    exit;
  AAction := TFDErrorAction.eaFail;
  checkNil;
  case ARequest of
    arInsert:
      Connection.Params.Insert(FCollectionName,
        mongoJSON(ASender.fields.ToJson));
    arUpdate:
      Connection.Params.Update(FCollectionName, GetKeyFieldsDoc(ASender.fields),
        mongoJSON(ASender.fields.ToJson), false, false);
    arDelete:
      Connection.Params.Delete(FCollectionName,
        GetKeyFieldsDoc(ASender.fields), true);
  end;
  AAction := TFDErrorAction.eaApplied;
end;

function TMVCBrMongoDataset.GetKeyFieldsDoc(AFields: TFields): IJSONDocument;
var
  str: TStringList;
  s: string;
begin
  assert(FKeyFields <> '', 'Cant create Where with no KeyFields');
  result := mongoJSON();
  str := TStringList.Create;
  try
    str.Delimiter := ';';
    str.DelimitedText := FKeyFields;
    for s in str do
    begin
      result.Item[s] := AFields.FieldByName(s).OldValue;
    end;
  finally
    str.free;
  end;

end;

function TMVCBrMongoDataset.Insert: boolean;
begin
  result := false;
  checkNil;
  Connection.Params.Insert(FCollectionName, mongoJSON(fields.ToJson));
  result := true;
end;

procedure TMVCBrMongoDataset.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if assigned(FConnection) and FConnection.Equals(AComponent) and
    (Operation = TOperation.opRemove) then
    FConnection := nil;
end;

procedure TMVCBrMongoDataset.Open;
begin
  self.Open([]);
end;

function TMVCBrMongoDataset.OpenWithCommand(ACommand: IJSONDocument;
  AProcBeforePost: TProc = nil): integer;
var
  j, jp: TJsonObject;
  p: TJsonPair;
  v: TJSonValue;
  rst: TJsonObject;
  arr: TJSonValue;
  s: string;
  doc: IJSONDocArray;
begin
  checkNil;
  FLoading := true;
  try
    if Active then
      EmptyDataSet;
    j := TJsonObject.Create as TJsonObject;
    try
      if VarIsNull(ACommand.Item['find']) then
        j.addPair('find', FCollectionName);
      jp := TJsonObject.ParseJSONValue(ACommand.ToString) as TJsonObject;
      try
        for p in jp do
        begin
          j.addPair(TJsonPair.Create(p.JsonString, p.JsonValue));
        end;
        s := j.ToJson;
        rst := TJsonObject.ParseJSONValue
          (Connection.Params.RunCommand(mongoJSON(s)).ToString) as TJsonObject;
        try
          arr := rst.GetValue('cursor');
          begin
            doc := TJSONDocument.NewDocArray;
            for v in arr.GetValue<TJsonArray>('firstBatch') do
            begin
              doc.AddJson(v.ToString);
            end;
            result := Connection.Params.This.FillDataset(doc, self, nil);
          end;
        finally
          rst.free;
        end;
      finally
        // jp.free;
      end;
    finally
      j.free;
    end;
  finally
    FLoading := false;
  end;
end;

function TMVCBrMongoDataset.Open(AWhereArray: array of Variant;
  AProcBeforePost: TProc = nil): integer;
var
  AJson: IJSONDocument;
begin
  checkNil;
  FLoading := true;
  try
    if Active then
      EmptyDataSet;
    AJson := mongoJSON(AWhereArray);
    result := Connection.Params.GetDataset(FCollectionName, AJson, self,
      AProcBeforePost);
  finally
    FLoading := false;
  end;
end;

function TMVCBrMongoDataset.Post(const AWhereJson: array of Variant): boolean;
begin
  checkNil;
  result := self.Update(AWhereJson, true, false);
end;

procedure TMVCBrMongoDataset.SetActive(Value: boolean);
begin
  inherited;
  if Value and (not FLoading) and (csDesigning in ComponentState) then
  begin
    try
      OpenWithCommand(mongoJSON(['limit', 10]));
    except
    end;
  end;
end;

procedure TMVCBrMongoDataset.SetCollectionName(const Value: string);
begin
  FCollectionName := Value;
end;

procedure TMVCBrMongoDataset.SetConnection(const Value: TMVCBrMongoConnection);
begin
  FConnection := Value;
end;

procedure TMVCBrMongoDataset.SetKeyFields(const Value: string);
begin
  FKeyFields := Value;
end;

procedure TMVCBrMongoDataset.SetLoading(const Value: boolean);
begin
  FLoading := Value;
end;

function TMVCBrMongoDataset.Update(const AWhereJson: array of Variant;
  AUpsert: boolean = false; AMUltiUpdate: boolean = false): boolean;
begin
  result := false;
  checkNil;
  Connection.Params.Update(FCollectionName, mongoJSON(AWhereJson),
    mongoJSON(fields.ToJson), AUpsert, AMUltiUpdate);
  result := false;
end;

{ TMVCBrMongoConnection }

constructor TMVCBrMongoConnection.Create(AOwner: TComponent);
begin
  inherited;
  FPort := 27017;
  FHost := 'localhost';
  FDatabase := 'mvcbrDB';
end;

function TMVCBrMongoConnection.Default: TMVCBrMongoConnection;
begin
  result := self;
  if not assigned(FParams) then
  begin
    FParams := TMongoModelFactory.Create;
    FParams.SetPort(FPort);
    FParams.SetHost(FHost);
    FParams.SetPassword(FPassword);
    FParams.SetUserName(FUserName);
    FParams.SetDatabase(FDatabase);
  end;
end;

destructor TMVCBrMongoConnection.Destroy;
begin
  FParams := nil;
  inherited;
end;

function TMVCBrMongoConnection.GetActive: boolean;
begin
  result := Default.Params.Active;
end;

function TMVCBrMongoConnection.RunCommand(ACommand: IJSONDocument)
  : IJSONDocument;
begin
  result := Default.Params.RunCommand(ACommand);
end;

procedure TMVCBrMongoConnection.SetActive(const Value: boolean);
begin
  Default;
  FParams.Active := Value;
end;

procedure TMVCBrMongoConnection.SetDatabase(const Value: string);
begin
  FDatabase := Value;
  Default.Params.Database(Value);
end;

procedure TMVCBrMongoConnection.SetHost(const Value: string);
begin
  FHost := Value;
  Default.Params.Host(Value);
end;

procedure TMVCBrMongoConnection.SetParams(const Value: IMongoModel);
begin
  with Default do
  begin
    Params.Database(Value.GetDatabase);
    Params.Host(Value.GetHost);
    Params.Password(Value.GetPassword);
    Params.Port(Value.GetPort);
    Params.UserName(Value.GetUserName);
  end;
end;

procedure TMVCBrMongoConnection.SetPassword(const Value: string);
begin
  FPassword := Value;
  Default.Params.Password(Value);
end;

procedure TMVCBrMongoConnection.SetPort(const Value: integer);
begin
  FPort := Value;
  Default.Params.Port(Value);
end;

procedure TMVCBrMongoConnection.SetUserName(const Value: string);
begin
  FUserName := Value;
  Default.Params.UserName(Value);
end;

end.
