unit uConnectionsImplementation;

interface

uses
  Data.SqlExpr,
  Data.DBXMySQL,
  uConnectionsInterfaces,
  uSessionInterfaces,
  uDbBaseClass,REST.Json,System.JSON;

type
  TGetConnectionFromDBName = class(TInterfacedObject, IGetConnection)
  public
    function Process(S: string): TSQLConnection;
  end;

  TGetConnectionFromSessionID = class(TdbBase, IGetConnection)
  public
    function Process(S: string): TSQLConnection;
  end;

implementation

uses
  System.SysUtils,
  Spring.Container,
  System.IniFiles,SynVirtualDataSet;

const
  DatabasesTable  = 'tblCommon';
  DBNameField     = 'dbname';

{ TGetConnection }

function TGetConnectionFromDBName.Process(S: string): TSQLConnection;
var
  ApplicationPath : string;
  IniFile         : string;
  X               : TIniFile;
  HostName        ,
  UserName        ,
  DB              ,
  Password        : string;
  Y               : TSQLConnection;
begin
  ApplicationPath := ExtractFilePath(GetModuleName(hInstance));
  IniFile         := ApplicationPath+'serverconfig.ini';
  X               := TIniFile.Create(IniFile);
  HostName        := X.ReadString('DBInfo', 'SERVER', '');
  UserName        := X.ReadString('DBInfo', 'USERNAME', '');
  Password        := X.ReadString('DBInfo', 'PASSWORD', '');

  Result              := TSQLConnection.Create(nil);
  Result.DriverName   := 'MySQL';
  Result.LoginPrompt  := False;
  Result.Params.Values['HostName']  := HostName;
  Result.Params.Values['Database']  := 'socialmedia';
  Result.Params.Values['User_Name'] := UserName;
  Result.Params.Values['Password']  := Password;
  Result.Connected := True;
  Result.KeepConnection := False;
end;

{ TGetConnectionFromSessionID }

function TGetConnectionFromSessionID.Process(S: string): TSQLConnection;
var
  SVG         : ISessionGetKeyValue;
  DBName      : string;
  CG          : IGetConnection;
  LJsonArr    : TJSONArray;
  LJsonValue  : TJSONValue;
  LItem       : TJSONValue;
begin
  if Trim(S) = '' then
    raise Exception.Create('GetConnectionFromSessionID: SessionID is blank.');

  SVG := GlobalContainer.Resolve<ISessionGetKeyValue>('SessionGetKeyValue', [DBConnection,'trnsessions']);
  DBName := SVG.Process(S, 'DatabaseName');

  CG := GlobalContainer.Resolve<IGetConnection>('GetConnectionFromDBName');
  Result := CG.Process(DBName);
end;

end.
