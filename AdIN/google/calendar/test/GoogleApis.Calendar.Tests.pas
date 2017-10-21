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

unit GoogleApis.Calendar.Tests;

interface

uses
  System.Classes, System.SysUtils, TestFramework, GoogleApis, GoogleApis.Calendar,
  GoogleApis.Calendar.Data, GoogleApis.Persister;

type
  TCalendarJsonSerializerTests = class(TTestCase)
  published
    procedure TestGoogleCalendarListEntry;
    procedure TestGoogleCalendarList;
    procedure TestGoogleCalendar;
    procedure TestEventCreator;
    procedure TestEventOrganizer;
    procedure TestEventDateTime;
    procedure TestEvent;
    procedure TestEvents;
  end;

  TCalendarServiceTests = class(TTestCase)
  private
    FService: TCalendarService;

    function GetService: TCalendarService;

    function ListCalendarList(const AFields: string): TCalendarList;
    function GetCalendarList(const ACalendarId, AFields: string): TCalendarListEntry;
    function UpdateCalendarList(var ACalendarListEntry: TCalendarListEntry; const AFields: string): TCalendarListEntry;
    function PatchCalendarList(var ACalendarListEntry: TCalendarListEntry; const AFields: string): TCalendarListEntry;
    function InsertCalendarList(var ACalendarListEntry: TCalendarListEntry; const AFields: string): TCalendarListEntry;
    function DeleteCalendarList(const ACalendarId: string): Boolean;

    function InsertCalendar(var ACalendar: TCalendar; const AFields: string): TCalendar;
    function GetCalendar(const ACalendarId, AFields: string): TCalendar;
    function UpdateCalendar(var ACalendar: TCalendar; const AFields: string): TCalendar;
    function PatchCalendar(var ACalendar: TCalendar; const AFields: string): TCalendar;
    function DeleteCalendar(const ACalendarId: string): Boolean;

    function ListEvents(const ACalendarId, AFields: string): TEvents;
    function GetEvent(const ACalendarId, AEventId, AFields: string): TEvent;
    function QuickAddEvent(const ACalendarId, AText, AFields: string): TEvent;
    function UpdateEvent(const ACalendarId: string; var AEvent: TEvent; const AFields: string): TEvent;
    function PatchEvent(const ACalendarId: string; var AEvent: TEvent; const AFields: string): TEvent;
    function InsertEvent(const ACalendarId: string; var AEvent: TEvent; const AFields: string): TEvent;
    function DeleteEvent(const ACalendarId, AEventId: string): Boolean;
    function MoveEvent(const ACalendarId, AEventId, ADestination, AFields: string): TEvent;
    function ImportEvent(const ACalendarId: string; var AEvent: TEvent; const AFields: string): TEvent;
    function GetInstances(const ACalendarId, AEventId, AFields: string): TEvents;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCalendars;
    procedure TestCalendarList;
    procedure TestEvents;
    procedure TestMoveEvents;
    procedure TestImportEvents;
    procedure TestRecurrentEvents;
  end;

implementation

{ TCalendarJsonSerializerTests }

procedure TCalendarJsonSerializerTests.TestEvent;
const
  jsonSource =
'{' +
' "kind": "calendar#event",' +
' "etag": "\"2878607593232000\"",' +
' "id": "2tn0dfau1e0ro7jj4d51peepvg",' +
' "status": "confirmed",' +
' "htmlLink": "https://www.google.com/calendar/event?eid=MnRuMGRmYXUxZTBybzdqajRkNTFwZWVwdmcgN3JqZ3UyNGo2bWZrbXJ2cmhfdsdfvdfg",' +
' "created": "2015-08-11T14:36:36.000Z",' +
' "updated": "2015-08-11T14:36:36.616Z",' +
' "summary": "test event",' +
' "creator": {' +
'  "email": "qwe@gmail.com",' +
'  "displayName": "John Smith"' +
' },' +
' "organizer": {' +
'  "email": "7rjgu24j6mfkmrvsdwqewer12v0g@group.calendar.google.com",' +
'  "displayName": "Test calendar",' +
'  "self": true' +
' },' +
' "start": {' +
'  "dateTime": "2015-08-11T17:36:36+03:00"' +
' },' +
' "end": {' +
'  "dateTime": "2015-08-11T18:36:36+03:00"' +
' },' +
' "iCalUID": "2tn0dfau1e0ro7jjsdfsdfpeepvg@google.com",' +
' "sequence": 0,' +
' "reminders": {' +
'  "useDefault": true' +
' }' +
'}';

  jsonDest = '{"kind": "calendar#event", "etag": "\"2878607593232000\"", "id": ' +
'"2tn0dfau1e0ro7jj4d51peepvg", "status": "confirmed", ' +
'"htmlLink": "https:\/\/www.google.com\/calendar\/event?eid=MnRuMGRmYXUxZTBybzdqajRkNTFwZWVwdmcgN3JqZ3UyNGo2bWZrbXJ2cmhfdsdfvdfg", ' +
'"created": 2015-08-11T14:36:36.000Z, "updated": 2015-08-11T14:36:36.616Z, "summary": "test event", ' +
'"creator": {"displayName": "John Smith", "email": "qwe@gmail.com"}, ' +
'"organizer": {"displayName": "Test calendar", "email": "7rjgu24j6mfkmrvsdwqewer12v0g@group.calendar.google.com", "self": true}, ' +
'"start": {"dateTime": "2015-08-11T17:36:36+03:00"}, "end": {"dateTime": "2015-08-11T18:36:36+03:00"}, ' +
'"iCalUID": "2tn0dfau1e0ro7jjsdfsdfpeepvg@google.com", "sequence": 0, "reminders": {"useDefault": true}}';

var
  serializer: TJsonSerializer;
  obj: TEvent;
  json: string;
begin
  serializer := nil;
  obj := nil;
  try
    serializer := TGoogleApisJsonSerializer.Create();

    obj := serializer.JsonToObject(TEvent, jsonSource) as TEvent;

    CheckEquals('calendar#event', obj.Kind);
    CheckEquals('2tn0dfau1e0ro7jj4d51peepvg', obj.Id);

    CheckEquals('2015-08-11T14:36:36.000Z', obj.CreatedRaw);
    CheckEquals(DateTimeToStr(EncodeDate(2015, 08, 11) + EncodeTime(17, 36, 36, 0)), DateTimeToStr(obj.Created));

    CheckEquals('2015-08-11T14:36:36.616Z', obj.UpdatedRaw);
    CheckEquals(DateTimeToStr(EncodeDate(2015, 08, 11) + EncodeTime(17, 36, 36, 616)), DateTimeToStr(obj.Updated));

    CheckEquals('qwe@gmail.com', obj.Creator.Email);
    CheckEquals('Test calendar', obj.Organizer.DisplayName);
    CheckEquals('2015-08-11T17:36:36+03:00', obj.Start.DateTimeRaw);

    json := serializer.ObjectToJson(obj);

    CheckEquals(jsonDest, json);
  finally
    obj.Free();
    serializer.Free();
  end;
end;

procedure TCalendarJsonSerializerTests.TestEventCreator;
const
  jsonSource =
'{' +
'  "email": "qweasd@gmail.com",' +
'  "displayName": "Qwe Asd"' +
' }';

  jsonDest = '{"displayName": "Qwe Asd", "email": "qweasd@gmail.com"}';

var
  serializer: TJsonSerializer;
  obj: TEventCreator;
  json: string;
begin
  serializer := nil;
  obj := nil;
  try
    serializer := TGoogleApisJsonSerializer.Create();

    obj := serializer.JsonToObject(TEventCreator, jsonSource) as TEventCreator;

    CheckEquals('qweasd@gmail.com', obj.Email);
    CheckEquals('Qwe Asd', obj.DisplayName);

    json := serializer.ObjectToJson(obj);

    CheckEquals(jsonDest, json);
  finally
    obj.Free();
    serializer.Free();
  end;
end;

procedure TCalendarJsonSerializerTests.TestEventDateTime;
const
  jsonSource =
'{' +
'  "date": "2015 August 11",' +
'  "dateTime": "2015-08-11T17:35:36+03:00",' +
'  "timeZone": "Europe/Moscow"' +
'}';

  jsonDest = '{"date": "2015 August 11", "dateTime": "2015-08-12T17:35:36+03:00", "timeZone": "Europe\/Moscow"}';

var
  serializer: TJsonSerializer;
  obj: TEventDateTime;
  json: string;
begin
  serializer := nil;
  obj := nil;
  try
    serializer := TGoogleApisJsonSerializer.Create();

    obj := serializer.JsonToObject(TEventDateTime, jsonSource) as TEventDateTime;

    CheckEquals('Europe/Moscow', obj.TimeZone);
    CheckEquals('2015 August 11', obj.Date);

    CheckEquals('2015-08-11T17:35:36+03:00', obj.DateTimeRaw);
    CheckEquals(DateTimeToStr(EncodeDate(2015, 08, 11) + EncodeTime(17, 35, 36, 0)), DateTimeToStr(obj.DateTime));

    obj.DateTime := EncodeDate(2015, 08, 12) + EncodeTime(17, 35, 36, 0);
    CheckEquals('2015-08-12T17:35:36+03:00', obj.DateTimeRaw);

    json := serializer.ObjectToJson(obj);

    CheckEquals(jsonDest, json);
  finally
    obj.Free();
    serializer.Free();
  end;
end;

procedure TCalendarJsonSerializerTests.TestEventOrganizer;
const
  jsonSource =
'{' +
'  "email": "7rjgu24j6mfkmrvrhvrq312v0g@group.calendar.google.com",' +
'  "displayName": "Test calendar",' +
'  "self": true' +
' }';

  jsonDest = '{"displayName": "Test calendar", "email": "7rjgu24j6mfkmrvrhvrq312v0g@group.calendar.google.com", "self": true}';

var
  serializer: TJsonSerializer;
  obj: TEventOrganizer;
  json: string;
begin
  serializer := nil;
  obj := nil;
  try
    serializer := TGoogleApisJsonSerializer.Create();

    obj := serializer.JsonToObject(TEventOrganizer, jsonSource) as TEventOrganizer;

    CheckEquals('7rjgu24j6mfkmrvrhvrq312v0g@group.calendar.google.com', obj.Email);
    CheckEquals('Test calendar', obj.DisplayName);
    CheckTrue(obj.Self);

    json := serializer.ObjectToJson(obj);

    CheckEquals(jsonDest, json);
  finally
    obj.Free();
    serializer.Free();
  end;
end;

procedure TCalendarJsonSerializerTests.TestEvents;
const
  jsonSource =
'{' +
' "kind": "calendar#events",' +
' "etag": "\"1441859420383000\"",' +
' "summary": "Праздники РФ",' +
' "description": "Праздники и памятные даты Российской Федерации",' +
' "updated": "2015-09-10T04:30:20.383Z",' +
' "timeZone": "UTC",' +
' "accessRole": "reader",' +
' "defaultReminders": [' +
' ],' +
' "nextSyncToken": "CJjOxfTQ68cCEJjOxfTQ68cCGAE=",' +
' "items": [' +
'  {' +
'   "kind": "calendar#event",' +
'   "etag": "\"2778501856000000\"",' +
'   "id": "20140102_60o30dj26oo30c1g60o30dr4ck"' +
'  },' +
'  {' +
'   "kind": "calendar#event",' +
'   "etag": "\"2778501856000000\"",' +
'   "id": "20140108_60o30dj2c8o30c1g60o30dr4ck"' +
'  }' +
' ]' +
'}';

  jsonDest = '{"kind": "calendar#events", "etag": "\"1441859420383000\"", "summary": "Праздники РФ", ' +
'"description": "Праздники и памятные даты Российской Федерации", "updated": 2015-09-10T04:30:20.383Z, ' +
'"timeZone": "UTC", "accessRole": "reader", "nextSyncToken": "CJjOxfTQ68cCEJjOxfTQ68cCGAE=", ' +
'"items": [{"kind": "calendar#event", "etag": "\"2778501856000000\"", "id": "20140102_60o30dj26oo30c1g60o30dr4ck", ' +
'"sequence": 0}, {"kind": "calendar#event", "etag": "\"2778501856000000\"", "id": "20140108_60o30dj2c8o30c1g60o30dr4ck", "sequence": 0}]}';

var
  serializer: TJsonSerializer;
  obj: TEvents;
  json: string;
begin
  serializer := nil;
  obj := nil;
  try
    serializer := TGoogleApisJsonSerializer.Create();

    obj := serializer.JsonToObject(TEvents, jsonSource) as TEvents;

    CheckEquals('calendar#events', obj.Kind);
    CheckEquals('"1441859420383000"', obj.ETag);
    CheckEquals('Праздники РФ', obj.Summary);
    CheckEquals('Праздники и памятные даты Российской Федерации', obj.Description);
    CheckEquals(DateTimeToStr(EncodeDate(2015, 09, 10) + EncodeTime(07, 30, 20, 383)), DateTimeToStr(obj.Updated));

    CheckEquals(0, Length(obj.DefaultReminders));

    CheckEquals(2, Length(obj.Items));

    CheckEquals('20140102_60o30dj26oo30c1g60o30dr4ck', obj.Items[0].Id);
    CheckEquals('20140108_60o30dj2c8o30c1g60o30dr4ck', obj.Items[1].Id);

    json := serializer.ObjectToJson(obj);

    CheckEquals(jsonDest, json);
  finally
    obj.Free();
    serializer.Free();
  end;
end;

procedure TCalendarJsonSerializerTests.TestGoogleCalendar;
const
  jsonSource =
'{' +
' "kind": "calendar#calendar",' +
' "etag": "\"dJhIJiuNJqPt32MYlEBHdNLPf7o/0xHVqU-nMzDdXjrlvc_Hmmk4za8\"",' +
' "id": "qwe@gmail.com",' +
' "summary": "summary value",' +
' "timeZone": "Europe/Moscow"' +
'}';

  jsonDest = '{"kind": "calendar#calendar", "etag": "\"dJhIJiuNJqPt32MYlEBHdNLPf7o\/0xHVqU-nMzDdXjrlvc_Hmmk4za8\"", ' +
'"id": "qwe@gmail.com", "summary": "summary value", "timeZone": "Europe\/Moscow"}';

var
  serializer: TJsonSerializer;
  obj: TCalendar;
  json: string;
begin
  serializer := nil;
  obj := nil;
  try
    serializer := TGoogleApisJsonSerializer.Create();

    obj := serializer.JsonToObject(TCalendar, jsonSource) as TCalendar;

    CheckEquals('calendar#calendar', obj.Kind);
    CheckEquals('"dJhIJiuNJqPt32MYlEBHdNLPf7o/0xHVqU-nMzDdXjrlvc_Hmmk4za8"', obj.ETag);
    CheckEquals('qwe@gmail.com', obj.Id);
    CheckEquals('summary value', obj.Summary);
    CheckEquals('Europe/Moscow', obj.TimeZone);

    json := serializer.ObjectToJson(obj);

    CheckEquals(jsonDest, json);
  finally
    obj.Free();
    serializer.Free();
  end;
end;

procedure TCalendarJsonSerializerTests.TestGoogleCalendarList;
const
  jsonSource =
'{' +
' "kind": "calendar#calendarList",' +
' "etag": "\"1\"",' +
' "nextPageToken": "39390000222234212373",' +
' "nextSyncToken": "00001437826053379000",' +
' "items": [' +
'  {' +
'   "id": "#contacts@group.v.calendar.google.com"' +
'  },' +
'  {' +
'   "id": "ru.russian#holiday@group.v.calendar.google.com"' +
'  }' +
' ]' +
'}';
  jsonDest =
'{' +
'"kind": "calendar#calendarList", ' +
'"etag": "\"1\"", ' +
'"nextPageToken": "39390000222234212373", ' +
'"nextSyncToken": "00001437826053379000", ' +
'"items": [' +
'{' +
'"id": "#contacts@group.v.calendar.google.com"' +
'}, ' +
'{"id": "ru.russian#holiday@group.v.calendar.google.com"' +
'}' +
']' +
'}';

var
  serializer: TJsonSerializer;
  obj: TCalendarList;
  json: string;
begin
  serializer := nil;
  obj := nil;
  try
    serializer := TGoogleApisJsonSerializer.Create();

    obj := serializer.JsonToObject(TCalendarList, jsonSource) as TCalendarList;

    CheckEquals('"1"', obj.ETag);
    CheckEquals('calendar#calendarList', obj.Kind);
    CheckEquals('39390000222234212373', obj.NextPageToken);
    CheckEquals('00001437826053379000', obj.NextSyncToken);

    CheckEquals(2, Length(obj.Items));

    CheckEquals('#contacts@group.v.calendar.google.com', obj.Items[0].Id);
    CheckEquals('ru.russian#holiday@group.v.calendar.google.com', obj.Items[1].Id);

    json := serializer.ObjectToJson(obj);

    CheckEquals(jsonDest, json);
  finally
    obj.Free();
    serializer.Free();
  end;
end;

procedure TCalendarJsonSerializerTests.TestGoogleCalendarListEntry;
const
  jsonSource =
'{' +
'  "kind": "calendar#calendarListEntry",' +
'   "etag": "\"0\"",' +
'   "id": "qweasd@gmail.com",' +
'   "summary": "qweasd@gmail.com",' +
'   "description": "Excersize Упражнение Übung",' +
'   "timeZone": "Europe/Moscow",' +
'   "colorId": "15",' +
'   "backgroundColor": "#9fc6e7",' +
'   "foregroundColor": "#000000",' +
'   "selected": true,' +
'   "accessRole": "owner",' +
'   "defaultReminders": [' +
'    {' +
'     "method": "popup",' +
'     "minutes": 30' +
'    },' +
'    {' +
'     "method": "email",' +
'     "minutes": 10' +
'    }' +
'   ],' +
'   "notificationSettings": {' +
'    "notifications": [' +
'     {' +
'      "type": "eventCreation",' +
'      "method": "email"' +
'     },' +
'     {' +
'      "type": "eventChange",' +
'      "method": "email"' +
'     },' +
'     {' +
'      "type": "eventCancellation",' +
'      "method": "email"' +
'     },' +
'     {' +
'      "type": "eventResponse",' +
'      "method": "email"' +
'     }' +
'    ]' +
'   },' +
'   "primary": true' +
'}';

  jsonDest = '{"kind": "calendar#calendarListEntry", "etag": "\"0\"", "id": "qweasd@gmail.com", ' +
'"summary": "qweasd@gmail.com", "description": "Excersize Упражнение Übung", ' +
'"timeZone": "Europe\/Moscow", "colorId": "15", "backgroundColor": "#9fc6e7", "foregroundColor": "#000000", ' +
'"selected": true, "accessRole": "owner", "primary": true, ' +
'"defaultReminders": [{"method": "popup", "minutes": 30}, {"method": "email", "minutes": 10}], ' +
'"notificationSettings": {"notifications": [{"method": "email", "type": "eventCreation"}, ' +
'{"method": "email", "type": "eventChange"}, {"method": "email", "type": "eventCancellation"}, ' +
'{"method": "email", "type": "eventResponse"}]}}';

var
  serializer: TJsonSerializer;
  obj: TCalendarListEntry;
  json: string;
begin
  serializer := nil;
  obj := nil;
  try
    serializer := TGoogleApisJsonSerializer.Create();

    obj := serializer.JsonToObject(TCalendarListEntry, jsonSource) as TCalendarListEntry;

    CheckEquals('owner', obj.AccessRole);
    CheckEquals('#9fc6e7', obj.BackgroundColor);
    CheckEquals('15', obj.ColorId);
    CheckEquals(False, obj.Deleted);
    CheckEquals('Excersize Упражнение Übung', obj.Description);
    CheckEquals('"0"', obj.ETag);
    CheckEquals('#000000', obj.ForegroundColor);
    CheckEquals(False, obj.Hidden);
    CheckEquals('qweasd@gmail.com', obj.Id);
    CheckEquals('calendar#calendarListEntry', obj.Kind);
    CheckEquals('', obj.Location);
    CheckEquals(True, obj.Primary);
    CheckEquals(True, obj.Selected);
    CheckEquals('qweasd@gmail.com', obj.Summary);
    CheckEquals('', obj.SummaryOverride);
    CheckEquals('Europe/Moscow', obj.TimeZone);
    CheckEquals(2, Length(obj.DefaultReminders));
    CheckEquals('popup', obj.DefaultReminders[0].Method);
    CheckEquals('email', obj.DefaultReminders[1].Method);
    CheckEquals(4, Length(obj.NotificationSettings.Notifications));
    CheckEquals('eventCreation', obj.NotificationSettings.Notifications[0].Type_);

    json := serializer.ObjectToJson(obj);

    CheckEquals(jsonDest, json);
  finally
    obj.Free();
    serializer.Free();
  end;
end;

{ TCalendarServiceTests }

function TCalendarServiceTests.DeleteCalendar(const ACalendarId: string): Boolean;
var
  delReq: TCalendarsDeleteRequest;
begin
  delReq := GetService().Calendars.Delete(ACalendarId);
  try
    Result := delReq.Execute();
  finally
    delReq.Free();
  end;
end;

function TCalendarServiceTests.DeleteCalendarList(const ACalendarId: string): Boolean;
var
  delReq: TCalendarListDeleteRequest;
begin
  delReq := GetService().CalendarList.Delete(ACalendarId);
  try
    Result := delReq.Execute();
  finally
    delReq.Free();
  end;
end;

function TCalendarServiceTests.DeleteEvent(const ACalendarId, AEventId: string): Boolean;
var
  delReq: TEventsDeleteRequest;
begin
  delReq := GetService().Events.Delete(ACalendarId, AEventId);
  try
    Result := delReq.Execute();
  finally
    delReq.Free();
  end;
end;

function TCalendarServiceTests.GetCalendar(const ACalendarId, AFields: string): TCalendar;
var
  getReq: TCalendarsGetRequest;
begin
  getReq := GetService().Calendars.Get(ACalendarId);
  try
    getReq.Fields := AFields;

    Result := getReq.Execute();
  finally
    getReq.Free();
  end;
end;

function TCalendarServiceTests.GetCalendarList(const ACalendarId,
  AFields: string): TCalendarListEntry;
var
  request: TCalendarListGetRequest;
begin
  request := GetService().CalendarList.Get(ACalendarId);
  try
    request.Fields := AFields;

    Result := request.Execute();
  finally
    request.Free();
  end;
end;

function TCalendarServiceTests.GetEvent(const ACalendarId, AEventId, AFields: string): TEvent;
var
  request: TEventsGetRequest;
begin
  request := GetService().Events.Get(ACalendarId, AEventId);
  try
    request.Fields := AFields;

    Result := request.Execute();
  finally
    request.Free();
  end;
end;

function TCalendarServiceTests.GetInstances(const ACalendarId, AEventId, AFields: string): TEvents;
var
  request: TEventsInstancesRequest;
begin
  request := GetService().Events.Instances(ACalendarId, AEventId);
  try
    request.MaxResults := 3;
    request.Fields := AFields;

    Result := request.Execute();
  finally
    request.Free();
  end;
end;

function TCalendarServiceTests.GetService: TCalendarService;
var
  credential: TGoogleOAuthCredential;
  initializer: TServiceInitializer;
begin
  if (FService = nil) then
  begin
    credential := TGoogleOAuthCredential.Create();
    initializer := TGoogleApisServiceInitializer.Create(credential, 'CleverComponents Calendar test');
    FService := TCalendarService.Create(initializer);

    credential.ClientID := '421475025220-6khpgoldbdsi60fegvjdqk2bk4v19ss2.apps.googleusercontent.com';
    credential.ClientSecret := '_4HJyAVUmH_iVrPB8pOJXjR1';
    credential.Scope := 'https://www.googleapis.com/auth/calendar';
  end;
  Result := FService;
end;

function TCalendarServiceTests.ImportEvent(const ACalendarId: string;
  var AEvent: TEvent; const AFields: string): TEvent;
var
  req: TEventsImportRequest;
begin
  req := GetService().Events.Import(ACalendarId, AEvent);
  try
    AEvent := nil;

    req.Fields := AFields;

    Result := req.Execute();
  finally
    req.Free();
  end;
end;

function TCalendarServiceTests.InsertCalendar(var ACalendar: TCalendar; const AFields: string): TCalendar;
var
  insertReq: TCalendarsInsertRequest;
begin
  insertReq := GetService().Calendars.Insert(ACalendar);
  try
    ACalendar := nil;

    insertReq.Fields := AFields;

    Result := insertReq.Execute();
  finally
    insertReq.Free();
  end;
end;

function TCalendarServiceTests.InsertCalendarList(var ACalendarListEntry: TCalendarListEntry;
  const AFields: string): TCalendarListEntry;
var
  request: TCalendarListInsertRequest;
begin
  request := GetService().CalendarList.Insert(ACalendarListEntry);
  try
    ACalendarListEntry := nil;

    request.Fields := AFields;

    Result := request.Execute();
  finally
    request.Free();
  end;
end;

function TCalendarServiceTests.InsertEvent(const ACalendarId: string;
  var AEvent: TEvent; const AFields: string): TEvent;
var
  req: TEventsInsertRequest;
begin
  req := GetService().Events.Insert(ACalendarId, AEvent);
  try
    AEvent := nil;

    req.Fields := AFields;

    Result := req.Execute();
  finally
    req.Free();
  end;
end;

function TCalendarServiceTests.ListCalendarList(const AFields: string): TCalendarList;
var
  request: TCalendarListRequest;
begin
  request := GetService().CalendarList.List();
  try
    request.MaxResults := 10;
    request.MinAccessRole := 'reader';
    request.ShowDeleted := False;
    request.ShowHidden := True;
    request.Fields := AFields;

    Result := request.Execute();
  finally
    request.Free();
  end;
end;

function TCalendarServiceTests.ListEvents(const ACalendarId, AFields: string): TEvents;
var
  request: TEventsListRequest;
begin
  request := GetService().Events.List(ACalendarId);
  try
    request.MaxResults := 3;
    request.OrderBy := 'updated';
    request.Fields := AFields;

    Result := request.Execute();
  finally
    request.Free();
  end;
end;

function TCalendarServiceTests.MoveEvent(const ACalendarId, AEventId, ADestination, AFields: string): TEvent;
var
  request: TEventsMoveRequest;
begin
  request := GetService().Events.Move(ACalendarId, AEventId, ADestination);
  try
    request.Fields := AFields;

    Result := request.Execute();
  finally
    request.Free();
  end;
end;

function TCalendarServiceTests.PatchCalendar(
  var ACalendar: TCalendar; const AFields: string): TCalendar;
var
  patchReq: TCalendarsPatchRequest;
begin
  patchReq := GetService().Calendars.Patch(ACalendar);
  try
    ACalendar := nil;

    patchReq.Fields := AFields;

    Result := patchReq.Execute();
  finally
    patchReq.Free();
  end;
end;

function TCalendarServiceTests.PatchCalendarList(var ACalendarListEntry: TCalendarListEntry;
  const AFields: string): TCalendarListEntry;
var
  request: TCalendarListPatchRequest;
begin
  request := GetService().CalendarList.Patch(ACalendarListEntry);
  try
    ACalendarListEntry := nil;

    request.Fields := AFields;

    Result := request.Execute();
  finally
    request.Free();
  end;
end;

function TCalendarServiceTests.PatchEvent(const ACalendarId: string;
  var AEvent: TEvent; const AFields: string): TEvent;
var
  req: TEventsPatchRequest;
begin
  req := GetService().Events.Patch(ACalendarId, AEvent);
  try
    AEvent := nil;

    req.Fields := AFields;

    Result := req.Execute();
  finally
    req.Free();
  end;
end;

function TCalendarServiceTests.QuickAddEvent(const ACalendarId, AText, AFields: string): TEvent;
var
  request: TEventsQuickAddRequest;
begin
  request := GetService().Events.QuickAdd(ACalendarId, AText);
  try
    request.Fields := AFields;

    Result := request.Execute();
  finally
    request.Free();
  end;
end;

function TCalendarServiceTests.UpdateEvent(const ACalendarId: string;
  var AEvent: TEvent; const AFields: string): TEvent;
var
  req: TEventsUpdateRequest;
begin
  req := GetService().Events.Update(ACalendarId, AEvent);
  try
    AEvent := nil;

    req.Fields := AFields;

    Result := req.Execute();
  finally
    req.Free();
  end;
end;

procedure TCalendarServiceTests.SetUp;
begin
  inherited SetUp();
  FService := nil;
end;

procedure TCalendarServiceTests.TearDown;
begin
  inherited TearDown();
  FService.Free();
end;

procedure TCalendarServiceTests.TestCalendars;
var
  calendar: TCalendar;
  id: string;
begin
  calendar := nil;
  try
    calendar := TCalendar.Create();
    calendar.Summary := 'test calendar';
    calendar.Kind := 'calendar#calendar';
    calendar.TimeZone := 'Europe/Moscow';

    calendar := InsertCalendar(calendar, 'summary,id,kind,timeZone');

    Check(calendar.Id <> '');
    CheckEquals('test calendar', calendar.Summary);
    CheckEquals('calendar#calendar', calendar.Kind);
    CheckEquals('Europe/Moscow', calendar.TimeZone);

    id := calendar.Id;
    FreeAndNil(calendar);

    Sleep(10000);

    calendar := GetCalendar(id, 'summary,id,kind,timeZone');

    CheckEquals(id, calendar.Id);
    CheckEquals('test calendar', calendar.Summary);
    CheckEquals('calendar#calendar', calendar.Kind);
    CheckEquals('Europe/Moscow', calendar.TimeZone);

    calendar.Description := 'test description';

    calendar := UpdateCalendar(calendar, 'summary,id,description');

    CheckEquals(id, calendar.Id);
    CheckEquals('test calendar', calendar.Summary);
    CheckEquals('test description', calendar.Description);

    FreeAndNil(calendar);

    calendar := TCalendar.Create();
    calendar.Id := id;
    calendar.Summary := 'test calendar updated';

    calendar := PatchCalendar(calendar, '');

    CheckEquals('test calendar updated', calendar.Summary);
    CheckEquals('test description', calendar.Description);

    FreeAndNil(calendar);

    //TODO Calendars.Clear is not tested

    Check(DeleteCalendar(id));

    try
      calendar := GetCalendar(id, '');
      Fail('The calendar is not deleted or the error handling does not work');
    except
      on EGoogleApisException do;
    end;
  finally
    calendar.Free();
  end;
end;

procedure TCalendarServiceTests.TestEvents;
var
  calendar: TCalendar;
  events: TEvents;
  event: TEvent;
  id, s: string;
  start, end_: TDateTime;
begin
  calendar := nil;
  event := nil;
  events := nil;
  try
    calendar := TCalendar.Create();
    calendar.Summary := 'test calendar with events';
    calendar.Kind := 'calendar#calendar';
    calendar.TimeZone := 'Europe/Moscow';

    calendar := InsertCalendar(calendar, 'summary,id');

    event := QuickAddEvent(calendar.Id, 'sample пример Übung', 'description,id,start,status,summary');

    CheckTrue(event.Id <> '');
    CheckEquals('sample пример Übung', event.Summary);

    id := event.Id;
    FreeAndNil(event);

    event := GetEvent(calendar.Id, id, 'id,summary,start,end');
    CheckEquals(id, event.Id);
    CheckEquals('sample пример Übung', event.Summary);

    events := ListEvents(calendar.Id, 'etag,items(id,summary)');

    CheckTrue(events.ETag <> '');
    CheckTrue(Length(events.Items) > 0);
    CheckTrue(events.Items[0].Id <> '');
    CheckTrue(events.Items[0].Summary <> '');

    s := event.Summary;
    start := event.Start.DateTime;
    end_ := event.End_.DateTime;
    event.Summary := event.Summary + ' - updated';
    event.Start.DateTime := event.Start.DateTime + 1;
    event.End_.DateTime := event.End_.DateTime + 1;

    event := UpdateEvent(calendar.Id, event, 'id,summary,start,end');

    CheckEquals(id, event.Id);
    CheckEquals(s + ' - updated', event.Summary);
    CheckEquals(Round(start + 1), Round(event.Start.DateTime));
    CheckEquals(Round(end_ + 1), Round(event.End_.DateTime));

    event.Summary := s + ' - patched';

    event := PatchEvent(calendar.Id, event, 'id,summary');

    CheckEquals(id, event.Id);
    CheckEquals(s + ' - patched', event.Summary);

    FreeAndNil(event);

    event := TEvent.Create();
    event.Start := TEventDateTime.Create();
    event.Start.DateTime := Now() + 1;
    event.End_ := TEventDateTime.Create();
    event.End_.DateTime := Now() + 2;
    event.Summary := 'sample пример Übung - inserted';

    event := InsertEvent(calendar.Id, event, 'id,summary,start,end');
    CheckEquals('sample пример Übung - inserted', event.Summary);
    CheckEquals(Round(Now() + 1), Round(event.Start.DateTime));
    CheckEquals(Round(Now() + 2), Round(event.End_.DateTime));

    id := event.Id;
    FreeAndNil(event);

    Check(DeleteEvent(calendar.Id, id));

    event := GetEvent(calendar.Id, id, 'id,status');
    CheckEquals('cancelled', event.Status);

    DeleteCalendar(calendar.Id);
  finally
    events.Free();
    event.Free();
    calendar.Free();
  end;
end;

procedure TCalendarServiceTests.TestImportEvents;
var
  calendar: TCalendar;
  event: TEvent;
  s: string;
begin
  calendar := nil;
  event := nil;
  try
    calendar := TCalendar.Create();
    calendar.Summary := 'test calendar import events';
    calendar.Kind := 'calendar#calendar';
    calendar.TimeZone := 'Europe/Moscow';

    calendar := InsertCalendar(calendar, 'summary,id');

    event := QuickAddEvent(calendar.Id, 'sample пример Übung', 'id,summary,start,end,iCalUID');

    s := event.Summary;
    event.Summary := event.Summary + ' - imported';

    event := ImportEvent(calendar.Id, event, 'id,summary');

    CheckEquals(s + ' - imported', event.Summary);

    DeleteCalendar(calendar.Id);
  finally
    event.Free();
    calendar.Free();
  end;
end;

procedure TCalendarServiceTests.TestMoveEvents;
var
  calendar, calendar2: TCalendar;
  event: TEvent;
  id: string;
begin
  calendar := nil;
  calendar2 := nil;
  event := nil;
  try
    calendar := TCalendar.Create();
    calendar.Summary := 'test calendar with events';
    calendar.Kind := 'calendar#calendar';
    calendar.TimeZone := 'Europe/Moscow';

    calendar := InsertCalendar(calendar, 'summary,id');

    event := QuickAddEvent(calendar.Id, 'sample пример Übung', '');

    calendar2 := TCalendar.Create();
    calendar2.Summary := 'test calendar move events';
    calendar2.Kind := 'calendar#calendar';
    calendar2.TimeZone := 'Europe/Moscow';

    calendar2 := InsertCalendar(calendar2, 'summary,id');

    id := event.Id;
    FreeAndNil(event);

    event := MoveEvent(calendar.Id, id, calendar2.Id, 'id, summary');
    CheckEquals('sample пример Übung', event.Summary);

    DeleteCalendar(calendar.Id);
    DeleteCalendar(calendar2.Id);
  finally
    event.Free();
    calendar2.Free();
    calendar.Free();
  end;
end;

procedure TCalendarServiceTests.TestRecurrentEvents;
var
  calendar: TCalendar;
  event: TEvent;
  events: TEvents;
  recurrence: TArray<string>;
begin
  calendar := nil;
  event := nil;
  events := nil;
  try
    calendar := TCalendar.Create();
    calendar.Summary := 'test calendar recurrent events';
    calendar.Kind := 'calendar#calendar';
    calendar.TimeZone := 'Europe/Moscow';

    calendar := InsertCalendar(calendar, 'summary,id');

    event := TEvent.Create();
    event.Start := TEventDateTime.Create();
    event.Start.DateTime := Now() + 1;
    event.Start.TimeZone := 'UTC';

    event.End_ := TEventDateTime.Create();
    event.End_.DateTime := Now() + 3;
    event.End_.TimeZone := 'UTC';

    event.Summary := 'sample пример Übung - recurrence';

    SetLength(recurrence, 1);
    event.Recurrence := recurrence;
    event.Recurrence[0] := 'RRULE:FREQ=DAILY';

    event := InsertEvent(calendar.Id, event, 'id,summary,start,end,recurrence');

    events := GetInstances(calendar.Id, event.Id, '');
    CheckEquals(3, Length(events.Items));

    DeleteCalendar(calendar.Id);
  finally
    events.Free();
    event.Free();
    calendar.Free();
  end;
end;

procedure TCalendarServiceTests.TestCalendarList;
var
  list: TCalendarList;
  listEntry: TCalendarListEntry;
  calendar: TCalendar;
  id: string;
  selected: Boolean;
begin
  list := nil;
  listEntry := nil;
  calendar := nil;
  try
    list := ListCalendarList('items(backgroundColor,description,id,location,selected,summary),nextPageToken,nextSyncToken');

    CheckTrue(Length(list.Items) > 0);
    CheckTrue(list.Items[0].Id <> '');
    CheckTrue(list.Items[0].Summary <> '');

    FreeAndNil(list);
    try
      list := ListCalendarList('qwe');
      Fail('Error handling does not work');
    except
      on E: EGoogleApisException do
      begin
        Check(E.Error.Code = 400);
        Check(Length(E.Error.Errors) > 0);
        Check(E.Error.Errors[0].Message <> '');
      end;
    end;

    calendar := TCalendar.Create();
    calendar.Summary := 'test calendar';
    calendar.Kind := 'calendar#calendar';
    calendar.TimeZone := 'Europe/Moscow';

    calendar := InsertCalendar(calendar, 'summary,id,kind,timeZone');
    id := calendar.Id;

    listEntry := GetCalendarList(id, '');
    CheckEquals(id, listEntry.Id);
    CheckTrue(listEntry.Summary <> '');

    selected := listEntry.Selected;
    listEntry.Selected := not listEntry.Selected;

    listEntry := UpdateCalendarList(listEntry, '');
    CheckEquals(id, listEntry.Id);
    CheckTrue(listEntry.Summary <> '');
    CheckNotEquals(selected, listEntry.Selected);

    selected := listEntry.Selected;
    FreeAndNil(listEntry);
    listEntry := TCalendarListEntry.Create();
    listEntry.Id := id;
    listEntry.Selected := not selected;
    listEntry.ColorId := '1';

    listEntry := PatchCalendarList(listEntry, '');
    CheckEquals(id, listEntry.Id);
    CheckTrue(listEntry.Summary <> '');
    CheckNotEquals(selected, listEntry.Selected);

    FreeAndNil(listEntry);
    listEntry := TCalendarListEntry.Create();
    listEntry.Id := id;
    listEntry.ColorId := '2';

    listEntry := InsertCalendarList(listEntry, '');
    CheckEquals(id, listEntry.Id);
    CheckTrue(listEntry.Summary <> '');
    CheckEquals('2', listEntry.ColorId);

    Check(DeleteCalendarList(id));
    Check(DeleteCalendar(id));
  finally
    calendar.Free();
    listEntry.Free();
    list.Free();
  end;
end;

function TCalendarServiceTests.UpdateCalendar(
  var ACalendar: TCalendar; const AFields: string): TCalendar;
var
  updReq: TCalendarsUpdateRequest;
begin
  updReq := GetService().Calendars.Update(ACalendar);
  try
    ACalendar := nil;

    updReq.Fields := AFields;

    Result := updReq.Execute();
  finally
    updReq.Free();
  end;
end;

function TCalendarServiceTests.UpdateCalendarList(var ACalendarListEntry: TCalendarListEntry;
  const AFields: string): TCalendarListEntry;
var
  request: TCalendarListUpdateRequest;
begin
  request := GetService().CalendarList.Update(ACalendarListEntry);
  try
    ACalendarListEntry := nil;

    request.Fields := AFields;

    Result := request.Execute();
  finally
    request.Free();
  end;
end;

initialization
  TestFramework.RegisterTest(TCalendarJsonSerializerTests.Suite);
  TestFramework.RegisterTest(TCalendarServiceTests.Suite);

end.
