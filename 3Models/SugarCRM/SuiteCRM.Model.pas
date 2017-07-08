{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 05/05/2017 14:44:02                                  // }
{ //************************************************************// }
Unit SuiteCRM.Model;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

{ .$I ..\inc\mvcbr.inc }
uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}
  System.Classes,
  MVCBr.Interf,
  MVCBr.Model, MVCBr.Component,
  System.JSON, System.JSON.Helper, MVCBr.Controller;

Type

  ISuiteCRMModel = interface;
  TSuiteCRMModel = class;

  TSuiteCRMUser = record

  end;

  TSuiteCRMProdut = record
  end;

  TSuiteCRMAccount = record
    id: String;
    name: string;
    assigned_user_name: string;
    modified_by_name: string;
    created_by_name: string;
    date_entered: TDateTime;
    date_modified: TDateTime;
    modified_user_id: string;
    created_by: string;
    description: string;
    deleted: string;
    assigned_user_id: string;
    account_type: string;
    industry: string;
    annual_revenue: string;
    phone_fax: string;
    billing_address_street: string;
    billing_address_city: string;
    billing_address_state: string;
    billing_address_postalcode: string;
    billing_address_country: string;
    rating: string;
    phone_office: string;
    phone_alternate: string;
    website: string;
    ownership: string;
    employees: string;
    ticker_symbol: string;
    shipping_address_street: string;
    shipping_address_city: string;
    shipping_address_state: string;
    shipping_address_postalcode: string;
    shipping_address_country: string;
    email: string;
    parent_id: string;
    sic_code: string;
    parent_name: string;
    campaign_id: string;
    campaign_name: string;
  end;

  TSuiteCRMContact = record
    id: string;
    first_name: string;
    last_name: string;
    description: string;
  end;

  ISuiteCRMComum = interface
    ['{404E82A2-55E4-4A5D-87F7-D9426E46FF09}']
    function CurrentID: String;
    function Get(AIds: string): string;
    function GetCount(AWhere: string): Integer;
    function CreateID(AJson: string): string;
    function UpdateID(AID: string; AJson: string): string;
    function Get_Entry_List(AWhere: string; AOrderBy: String;
      AOffSet: Integer = 0; ADeleted: Boolean = false): string;
  end;

  ISuiteCRMUsers = interface(ISuiteCRMComum)
    ['{B62A4DF5-5E44-4BB8-B642-DB177DDEE7F0}']
    function get_user_id: string;
  end;

  ISuiteCRMAccounts = interface(ISuiteCRMComum)
    ['{939E80A2-BCD1-446A-9083-B15A7616F726}']
    function CreateID(AJson: TSuiteCRMAccount): string; overload;
    function UpdateID(AJson: TSuiteCRMAccount): string; overload;
  end;

  ISuiteCRMContacts = interface(ISuiteCRMComum)
    ['{16CF4DC6-2EC7-4618-B371-C203C35D92B5}']
  end;

  ISuiteCRMProducts = interface(ISuiteCRMComum)
    ['{7FB40394-9DE1-4D11-AB05-706B50F3844A}']
  end;

  TSuiteCRMComum = class(TMVCFactoryAbstract, ISuiteCRMComum)
  protected
    FSelect_fields: string;
    FModel: ISuiteCRMModel;
    FCurrentID: String;
    FModuleName: string;
    FBeforeProc: TProc<IJsonObject>;
  public
    function GetArrayFromString(AItems: string): TJsonArray;
    function Get(AIds: string): string; virtual;
    function GetCount(AWhere: string): Integer; virtual;
    function Get_Entry_List(AWhere: string; AOrderBy: String;
      AOffSet: Integer = 0; ADeleted: Boolean = false): string; virtual;
    function CurrentID: String; virtual;
    function CreateID(AJson: string): string; virtual;
    function UpdateID(AID: string; AJson: string): string; virtual;
  end;

  TSuiteCRMUsers = class(TSuiteCRMComum, ISuiteCRMUsers)
  const
    moduleName = 'Users';
  public
    class function New(AModel: ISuiteCRMModel): ISuiteCRMUsers;
    function get_user_id: string;
  end;

  TSuiteCRMAccounts = class(TSuiteCRMComum, ISuiteCRMAccounts)
  const
    moduleName = 'Accounts';
  protected
  public
    class function New(AModel: ISuiteCRMModel): ISuiteCRMAccounts;
    function CreateID(AJson: TSuiteCRMAccount): string; overload;
    function UpdateID(AJson: TSuiteCRMAccount): string; overload;

  end;

  TSuiteCRMContacts = class(TSuiteCRMComum, ISuiteCRMContacts)
  const
    moduleName = 'Contacts';
  public
    class function New(AModel: ISuiteCRMModel): ISuiteCRMContacts;
  end;

  TSuiteCRMProducts = class(TSuiteCRMComum, ISuiteCRMProducts)
  const
    moduleName = 'Products';
  protected
    FModel: ISuiteCRMModel;
  public
    class function New(AModel: ISuiteCRMModel): ISuiteCRMProducts;

  end;

  // Interface de acesso ao model
  ISuiteCRMModel = interface(IModel)
    ['{E7250FB4-B5A7-470E-851C-4C3668B8263A}']
    // incluir aqui as especializações
    function ThisAs: TSuiteCRMModel;
    procedure SetBaseURL(const Value: string);
    procedure SetPathURL(const Value: string);
    function GetBaseURL: string;
    function GetPathURL: string;

    property BaseURL: string read GetBaseURL write SetBaseURL;
    property PathURL: string read GetPathURL write SetPathURL;
    function GetURL(AResource: string; AParams: string): string;
    function Init(ABaseURL: string; APathUrl: string; AUser: string;
      APassword: String): ISuiteCRMModel;

    function Users: ISuiteCRMUsers;

    Function &Get(AMethod, ARestData: string): string;
    function &Post(AResource, ARestData: string): string;
    function &Put(AMethod, ARestData: string): String;

    Function RequestText: String;
    Function ResponseText: string;
    Function ToJson: string;

    function Login(AUserID, APasswd: string): Boolean;
    function GetEntryPoint(AModule: string; AJson: string = '{}'): IJsonObject;

    //
    function SessionID: string;
    function GetAccounts: ISuiteCRMAccounts;
    property Accounts: ISuiteCRMAccounts read GetAccounts;
    function Contacts: ISuiteCRMContacts;
  end;

  TSuiteCRMModel = class(TComponentFactory, ISuiteCRMModel,
    IThisAs<TSuiteCRMModel>)
  private
    FRequest: string;
    FResponse: string;
    FTokenID: string;
    FBaseURL: string;
    FPathURL: string;
    FUser_name: string;
    FPassword: string;
    FUsers: ISuiteCRMUsers;
    FAccounts: ISuiteCRMAccounts;
    FContacts: ISuiteCRMContacts;
    FProducts: ISuiteCRMProducts;
    procedure SetBaseURL(const Value: string);
    procedure SetPathURL(const Value: string);
    function GetBaseURL: string;
    function GetPathURL: string;
    procedure SetPassword(const Value: string);
    procedure SetUser_name(const Value: string);
    function Login(AUserID, APasswd: string): Boolean;
    procedure SetAccounts(const Value: ISuiteCRMAccounts);
    function GetAccounts: ISuiteCRMAccounts;
    procedure SetProducts(const Value: ISuiteCRMProducts);
    function GetProducts: ISuiteCRMProducts;
  protected
  public
    Constructor Create(AOwner: TComponent); overload; override;
    Constructor Create; overload;
    Destructor Destroy; override;
    class function New(): ISuiteCRMModel; overload;
    class function New(const AController: IController): ISuiteCRMModel;
      overload;
    function ThisAs: TSuiteCRMModel;

    function GetEntryPoint(AModule: string; AJson: string = '{}'): IJsonObject;

    // implementaçoes REST
    function Get_Entry_List(AModule, ASelect_fields, AWhere: string;
      AOrderBy: String; AOffSet: Integer = 0;
      ADeleted: Boolean = false): string;

    /// server interfaced
    property BaseURL: string read GetBaseURL write SetBaseURL;
    property PathURL: string read GetPathURL write SetPathURL;
    property User_name: string read FUser_name write SetUser_name;
    property Password: string read FPassword write SetPassword;
    function GetURL(AResource: string; AParams: string = ''): string;
    function Init(ABaseURL: string; APathUrl: string; AUser: string;
      APassword: String): ISuiteCRMModel;

    function &Post(AResource, ARestData: string): string;
    Function &Get(AMethod, ARestData: string): string;
    Function &Put(AMethod, ARestData: string): String;

    Function RequestText: String;
    Function ResponseText: string;
    Function ToJson: string;

    function SessionID: string;
    function Users: ISuiteCRMUsers;
    property Accounts: ISuiteCRMAccounts read GetAccounts;
    function Contacts: ISuiteCRMContacts;

    property Products: ISuiteCRMProducts read GetProducts;

  end;

Implementation

uses System.RTTI, System.Classes.Helper, idHttp, IdHashMessageDigest;

function TSuiteCRMModel.Contacts: ISuiteCRMContacts;
begin
  result := FContacts;
end;

constructor TSuiteCRMModel.Create();
begin
  Create(nil);
end;

constructor TSuiteCRMModel.Create(AOwner: TComponent);
begin
  inherited;
  ModelTypes := [mtComponent];
  FUsers := TSuiteCRMUsers.New(self);
  FAccounts := TSuiteCRMAccounts.New(self);
  FContacts := TSuiteCRMContacts.New(self);

  FProducts := TSuiteCRMProducts.New(self);
end;

destructor TSuiteCRMModel.Destroy;
begin
  inherited;
end;

function TSuiteCRMModel.GetEntryPoint(AModule: string; AJson: string = '{}')
  : IJsonObject;
begin
  result := TInterfacedJSON.New(AJson);
  result.addPair('session', FTokenID);
  result.addPair('module_name', AModule);
end;

const
  cSugarCRMApplication = 'MVCBr Rest API';

function TSuiteCRMModel.Post(AResource, ARestData: string): string;
var
  sl: TStringList;
  http: TIdHttp;
  url: string;
begin
  http := TIdHttp.Create(nil);
  try
    url := GetURL('', '');
    sl := TStringList.Create;
    try
      sl.Add('method=' + AResource);
      sl.Add('input_type=JSON');
      sl.Add('response_type=JSON');
      sl.Add('rest_data=' + ARestData);

      FRequest := sl.text;
      result := http.Post(url, sl);
      FResponse := result;
    finally
      sl.Free;
    end;
  finally
    http.Free;
  end;
end;

function TSuiteCRMModel.Login(AUserID, APasswd: string): Boolean;

var
  md5: TIdHashMessageDigest5;
  data: string;
  JSON: IJsonObject;
  j: IJsonObject;
  a: TJsonArray;
  oldToken: string;
begin
  result := false;
  oldToken := FTokenID;
  FTokenID := '';
  md5 := TIdHashMessageDigest5.Create;
  try
    JSON := TInterfacedJSON.New();
    JSON.addPair('user_name', AUserID);
    JSON.addPair('password', md5.HashStringAsHex(APasswd));
    JSON.addPair('version', '1');

    a := TJsonArray.Create;
    j := TInterfacedJSON.New;
    j.addChild('user_auth', JSON.ToJson);
    j.addPair('application', cSugarCRMApplication);

    j.addArray('name_value_list', a);

    FResponse := Post('login', j.ToJson);

    j := TInterfacedJSON.New(FResponse);
    if not j.isNull then
    begin
      FTokenID := j.Value['id'];
    end;
    result := FTokenID <> '';
    if result then
    begin
      FUser_name := AUserID;
      FPassword := APasswd;
    end
    else
    begin
      FTokenID := oldToken;
      if j.Value['description'] <> '' then
        raise Exception.Create(j.Value['description']);
    end;
  finally
    md5.Free;
  end;
end;

function TSuiteCRMModel.Get(AMethod, ARestData: string): string;
var
  http: TIdHttp;
  url: string;
begin
  http := TIdHttp.Create(nil);
  try
    FRequest := ARestData;
    Post(AMethod, FRequest);
    result := FResponse;
  finally
    http.Free;
  end;
end;

function TSuiteCRMModel.GetAccounts: ISuiteCRMAccounts;
begin
  result := FAccounts;
end;

function TSuiteCRMModel.GetBaseURL: string;
begin
  result := FBaseURL;
end;

function TSuiteCRMModel.GetPathURL: string;
begin
  result := FPathURL;
end;

function TSuiteCRMModel.GetProducts: ISuiteCRMProducts;
begin
  result := FProducts;
end;

function TSuiteCRMModel.GetURL(AResource: string; AParams: string): string;
begin
  result := BaseURL + PathURL + AResource;
  if AParams <> '' then
    result := result + '?' + AParams;
end;

function TSuiteCRMModel.Get_Entry_List(AModule, ASelect_fields, AWhere,
  AOrderBy: String; AOffSet: Integer = 0; ADeleted: Boolean = false): string;
begin
  with GetEntryPoint(AModule) do
  begin
    addPair('query', AWhere);
    addPair('order_by', AOrderBy);
    addPair('offset', AOffSet.toString);
    addPair('select_fields', ASelect_fields);
    addPair('link_name_to_fields_array', TJsonArray.Create());
    addPair('max_results', TJSONNumber.Create(-1));
    addPair('deleted', ord(ADeleted).toString);
    addPair('favorites', TJSONFalse.Create);
    result := Get('Get_Entry_List', ToJson);
  end;
end;

function TSuiteCRMModel.Init(ABaseURL, APathUrl, AUser, APassword: String)
  : ISuiteCRMModel;
begin
  result := self;
  FBaseURL := ABaseURL;
  FPathURL := APathUrl;
  FUser_name := AUser;
  FPassword := APassword;
end;

function TSuiteCRMModel.ThisAs: TSuiteCRMModel;
begin
  result := self;
end;

class function TSuiteCRMModel.New(): ISuiteCRMModel;
begin
  result := New(nil);
end;

class function TSuiteCRMModel.New(const AController: IController)
  : ISuiteCRMModel;
begin
  result := TSuiteCRMModel.Create;
  result.Controller(AController);
end;

function TSuiteCRMModel.Put(AMethod, ARestData: string): String;
var
  http: TIdHttp;
  url: string;
  j: IJsonObject;
  sl: TStringList;
  a: TJsonValue;
begin
  http := TIdHttp.Create(nil);
  try
    FRequest := ARestData;
    Post(AMethod, FRequest);
    result := FResponse;
  finally
    http.Free;
  end;
end;

function TSuiteCRMModel.ToJson: string;
var
  a: TJsonArray;
  j: IJsonObject;
  tmp, vv: TJsonValue;
  r, tmp1: TJSONObject;
  i: Integer;
  v: TJSONObject;
  k: TJsonPair;

  function GetNewJson(tmp1: TJSONObject;AOwned:Boolean): IJsonObject;
  var
    i: Integer;
  begin
    /// convert para JSON Plano (retira tags desnecessárias)
    try
      result := TInterfacedJSON.New(TJsonObject.create,AOwned);
      try
        for i := 0 to tmp1.count - 1 do
        begin
          k := tmp1.Get(i);
          result.addPair(k.JsonString.Value,
            k.JsonValue.GetValue<TJsonValue>('value'));
        end;
      finally
      end;
    except
    end;
  end;

begin
  result := FResponse;
  j := TInterfacedJSON.New(FResponse);
  if j.isNull then
  begin
    result := '';
    exit;
  end;

  if j.Contains('entry_list') then
  begin
    j.JSONObject.TryGetValue<TJsonValue>('entry_list', tmp);
    result := tmp.ToJson;
    with TInterfacedJSON.New(result) do
      if AsArray.Get(0).asObject.Contains('name_value_list') then
      begin
        tmp.Free;
        a := TJsonArray.Create;
        try
          for vv in AsArray do
          begin
            vv.tryGetValue<TJsonValue>('name_value_list',tmp);
            tmp1 := tmp as TJsonObject;
            a.Add( GetNewJson(tmp1,false).JSONObject );
          end;  
          result := a.ToJson;
        finally
          a.Free;
        end;
        exit;
      end
      else
        exit;
  end
  else if j.Contains('name_value_list') then
    j.JSONObject.TryGetValue<TJsonValue>('name_value_list', tmp)
  else
    exit;

  if not assigned(tmp) then
    exit;

  tmp1 := tmp as TJSONObject;

  result := GetNewJson(tmp1,false).ToJson;

end;

function TSuiteCRMModel.Users: ISuiteCRMUsers;
begin
  result := FUsers;
end;

function TSuiteCRMModel.RequestText: String;
begin
  result := FRequest;
end;

function TSuiteCRMModel.ResponseText: string;
begin
  result := FResponse;
end;

function TSuiteCRMModel.SessionID: string;
begin
  result := FTokenID;
end;

procedure TSuiteCRMModel.SetAccounts(const Value: ISuiteCRMAccounts);
begin
  FAccounts := Value;
end;

procedure TSuiteCRMModel.SetBaseURL(const Value: string);
begin
  FBaseURL := Value;
end;

procedure TSuiteCRMModel.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TSuiteCRMModel.SetPathURL(const Value: string);
begin
  FPathURL := Value;
end;

procedure TSuiteCRMModel.SetProducts(const Value: ISuiteCRMProducts);
begin
  FProducts := Value;
end;

procedure TSuiteCRMModel.SetUser_name(const Value: string);
begin
  FUser_name := Value;
end;

type

  TInterfacedJSONHelper = class helper for TInterfacedJSON
  public
    procedure addItem(AName: String; AValue: String);
  end;

procedure TInterfacedJSONHelper.addItem(AName: String; AValue: String);
var
  v: TJsonValue;
begin
  v := TJSONObject.Create;
  v.addPair('name', AName);
  v.addPair('value', AValue);
  self.addPair(AName, v);
end;

{ TSugarCRMAccounts }

function TSuiteCRMComum.CreateID(AJson: string): string;
var
  v: IJsonObject;
  j: TJSONObject;
begin
  try
    /// dados do item
    v := FModel.GetEntryPoint(FModuleName);
    j := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
    j.addPair('track_view', TJsonTrue.Create);
    v.addPair('name_value_list', j);
    result := FModel.Post('Set_Entry', v.ToJson);

    with TInterfacedJSON.New(result) do
      if not isNull then
      begin
        if Contains('id') then
          FCurrentID := Value['id'];
      end;
  finally
  end;
end;

function TSuiteCRMComum.CurrentID: String;
begin
  result := FCurrentID;
end;

function TSuiteCRMComum.Get(AIds: string): string;
var
  sl: TStringList;
  i: Integer;
  JSON: IJsonObject;
begin
  try
    JSON := FModel.GetEntryPoint(FModuleName);
    sl := TStringList.Create;
    try
      sl.Delimiter := ',';
      sl.DelimitedText := AIds;
      with JSON.addArray('ids', TJsonArray.Create) do
        for i := 0 to sl.count - 1 do
        begin
          Add(sl[i]);
        end;

      JSON.addArray('select_fields', GetArrayFromString(FSelect_fields));

      JSON.addPair('track_view', TJsonTrue.Create);

    finally
      sl.Free;
    end;
    if assigned(FBeforeProc) then
      FBeforeProc(JSON);
    result := FModel.Get('Get_Entries', JSON.ToJson);
  finally
  end;
end;

function TSuiteCRMComum.GetArrayFromString(AItems: string): TJsonArray;
var
  st: TStringList;
  s: String;
begin
  result := TJsonArray.Create;
  st := TStringList.Create;
  try
    with result do
      for s in st do
      begin
        Add(s);
      end;
  finally
    st.Free;
  end;
end;

function TSuiteCRMComum.GetCount(AWhere: string): Integer;
begin
  with FModel.GetEntryPoint(FModuleName) do
  begin
    addPair('query', AWhere);
    addPair('deleted', '0');
    FModel.Get('Get_Entries_Count', ToJson);
  end;
  with TInterfacedJSON.New(FModel.ResponseText) do
  begin
    if not isNull then
      result := JSONObject.i('result_count');
  end;
end;

function TSuiteCRMComum.Get_Entry_List(AWhere, AOrderBy: String;
  AOffSet: Integer = 0; ADeleted: Boolean = false): string;
begin
  result := FModel.ThisAs.Get_Entry_List(FModuleName, FSelect_fields, AWhere,
    AOrderBy, AOffSet, ADeleted);
end;

type
  TJsonRecordEx<T: Record > = class(TJsonRecord<T>)
    class function ToJsonValueList(O: T; AIgnoreEmpty: Boolean = true;
      AProc: TProc < TJSONObject >= nil): String;
  end;

class function TJsonRecordEx<T>.ToJsonValueList(O: T;
  AIgnoreEmpty: Boolean = true; AProc: TProc < TJSONObject >= nil): String;
var
  AContext: TRttiContext;
  AField: TRttiField;
  ARecord: TRttiRecordType;
  AFldName: String;
  AValue: TValue;
  ArrFields: TArray<TRttiField>;
  i: Integer;
  js: TJSONObject;
  v: IJsonObject;
begin
  js := TJSONObject.Create;
  AContext := TRttiContext.Create;
  try
    ARecord := AContext.GetType(TypeInfo(T)).AsRecord;
    ArrFields := ARecord.GetFields;
    i := 0;
    for AField in ArrFields do
    begin
      AFldName := AField.name;

      v := TInterfacedJSON.New;
      v.addPair('name', AFldName);

      AValue := AField.GetValue(@O);
      try
        if AValue.IsEmpty then
        begin
          if not AIgnoreEmpty then
            v.addPair('value', 'NULL');
        end
        else
          case AField.FieldType.TypeKind of
            tkInteger, tkInt64:
              try
                v.addPair('value', TJSONNumber.Create(AValue.AsInt64));
              except
                v.addPair('value', TJSONNumber.Create(0));
              end;
            tkEnumeration:
              v.addPair('value', TJSONNumber.Create(AValue.AsInteger));
            tkFloat:
              begin
                if AField.FieldType.toString.Equals('TDateTime') then
                begin
                  if AValue.AsExtended < 1 then
                    continue;
                  v.addPair('value', FormatDateTime('yyyy-mm-dd HH:nn:ss',
                    AValue.AsExtended));
                end
                else if AField.FieldType.toString.Equals('TDate') then
                begin
                  if (AValue.AsExtended < 1) then
                    continue;
                  v.addPair('value', FormatDateTime('yyyy-mm-dd',
                    AValue.AsExtended));
                end
                else if AField.FieldType.toString.Equals('TTime') then
                  v.addPair('value', FormatDateTime('HH:nn:ss',
                    AValue.AsExtended))
                else
                  try
                    v.addPair('value', TJSONNumber.Create(AValue.AsExtended));
                  except
                    v.addPair('value', TJSONNumber.Create(0));
                  end;
              end
          else
            if (AIgnoreEmpty) and AValue.AsString.IsEmpty then
              continue;
            v.addPair('value', AValue.AsString)
          end;
        js.addPair(AFldName, v.JsonValue);
      except
      end;

    end;

    if assigned(AProc) then
      AProc(js);

    result := js.toString;
  finally
    js.Free;
    AContext.Free;
  end;

end;

function TSuiteCRMAccounts.CreateID(AJson: TSuiteCRMAccount): string;
begin
  result := inherited CreateID
    (TJsonRecord<TSuiteCRMAccount>.ToJson { ValueList }
    (AJson, true,
    procedure(js: TJSONObject)
    // var
    // v: TJSONObject;
    begin
      if AJson.id <> '' then
      begin
        // js.addPair('id', AJson.id);
        // v := TJSONObject.Create as TJSONObject;
        // v.addPair('name', 'new_with_id');
        // v.addPair('value', TJSONTrue.Create);
        js.addPair('new_with_id', TJSONNumber.Create(1));
      end;
    end));
end;

class function TSuiteCRMAccounts.New(AModel: ISuiteCRMModel): ISuiteCRMAccounts;
var
  O: TSuiteCRMAccounts;
begin
  O := TSuiteCRMAccounts.Create;
  O.FModuleName := moduleName;
  O.FModel := AModel;
  // o.FSelect_fields := 'name,billing_address_state,billing_address_country';
  result := O;
end;

function TSuiteCRMComum.UpdateID(AID, AJson: string): string;
var
  item: IJsonObject;
  v: IJsonObject;
begin
  item := FModel.GetEntryPoint(FModuleName);
  try
    item.addPair('id', AID);
    v := TInterfacedJSON.New(AJson);
    item.addPair('name_value_list', v.JSONObject);
    result := FModel.Put('Set_Entry', item.ToJson);
  finally
  end;
end;

{ TSugarCRMProducts }

class function TSuiteCRMProducts.New(AModel: ISuiteCRMModel): ISuiteCRMProducts;
var
  O: TSuiteCRMProducts;
begin
  O := TSuiteCRMProducts.Create;
  O.FModuleName := moduleName;
  O.FModel := AModel;
  result := O;
end;

{ TSuiteCRMAccount }
function TSuiteCRMAccounts.UpdateID(AJson: TSuiteCRMAccount): string;
begin
  result := inherited UpdateID(AJson.id,
    TJsonRecord<TSuiteCRMAccount>.ToJson(AJson));
end;

{ TJsonRecordEx<T> }

{ TSuiteCRMUsers }

function TSuiteCRMUsers.get_user_id: string;
begin
  with FModel.GetEntryPoint(FModuleName) do
    result := FModel.Get('get_user_id', ToJson);
end;

class function TSuiteCRMUsers.New(AModel: ISuiteCRMModel): ISuiteCRMUsers;
var
  O: TSuiteCRMUsers;
begin
  O := TSuiteCRMUsers.Create;
  O.FModuleName := moduleName;
  O.FModel := AModel;
  result := O;
end;

{ TSuiteCRMContacts }

class function TSuiteCRMContacts.New(AModel: ISuiteCRMModel): ISuiteCRMContacts;
var
  O: TSuiteCRMContacts;
begin
  O := TSuiteCRMContacts.Create;
  O.FModuleName := moduleName;
  O.FModel := AModel;
  result := O;
end;

Initialization

TMVCRegister.RegisterType<ISuiteCRMModel, TSuiteCRMModel>
  (TSuiteCRMModel.classname, true);

end.
