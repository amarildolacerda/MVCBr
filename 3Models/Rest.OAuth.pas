{
      Mozilla Public License.

      ``The contents of this file are subject to the Mozilla Public License
      Version 1.1 (the "License"); you may not use this file except in compliance
      with the License. You may obtain a copy of the License at

      http://www.mozilla.org/MPL/

      Software distributed under the License is distributed on an "AS IS"
      basis, WITHOUT WARRANTY OF

      ANY KIND, either express or implied. See the License for the specific language governing rights and

      limitations under the License.

      The Original Code is OAuth Core 1.0 - Delphi implementation.

      The Initial Developer of the Original Code is CB2 Enterprises, Inc.
      Portions created by

      CB2 Enterprises, Inc. are Copyright (C) 2008-2009.
      All Rights Reserved.

      Contributor(s): ______________________________________.

      Alternatively, the contents of this file may be used under the terms
      of the _____ license (the  [___] License), in which case the provisions
      of [______] License are applicable  instead of those above.
      If you wish to allow use of your version of this file only under the terms
      of the [____] License and not to allow others to use your version of this
      file under the MPL, indicate your decision by deleting  the provisions
      above and replace  them with the notice and other provisions required
      by the [___] License.  If you do not delete the provisions above,
      a recipient may use your version of this file under either the MPL or the
      [___] License."
}

unit Rest.OAuth;

interface

uses
  Classes, SysUtils, IdURI, Windows;

type

  EOAuthException = class(Exception);

  TOAuthConsumer = class;
  TOAuthToken = class;
  TOAuthRequest = class;
  TOAuthSignatureMethod = class;
  TOAuthSignatureMethod_HMAC_SHA1 = class;
  TOAuthSignatureMethod_PLAINTEXT = class;

  TOAuthConsumer = class
  private
    FKey: string;
    FSecret: string;
    FCallback_URL: string;
    procedure SetKey(const Value: string);
    procedure SetSecret(const Value: string);
    procedure SetCallback_URL(const Value: string);
  public
    constructor Create(Key, Secret: string); overload;
    constructor Create(Key, Secret: string; Callback_URL: string); overload;
    property Key: string read FKey write SetKey;
    property Secret: string read FSecret write SetSecret;
    property Callback_URL: string read Fcallback_URL write SetCallback_URL;
  end;

  TOAuthToken = class
  private
    FKey: string;
    FSecret: string;
    procedure SetKey(const Value: string);
    procedure SetSecret(const Value: string);
  public
    constructor Create(Key, Secret: string);
    function AsString: string; virtual;
    property Key: string read FKey write SetKey;
    property Secret: string read FSecret write SetSecret;
  end;

  TOAuthRequest = class
  private
    FParameters: TStringList;
    FHTTPURL: string;
    FScheme: string;
    FHost: string;
    FPath: string;
    FFields: string;
    FVersion: string;
    FBaseString: string;
    FGetString: string;
    procedure SetHTTPURL(const Value: string);
    procedure SetBaseString(const Value: string);
    procedure SetVersion(const Value: string);
    function GenerateNonce: string;
    function GenerateTimeStamp: string;
    function GetSignableParameters: string;
  public
    constructor Create(HTTPURL: string);
    function FromConsumerAndToken(Consumer: TOAuthConsumer; Token: TOAuthToken;
                                  HTTPURL: string): TOAuthRequest;
    procedure Sign_Request(Signature_Method: TOAuthSignatureMethod; Consumer: TOAuthConsumer;
                          Token: TOAuthToken);
    function Build_Signature(Signature_Method: TOAuthSignatureMethod; Consumer: TOAuthConsumer;
                          Token: TOAuthToken): string;
    property BaseString: string read FBaseString write SetBaseString;
    property Version: string read FVersion write SetVersion;
    property Parameters: TStringList read FParameters;
    property HTTPURL: string read FHTTPURL write SetHTTPURL;
    property Scheme: string read FScheme;
    property Host: string read FHost;
    property Path: string read FPath;
    property Fields: string read FFields;
    property GetString: string read FGetString;
  end;

  TOAuthSignatureMethod = class
  public
    function check_signature(Request: TOAuthRequest; Consumer: TOAuthConsumer;
                             Token: TOAuthToken; Signature: string): boolean;
    function get_name(): string; virtual; abstract;
    function build_signature(Request: TOAuthRequest; Consumer: TOAuthConsumer;
                             Token: TOAuthToken): string; virtual; abstract;
  end;

  TOAuthSignatureMethod_HMAC_SHA1 = class(TOAuthSignatureMethod)
  public
    function get_name(): string; override;
    function build_signature(Request: TOAuthRequest; Consumer: TOAuthConsumer;
                             Token: TOAuthToken): string; override;
  end;

  TOAuthSignatureMethod_PLAINTEXT = class(TOAuthSignatureMethod)
  public
    function get_name(): string; override;
    function build_signature(Request: TOAuthRequest; Consumer: TOAuthConsumer;
                             Token: TOAuthToken): string; override;
  end;

  TOAuthUtil = class
  public
    class function urlEncodeRFC3986(URL: string):string;
    class function urlDecodeRFC3986(URL: string):string;
  end;

const
  UnixStartDate : TDateTime = 25569;

implementation
uses
  IdGlobal, IdHash, IdHashMessageDigest, IdHMACSHA1, IdCoderMIME;

function DateTimeToUnix(ConvDate: TDateTime): Longint;
var
  x: double;
  lTimeZone: TTimeZoneInformation;
begin
  GetTimeZoneInformation(lTimeZone);
  ConvDate := ConvDate + (lTimeZone.Bias / 1440);
  x := (ConvDate - UnixStartDate) * 86400;
  Result := Trunc(x);
end;

function _IntToHex(Value: Integer; Digits: Integer): String;
begin
    Result := SysUtils.IntToHex(Value, Digits);
end;

function XDigit(Ch : Char) : Integer;
begin
    if (Ch >= '0') and (Ch <= '9') then
        Result := Ord(Ch) - Ord('0')
    else
        Result := (Ord(Ch) and 15) + 9;
end;


function IsXDigit(Ch : Char) : Boolean;
begin
    Result := ((Ch >= '0') and (Ch <= '9')) or
              ((Ch >= 'a') and (Ch <= 'f')) or
              ((Ch >= 'A') and (Ch <= 'F'));
end;

function htoin(Value : PChar; Len : Integer) : Integer;
var
    I : Integer;
begin
    Result := 0;
    I      := 0;
    while (I < Len) and (Value[I] = ' ') do
        I := I + 1;
    while (I < len) and (IsXDigit(Value[I])) do begin
        Result := Result * 16 + XDigit(Value[I]);
        I := I + 1;
    end;
end;


function htoi2(Value : PChar) : Integer;
begin
    Result := htoin(Value, 2);
end;

function UrlEncode(const S : String) : String;
var
    I : Integer;
    Ch : Char;
begin
    Result := '';
    for I := 1 to Length(S) do begin
        Ch := S[I];
        if ((Ch >= '0') and (Ch <= '9')) or
           ((Ch >= 'a') and (Ch <= 'z')) or
           ((Ch >= 'A') and (Ch <= 'Z')) or
           (Ch = '.') or (Ch = '-') or (Ch = '_') or (Ch = '~')then
            Result := Result + Ch
        else
            Result := Result + '%' + _IntToHex(Ord(Ch), 2);
    end;
end;

function UrlDecode(const Url : String) : String;
var
    I, J, K, L : Integer;
begin
    Result := Url;
    L      := Length(Result);
    I      := 1;
    K      := 1;
    while TRUE do begin
        J := I;
        while (J <= Length(Result)) and (Result[J] <> '%') do begin
            if J <> K then
                Result[K] := Result[J];
            Inc(J);
            Inc(K);
        end;
        if J > Length(Result) then
            break;                   { End of string }
        if J > (Length(Result) - 2) then begin
            while J <= Length(Result) do begin
                Result[K] := Result[J];
                Inc(J);
                Inc(K);
            end;
            break;
        end;
        Result[K] := Char(htoi2(@Result[J + 1]));
        Inc(K);
        I := J + 3;
        Dec(L, 2);
    end;
    SetLength(Result, L);
end;

{ TOAuthConsumer }
constructor TOAuthConsumer.Create(Key, Secret: string);
begin
  FKey := Key;
  FSecret := Secret;
  FCallBack_URL  := '';
end;

constructor TOAuthConsumer.Create(Key, Secret, Callback_URL: string);
begin
  FKey := Key;
  FSecret := Secret;
  FCallBack_URL  := Callback_URL;
end;

procedure TOAuthConsumer.SetCallback_URL(const Value: string);
begin
  FCallback_URL := Value;
end;

procedure TOAuthConsumer.SetKey(const Value: string);
begin
  FKey := Value;
end;

procedure TOAuthConsumer.SetSecret(const Value: string);
begin
  FSecret := Value;
end;

{ TOAuthToken }
function TOAuthToken.AsString: string;
begin
  result := 'oauth_token=' + Self.Key + '&oauth_token_secret=' + Self.Secret;
end;

constructor TOAuthToken.Create(Key, Secret: string);
begin
  FKey := Key;
  FSecret := Secret;
end;

procedure TOAuthToken.SetKey(const Value: string);
begin
  FKey := Value;
end;

procedure TOAuthToken.SetSecret(const Value: string);
begin
  FSecret := Value;
end;

{ TOAuthRequest }
function TOAuthRequest.Build_Signature(Signature_Method: TOAuthSignatureMethod;
  Consumer: TOAuthConsumer; Token: TOAuthToken): string;
begin
  Result := Signature_Method.build_signature(Self, Consumer, Token);
end;

constructor TOAuthRequest.Create(HTTPURL: string);
var
  x,y: integer;
begin
  FHTTPURL := HTTPURL;
  FScheme := Copy(FHTTPURL, 0, 7);
  x := AnsiPos('.com', FHTTPURL);
  y := AnsiPos('?', FHTTPURL);
  FHost := Copy(FHTTPURL, 8, x-4);
  FPath := Copy(FHTTPURL, x + 4, Length(HTTPURL) - y - 1);
  if y > 0 then
    FFields := Copy(FHTTPURL, y + 1, Length(HTTPURL));
  FVersion := '1.0';
  FParameters := TStringList.Create;
end;

function TOAuthRequest.FromConsumerAndToken(Consumer: TOAuthConsumer;
  Token: TOAuthToken; HTTPURL: string): TOAuthRequest;
begin
  Self.FParameters.Clear;
  Self.FParameters.Add('oauth_consumer_key=' + Consumer.Key);
  Self.FParameters.Add('oauth_nonce=' + Self.GenerateNonce);
  Self.FParameters.Add('oauth_timestamp=' + Self.GenerateTimeStamp);
  if Token <> nil then
    FParameters.Add('oauth_token=' + Token.Key);
  Self.FParameters.Add('oauth_version=' + Self.Version);
  Result := Self;
end;

function TOAuthRequest.GenerateNonce: string;
var
  md5: TIdHashMessageDigest;
begin
  md5 := TIdHashMessageDigest5.Create;
  Result := md5.HashStringAsHex(GenerateTimeStamp);
  md5.Free;
end;

function TOAuthRequest.GenerateTimeStamp: string;
begin
  Result := IntToStr(DateTimeToUnix(Now));
end;

function TOAuthRequest.GetSignableParameters: string;
var
  x: integer;
  parm: string;
begin
  parm := '';
  x := FParameters.IndexOfName('oauth_signature');
  if x <> -1 then
    FParameters.Delete(x);
  for x := 0 to FParameters.Count - 1 do
  begin
    if x = 0 then
    begin
      FParameters.ValueFromIndex[x] := TOAuthUtil.urlEncodeRFC3986(FParameters.ValueFromIndex[x]);
      parm := FParameters.Names[x] + TOAuthUtil.urlEncodeRFC3986('=') + TIdURI.PathEncode(FParameters.ValueFromIndex[x]);
    end
    else
      parm := parm + TOAuthUtil.urlEncodeRFC3986('&') +
              FParameters.Names[x] + TOAuthUtil.urlEncodeRFC3986('=' + FParameters.ValueFromIndex[x])
  end;
  Result := parm;
end;

procedure TOAuthRequest.SetBaseString(const Value: string);
begin
  FBaseString := Value;
end;

procedure TOAuthRequest.SetHTTPURL(const Value: string);
var
  x,y: integer;
begin
  FHTTPURL := Value;
  FScheme := Copy(FHTTPURL, 0, 7);
  x := AnsiPos('.com', FHTTPURL);
  y := AnsiPos('?', FHTTPURL);
  FHost := Copy(FHTTPURL, 8, x-4);
  if y > 0 then
    FPath := Copy(FHTTPURL, x + 4, y - (x + 4))
  else
    FPath := Copy(FHTTPURL, x + 4, Length(HTTPURL) - y - 1);
  if y > 0 then
    FFields := Copy(FHTTPURL, y + 1, Length(HTTPURL));
end;

procedure TOAuthRequest.SetVersion(const Value: string);
begin
  FVersion := Value;
end;

procedure TOAuthRequest.Sign_Request(Signature_Method: TOAuthSignatureMethod;
  Consumer: TOAuthConsumer; Token: TOAuthToken);
var
  signature: string;
  x: integer;
begin
  FParameters.Insert(2 ,'oauth_signature_method=' + Signature_Method.get_name);
  //FParameters.Sort;
  signature := Self.Build_Signature(Signature_Method, Consumer, Token);
  signature := TOAuthUtil.urlEncodeRFC3986(signature);
  FParameters.Insert(3, 'oauth_signature=' + signature);
  for x := 0 to FParameters.Count - 1 do
  begin
    if x = 0 then
      FGetString := FParameters.Names[X] + '=' + FParameters.ValueFromIndex[x]
    else
      FGetString := FGetString + '&' + FParameters.Names[X] + '=' + FParameters.ValueFromIndex[x];
  end;
end;

{ TOAuthUtil }
class function TOAuthUtil.urlDecodeRFC3986(URL: string): string;
begin
  result := TIdURI.URLDecode(URL);
end;

class function TOAuthUtil.urlEncodeRFC3986(URL: string): string;
var
  URL1: string;
begin
  URL1 := URLEncode(URL);
  URL1 := StringReplace(URL1, '+', ' ', [rfReplaceAll, rfIgnoreCase]);
  result := URL1;
end;

{ TOAuthSignatureMethod }
function TOAuthSignatureMethod.check_signature(Request:TOAuthRequest;
  Consumer: TOAuthConsumer; Token: TOAuthToken; Signature: string): boolean;
var
  newsig: string;
begin
   newsig:= Self.build_signature(Request, Consumer, Token);
  if (newsig = Signature) then
    Result := True
  else
    Result := False;
end;

{ TOAuthSignatureMethod_HMAC_SHA1 }
function TOAuthSignatureMethod_HMAC_SHA1.build_signature(Request: TOAuthRequest;
  Consumer: TOAuthConsumer; Token: TOAuthToken): string;

  function Base64Encode(const Input: TIdBytes): string;
  begin
    Result := TIdEncoderMIME.EncodeBytes(Input);
  end;

  function EncryptHMACSha1(Input, AKey: string): TIdBytes;
  begin
    with TIdHMACSHA1.Create do
    try
      Key := ToBytes(AKey);
      Result := HashValue(ToBytes(Input));
    finally
      Free;
    end;
  end;
var
  parm1, parm: string;
  consec, toksec: string;
begin
  parm1 := Request.GetSignableParameters;
  parm := TOAuthUtil.urlEncodeRFC3986(Request.Scheme) +
          TOAuthUtil.urlEncodeRFC3986(Request.Host) +
          TOAuthUtil.urlEncodeRFC3986(Request.Path);
  if Request.Fields <> '' then
  begin
    parm := parm + '&' + TOAuthUtil.urlEncodeRFC3986(Request.Fields);
    parm := parm +  TOAuthUtil.urlEncodeRFC3986('&') + parm1;
  end
  else
    parm :=  parm + '&' + parm1;

  Request.BaseString := 'GET&' + parm;
  if Token <> nil then
  begin
    consec := TOAuthUtil.urlEncodeRFC3986(Consumer.Secret);
    toksec := TOAuthUtil.urlEncodeRFC3986(Token.Secret);
    consec := consec + '&' + toksec;
    Result := Base64Encode(EncryptHMACSha1(Request.BaseString, consec))
  end
  else
  begin
    consec := TOAuthUtil.urlEncodeRFC3986(Consumer.Secret);
    consec := consec + '&';
    Result := Base64Encode(EncryptHMACSha1(Request.BaseString, consec));
  end;
end;

function TOAuthSignatureMethod_HMAC_SHA1.get_name: string;
begin
  result := 'HMAC-SHA1';
end;

{ TOAuthSignatureMethod_PLAINTEXT }
function TOAuthSignatureMethod_PLAINTEXT.build_signature(Request: TOAuthRequest;
  Consumer: TOAuthConsumer; Token: TOAuthToken): string;
begin
  if Token <> nil then
    Result := TOAuthUtil.urlEncodeRFC3986((Consumer.Secret + '&' + Token.Secret))
  else
    Result := TOAuthUtil.urlEncodeRFC3986((Consumer.Secret));
end;

function TOAuthSignatureMethod_PLAINTEXT.get_name: string;
begin
  Result := 'PLAINTEXT';
end;

end.
