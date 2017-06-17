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

  TFireDACModelFactory = class(TDatabaseModelFactory<TFDConnection, TFDQuery>,
    IFireDACModel, IThisAs<TFireDACModelFactory>)
  private
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    function ThisAs: TFireDACModelFactory;
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

function TFireDACModelFactory.ConnectionName(const AConn: string): IFireDACModel;
begin
  result := Self;
  GetConnection.ConnectionName := AConn;
end;

constructor TFireDACModelFactory.Create;
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

destructor TFireDACModelFactory.Destroy;
begin
  inherited;
end;

function TFireDACModelFactory.DriverID(const ADriverID: string): IFireDACModel;
begin
  result := Self;
  GetConnection.DriverName := ADriverID;
end;


function TFireDACModelFactory.ThisAs: TFireDACModelFactory;
begin
  result := Self;
end;

function TFireDACModelFactory.UserName(const AUser: string): IFireDACModel;
begin
  result := Self;
  GetConnection.Params.Values['USER_NAME'] := AUser;
end;


function TFireDACModelFactory.Password(const APass: string): IFireDACModel;
begin
  result := Self;
  GetConnection.Params.Values['PASSWORD'] := APass;

end;

procedure TFireDACModelFactory.SetConnectionString(const Value: string);
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
