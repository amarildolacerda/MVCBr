unit uCommonClass;

interface

uses
  System.Classes,
  Data.DB,
  uBasicFieldsClass;

type
  TUsers = class(TBasicFieldsClass)
  private
    FPassword: string;
    FLogin: string;
    FName: string;
    FUType: string;
    FFolderID: string;
    procedure SetLogin(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetFolderID(const Value: string);
    procedure SetName(const Value: string);
    procedure SetUType(const Value: string);
  published
    [TDatabaseFieldAttribute('Name', ftString)]
    property Name: string read FName write SetName;
    [TDatabaseFieldAttribute('UType', ftString)]
    property UType: string read FUType write SetUType;
    [TDatabaseFieldAttribute('Login', ftString)]
    property Login: string read FLogin write SetLogin;
    [TDatabaseFieldAttribute('Password', ftString)]
    property Password: string read FPassword write SetPassword;
    [TDatabaseFieldAttribute('FolderID', ftString)]
    property FolderID: string read FFolderID write SetFolderID;
  end;

implementation

{ TUsers }


procedure TUsers.SetFolderID(const Value: string);
begin
  FFolderID := Value;
end;

procedure TUsers.SetLogin(const Value: string);
begin
  FLogin := Value;
end;

procedure TUsers.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TUsers.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TUsers.SetUType(const Value: string);
begin
  FUType := Value;
end;

end.
