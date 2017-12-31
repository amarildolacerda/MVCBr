unit uSessionImplementations;

interface

uses
  System.SysUtils,
  uDbBaseClass,
  uSessionInterfaces;

type
  TSessionAddKeyValue = class(TdbBase, ISessionAddKeyValue)
  public
    function Process(SessionID: string; Key: string; Value: string): Boolean;
  end;

  TSessionGetKeyValue = class(TdbBase, ISessionGetKeyValue)
  public
    function Process(SessionID: string; Key: string): string;
  end;

  TSessionRemoveKeyValue = class(TdbBase, ISessionRemoveKeyValue)
  public
    function Process(SessionID: string; Key: string): Boolean;
  end;

  TSessionUpdateKeyValue = class(TdbBase, ISessionUpdateKeyValue)
  public
    function Process(SessionID: string; Key: string; Value: string): Boolean;
  end;

  TSessionLogout = class(TdbBase, ISessionLogout)
  public
    function Process(SessionID: string): Boolean;
  end;

  TSessionIsExpired = class(TdbBase, ISessionIsExpired)
  public
    function Process(SessionID: string): Boolean;
  end;



implementation

uses
  SynVirtualDataSet;

const
  TableName = 'trnSessions';

{ TSessionGetKeyValue }

function TSessionGetKeyValue.Process(SessionID, Key: string): string;
begin
  Query.Close;
  Query.SQL.Text := 'select SessionValue from ' + TableName + ' where ' +
                    'SessionID = ' + QuotedStr(SessionID) + ' and ' +
                    'SessionKey = ' + QuotedStr(Key);
  Query.Open;
  Result := Query.FieldByName('SessionValue').AsString;
end;


{ TSessionAddKeyValue }

function TSessionAddKeyValue.Process(SessionID, Key, Value: string): Boolean;
begin
  Query.Close;
  Query.SQL.Text := 'insert into ' + TableName + ' (SessionID, SessionKey, SessionValue) ' +
                    'values (' +
                    QuotedStr(SessionID) + ', ' +
                    QuotedStr(Key) + ', ' +
                    QuotedStr(Value) + ')';
  Result := (Query.ExecSQL > 0);
end;

{ TSessionLogout }

function TSessionLogout.Process(SessionID: string): Boolean;
begin
  Query.Close;
  Query.SQL.Text := 'delete from ' + TableName + ' where SessionID = ' + QuotedStr(SessionID);
  Result := (Query.ExecSQL > 0);
end;

{ TSessionIsExpired }

function TSessionIsExpired.Process(SessionID: string): Boolean;
var
  ExpiryDateTime: TDateTime;
begin
  Query.Close;
  Query.SQL.Text := 'select SessionValue from ' + TableName + ' where SessionID = ' + QuotedStr(SessionID) +
                    ' and SessionKey = ''ExpiresOn'';';
  Query.Open;

  Result := (Now > Query.FieldByName('SessionValue').AsDateTime);
end;

{ TSessionRemoveKeyValue }

function TSessionRemoveKeyValue.Process(SessionID, Key: string): Boolean;
begin
  Query.Close;
  Query.SQL.Text := 'delete from ' + TableName + ' where SessionID = ' +
                    QuotedStr(SessionID) + ' and SessionKey = ' + QuotedStr(Key);
  Result := (Query.ExecSQL = 1);
end;

{ TSessionUpdateKeyValue }

function TSessionUpdateKeyValue.Process(SessionID, Key, Value: string): Boolean;
begin
  Query.Close;
  Query.SQL.Text := ' update ' + TableName + ' set ' +
                    ' SessionValue = ' + QuotedStr(Value) +
                    ' where SessionID = ' + QuotedStr(SessionID) +
                    ' and SessionKey = ' + QuotedStr(Key);
  Result := (Query.ExecSQL = 1);
end;

end.
