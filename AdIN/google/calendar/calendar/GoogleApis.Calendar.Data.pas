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

unit GoogleApis.Calendar.Data;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, {clJsonSerializerBase,} GoogleApis;

type
  TEventCreator = class
  strict private
    FDisplayName: string;
    FEmail: string;
    FId: string;
    FSelf: Boolean;
  public
    [TclJsonString('displayName')]
    property DisplayName: string read FDisplayName write FDisplayName;

    [TclJsonString('email')]
    property Email: string read FEmail write FEmail;

    [TclJsonString('id')]
    property Id: string read FId write FId;

    [TclJsonProperty('self')]
    property Self: Boolean read FSelf write FSelf;
  end;

  TEventOrganizer = class
  strict private
    FDisplayName: string;
    FEmail: string;
    FId: string;
    FSelf: Boolean;
  public
    [TclJsonString('displayName')]
    property DisplayName: string read FDisplayName write FDisplayName;

    [TclJsonString('email')]
    property Email: string read FEmail write FEmail;

    [TclJsonString('id')]
    property Id: string read FId write FId;

    [TclJsonProperty('self')]
    property Self: Boolean read FSelf write FSelf;
  end;

  TEventDateTime = class
  strict private
    FDate: string;
    FTimeZone: string;
    FDateTimeRaw: string;

    function GetDateTime: TDateTime;
    procedure SetDateTime(const Value: TDateTime);
  public
    [TclJsonString('date')]
    property Date: string read FDate write FDate;

    property DateTime: TDateTime read GetDateTime write SetDateTime;

    [TclJsonString('dateTime')]
    property DateTimeRaw: string read FDateTimeRaw write FDateTimeRaw;

    [TclJsonString('timeZone')]
    property TimeZone: string read FTimeZone write FTimeZone;
  end;

  TEventReminder = class
  strict private
    FMethod: string;
    FMinutes: Integer;
  public
    [TclJsonString('method')]
    property Method: string read FMethod write FMethod;

    [TclJsonProperty('minutes')]
    property Minutes: Integer read FMinutes write FMinutes;
  end;

  TEventReminders = class
  strict private
    FUseDefault: Boolean;
    FOverrides: TArray<TEventReminder>;

    procedure SetOverrides(const Value: TArray<TEventReminder>);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonProperty('useDefault')]
    property UseDefault: Boolean read FUseDefault write FUseDefault;

    [TclJsonProperty('overrides')]
    property Overrides: TArray<TEventReminder> read FOverrides write SetOverrides;
  end;

  TEventAttachment = class
  strict private
    FTitle: string;
    FFileId: string;
    FMimeType: string;
    FFileUrl: string;
    FIconLink: string;
  public
    [TclJsonString('fileId')]
    property FileId: string read FFileId write FFileId;

    [TclJsonString('fileUrl')]
    property FileUrl: string read FFileUrl write FFileUrl;

    [TclJsonString('iconLink')]
    property IconLink: string read FIconLink write FIconLink;

    [TclJsonString('mimeType')]
    property MimeType: string read FMimeType write FMimeType;

    [TclJsonString('title')]
    property Title: string read FTitle write FTitle;
  end;

  TEventAttendee = class
  strict private
    FAdditionalGuests: string;
    FDisplayName: string;
    FEmail: string;
    FComment: string;
    FOrganizer: Boolean;
    FResource: Boolean;
    FId: string;
    FOptional: Boolean;
    FResponseStatus: string;
    FSelf: Boolean;
  public
    [TclJsonProperty('additionalGuests')]
    property AdditionalGuests: string read FAdditionalGuests write FAdditionalGuests;

    [TclJsonString('comment')]
    property Comment: string read FComment write FComment;

    [TclJsonString('displayName')]
    property DisplayName: string read FDisplayName write FDisplayName;

    [TclJsonString('email')]
    property Email: string read FEmail write FEmail;

    [TclJsonString('id')]
    property Id: string read FId write FId;

    [TclJsonProperty('optional')]
    property Optional: Boolean read FOptional write FOptional;

    [TclJsonProperty('organizer')]
    property Organizer: Boolean read FOrganizer write FOrganizer;

    [TclJsonProperty('resource')]
    property Resource: Boolean read FResource write FResource;

    [TclJsonString('responseStatus')]
    property ResponseStatus: string read FResponseStatus write FResponseStatus;

    [TclJsonProperty('self')]
    property Self: Boolean read FSelf write FSelf;
  end;

  TEventSource = class
  strict private
    FTitle: string;
    FUrl: string;
  public
    [TclJsonString('title')]
    property Title: string read FTitle write FTitle;

    [TclJsonString('url')]
    property Url: string read FUrl write FUrl;
  end;

  TEvent = class
  strict private
    FLocation: string;
    FETag: string;
    FHangoutLink: string;
    FEndTimeUnspecified: Boolean;
    FAnyoneCanAddSelf: Boolean;
    FSequence: string;
    FUpdatedRaw: string;
    FICalUID: string;
    FGuestsCanInviteOthers: Boolean;
    FLocked: Boolean;
    FId: string;
    FCreatedRaw: string;
    FRecurringEventId: string;
    FGuestsCanModify: Boolean;
    FStatus: string;
    FKind: string;
    FHtmlLink: string;
    FDescription: string;
    FSummary: string;
    FVisibility: string;
    FAttendeesOmitted: Boolean;
    FPrivateCopy: Boolean;
    FGuestsCanSeeOtherGuests: Boolean;
    FColorId: string;
    FTransparency: string;
    FCreator: TEventCreator;
    FOrganizer: TEventOrganizer;
    FOriginalStartTime: TEventDateTime;
    FEnd_: TEventDateTime;
    FStart: TEventDateTime;
    FReminders: TEventReminders;
    FRecurrence: TArray<string>;
    FAttachments: TArray<TEventAttachment>;
    FAttendees: TArray<TEventAttendee>;
    FSource: TEventSource;

    procedure SetCreator(const Value: TEventCreator);
    procedure SetOrganizer(const Value: TEventOrganizer);
    procedure SetEnd_(const Value: TEventDateTime);
    procedure SetOriginalStartTime(const Value: TEventDateTime);
    procedure SetStart(const Value: TEventDateTime);
    procedure SetReminders(const Value: TEventReminders);
    procedure SetAttachments(const Value: TArray<TEventAttachment>);
    procedure SetAttendees(const Value: TArray<TEventAttendee>);
    procedure SetSource(const Value: TEventSource);
    function GetCreated: TDateTime;
    procedure SetCreated(const Value: TDateTime);
    function GetUpdated: TDateTime;
    procedure SetUpdated(const Value: TDateTime);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonString('kind')]
    property Kind: string read FKind write FKind;

    [TclJsonString('etag')]
    property ETag: string read FETag write FETag;

    [TclJsonString('id')]
    property Id: string read FId write FId;

    [TclJsonString('status')]
    property Status: string read FStatus write FStatus;

    [TclJsonString('htmlLink')]
    property HtmlLink: string read FHtmlLink write FHtmlLink;

    property Created: TDateTime read GetCreated write SetCreated;
    [TclJsonProperty('created')]
    property CreatedRaw: string read FCreatedRaw write FCreatedRaw;

    property Updated: TDateTime read GetUpdated write SetUpdated;
    [TclJsonProperty('updated')]
    property UpdatedRaw: string read FUpdatedRaw write FUpdatedRaw;

    [TclJsonString('summary')]
    property Summary: string read FSummary write FSummary;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    [TclJsonProperty('creator')]
    property Creator: TEventCreator read FCreator write SetCreator;

    [TclJsonProperty('organizer')]
    property Organizer: TEventOrganizer read FOrganizer write SetOrganizer;

    [TclJsonProperty('start')]
    property Start: TEventDateTime read FStart write SetStart;

    [TclJsonProperty('end')]
    property End_: TEventDateTime read FEnd_ write SetEnd_;

    [TclJsonProperty('endTimeUnspecified')]
    property EndTimeUnspecified: Boolean read FEndTimeUnspecified write FEndTimeUnspecified;

    [TclJsonString('iCalUID')]
    property ICalUID: string read FICalUID write FICalUID;

    [TclJsonProperty('sequence')]
    property Sequence: string read FSequence write FSequence;

    [TclJsonProperty('reminders')]
    property Reminders: TEventReminders read FReminders write SetReminders;

    [TclJsonProperty('anyoneCanAddSelf')]
    property AnyoneCanAddSelf: Boolean read FAnyoneCanAddSelf write FAnyoneCanAddSelf;

    [TclJsonProperty('attachments')]
    property Attachments: TArray<TEventAttachment> read FAttachments write SetAttachments;

    [TclJsonProperty('attendees')]
    property Attendees: TArray<TEventAttendee> read FAttendees write SetAttendees;

    [TclJsonProperty('attendeesOmitted')]
    property AttendeesOmitted: Boolean read FAttendeesOmitted write FAttendeesOmitted;

    [TclJsonString('colorId')]
    property ColorId: string read FColorId write FColorId;

    [TclJsonProperty('guestsCanInviteOthers')]
    property GuestsCanInviteOthers: Boolean read FGuestsCanInviteOthers write FGuestsCanInviteOthers;

    [TclJsonProperty('guestsCanModify')]
    property GuestsCanModify: Boolean read FGuestsCanModify write FGuestsCanModify;

    [TclJsonProperty('guestsCanSeeOtherGuests')]
    property GuestsCanSeeOtherGuests: Boolean read FGuestsCanSeeOtherGuests write FGuestsCanSeeOtherGuests;

    [TclJsonString('hangoutLink')]
    property HangoutLink: string read FHangoutLink write FHangoutLink;

    [TclJsonString('location')]
    property Location: string read FLocation write FLocation;

    [TclJsonProperty('locked')]
    property Locked: Boolean read FLocked write FLocked;

    [TclJsonProperty('originalStartTime')]
    property OriginalStartTime: TEventDateTime read FOriginalStartTime write SetOriginalStartTime;

    [TclJsonProperty('privateCopy')]
    property PrivateCopy: Boolean read FPrivateCopy write FPrivateCopy;

    [TclJsonString('recurrence')]
    property Recurrence: TArray<string> read FRecurrence write FRecurrence;

    [TclJsonString('recurringEventId')]
    property RecurringEventId: string read FRecurringEventId write FRecurringEventId;

    [TclJsonProperty('source')]
    property Source: TEventSource read FSource write SetSource;

    [TclJsonString('transparency')]
    property Transparency: string read FTransparency write FTransparency;

    [TclJsonString('visibility')]
    property Visibility: string read FVisibility write FVisibility;

    //TODO property TEventExtendedPropertiesData ExtendedProperties
    //property TEventGadgetData Gadget
  end;

  TEvents = class
  strict private
    FETag: string;
    FUpdatedRaw: string;
    FNextSyncToken: string;
    FAccessRole: string;
    FDefaultReminders: TArray<TEventReminder>;
    FItems: TArray<TEvent>;
    FNextPageToken: string;
    FKind: string;
    FDescription: string;
    FSummary: string;
    FTimeZone: string;

    function GetUpdated: TDateTime;
    procedure SetUpdated(const Value: TDateTime);
    procedure SetDefaultReminders(const Value: TArray<TEventReminder>);
    procedure SetItems(const Value: TArray<TEvent>);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonString('kind')]
    property Kind: string read FKind write FKind;

    [TclJsonString('etag')]
    property ETag: string read FETag write FETag;

    [TclJsonString('summary')]
    property Summary: string read FSummary write FSummary;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    property Updated: TDateTime read GetUpdated write SetUpdated;
    [TclJsonProperty('updated')]
    property UpdatedRaw: string read FUpdatedRaw write FUpdatedRaw;

    [TclJsonString('timeZone')]
    property TimeZone: string read FTimeZone write FTimeZone;

    [TclJsonString('accessRole')]
    property AccessRole: string read FAccessRole write FAccessRole;

    [TclJsonProperty('defaultReminders')]
    property DefaultReminders: TArray<TEventReminder> read FDefaultReminders write SetDefaultReminders;

    [TclJsonString('nextPageToken')]
    property NextPageToken: string read FNextPageToken write FNextPageToken;

    [TclJsonString('nextSyncToken')]
    property NextSyncToken: string read FNextSyncToken write FNextSyncToken;

    [TclJsonProperty('items')]
    property Items: TArray<TEvent> read FItems write SetItems;
  end;

  TCalendarNotification = class
  strict private
    FMethod: string;
    FType_: string;
  public
    [TclJsonString('method')]
    property Method: string read FMethod write FMethod;

    [TclJsonString('type')]
    property Type_: string read FType_ write FType_;
  end;

  TCalendarNotificationSettings = class
  strict private
    FNotifications: TArray<TCalendarNotification>;

    procedure SetNotifications(const Value: TArray<TCalendarNotification>);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonProperty('notifications')]
    property Notifications: TArray<TCalendarNotification> read FNotifications write SetNotifications;
  end;

  TCalendarListEntry = class
  strict private
    FLocation: string;
    FETag: string;
    FDeleted: Boolean;
    FAccessRole: string;
    FPrimary: Boolean;
    FSummaryOverride: string;
    FHidden: Boolean;
    FId: string;
    FKind: string;
    FDescription: string;
    FSummary: string;
    FForegroundColor: string;
    FTimeZone: string;
    FSelected: Boolean;
    FBackgroundColor: string;
    FColorId: string;
    FDefaultReminders: TArray<TEventReminder>;
    FNotificationSettings: TCalendarNotificationSettings;

    procedure SetDefaultReminders(const Value: TArray<TEventReminder>);
    procedure SetNotificationSettings(const Value: TCalendarNotificationSettings);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonString('kind')]
    property Kind: string read FKind write FKind;

    [TclJsonString('etag')]
    property ETag: string read FETag write FETag;

    [TclJsonString('id')]
    property Id: string read FId write FId;

    [TclJsonString('summary')]
    property Summary: string read FSummary write FSummary;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    [TclJsonString('timeZone')]
    property TimeZone: string read FTimeZone write FTimeZone;

    [TclJsonString('colorId')]
    property ColorId: string read FColorId write FColorId;

    [TclJsonString('backgroundColor')]
    property BackgroundColor: string read FBackgroundColor write FBackgroundColor;

    [TclJsonString('foregroundColor')]
    property ForegroundColor: string read FForegroundColor write FForegroundColor;

    [TclJsonProperty('selected')]
    property Selected: Boolean read FSelected write FSelected;

    [TclJsonString('accessRole')]
    property AccessRole: string read FAccessRole write FAccessRole;

    [TclJsonProperty('primary')]
    property Primary: Boolean read FPrimary write FPrimary;

    [TclJsonProperty('deleted')]
    property Deleted: Boolean read FDeleted write FDeleted;

    [TclJsonProperty('hidden')]
    property Hidden: Boolean read FHidden write FHidden;

    [TclJsonString('location')]
    property Location: string read FLocation write FLocation;

    [TclJsonString('summaryOverride')]
    property SummaryOverride: string read FSummaryOverride write FSummaryOverride;

    [TclJsonProperty('defaultReminders')]
    property DefaultReminders: TArray<TEventReminder> read FDefaultReminders write SetDefaultReminders;

    [TclJsonProperty('notificationSettings')]
    property NotificationSettings: TCalendarNotificationSettings read FNotificationSettings write SetNotificationSettings;
  end;

  TCalendarList = class
  strict private
    FETag: string;
    FKind: string;
    FNextPageToken: string;
    FNextSyncToken: string;
    FItems: TArray<TCalendarListEntry>;

    procedure SetItems(const Value: TArray<TCalendarListEntry>);
  public
    constructor Create;
    destructor Destroy; override;

    [TclJsonString('kind')]
    property Kind: string read FKind write FKind;

    [TclJsonString('etag')]
    property ETag: string read FETag write FETag;

    [TclJsonString('nextPageToken')]
    property NextPageToken: string read FNextPageToken write FNextPageToken;

    [TclJsonString('nextSyncToken')]
    property NextSyncToken: string read FNextSyncToken write FNextSyncToken;

    [TclJsonProperty('items')]
    property Items: TArray<TCalendarListEntry> read FItems write SetItems;
  end;

  TCalendar = class
  strict private
    FLocation: string;
    FETag: string;
    FId: string;
    FKind: string;
    FDescription: string;
    FSummary: string;
    FTimeZone: string;
  public
    [TclJsonString('kind')]
    property Kind: string read FKind write FKind;

    [TclJsonString('etag')]
    property ETag: string read FETag write FETag;

    [TclJsonString('id')]
    property Id: string read FId write FId;

    [TclJsonString('location')]
    property Location: string read FLocation write FLocation;

    [TclJsonString('summary')]
    property Summary: string read FSummary write FSummary;

    [TclJsonString('description')]
    property Description: string read FDescription write FDescription;

    [TclJsonString('timeZone')]
    property TimeZone: string read FTimeZone write FTimeZone;
  end;

implementation

{ TCalendarList }

constructor TCalendarList.Create;
begin
  inherited Create();
  FItems := nil;
end;

destructor TCalendarList.Destroy;
begin
  SetItems(nil);
  inherited Destroy();
end;

procedure TCalendarList.SetItems(const Value: TArray<TCalendarListEntry>);
var
  obj: TObject;
begin
  if (FItems <> nil) then
  begin
    for obj in FItems do
    begin
      obj.Free();
    end;
  end;

  FItems := Value;
end;

{ TEvent }

constructor TEvent.Create;
begin
  inherited Create();

  FCreator := nil;
  FOrganizer := nil;
  FEnd_ := nil;
  FStart := nil;
  FOriginalStartTime := nil;
  FReminders := nil;
  FSource := nil;
  FAttachments := nil;
  FAttendees := nil;
end;

destructor TEvent.Destroy;
begin
  SetAttendees(nil);
  SetAttachments(nil);

  FSource.Free();
  FReminders.Free();
  FOriginalStartTime.Free();
  FEnd_.Free();
  FStart.Free();
  FOrganizer.Free();
  FCreator.Free();

  inherited Destroy();
end;

function TEvent.GetCreated: TDateTime;
begin
  Result := TUtils.Rfc3339ToDateTime(CreatedRaw);
end;

function TEvent.GetUpdated: TDateTime;
begin
  Result := TUtils.Rfc3339ToDateTime(UpdatedRaw);
end;

procedure TEvent.SetAttachments(const Value: TArray<TEventAttachment>);
var
  obj: TObject;
begin
  if (FAttachments <> nil) then
  begin
    for obj in FAttachments do
    begin
      obj.Free();
    end;
  end;

  FAttachments := Value;
end;

procedure TEvent.SetAttendees(const Value: TArray<TEventAttendee>);
var
  obj: TObject;
begin
  if (FAttendees <> nil) then
  begin
    for obj in FAttendees do
    begin
      obj.Free();
    end;
  end;

  FAttendees := Value;
end;

procedure TEvent.SetCreated(const Value: TDateTime);
begin
  CreatedRaw := TUtils.DateTimeToRfc3339(Value);
end;

procedure TEvent.SetCreator(const Value: TEventCreator);
begin
  FCreator.Free();
  FCreator := Value;
end;

procedure TEvent.SetEnd_(const Value: TEventDateTime);
begin
  FEnd_.Free();
  FEnd_ := Value;
end;

procedure TEvent.SetOrganizer(const Value: TEventOrganizer);
begin
  FOrganizer.Free();
  FOrganizer := Value;
end;

procedure TEvent.SetOriginalStartTime(const Value: TEventDateTime);
begin
  FOriginalStartTime.Free();
  FOriginalStartTime := Value;
end;

procedure TEvent.SetReminders(const Value: TEventReminders);
begin
  FReminders.Free();
  FReminders := Value;
end;

procedure TEvent.SetSource(const Value: TEventSource);
begin
  FSource.Free();
  FSource := Value;
end;

procedure TEvent.SetStart(const Value: TEventDateTime);
begin
  FStart.Free();
  FStart := Value;
end;

procedure TEvent.SetUpdated(const Value: TDateTime);
begin
  UpdatedRaw := TUtils.DateTimeToRfc3339(Value);
end;

{ TEventReminders }

constructor TEventReminders.Create;
begin
  inherited Create();
  FOverrides := nil;
end;

destructor TEventReminders.Destroy;
begin
  SetOverrides(nil);
  inherited Destroy();
end;

procedure TEventReminders.SetOverrides(const Value: TArray<TEventReminder>);
var
  obj: TObject;
begin
  if (FOverrides <> nil) then
  begin
    for obj in FOverrides do
    begin
      obj.Free();
    end;
  end;

  FOverrides := Value;
end;

{ TEventDateTime }

function TEventDateTime.GetDateTime: TDateTime;
begin
  Result := TUtils.Rfc3339ToDateTime(DateTimeRaw);
end;

procedure TEventDateTime.SetDateTime(const Value: TDateTime);
begin
  DateTimeRaw := TUtils.DateTimeToRfc3339(Value);
end;

{ TCalendarListEntry }

constructor TCalendarListEntry.Create;
begin
  inherited Create();

  FDefaultReminders := nil;
  FNotificationSettings := nil;
end;

destructor TCalendarListEntry.Destroy;
begin
  SetDefaultReminders(nil);

  FNotificationSettings.Free();

  inherited Destroy();
end;

procedure TCalendarListEntry.SetDefaultReminders(const Value: TArray<TEventReminder>);
var
  obj: TObject;
begin
  if (FDefaultReminders <> nil) then
  begin
    for obj in FDefaultReminders do
    begin
      obj.Free();
    end;
  end;

  FDefaultReminders := Value;
end;

procedure TCalendarListEntry.SetNotificationSettings(const Value: TCalendarNotificationSettings);
begin
  FNotificationSettings.Free();
  FNotificationSettings := Value;
end;

{ TCalendarNotificationSettings }

constructor TCalendarNotificationSettings.Create;
begin
  inherited Create();
  FNotifications := nil;
end;

destructor TCalendarNotificationSettings.Destroy;
begin
  SetNotifications(nil);
  inherited Destroy();
end;

procedure TCalendarNotificationSettings.SetNotifications(const Value: TArray<TCalendarNotification>);
var
  obj: TObject;
begin
  if (FNotifications <> nil) then
  begin
    for obj in FNotifications do
    begin
      obj.Free();
    end;
  end;

  FNotifications := Value;
end;

{ TEvents }

constructor TEvents.Create;
begin
  inherited Create();

  FDefaultReminders := nil;
  FItems := nil;
end;

destructor TEvents.Destroy;
begin
  SetItems(nil);
  SetDefaultReminders(nil);

  inherited Destroy();
end;

function TEvents.GetUpdated: TDateTime;
begin
  Result := TUtils.Rfc3339ToDateTime(UpdatedRaw);
end;

procedure TEvents.SetDefaultReminders(const Value: TArray<TEventReminder>);
var
  obj: TObject;
begin
  if (FDefaultReminders <> nil) then
  begin
    for obj in FDefaultReminders do
    begin
      obj.Free();
    end;
  end;

  FDefaultReminders := Value;
end;

procedure TEvents.SetItems(const Value: TArray<TEvent>);
var
  obj: TObject;
begin
  if (FItems <> nil) then
  begin
    for obj in FItems do
    begin
      obj.Free();
    end;
  end;

  FItems := Value;
end;

procedure TEvents.SetUpdated(const Value: TDateTime);
begin
  UpdatedRaw := TUtils.DateTimeToRfc3339(Value);
end;

end.
