Unit MVCBr.FireDACModel;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

uses Classes, forms, SysUtils,
  MVCBr.Interf, MVCBr.Model,
  MVCBr.FireDACModel.Interf,
  MVCBr.Controller, MVCBr.DatabaseModel, MVCBr.DatabaseModel.Interf,
  FireDAC.Comp.Client, FireDAC.Stan.Def;

Type

  TFireDACModel = class(TDatabaseModelFactory<TFDConnection, TFDQuery>,
    IFireDACModel, IThisAs<TFireDACModel>)
  private
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new(AProc: TProc<IFireDACModel>): IFireDACModel; overload;
    class function new(const AController: IController): IFireDACModel; overload;
    function ThisAs: TFireDACModel;
    // connection
    function DriverID(const ADriverID: string): IFireDACModel;
    function ConnectionName(const AConn: string): IFireDACModel;
    function UserName(const AUser: string): IFireDACModel;
    function Password(const APass: string): IFireDACModel;
    procedure SetConnectionString(const Value: string); override;


    // Query
    // function NewQuery(const AProcChange: TProc<Q>): IQueryModel<Q>; virtual;

  end;

Implementation

function TFireDACModel.ConnectionName(const AConn: string): IFireDACModel;
begin
  result := Self;
  GetConnection.ConnectionName := AConn;
end;

constructor TFireDACModel.Create;
begin
  inherited;
  SetModelTypes( [mtPersistent] );
  with TStringList.Create do
    try
      Assign(GetConnection.Params);
      Delimiter := ';';
      FConnectionString := DelimitedText;
    finally
      DisposeOf;
    end;
end;

destructor TFireDACModel.Destroy;
begin
  inherited;
end;

function TFireDACModel.DriverID(const ADriverID: string): IFireDACModel;
begin
  result := Self;
  GetConnection.DriverName := ADriverID;
end;

class function TFireDACModel.new(AProc: TProc<IFireDACModel>): IFireDACModel;
begin
  result := TFireDACModel.Create;
  if Assigned(AProc) then
    AProc(result);
end;

function TFireDACModel.ThisAs: TFireDACModel;
begin
  result := Self;
end;

function TFireDACModel.UserName(const AUser: string): IFireDACModel;
begin
  result := Self;
  GetConnection.Params.Values['USER_NAME'] := AUser;
end;

class function TFireDACModel.new(const AController: IController): IFireDACModel;
begin
  result := TFireDACModel.Create;
  result.Controller(AController);
end;

function TFireDACModel.Password(const APass: string): IFireDACModel;
begin
  result := Self;
  GetConnection.Params.Values['PASSWORD'] := APass;

end;

procedure TFireDACModel.SetConnectionString(const Value: string);
var
  Params: TStringList;
  i:integer;
begin
  inherited;
  Params := TStringList.Create;
  try
    Params.Delimiter := ';';
    Params.DelimitedText := Value;
    for I := 0 to Params.count-1 do
       GetConnection.Params.Values[ Params.Names[i] ] :=  Params.ValueFromIndex[i];
  finally
    Params.free;
  end;
end;

end.
