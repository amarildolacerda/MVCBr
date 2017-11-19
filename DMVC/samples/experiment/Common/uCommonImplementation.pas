unit uCommonImplementation;

interface

uses
  uCommonInterface,
  System.JSON,
  REST.Types,
  Data.DB,
  Data.SqlExpr,
  uClasses,
  uDbBaseClass,
  uConnectionsInterfaces,
  Spring.Container,
  SynVirtualDataSet,
  System.SysUtils;

type
  TAddCompany = class(TdbBase, IAddCompany)
  public
    function Process(oCompany : TCompany): string;
  end;

  TGetCompany = class(TdbBase, IGetCompany)
    function Process() : string;
  end;

  TAddTwitterApplication = class(TdbBase, IAddTwitterApplication)
    function Process(oTwitterApplication : TTwitterApplication) : string;
  end;

  TGetTwitterApplication = class(TdbBase, IGetTwitterApplication)
    function Process(CompanyID : Integer) : string;
  end;

  TGetTwitterAccount = class(TdbBase, IGetTwitterAccount)
    function Process(AppID : Integer) : string;
  end;

  TAddTwitterAccount = class(TdbBase, IAddTwitterAccount)
    function Process(oTwitterAccount : TTwitterAccount) : string;
  end;

implementation



{ TAddCompany }

function TAddCompany.Process(oCompany: TCompany): string;
begin
  Result := 'Error While Adding.';
  Query.Close;
  Query.SQL.Text := GetInsertString(oCompany);
  try
    if Query.ExecSQL = 1 then
      Result := 'Company Added Successfully.';
  except
    Result := 'Error While Adding.';
  end;
  Query.Close;
end;

{ TGetCompany }

function TGetCompany.Process: string;
begin
  Query.Close;
  Query.SQL.Text := 'select UID,CompanyName from company ';
  Query.Open;
  Result := DataSetToJSON(Query);
end;

{ TAddTwitterApplication }

function TAddTwitterApplication.Process(oTwitterApplication : TTwitterApplication): string;
begin
  Result := 'Error While Adding.';
  Query.Close;
  Query.SQL.Text := GetInsertString(oTwitterApplication);
  try
    if Query.ExecSQL = 1 then
      Result := 'Application Added Successfully.';
  except
    Result := 'Error While Adding.';
  end;
  Query.Close;
end;

{ TGetTwitterApplication }

function TGetTwitterApplication.Process(CompanyID: Integer): string;
begin
  Query.Close;
  Query.SQL.Text := 'select UID,ConsumerName,ConsumerKey,ConsumerSecret '+
  ' from twitterapplication where PID = '+CompanyID.ToString+'';
  Query.Open;
  Result := DataSetToJSON(Query);
end;

{ TGetTwitterAccount }

function TGetTwitterAccount.Process(AppID: Integer): string;
begin
  Query.Close;
  Query.SQL.Text := 'select UID,AccountName,AccessToken,AccessTokenSecret '+
  ' from twitteraccount where PID = '+AppID.ToString+'';
  Query.Open;
  Result := DataSetToJSON(Query);
end;

{ TAddTwitterAccount }

function TAddTwitterAccount.Process(oTwitterAccount: TTwitterAccount): string;
begin
  Result := 'Error While Adding.';
  Query.Close;
  Query.SQL.Text := GetInsertString(oTwitterAccount);
  try
    if Query.ExecSQL = 1 then
      Result := 'Account Added Successfully.';
  except
    Result := 'Error While Adding.';
  end;
  Query.Close;
end;

end.
