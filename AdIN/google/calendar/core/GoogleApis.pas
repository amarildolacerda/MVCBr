{
  Copyright (C) 2015 by Clever Components

  Author: Sergey Shirokov <admin@clevercomponents.com>

  Website: www.CleverComponents.com

  This file is part of Google API Client Library for Delphi.

  Google API Client Library for Delphi is free software:
  you can redistribute it and/or modify it under the terms of
  the GNU Lesser General Public License version 3
  as published by the Free Software Foundation and appearing in the
  included file COPYING.LESSER.

  Google API Client Library for Delphi is distributed in the hope
  that it will be useful, but WITHOUT ANY WARRANTY; without even the
  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with Json Serializer. If not, see <http://www.gnu.org/licenses/>.

  The current version of Google API Client Library for Delphi needs for
  the non-free library Clever Internet Suite. This is a drawback,
  and we suggest the task of changing
  the program so that it does the same job without the non-free library.
  Anyone who thinks of doing substantial further work on the program,
  first may free it from dependence on the non-free library.
}

unit GoogleApis;

interface

uses
  System.Classes, System.Contnrs, System.SysUtils,
  Winapi.Windows{, clJsonSerializerBase};

type
  TErrorEntry = class
  strict private
    FLocation: string;
    FExtendedHelp: string;
    FDomain: string;
    FMessage: string;
    FReason: string;
    FLocationType: string;
  public
    [TclJsonString('domain')]
    property Domain: string read FDomain write FDomain;

    [TclJsonString('reason')]
    property Reason: string read FReason write FReason;

    [TclJsonString('message')]
    property Message: string read FMessage write FMessage;

    [TclJsonString('locationType')]
    property LocationType: string read FLocationType write FLocationType;

    [TclJsonString('location')]
    property Location: string read FLocation write FLocation;

    [TclJsonString('extendedHelp')]
    property ExtendedHelp: string read FExtendedHelp write FExtendedHelp;
  end;

  TError = class
  strict private
    FExtendedHelp: string;
    FCode: Integer;
    FMessage: string;
    FErrors: TArray<TErrorEntry>;

    procedure SetErrors(const Value: TArray<TErrorEntry>);
  public
    constructor Create();
    destructor Destroy; override;

    [TclJsonString('message')]
    property Message: string read FMessage write FMessage;

    [TclJsonProperty('code')]
    property Code: Integer read FCode write FCode;

    [TclJsonString('extendedHelp')]
    property ExtendedHelp: string read FExtendedHelp write FExtendedHelp;

    [TclJsonProperty('errors')]
    property Errors: TArray<TErrorEntry> read FErrors write SetErrors;
  end;

  EGoogleApisException = class(Exception)
  strict private
    FError: TError;

    procedure SetError(const Value: TError);
  public
    constructor Create; overload;
    constructor Create(AError: TError); overload;
    destructor Destroy; override;

    [TclJsonProperty('error')]
    property Error: TError read FError write SetError;
  end;

  TCredential = class abstract
  public
    function GetAuthorization: string; virtual; abstract;
    function RefreshAuthorization: string; virtual; abstract;
    procedure RevokeAuthorization; virtual; abstract;
    procedure Abort; virtual; abstract;
  end;

  TJsonSerializer = class abstract
  public
    function JsonToException(const AJson: string): EGoogleApisException; virtual; abstract;
    function ExceptionToJson(E: EGoogleApisException): string; virtual; abstract;

    function JsonToObject(AType: TClass; const AJson: string): TObject; virtual; abstract;
    function ObjectToJson(AObject: TObject): string; virtual; abstract;
  end;

  TServiceInitializer = class;

  THttpRequestParameter = class
  strict private
    FName: string;
    FValue: string;
  public
    property Name: string read FName write FName;
    property Value: string read FValue write FValue;
  end;

  THttpRequestParameterList = class
  strict private
    FList: TObjectList;

    function GetCount: Integer;
    function GetItem(Index: Integer): THttpRequestParameter;
  public
    constructor Create;
    destructor Destroy; override;

    function Add(const AName: string): THttpRequestParameter; overload;
    function Add(const AName, AValue: string): THttpRequestParameter; overload;
    function Add(const AName: string; AValue: Integer): THttpRequestParameter; overload;
    function Add(const AName: string; AValue: Boolean): THttpRequestParameter; overload;

    procedure Delete(Index: Integer);
    procedure Clear;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: THttpRequestParameter read GetItem; default;
  end;

  THttpClient = class abstract
  strict private
    FInitializer: TServiceInitializer;
  strict protected
    function GetStatusCode: Integer; virtual; abstract;
  public
    constructor Create(AInitializer: TServiceInitializer);

    function Get(const AUri: string; AParameters: THttpRequestParameterList): string; virtual; abstract;
    function Post(const AUri: string; AParameters: THttpRequestParameterList; const AJsonRequest: string): string; virtual; abstract;
    function Put(const AUri: string; AParameters: THttpRequestParameterList; const AJsonRequest: string): string; virtual; abstract;
    function Patch(const AUri: string; AParameters: THttpRequestParameterList; AJsonRequest: string): string; virtual; abstract;
    function Delete(const AUri: string): string; virtual; abstract;
    procedure Abort; virtual; abstract;

    property Initializer: TServiceInitializer read FInitializer;
    property StatusCode: Integer read GetStatusCode;
  end;

  TServiceInitializer = class abstract
  strict private
    FApplicationName: string;
    FCredential: TCredential;
  strict protected
    function GetHttpClient: THttpClient; virtual; abstract;
    function GetJsonSerializer: TJsonSerializer; virtual; abstract;
  public
    constructor Create(ACredential: TCredential; const ApplicationName: string);
    destructor Destroy; override;

    property HttpClient: THttpClient read GetHttpClient;
    property JsonSerializer: TJsonSerializer read GetJsonSerializer;
    property Credential: TCredential read FCredential;
    property ApplicationName: string read FApplicationName;
  end;

  TService = class
  strict private
    FInitializer: TServiceInitializer;
  public
    constructor Create(AInitializer: TServiceInitializer);
    destructor Destroy; override;

    procedure Abort;

    property Initializer: TServiceInitializer read FInitializer;
  end;

  TServiceRequest<TResponse> = class abstract
  strict private
    FService: TService;
  public
    constructor Create(AService: TService);

    function Execute: TResponse; virtual; abstract;

    property Service: TService read FService;
  end;

  TUtils = class sealed
  public
    class function GlobalTimeToLocalTime(ATime: TDateTime): TDateTime;
    class function LocalTimeToGlobalTime(ATime: TDateTime): TDateTime;

    class function TimeZoneBiasString: string;
    class function TimeZoneBiasToDateTime(const ABias: string): TDateTime;

    class function DateTimeToRfc3339(ADateTime: TDateTime): string;
    class function Rfc3339ToDateTime(const ADateTime: string): TDateTime;
  end;

resourcestring
  cUnspecifiedError = 'Unspecified error';

implementation

{ TService }

procedure TService.Abort;
begin
  FInitializer.Credential.Abort();
  FInitializer.HttpClient.Abort();
end;

constructor TService.Create(AInitializer: TServiceInitializer);
begin
  inherited Create();
  FInitializer := AInitializer;
  Assert(FInitializer <> nil);
end;

destructor TService.Destroy;
begin
  FInitializer.Free();
  inherited Destroy();
end;

{ TServiceInitializer }

constructor TServiceInitializer.Create(ACredential: TCredential; const ApplicationName: string);
begin
  inherited Create();

  FCredential := ACredential;
  FApplicationName := ApplicationName;

  Assert(FCredential <> nil);
end;

destructor TServiceInitializer.Destroy;
begin
  FCredential.Free();

  inherited Destroy();
end;

{ THttpClient }

constructor THttpClient.Create(AInitializer: TServiceInitializer);
begin
  inherited Create();

  FInitializer := AInitializer;
end;

{ THttpRequestParameterList }

function THttpRequestParameterList.Add(const AName, AValue: string): THttpRequestParameter;
begin
  if (AValue <> '') then
  begin
    Result := Add(AName);
    Result.Value := AValue;
  end else
  begin
    Result := nil;
  end;
end;

function THttpRequestParameterList.Add(const AName: string; AValue: Integer): THttpRequestParameter;
begin
  if (AValue <> 0) then
  begin
    Result := Add(AName, IntToStr(AValue));
  end else
  begin
    Result := nil;
  end;
end;

function THttpRequestParameterList.Add(const AName: string; AValue: Boolean): THttpRequestParameter;
begin
  if (AValue) then
  begin
    Result := Add(AName, 'true');
  end else
  begin
    Result := nil;
  end;
end;

function THttpRequestParameterList.Add(const AName: string): THttpRequestParameter;
begin
  Result := THttpRequestParameter.Create();
  FList.Add(Result);
  Result.Name := AName;
end;

procedure THttpRequestParameterList.Clear;
begin
  FList.Clear();
end;

constructor THttpRequestParameterList.Create;
begin
  inherited Create();
  FList := TObjectList.Create(True);
end;

procedure THttpRequestParameterList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor THttpRequestParameterList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function THttpRequestParameterList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function THttpRequestParameterList.GetItem(Index: Integer): THttpRequestParameter;
begin
  Result := THttpRequestParameter(FList[Index]);
end;

{ TServiceRequest<TResponse> }

constructor TServiceRequest<TResponse>.Create(AService: TService);
begin
  inherited Create();
  FService := AService;
end;

{ TError }

constructor TError.Create;
begin
  inherited Create();
  FErrors := nil;
end;

destructor TError.Destroy;
begin
  SetErrors(nil);
  inherited Destroy();
end;

procedure TError.SetErrors(const Value: TArray<TErrorEntry>);
var
  obj: TObject;
begin
  if (FErrors <> nil) then
  begin
    for obj in FErrors do
    begin
      obj.Free();
    end;
  end;

  FErrors := Value;
end;

{ EGoogleApisException }

constructor EGoogleApisException.Create(AError: TError);
begin
  inherited Create(cUnspecifiedError);
  SetError(AError);
end;

constructor EGoogleApisException.Create;
begin
  inherited Create(cUnspecifiedError);
end;

destructor EGoogleApisException.Destroy;
begin
  SetError(nil);
  inherited Destroy();
end;

procedure EGoogleApisException.SetError(const Value: TError);
begin
  FError.Free();
  FError := Value;

  if (FError <> nil) then
  begin
    Message := FError.Message;
  end;
end;

{ TUtils }

class function TUtils.DateTimeToRfc3339(ADateTime: TDateTime): string;
var
  year, month, day, hour, min, sec, msec: Word;
  ms: string;
begin
  if not (ADateTime > 0) then
  begin
    Result := '';
    Exit;
  end;

  DecodeDate(ADateTime, year, month, day);
  DecodeTime(ADateTime, hour, min, sec, msec);

  if (msec > 0) then
  begin
    ms := '.' + IntToStr(msec);
  end else
  begin
    ms := '';
  end;

  Result := Format('%d-%.2d-%.2dT%.2d:%.2d:%.2d%s%s',
    [year, month, day, hour, min, sec, ms, TimeZoneBiasString]);
end;

class function TUtils.GlobalTimeToLocalTime(ATime: TDateTime): TDateTime;
var
  ST: TSystemTime;
  FT: TFileTime;
begin
  DateTimeToSystemTime(ATime, ST);
  SystemTimeToFileTime(ST, FT);
  FileTimeToLocalFileTime(FT, FT);
  FileTimeToSystemTime(FT, ST);
  Result := SystemTimeToDateTime(ST);
end;

class function TUtils.LocalTimeToGlobalTime(ATime: TDateTime): TDateTime;
var
  ST: TSystemTime;
  FT: TFileTime;
begin
  DateTimeToSystemTime(ATime, ST);
  SystemTimeToFileTime(ST, FT);
  LocalFileTimeToFileTime(FT, FT);
  FileTimeToSystemTime(FT, ST);
  Result := SystemTimeToDateTime(ST);
end;

class function TUtils.Rfc3339ToDateTime(const ADateTime: string): TDateTime;
var
  arr, sec: TArray<string>;
  datepart, time, bias: string;
  ind: Integer;
begin
  Result := 0.0;

  arr := ADateTime.Split(['T', 't']);

  if (Length(arr) < 2) then
  begin
    datepart := ADateTime;
    time := '';
  end else
  begin
    datepart := arr[0];
    time := arr[1];
  end;

  SetLength(arr, 0);
  arr := datepart.Split(['-']);

  if (Length(arr) <> 3) then Exit;

  Result := EncodeDate(StrToIntDef(arr[0], 0), StrToIntDef(arr[1], 1), StrToIntDef(arr[2], 1));

  ind := time.IndexOfAny(['+', '-', 'Z', 'z']);

  if (ind > -1) then
  begin
    bias := time.Substring(ind, 100);
    time := time.Substring(0, ind);
  end;

  SetLength(arr, 0);
  arr := time.Split([':']);

  if (Length(arr) < 3) then Exit;

  sec := arr[2].Split(['.']);

  if (Length(sec) <> 2) then
  begin
    SetLength(sec, 2);
    sec[0] := arr[2];
    sec[1] := '0';
  end;

  Result := Result + EncodeTime(StrToIntDef(arr[0], 0), StrToIntDef(arr[1], 0), StrToIntDef(sec[0], 0), StrToIntDef(sec[1], 0));

  if (bias.ToUpper() <> 'Z') then
  begin
    Result := Result - TimeZoneBiasToDateTime(bias);
  end;

  Result := GlobalTimeToLocalTime(Result);
end;

class function TUtils.TimeZoneBiasString: string;
const
  BiasSign: array[Boolean] of string = ('+', '-');
var
  TimeZoneInfo: TTimeZoneInformation;
  TimeZoneID: DWORD;
  Bias: Integer;
begin
  Bias := 0;
  TimeZoneID := GetTimeZoneInformation(TimeZoneInfo);
  if (TimeZoneID <> TIME_ZONE_ID_INVALID) then
  begin
    if (TimeZoneID = TIME_ZONE_ID_DAYLIGHT) then
    begin
      Bias := TimeZoneInfo.Bias + TimeZoneInfo.DaylightBias;
    end else
    begin
      Bias := TimeZoneInfo.Bias;
    end;
  end;

  Result := Format('%s%.2d:%.2d', [BiasSign[(Bias > 0)], Abs(Bias) div 60, Abs(Bias) mod 60]);
end;

class function TUtils.TimeZoneBiasToDateTime(const ABias: string): TDateTime;
var
  arr: TArray<string>;
begin
  Result := 0.0;

  if (ABias.Length > 4) and (ABias.IndexOfAny(['-', '+']) = 0) then
  begin
    arr := ABias.Substring(1).Split([':']);

    if (Length(arr) = 2) then
    begin
      TryEncodeTime(StrToIntDef(arr[0], 0), StrToIntDef(arr[1], 0), 0, 0, Result);
    end;

    if (ABias.Chars[0] = '-') and (Result <> 0) then Result := - Result;
  end;
end;

end.
