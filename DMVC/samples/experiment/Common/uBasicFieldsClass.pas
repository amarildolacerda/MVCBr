unit uBasicFieldsClass;

interface

uses
  Data.DB;

type

  TDatabaseFieldAttribute = class(TCustomAttribute)
  private
    FFieldName: string;
    FFieldType: TFieldType;
  public
    constructor Create(FName:string; FType: TFieldType);
    property FieldName: string read FFieldName write FFieldName;
    property FieldType: TFieldType read FFieldType write FFieldType;
  end;

  TFunctionalityAttribute = class(TCustomAttribute)
  private
    FFunctionalityName: string;
  public
    constructor Create(FName:string);
    property FunctionalityName: string read FFunctionalityName write FFunctionalityName;
  end;

  TBasicFieldsClass = class
  private
    FUID: Integer;
    FPID: Integer;
    FModBy: Integer;
    FJsonString : string;
    FLastUpdatedOn: TDateTime;

    function GetLastUpdatedOn: TDateTime;
    function GetModBy: Integer;
    function GetPID: Integer;
    function GetUID: Integer;
    procedure SetLastUpdatedOn(const Value: TDateTime);
    procedure SetModBy(const Value: Integer);
    procedure SetPID(const Value: Integer);
    procedure SetUID(const Value: Integer);
    function GetJsonString: string;
    procedure SetJsonString(const Value: string);

  public
    property UID: Integer read GetUID write SetUID;

    [TDatabaseFieldAttribute('PID', ftInteger)]
    property PID: Integer read GetPID write SetPID;

    [TDatabaseFieldAttribute('ModBy', ftInteger)]
    property ModBy: Integer read GetModBy write SetModBy;

    property JsonString: string read GetJsonString write SetJsonString;

    property LastUpdatedOn: TDateTime read GetLastUpdatedOn write SetLastUpdatedOn;
  end;
implementation

{ TBasicFieldsClass }

function TBasicFieldsClass.GetJsonString: string;
begin
  Result := FJsonString;
end;


function TBasicFieldsClass.GetLastUpdatedOn: TDateTime;
begin
  Result := FLastUpdatedOn;
end;

function TBasicFieldsClass.GetModBy: Integer;
begin
  Result := FModBy;
end;

function TBasicFieldsClass.GetPID: Integer;
begin
  Result := FPID;
end;

function TBasicFieldsClass.GetUID: Integer;
begin
  Result := FUID;
end;

procedure TBasicFieldsClass.SetJsonString(const Value: string);
begin
  FJsonString := Value;
end;

procedure TBasicFieldsClass.SetLastUpdatedOn(const Value: TDateTime);
begin
  FLastUpdatedOn := Value;
end;

procedure TBasicFieldsClass.SetModBy(const Value: Integer);
begin
  FModBy := Value;
end;

procedure TBasicFieldsClass.SetPID(const Value: Integer);
begin
  FPID := Value;
end;

procedure TBasicFieldsClass.SetUID(const Value: Integer);
begin
  FUID := Value;
end;

{ TDatabaseFieldAttribute }

constructor TDatabaseFieldAttribute.Create(FName: string; FType: TFieldType);
begin
  FFieldName := FName;
  FFieldType := FType;
end;

{ TFunctionalityAttribute }

constructor TFunctionalityAttribute.Create(FName: string);
begin
  FFunctionalityName := FName;
end;

end.
