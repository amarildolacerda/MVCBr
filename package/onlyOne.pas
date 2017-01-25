{ Name   : onlyOne.pas
  Author : Larry Le
  Version: 1.0
  Description:
  Two components for starting only one copy of application.
}

unit onlyOne;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

const InfoString = 'Program is running£¬you can run one instance only!';
const AskString = 'Program is running£¬run another instance?';

type TinfoType = (otInform, otAsk, otNone);

type
  TOnlyOne = class(TComponent)
  private
    { Private declarations }
    FInfoType: TinfoType;
    FGloable: Boolean;
    FuserInput: Boolean;
    FQuestion: string;
//   FAsk: Boolean;
    MyMutex: HWND;
    MutexCreated: boolean;
    procedure setInfoType(Value: TInfoType);
    procedure setQuestion(Value: string);
  protected
    { Protected declarations }
    procedure Loaded; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;


  published
    { Published declarations }
    property Question: string read FQuestion write setQuestion;
//    property Ask: Boolean read FAsk Write setAsk default false;
    property GloableEffect: Boolean read FGloable write FGloable default false;
    property InfoType: TinfoType read FInfoType write setInfoType default otInform;

  end;


procedure Register;

implementation

//constructor

constructor TOnlyOne.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FuserInput := False;
  FuserInput := false;
  FQuestion := infoString;
end;

//destructor

destructor TOnlyOne.Destroy;
begin
  if MutexCreated then
    CloseHandle(MyMutex);
  inherited Destroy;
end;

//set Fask

procedure TOnlyOne.setInfoType(Value: TInfoType);
begin
  FInfoType := Value;
  if (not FuserInput) then
  begin
    case FInfoType of
      otAsk:
        FQuestion := AskString;
      otInform:
        FQuestion := InfoString;
    end;
  end;

end;

//set Qestion String

procedure TOnlyOne.setQuestion(Value: string);
begin
  FQuestion := Value;
  FuserInput := True;
end;


//Load function
////////////////////////////////////////////////////////////////////////////////

procedure TOnlyOne.Loaded;
var
  MN: string;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;

  MutexCreated := FALSE;
  if GloableEffect then
    MN := 'same'
  else
    MN := ExtractFileName(Application.ExeName);

  MyMutex := 0;
  MyMutex := CreateMutex(nil, FALSE, PChar(MN));

  if (GetLastError = ERROR_ALREADY_EXISTS) or
    (MyMutex = 0) then //
  begin
    case FInfoType of
      otInform:
        begin
          application.MessageBox(pchar(FQuestion), 'Information', MB_OK + MB_ICONINFORMATION);
          Application.Terminate;
          //postMessage(Application.mainForm.handle, WM_CLOSE, 0, 0);
        end;
      otAsk:
        begin
          if application.MessageBox(pchar(FQuestion), 'Confirm', mb_YesNo + MB_ICONQUESTION) = IDNo then
            Application.Terminate;
            //postMessage(Application.mainForm.handle, WM_CLOSE, 0, 0);
        end;
      otNone:
        begin
         // postMessage(Application.mainForm.handle, WM_CLOSE, 0, 0);
          Application.Terminate;
        end;
    end; //end of case
    Exit;
  end;
  MutexCreated := TRUE;
end;


procedure Register;
begin
  RegisterComponents('EzLib', [TOnlyOne]);
end;

end.

