unit uUserImplementation;

interface

uses
  System.SysUtils,
  System.Classes,
  Spring.Container,
  uDbBaseClass,
  uUserInterfaces,
  SynCommons,
  uUserClass;

type
  TUserLogin = class(TdbBase, IUserLogin)
  public
    function Process(Username, Password: string): string;
  end;

implementation

uses
  SynVirtualDataSet;

{ TUserProcessor }

function TUserLogin.Process(UserName, Password: string): string;
begin
  if (Trim(Username) = '') or (Trim(Password) = '') then
  begin
    Result := '111';
    Exit;
  end;

  Query.Close;
  Query.SQL.Text := 'SELECT UID,Name, UType, FolderID, ''socialmedia'' DatabaseName FROM users ml where ml.Login = '+QuotedStr(Username)+' and ml.password = '+QuotedStr(Password)+'';

  Query.Open;
  Result := DataSetToJSON(Query);
  Query.Close;
end;

end.
