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

unit GoogleApis.Calendar;

interface

uses
  System.Classes, System.SysUtils, System.Contnrs, GoogleApis, GoogleApis.Calendar.Data;

type
  TCalendarResource = class
  strict private
    FService: TService;
  public
    constructor Create(AService: TService);

    property Service: TService read FService;
  end;

  TCalendarListBaseRequest = class(TServiceRequest<TCalendarListEntry>)
  strict private
    FCalendarListEntry: TCalendarListEntry;
    FFields: string;
    FColorRgbFormat: Boolean;
  strict protected
    function GetUpdateRequest: string;
    function GetUpdateListEntry(ASource: TCalendarListEntry): TCalendarListEntry; virtual;
  public
    constructor Create(AService: TService; ACalendarListEntry: TCalendarListEntry);
    destructor Destroy; override;

    property CalendarListEntry: TCalendarListEntry read FCalendarListEntry;
    property Fields: string read FFields write FFields;
    property ColorRgbFormat: Boolean read FColorRgbFormat write FColorRgbFormat;
  end;

  TCalendarListUpdateRequest = class(TCalendarListBaseRequest)
  public
    function Execute: TCalendarListEntry; override;
  end;

  TCalendarListPatchRequest = class(TCalendarListBaseRequest)
  public
    function Execute: TCalendarListEntry; override;
  end;

  TCalendarListInsertRequest = class(TCalendarListBaseRequest)
  strict protected
    function GetUpdateListEntry(ASource: TCalendarListEntry): TCalendarListEntry; override;
  public
    function Execute: TCalendarListEntry; override;
  end;

  TCalendarListDeleteRequest = class(TServiceRequest<Boolean>)
  strict private
    FCalendarId: string;
  public
    constructor Create(AService: TService; const ACalendarId: string);

    function Execute: Boolean; override;

    property CalendarId: string read FCalendarId;
  end;

  TCalendarListGetRequest = class(TServiceRequest<TCalendarListEntry>)
  strict private
    FFields: string;
    FCalendarId: string;
  public
    constructor Create(AService: TService; const ACalendarId: string);

    function Execute: TCalendarListEntry; override;

    property CalendarId: string read FCalendarId;
    property Fields: string read FFields write FFields;
  end;

  TCalendarListRequest = class(TServiceRequest<TCalendarList>)
  strict private
    FFields: string;
    FSyncToken: string;
    FShowHidden: Boolean;
    FPageToken: string;
    FMinAccessRole: string;
    FMaxResults: Integer;
    FShowDeleted: Boolean;

    procedure FillParams(AParams: THttpRequestParameterList);
  public
    function Execute: TCalendarList; override;

    property MaxResults: Integer read FMaxResults write FMaxResults;
    property MinAccessRole: string read FMinAccessRole write FMinAccessRole;
    property PageToken: string read FPageToken write FPageToken;
    property ShowDeleted: Boolean read FShowDeleted write FShowDeleted;
    property ShowHidden: Boolean read FShowHidden write FShowHidden;
    property SyncToken: string read FSyncToken write FSyncToken;
    property Fields: string read FFields write FFields;
  end;

  TCalendarsGetRequest = class(TServiceRequest<TCalendar>)
  strict private
    FCalendarId: string;
    FFields: string;
  public
    constructor Create(AService: TService; const ACalendarId: string);

    function Execute: TCalendar; override;

    property CalendarId: string read FCalendarId;
    property Fields: string read FFields write FFields;
  end;

  TCalendarsDeleteRequest = class(TServiceRequest<Boolean>)
  strict private
    FCalendarId: string;
  public
    constructor Create(AService: TService; const ACalendarId: string);

    function Execute: Boolean; override;

    property CalendarId: string read FCalendarId;
  end;

  TCalendarsClearRequest = class(TServiceRequest<Boolean>)
  strict private
    FCalendarId: string;
  public
    constructor Create(AService: TService; const ACalendarId: string);

    function Execute: Boolean; override;

    property CalendarId: string read FCalendarId;
  end;

  TCalendarsRequest = class(TServiceRequest<TCalendar>)
  strict private
    FCalendar: TCalendar;
    FFields: string;
  public
    constructor Create(AService: TService; ACalendar: TCalendar);
    destructor Destroy; override;

    property Calendar: TCalendar read FCalendar;
    property Fields: string read FFields write FFields;
  end;

  TCalendarsInsertRequest = class(TCalendarsRequest)
  public
    function Execute: TCalendar; override;
  end;

  TCalendarsPatchRequest = class(TCalendarsRequest)
  public
    function Execute: TCalendar; override;
  end;

  TCalendarsUpdateRequest = class(TCalendarsRequest)
  public
    function Execute: TCalendar; override;
  end;

  TEventsListRequest = class(TServiceRequest<TEvents>)
  strict private
    FCalendarId: string;
    FOrderBy: string;
    FICalUID: string;
    FSyncToken: string;
    FSingleEvents: Boolean;
    FSharedExtendedProperty: string;
    FShowHiddenInvitations: Boolean;
    FPageToken: string;
    FAlwaysIncludeEmail: Boolean;
    FUpdatedMin: TDateTime;
    FTimeMax: TDateTime;
    FMaxResults: Integer;
    FTimeZone: string;
    FMaxAttendees: Integer;
    FPrivateExtendedProperty: string;
    FQ: string;
    FTimeMin: TDateTime;
    FShowDeleted: Boolean;
    FFields: string;

    procedure FillParams(AParams: THttpRequestParameterList);
  public
    constructor Create(AService: TService; const ACalendarId: string);

    function Execute: TEvents; override;

    property CalendarId: string read FCalendarId;

    property AlwaysIncludeEmail: Boolean read FAlwaysIncludeEmail write FAlwaysIncludeEmail;
    property ICalUID: string read FICalUID write FICalUID;
    property MaxAttendees: Integer read FMaxAttendees write FMaxAttendees;
    property MaxResults: Integer read FMaxResults write FMaxResults;
    property OrderBy: string read FOrderBy write FOrderBy;
    property PageToken: string read FPageToken write FPageToken;
    property PrivateExtendedProperty: string read FPrivateExtendedProperty write FPrivateExtendedProperty;
    property Q: string read FQ write FQ;
    property SharedExtendedProperty: string read FSharedExtendedProperty write FSharedExtendedProperty;
    property ShowDeleted: Boolean read FShowDeleted write FShowDeleted;
    property ShowHiddenInvitations: Boolean read FShowHiddenInvitations write FShowHiddenInvitations;
    property SingleEvents: Boolean read FSingleEvents write FSingleEvents;
    property SyncToken: string read FSyncToken write FSyncToken;
    property TimeMax: TDateTime read FTimeMax write FTimeMax;
    property TimeMin: TDateTime read FTimeMin write FTimeMin;
    property TimeZone: string read FTimeZone write FTimeZone;
    property UpdatedMin: TDateTime read FUpdatedMin write FUpdatedMin;
    property Fields: string read FFields write FFields;
  end;

  TEventsGetRequest = class(TServiceRequest<TEvent>)
  strict private
    FCalendarId: string;
    FEventId: string;
    FFields: string;
    FAlwaysIncludeEmail: Boolean;
    FTimeZone: string;
    FMaxAttendees: Integer;

    procedure FillParams(AParams: THttpRequestParameterList);
  public
    constructor Create(AService: TService; const ACalendarId, AEventId: string);

    function Execute: TEvent; override;

    property CalendarId: string read FCalendarId;
    property EventId: string read FEventId;

    property AlwaysIncludeEmail: Boolean read FAlwaysIncludeEmail write FAlwaysIncludeEmail;
    property MaxAttendees: Integer read FMaxAttendees write FMaxAttendees;
    property TimeZone: string read FTimeZone write FTimeZone;
    property Fields: string read FFields write FFields;
  end;

  TEventsInstancesRequest = class(TServiceRequest<TEvents>)
  strict private
    FCalendarId: string;
    FEventId: string;
    FFields: string;
    FPageToken: string;
    FAlwaysIncludeEmail: Boolean;
    FOriginalStart: string;
    FTimeMax: TDateTime;
    FMaxResults: Integer;
    FTimeZone: string;
    FMaxAttendees: Integer;
    FTimeMin: TDateTime;
    FShowDeleted: Boolean;

    procedure FillParams(AParams: THttpRequestParameterList);
  public
    constructor Create(AService: TService; const ACalendarId, AEventId: string);

    function Execute: TEvents; override;

    property CalendarId: string read FCalendarId;
    property EventId: string read FEventId;

    property AlwaysIncludeEmail: Boolean read FAlwaysIncludeEmail write FAlwaysIncludeEmail;
    property MaxAttendees: Integer read FMaxAttendees write FMaxAttendees;
    property MaxResults: Integer read FMaxResults write FMaxResults;
    property OriginalStart: string read FOriginalStart write FOriginalStart;
    property PageToken: string read FPageToken write FPageToken;
    property ShowDeleted: Boolean read FShowDeleted write FShowDeleted;
    property TimeMax: TDateTime read FTimeMax write FTimeMax;
    property TimeMin: TDateTime read FTimeMin write FTimeMin;
    property TimeZone: string read FTimeZone write FTimeZone;
    property Fields: string read FFields write FFields;
  end;

  TEventsQuickAddRequest = class(TServiceRequest<TEvent>)
  strict private
    FCalendarId: string;
    FText: string;
    FSendNotifications: Boolean;
    FFields: string;

    procedure FillParams(AParams: THttpRequestParameterList);
  public
    constructor Create(AService: TService; const ACalendarId, AText: string);

    function Execute: TEvent; override;

    property CalendarId: string read FCalendarId;
    property Text: string read FText;

    property SendNotifications: Boolean read FSendNotifications write FSendNotifications;
    property Fields: string read FFields write FFields;
  end;

  TEventsRequest = class(TServiceRequest<TEvent>)
  strict private
    FCalendarId: string;
    FEvent: TEvent;
    FFields: string;
    FSupportsAttachments: Boolean;
  protected
    procedure FillParams(AParams: THttpRequestParameterList); virtual;
  public
    constructor Create(AService: TService; const ACalendarId: string; AEvent: TEvent);
    destructor Destroy; override;

    property CalendarId: string read FCalendarId;
    property Event: TEvent read FEvent;

    property SupportsAttachments: Boolean read FSupportsAttachments write FSupportsAttachments;
    property Fields: string read FFields write FFields;
  end;

  TEventsModifyRequest = class(TEventsRequest)
  strict private
    FMaxAttendees: Integer;
    FSendNotifications: Boolean;
  protected
    procedure FillParams(AParams: THttpRequestParameterList); override;
  public
    property MaxAttendees: Integer read FMaxAttendees write FMaxAttendees;
    property SendNotifications: Boolean read FSendNotifications write FSendNotifications;
  end;

  TEventsUpdateBaseRequest = class(TEventsModifyRequest)
  strict private
    FAlwaysIncludeEmail: Boolean;
  protected
    procedure FillParams(AParams: THttpRequestParameterList); override;
  public
    property AlwaysIncludeEmail: Boolean read FAlwaysIncludeEmail write FAlwaysIncludeEmail;
  end;

  TEventsUpdateRequest = class(TEventsUpdateBaseRequest)
  public
    function Execute: TEvent; override;
  end;

  TEventsPatchRequest = class(TEventsUpdateBaseRequest)
  public
    function Execute: TEvent; override;
  end;

  TEventsInsertRequest = class(TEventsModifyRequest)
  public
    function Execute: TEvent; override;
  end;

  TEventsImportRequest = class(TEventsRequest)
  public
    function Execute: TEvent; override;
  end;

  TEventsDeleteRequest = class(TServiceRequest<Boolean>)
  strict private
    FCalendarId: string;
    FEventId: string;
    FSendNotifications: Boolean;
  public
    constructor Create(AService: TService; const ACalendarId, AEventId: string);

    function Execute: Boolean; override;

    property CalendarId: string read FCalendarId;
    property EventId: string read FEventId;

    property SendNotifications: Boolean read FSendNotifications write FSendNotifications;
  end;

  TEventsMoveRequest = class(TServiceRequest<TEvent>)
  strict private
    FFields: string;
    FCalendarId: string;
    FDestination: string;
    FEventId: string;
    FSendNotifications: Boolean;

    procedure FillParams(AParams: THttpRequestParameterList);
  public
    constructor Create(AService: TService; const ACalendarId, AEventId, ADestination: string);

    function Execute: TEvent; override;

    property CalendarId: string read FCalendarId;
    property EventId: string read FEventId;
    property Destination: string read FDestination;

    property SendNotifications: Boolean read FSendNotifications write FSendNotifications;
    property Fields: string read FFields write FFields;
  end;

  TCalendarListResource = class(TCalendarResource)
  public
    function Delete(const ACalendarId: string): TCalendarListDeleteRequest; virtual;
    function Get(const ACalendarId: string): TCalendarListGetRequest; virtual;
    function Insert(ACalendarListEntry: TCalendarListEntry): TCalendarListInsertRequest; virtual;
    function List: TCalendarListRequest; virtual;
    function Patch(ACalendarListEntry: TCalendarListEntry): TCalendarListPatchRequest; virtual;
    function Update(ACalendarListEntry: TCalendarListEntry): TCalendarListUpdateRequest; virtual;
//TODO  Watch
  end;

  TCalendarsResource = class(TCalendarResource)
  public
    function Clear(const ACalendarId: string): TCalendarsClearRequest; virtual;
    function Delete(const ACalendarId: string): TCalendarsDeleteRequest; virtual;
    function Get(const ACalendarId: string): TCalendarsGetRequest; virtual;
    function Insert(ACalendar: TCalendar): TCalendarsInsertRequest; virtual;
    function Patch(ACalendar: TCalendar): TCalendarsPatchRequest; virtual;
    function Update(ACalendar: TCalendar): TCalendarsUpdateRequest; virtual;
  end;

  TEventsResource = class(TCalendarResource)
  public
    function Delete(const ACalendarId, AEventId: string): TEventsDeleteRequest; virtual;
    function Get(const ACalendarId, AEventId: string): TEventsGetRequest; virtual;
    function Import(const ACalendarId: string; AEvent: TEvent): TEventsImportRequest; virtual;
    function Insert(const ACalendarId: string; AEvent: TEvent): TEventsInsertRequest; virtual;
    function Instances(const ACalendarId, AEventId: string): TEventsInstancesRequest; virtual;
    function List(const ACalendarId: string): TEventsListRequest; virtual;
    function Move(const ACalendarId, AEventId, ADestination: string): TEventsMoveRequest; virtual;
    function Patch(const ACalendarId: string; AEvent: TEvent): TEventsPatchRequest; virtual;
    function QuickAdd(const ACalendarId, AText: string): TEventsQuickAddRequest; virtual;
    function Update(const ACalendarId: string; AEvent: TEvent): TEventsUpdateRequest; virtual;
//  Watch
  end;

  TCalendarService = class(TService)
  strict private
    FCalendarList: TCalendarListResource;
    FCalendars: TCalendarsResource;
    FEvents: TEventsResource;

    function GetCalendarList: TCalendarListResource;
    function GetCalendars: TCalendarsResource;
    function GetEvents: TEventsResource;
  strict protected
    function CreateCalendarList: TCalendarListResource; virtual;
    function CreateCalendars: TCalendarsResource; virtual;
    function CreateEvents: TEventsResource; virtual;
  public
    constructor Create(AInitializer: TServiceInitializer);
    destructor Destroy; override;

    //property Acl
    property CalendarList: TCalendarListResource read GetCalendarList;
    property Calendars: TCalendarsResource read GetCalendars;
    //property Channels
    //property Colors
    property Events: TEventsResource read GetEvents;
    //property FreeBusy
    //property Settings
  end;

implementation

{ TCalendarService }

constructor TCalendarService.Create(AInitializer: TServiceInitializer);
begin
  inherited Create(AInitializer);

  FCalendarList := nil;
  FCalendars := nil;
  FEvents := nil;
end;

function TCalendarService.CreateCalendarList: TCalendarListResource;
begin
  Result := TCalendarListResource.Create(Self);
end;

function TCalendarService.CreateCalendars: TCalendarsResource;
begin
  Result := TCalendarsResource.Create(Self);
end;

function TCalendarService.CreateEvents: TEventsResource;
begin
  Result := TEventsResource.Create(Self);
end;

destructor TCalendarService.Destroy;
begin
  FreeAndNil(FCalendarList);
  FreeAndNil(FCalendars);
  FreeAndNil(FEvents);

  inherited Destroy();
end;

function TCalendarService.GetCalendarList: TCalendarListResource;
begin
  if (FCalendarList = nil) then
  begin
    FCalendarList := CreateCalendarList();
  end;
  Result := FCalendarList;
end;

function TCalendarService.GetCalendars: TCalendarsResource;
begin
  if (FCalendars = nil) then
  begin
    FCalendars := CreateCalendars();
  end;
  Result := FCalendars;
end;

function TCalendarService.GetEvents: TEventsResource;
begin
  if (FEvents = nil) then
  begin
    FEvents := CreateEvents();
  end;
  Result := FEvents;
end;

{ TCalendarListResource }

function TCalendarListResource.Delete(const ACalendarId: string): TCalendarListDeleteRequest;
begin
  Result := TCalendarListDeleteRequest.Create(Service, ACalendarId);
end;

function TCalendarListResource.Get(const ACalendarId: string): TCalendarListGetRequest;
begin
  Result := TCalendarListGetRequest.Create(Service, ACalendarId);
end;

function TCalendarListResource.Insert(ACalendarListEntry: TCalendarListEntry): TCalendarListInsertRequest;
begin
  Result := TCalendarListInsertRequest.Create(Service, ACalendarListEntry);
end;

function TCalendarListResource.List: TCalendarListRequest;
begin
  Result := TCalendarListRequest.Create(Service);
end;

function TCalendarListResource.Patch(ACalendarListEntry: TCalendarListEntry): TCalendarListPatchRequest;
begin
  Result := TCalendarListPatchRequest.Create(Service, ACalendarListEntry);
end;

function TCalendarListResource.Update(ACalendarListEntry: TCalendarListEntry): TCalendarListUpdateRequest;
begin
  Result := TCalendarListUpdateRequest.Create(Service, ACalendarListEntry);
end;

{ TCalendarListRequest }

function TCalendarListRequest.Execute: TCalendarList;
var
  response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    FillParams(params);
    response := Service.Initializer.HttpClient.Get('https://www.googleapis.com/calendar/v3/users/me/calendarList', params);
    Result := TCalendarList(Service.Initializer.JsonSerializer.JsonToObject(TCalendarList, response));
  finally
    params.Free();
  end;
end;

procedure TCalendarListRequest.FillParams(AParams: THttpRequestParameterList);
begin
  if (SyncToken = '') then
  begin
    AParams.Add('minAccessRole', MinAccessRole);
  end;
  AParams.Add('maxResults', MaxResults);
  AParams.Add('pageToken', PageToken);
  AParams.Add('showDeleted', ShowDeleted);
  AParams.Add('showHidden', ShowHidden);
  AParams.Add('syncToken', SyncToken);
  AParams.Add('fields', Fields);
end;

{ TCalendarsResource }

function TCalendarsResource.Clear(const ACalendarId: string): TCalendarsClearRequest;
begin
  Result := TCalendarsClearRequest.Create(Service, ACalendarId);
end;

function TCalendarsResource.Delete(const ACalendarId: string): TCalendarsDeleteRequest;
begin
  Result := TCalendarsDeleteRequest.Create(Service, ACalendarId);
end;

function TCalendarsResource.Get(const ACalendarId: string): TCalendarsGetRequest;
begin
  Result := TCalendarsGetRequest.Create(Service, ACalendarId);
end;

function TCalendarsResource.Insert(ACalendar: TCalendar): TCalendarsInsertRequest;
begin
  Result := TCalendarsInsertRequest.Create(Service, ACalendar);
end;

function TCalendarsResource.Patch(ACalendar: TCalendar): TCalendarsPatchRequest;
begin
  Result := TCalendarsPatchRequest.Create(Service, ACalendar);
end;

function TCalendarsResource.Update(ACalendar: TCalendar): TCalendarsUpdateRequest;
begin
  Result := TCalendarsUpdateRequest.Create(Service, ACalendar);
end;

{ TCalendarsGetRequest }

constructor TCalendarsGetRequest.Create(AService: TService; const ACalendarId: string);
begin
  inherited Create(AService);
  FCalendarId := ACalendarId;
end;

function TCalendarsGetRequest.Execute: TCalendar;
var
  response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    params.Add('fields', Fields);
    response := Service.Initializer.HttpClient.Get('https://www.googleapis.com/calendar/v3/calendars/' + CalendarId, params);
    Result := TCalendar(Service.Initializer.JsonSerializer.JsonToObject(TCalendar, response));
  finally
    params.Free();
  end;
end;

{ TCalendarResource }

constructor TCalendarResource.Create(AService: TService);
begin
  inherited Create();
  FService := AService;
end;

{ TCalendarsInsertRequest }

function TCalendarsInsertRequest.Execute: TCalendar;
var
  request, response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    params.Add('fields', Fields);

    request := Service.Initializer.JsonSerializer.ObjectToJson(Calendar);

    response := Service.Initializer.HttpClient.Post('https://www.googleapis.com/calendar/v3/calendars', params, request);

    Result := TCalendar(Service.Initializer.JsonSerializer.JsonToObject(TCalendar, response));
  finally
    params.Free();
  end;
end;

{ TCalendarsUpdateRequest }

function TCalendarsUpdateRequest.Execute: TCalendar;
var
  request, response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    params.Add('fields', Fields);

    request := Service.Initializer.JsonSerializer.ObjectToJson(Calendar);

    response := Service.Initializer.HttpClient.Put('https://www.googleapis.com/calendar/v3/calendars/' + Calendar.Id, params, request);

    Result := TCalendar(Service.Initializer.JsonSerializer.JsonToObject(TCalendar, response));
  finally
    params.Free();
  end;
end;

{ TCalendarsRequest }

constructor TCalendarsRequest.Create(AService: TService; ACalendar: TCalendar);
begin
  inherited Create(AService);
  FCalendar := ACalendar;
end;

destructor TCalendarsRequest.Destroy;
begin
  FCalendar.Free();
  inherited Destroy();
end;

{ TCalendarsPatchRequest }

function TCalendarsPatchRequest.Execute: TCalendar;
var
  request, response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    params.Add('fields', Fields);

    request := Service.Initializer.JsonSerializer.ObjectToJson(Calendar);

    response := Service.Initializer.HttpClient.Patch('https://www.googleapis.com/calendar/v3/calendars/' + Calendar.Id, params, request);

    Result := TCalendar(Service.Initializer.JsonSerializer.JsonToObject(TCalendar, response));
  finally
    params.Free();
  end;
end;

{ TCalendarsDeleteRequest }

constructor TCalendarsDeleteRequest.Create(AService: TService; const ACalendarId: string);
begin
  inherited Create(AService);
  FCalendarId := ACalendarId;
end;

function TCalendarsDeleteRequest.Execute: Boolean;
begin
  Service.Initializer.HttpClient.Delete('https://www.googleapis.com/calendar/v3/calendars/' + CalendarId);
  Result := True;
end;

{ TCalendarsClearRequest }

constructor TCalendarsClearRequest.Create(AService: TService; const ACalendarId: string);
begin
  inherited Create(AService);
  FCalendarId := ACalendarId;
end;

function TCalendarsClearRequest.Execute: Boolean;
var
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    Service.Initializer.HttpClient.Post('https://www.googleapis.com/calendar/v3/calendars/' + CalendarId, params, '');
    Result := True;
  finally
    params.Free();
  end;
end;

{ TCalendarListBaseRequest }

constructor TCalendarListBaseRequest.Create(AService: TService;
  ACalendarListEntry: TCalendarListEntry);
begin
  inherited Create(AService);
  FCalendarListEntry := ACalendarListEntry;
end;

destructor TCalendarListBaseRequest.Destroy;
begin
  FCalendarListEntry.Free();
  inherited Destroy();
end;

function TCalendarListBaseRequest.GetUpdateListEntry(ASource: TCalendarListEntry): TCalendarListEntry;
begin
  Result := TCalendarListEntry.Create();
  try
    Result.BackgroundColor := ASource.BackgroundColor;
    Result.ColorId := ASource.ColorId;
    Result.DefaultReminders := ASource.DefaultReminders;
    Result.ForegroundColor := ASource.ForegroundColor;
    Result.Hidden := ASource.Hidden;
    Result.NotificationSettings := ASource.NotificationSettings;
    Result.Selected := ASource.Selected;
    Result.SummaryOverride := ASource.SummaryOverride;
  except
    Result.Free();
    raise;
  end;
end;

function TCalendarListBaseRequest.GetUpdateRequest: string;
var
  listEntry: TCalendarListEntry;
begin
  listEntry := GetUpdateListEntry(CalendarListEntry);
  try
    Result := Service.Initializer.JsonSerializer.ObjectToJson(listEntry);
  finally
    listEntry.Free();
  end;
end;

{ TCalendarListGetRequest }

constructor TCalendarListGetRequest.Create(AService: TService; const ACalendarId: string);
begin
  inherited Create(AService);
  FCalendarId := ACalendarId;
end;

function TCalendarListGetRequest.Execute: TCalendarListEntry;
var
  response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    params.Add('fields', Fields);
    response := Service.Initializer.HttpClient.Get('https://www.googleapis.com/calendar/v3/users/me/calendarList/' + CalendarId, params);
    Result := TCalendarListEntry(Service.Initializer.JsonSerializer.JsonToObject(TCalendarListEntry, response));
  finally
    params.Free();
  end;
end;

{ TCalendarListUpdateRequest }

function TCalendarListUpdateRequest.Execute: TCalendarListEntry;
var
  request, response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    params.Add('colorRgbFormat', ColorRgbFormat);
    params.Add('fields', Fields);

    request := GetUpdateRequest();

    response := Service.Initializer.HttpClient.Put('https://www.googleapis.com/calendar/v3/users/me/calendarList/' + CalendarListEntry.Id, params, request);
    Result := TCalendarListEntry(Service.Initializer.JsonSerializer.JsonToObject(TCalendarListEntry, response));
  finally
    params.Free();
  end;
end;

{ TCalendarListPatchRequest }

function TCalendarListPatchRequest.Execute: TCalendarListEntry;
var
  request, response: string;
  params: THttpRequestParameterList;
  id: string;
begin
  params := THttpRequestParameterList.Create();
  try
    params.Add('colorRgbFormat', ColorRgbFormat);
    params.Add('fields', Fields);

    id := CalendarListEntry.Id;
    try
      CalendarListEntry.Id := '';
      request := Service.Initializer.JsonSerializer.ObjectToJson(CalendarListEntry);
    finally
      CalendarListEntry.Id := id;
    end;

    response := Service.Initializer.HttpClient.Patch('https://www.googleapis.com/calendar/v3/users/me/calendarList/' + id, params, request);
    Result := TCalendarListEntry(Service.Initializer.JsonSerializer.JsonToObject(TCalendarListEntry, response));
  finally
    params.Free();
  end;
end;

{ TCalendarListInsertRequest }

function TCalendarListInsertRequest.Execute: TCalendarListEntry;
var
  request, response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    params.Add('colorRgbFormat', ColorRgbFormat);
    params.Add('fields', Fields);

    request := GetUpdateRequest();

    response := Service.Initializer.HttpClient.Post('https://www.googleapis.com/calendar/v3/users/me/calendarList', params, request);
    Result := TCalendarListEntry(Service.Initializer.JsonSerializer.JsonToObject(TCalendarListEntry, response));
  finally
    params.Free();
  end;
end;

function TCalendarListInsertRequest.GetUpdateListEntry(ASource: TCalendarListEntry): TCalendarListEntry;
begin
  Result := inherited GetUpdateListEntry(ASource);
  try
    Result.Id := ASource.Id;
  except
    Result.Free();
    raise;
  end;
end;

{ TCalendarListDeleteRequest }

constructor TCalendarListDeleteRequest.Create(AService: TService; const ACalendarId: string);
begin
  inherited Create(AService);
  FCalendarId := ACalendarId;
end;

function TCalendarListDeleteRequest.Execute: Boolean;
begin
  Service.Initializer.HttpClient.Delete('https://www.googleapis.com/calendar/v3/users/me/calendarList/' + CalendarId);
  Result := True;
end;

{ TEventsResource }

function TEventsResource.Delete(const ACalendarId, AEventId: string): TEventsDeleteRequest;
begin
  Result := TEventsDeleteRequest.Create(Service, ACalendarId, AEventId);
end;

function TEventsResource.Get(const ACalendarId, AEventId: string): TEventsGetRequest;
begin
  Result := TEventsGetRequest.Create(Service, ACalendarId, AEventId);
end;

function TEventsResource.Import(const ACalendarId: string; AEvent: TEvent): TEventsImportRequest;
begin
  Result := TEventsImportRequest.Create(Service, ACalendarId, AEvent);
end;

function TEventsResource.Insert(const ACalendarId: string; AEvent: TEvent): TEventsInsertRequest;
begin
  Result := TEventsInsertRequest.Create(Service, ACalendarId, AEvent);
end;

function TEventsResource.Instances(const ACalendarId, AEventId: string): TEventsInstancesRequest;
begin
  Result := TEventsInstancesRequest.Create(Service, ACalendarId, AEventId);
end;

function TEventsResource.List(const ACalendarId: string): TEventsListRequest;
begin
  Result := TEventsListRequest.Create(Service, ACalendarId);
end;

function TEventsResource.Move(const ACalendarId, AEventId, ADestination: string): TEventsMoveRequest;
begin
  Result := TEventsMoveRequest.Create(Service, ACalendarId, AEventId, ADestination);
end;

function TEventsResource.Patch(const ACalendarId: string; AEvent: TEvent): TEventsPatchRequest;
begin
  Result := TEventsPatchRequest.Create(Service, ACalendarId, AEvent);
end;

function TEventsResource.QuickAdd(const ACalendarId, AText: string): TEventsQuickAddRequest;
begin
  Result := TEventsQuickAddRequest.Create(Service, ACalendarId, AText);
end;

function TEventsResource.Update(const ACalendarId: string; AEvent: TEvent): TEventsUpdateRequest;
begin
  Result := TEventsUpdateRequest.Create(Service, ACalendarId, AEvent);
end;

{ TEventsListRequest }

constructor TEventsListRequest.Create(AService: TService; const ACalendarId: string);
begin
  inherited Create(AService);
  FCalendarId := ACalendarId;
end;

function TEventsListRequest.Execute: TEvents;
var
  response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    FillParams(params);
    response := Service.Initializer.HttpClient.Get('https://www.googleapis.com/calendar/v3/calendars/' + CalendarId + '/events', params);
    Result := TEvents(Service.Initializer.JsonSerializer.JsonToObject(TEvents, response));
  finally
    params.Free();
  end;
end;

procedure TEventsListRequest.FillParams(AParams: THttpRequestParameterList);
begin
  if (SyncToken = '') then
  begin
    AParams.Add('iCalUID', ICalUID);
    AParams.Add('orderBy', OrderBy);
    AParams.Add('privateExtendedProperty', PrivateExtendedProperty);
    AParams.Add('q', Q);
    AParams.Add('sharedExtendedProperty', SharedExtendedProperty);
    AParams.Add('timeMax', TUtils.DateTimeToRfc3339(TimeMax));
    AParams.Add('timeMin', TUtils.DateTimeToRfc3339(TimeMin));
    AParams.Add('updatedMin', TUtils.DateTimeToRfc3339(UpdatedMin));
  end;
  AParams.Add('alwaysIncludeEmail', AlwaysIncludeEmail);
  AParams.Add('maxAttendees', MaxAttendees);
  AParams.Add('maxResults', MaxResults);
  AParams.Add('pageToken', PageToken);
  AParams.Add('showDeleted', ShowDeleted);
  AParams.Add('showHiddenInvitations', ShowHiddenInvitations);
  AParams.Add('singleEvents', SingleEvents);
  AParams.Add('syncToken', SyncToken);
  AParams.Add('timeZone', TimeZone);
  AParams.Add('fields', Fields);
end;

{ TEventsGetRequest }

constructor TEventsGetRequest.Create(AService: TService; const ACalendarId, AEventId: string);
begin
  inherited Create(AService);

  FCalendarId := ACalendarId;
  FEventId := AEventId;
end;

function TEventsGetRequest.Execute: TEvent;
var
  response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    FillParams(params);
    response := Service.Initializer.HttpClient.Get('https://www.googleapis.com/calendar/v3/calendars/' + CalendarId + '/events/' + EventId, params);
    Result := TEvent(Service.Initializer.JsonSerializer.JsonToObject(TEvent, response));
  finally
    params.Free();
  end;
end;

procedure TEventsGetRequest.FillParams(AParams: THttpRequestParameterList);
begin
  AParams.Add('alwaysIncludeEmail', AlwaysIncludeEmail);
  AParams.Add('maxAttendees', MaxAttendees);
  AParams.Add('timeZone', TimeZone);
  AParams.Add('fields', Fields);
end;

{ TEventsQuickAddRequest }

constructor TEventsQuickAddRequest.Create(AService: TService; const ACalendarId, AText: string);
begin
  inherited Create(AService);

  FCalendarId := ACalendarId;
  FText := AText;
end;

function TEventsQuickAddRequest.Execute: TEvent;
var
  response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    FillParams(params);
    response := Service.Initializer.HttpClient.Post('https://www.googleapis.com/calendar/v3/calendars/' + CalendarId + '/events/quickAdd', params, '');
    Result := TEvent(Service.Initializer.JsonSerializer.JsonToObject(TEvent, response));
  finally
    params.Free();
  end;
end;

procedure TEventsQuickAddRequest.FillParams(AParams: THttpRequestParameterList);
begin
  AParams.Add('text', Text);
  AParams.Add('sendNotifications', SendNotifications);
  AParams.Add('fields', Fields);
end;

{ TEventsRequest }

constructor TEventsRequest.Create(AService: TService; const ACalendarId: string; AEvent: TEvent);
begin
  inherited Create(AService);

  FCalendarId := ACalendarId;
  FEvent := AEvent;
end;

destructor TEventsRequest.Destroy;
begin
  FEvent.Free();
  inherited Destroy();
end;

procedure TEventsRequest.FillParams(AParams: THttpRequestParameterList);
begin
  AParams.Add('supportsAttachments', SupportsAttachments);
  AParams.Add('fields', Fields);
end;

{ TEventsUpdateRequest }

function TEventsUpdateRequest.Execute: TEvent;
var
  request, response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    FillParams(params);

    request := Service.Initializer.JsonSerializer.ObjectToJson(Event);

    response := Service.Initializer.HttpClient.Put('https://www.googleapis.com/calendar/v3/calendars/' + CalendarId + '/events/' + Event.Id, params, request);

    Result := TEvent(Service.Initializer.JsonSerializer.JsonToObject(TEvent, response));
  finally
    params.Free();
  end;
end;

{ TEventsPatchRequest }

function TEventsPatchRequest.Execute: TEvent;
var
  request, response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    FillParams(params);

    request := Service.Initializer.JsonSerializer.ObjectToJson(Event);

    response := Service.Initializer.HttpClient.Patch('https://www.googleapis.com/calendar/v3/calendars/' + CalendarId + '/events/' + Event.Id, params, request);

    Result := TEvent(Service.Initializer.JsonSerializer.JsonToObject(TEvent, response));
  finally
    params.Free();
  end;
end;

{ TEventsInsertRequest }

function TEventsInsertRequest.Execute: TEvent;
var
  request, response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    FillParams(params);

    request := Service.Initializer.JsonSerializer.ObjectToJson(Event);

    response := Service.Initializer.HttpClient.Post('https://www.googleapis.com/calendar/v3/calendars/' + CalendarId + '/events', params, request);

    Result := TEvent(Service.Initializer.JsonSerializer.JsonToObject(TEvent, response));
  finally
    params.Free();
  end;
end;

{ TEventsDeleteRequest }

constructor TEventsDeleteRequest.Create(AService: TService; const ACalendarId, AEventId: string);
begin
  inherited Create(AService);

  FCalendarId := ACalendarId;
  FEventId := AEventId;
end;

function TEventsDeleteRequest.Execute: Boolean;
begin
  Service.Initializer.HttpClient.Delete('https://www.googleapis.com/calendar/v3/calendars/' + CalendarId + '/events/' + EventId);
  Result := True;
end;

{ TEventsMoveRequest }

constructor TEventsMoveRequest.Create(AService: TService; const ACalendarId, AEventId, ADestination: string);
begin
  inherited Create(AService);

  FCalendarId := ACalendarId;
  FEventId := AEventId;
  FDestination := ADestination;
end;

function TEventsMoveRequest.Execute: TEvent;
var
  response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    FillParams(params);

    response := Service.Initializer.HttpClient.Post('https://www.googleapis.com/calendar/v3/calendars/' + CalendarId + '/events/' + EventId + '/move', params, '');

    Result := TEvent(Service.Initializer.JsonSerializer.JsonToObject(TEvent, response));
  finally
    params.Free();
  end;
end;

procedure TEventsMoveRequest.FillParams(AParams: THttpRequestParameterList);
begin
  AParams.Add('destination', Destination);
  AParams.Add('sendNotifications', SendNotifications);
  AParams.Add('fields', Fields);
end;

{ TEventsImportRequest }

function TEventsImportRequest.Execute: TEvent;
var
  request, response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    FillParams(params);

    request := Service.Initializer.JsonSerializer.ObjectToJson(Event);

    response := Service.Initializer.HttpClient.Post('https://www.googleapis.com/calendar/v3/calendars/' + CalendarId + '/events/import', params, request);

    Result := TEvent(Service.Initializer.JsonSerializer.JsonToObject(TEvent, response));
  finally
    params.Free();
  end;
end;

{ TEventsUpdateBaseRequest }

procedure TEventsUpdateBaseRequest.FillParams(AParams: THttpRequestParameterList);
begin
  AParams.Add('alwaysIncludeEmail', AlwaysIncludeEmail);

  inherited FillParams(AParams);
end;

{ TEventsModifyRequest }

procedure TEventsModifyRequest.FillParams(AParams: THttpRequestParameterList);
begin
  AParams.Add('maxAttendees', MaxAttendees);
  AParams.Add('sendNotifications', SendNotifications);

  inherited FillParams(AParams);
end;

{ TEventsInstancesRequest }

constructor TEventsInstancesRequest.Create(AService: TService; const ACalendarId, AEventId: string);
begin
  inherited Create(AService);

  FCalendarId := ACalendarId;
  FEventId := AEventId;
end;

function TEventsInstancesRequest.Execute: TEvents;
var
  response: string;
  params: THttpRequestParameterList;
begin
  params := THttpRequestParameterList.Create();
  try
    FillParams(params);
    response := Service.Initializer.HttpClient.Get('https://www.googleapis.com/calendar/v3/calendars/' + CalendarId + '/events/' + EventId + '/instances', params);
    Result := TEvents(Service.Initializer.JsonSerializer.JsonToObject(TEvents, response));
  finally
    params.Free();
  end;
end;

procedure TEventsInstancesRequest.FillParams(AParams: THttpRequestParameterList);
begin
  AParams.Add('alwaysIncludeEmail', AlwaysIncludeEmail);
  AParams.Add('maxAttendees', MaxAttendees);
  AParams.Add('maxResults', MaxResults);
  AParams.Add('originalStart', OriginalStart);
  AParams.Add('pageToken', PageToken);
  AParams.Add('showDeleted', ShowDeleted);
  AParams.Add('timeMax', TUtils.DateTimeToRfc3339(TimeMax));
  AParams.Add('timeMin', TUtils.DateTimeToRfc3339(TimeMin));
  AParams.Add('timeZone', TimeZone);
  AParams.Add('fields', Fields);
end;

end.
