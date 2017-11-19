unit uClasses;

interface

uses
  System.Classes,
  Data.DB,
  uBasicFieldsClass;

type
  TCompany = class(TBasicFieldsClass)
  private
    FCompanyName: string;
    procedure SetCompanyName(const Value: string);

  public
    [TDatabaseFieldAttribute('CompanyName',ftString)]
    property CompanyName: string read FCompanyName write SetCompanyName;
  end;

  TTwitterApplication = class(TBasicFieldsClass)
  private
    FConsumerSecret: string;
    FConsumerKey: string;
    FConsumerName: string;
    procedure SetConsumerKey(const Value: string);
    procedure SetConsumerName(const Value: string);
    procedure SetConsumerSecret(const Value: string);
  public
    [TDatabaseFieldAttribute('ConsumerName',ftString)]
    property ConsumerName: string read FConsumerName write SetConsumerName;

    [TDatabaseFieldAttribute('ConsumerKey',ftString)]
    property ConsumerKey: string read FConsumerKey write SetConsumerKey;

    [TDatabaseFieldAttribute('ConsumerSecret',ftString)]
    property ConsumerSecret: string read FConsumerSecret write SetConsumerSecret;
  end;

  TTwitterAccount = class(TBasicFieldsClass)
  private
    FAccessToken: string;
    FAccessTokenSecret: string;
    FAccountName: string;
    procedure SetAccessToken(const Value: string);
    procedure SetAccessTokenSecret(const Value: string);
    procedure SetAccountName(const Value: string);
  published
    [TDatabaseFieldAttribute('AccessToken',ftString)]
    property AccessToken: string read FAccessToken write SetAccessToken;
    [TDatabaseFieldAttribute('AccessTokenSecret',ftString)]
    property AccessTokenSecret: string read FAccessTokenSecret write SetAccessTokenSecret;
    [TDatabaseFieldAttribute('AccountName',ftString)]
    property AccountName: string read FAccountName write SetAccountName;
  end;

implementation

{ TQClientEntity }

procedure TCompany.SetCompanyName(const Value: string);
begin
  FCompanyName := Value;
end;

{ TTwitterApplication }

procedure TTwitterApplication.SetConsumerKey(const Value: string);
begin
  FConsumerKey := Value;
end;

procedure TTwitterApplication.SetConsumerName(const Value: string);
begin
  FConsumerName := Value;
end;

procedure TTwitterApplication.SetConsumerSecret(const Value: string);
begin
  FConsumerSecret := Value;
end;

{ TTwitterAccount }

procedure TTwitterAccount.SetAccessToken(const Value: string);
begin
  FAccessToken := Value;
end;

procedure TTwitterAccount.SetAccessTokenSecret(const Value: string);
begin
  FAccessTokenSecret := Value;
end;

procedure TTwitterAccount.SetAccountName(const Value: string);
begin
  FAccountName := Value;
end;

end.
