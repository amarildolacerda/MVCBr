unit uGlobals;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.SqlExpr,
  Data.DBXMySql,
  Spring.Container,
  uConnectionsInterfaces,
  System.IniFiles;

var
  CommonDBConnection: TSQLConnection;
  Connections       : TStringList;
  BaseIP            : string;

function GetSessionConnection(SessionID: string): TSQLConnection;
function RemoveSessionConnection(SessionID : string) : Boolean;

implementation

procedure CreateCommonDBConnection;
var
  ApplicationPath : string;
  SessionPort     : Integer;
  IniFile         : string;
  X               : TIniFile;
  HostName        ,
  UserName        ,
  Password        ,
  CommonDB        : string;
begin
  { TODO : values to be got from ini }
  ApplicationPath := ExtractFilePath(GetModuleName(hInstance));
  IniFile := ApplicationPath+'serverconfig.ini';
  X := TIniFile.Create(IniFile);
  HostName     := X.ReadString('DBInfo', 'SERVER', '');
  UserName     := X.ReadString('DBInfo', 'USERNAME', '');
  Password     := X.ReadString('DBInfo', 'PASSWORD', '');
  CommonDB     := X.ReadString('DBInfo', 'COMMONDB', '');
  BaseIP       := X.ReadString('DBInfo', 'BaseIP', '');

  CommonDBConnection := TSQLConnection.Create(nil);
  CommonDBConnection.DriverName := 'MySQL';
  CommonDBConnection.LoginPrompt := False;
  CommonDBConnection.Params.Values['HostName'] := HostName;
  CommonDBConnection.Params.Values['Database'] := CommonDB;
  CommonDBConnection.Params.Values['User_Name'] := UserName;
  CommonDBConnection.Params.Values['Password'] := Password;
  CommonDBConnection.Connected := True;
  CommonDBConnection.KeepConnection := False;

  SetLength(TrueBoolStrs,1);
  TrueBoolStrs[0] := '1';

  SetLength(FalseBoolStrs,1);
  FalseBoolStrs[0] := '0';
end;

procedure DestroyCommonDBConnection;
begin
  if Assigned(CommonDBConnection) then
  begin
    CommonDBConnection.Close;
    CommonDBConnection.Free;
  end;
end;

function GetSessionConnection(SessionID: string): TSQLConnection;
var
  I: Integer;
  CG: IGetConnection;
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }

  // if there's no session id, do not proceed
  if SessionID = '' then
    raise Exception.Create('SessionID is blank.');

  // check if the connection object for the session id already exists in the Connections list
  I := Connections.IndexOf(SessionID);
  if I >= 0 then
  begin
    Result := (Connections.Objects[I] as TSQLConnection);
    Exit;
  end;

  // if the connection object is not found, create a new connection from session id
  CG := GlobalContainer.Resolve<IGetConnection>('GetConnectionFromSessionID', [CommonDBConnection,'trnsessions']);
  Result := CG.Process(SessionID);

  // if the creation of connection object fails, do not proceed
  if not Assigned(Result) then
    raise Exception.Create('Connection not assigned.');

  // add the new connection object to the Connections list for future reference
  Connections.AddObject(SessionID, Result);
end;

function RemoveSessionConnection(SessionID : string) : Boolean;
var
  I : Integer;
begin
  //Check if the connection object for the sessionid already exists in the connection list
  I := Connections.IndexOf(SessionID);
  if I >= 0 then
  begin
    (Connections.Objects[I] as TSQLConnection).Close;
    (Connections.Objects[I] as TSQLConnection).Free;
    Connections.Delete(I);
  end;
end;


initialization
  Connections := TStringList.Create;
  CreateCommonDBConnection;

finalization
  DestroyCommonDBConnection;
  Connections.Free;

end.
