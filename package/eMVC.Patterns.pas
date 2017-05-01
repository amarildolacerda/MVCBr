unit eMVC.Patterns;
{**********************************************************************}
{ Copyright 2005-2006 Reserved by Eazisoft.com                         }
{ File Name: patterns.pas                                              }
{ Author: Larry Le                                                     }
{ Description:                                                         }
{   This unit contains the Easy MVC petterns define                    }
{                                                                      }
{ History:                                                             }
{ 01 Sep, 2006 - version 1.0a3                                         }
{ - Support D7/2005/2006                                               }
{ - TCommand class implements command pattern.                         }
{ - Get rid of 3 interface: ICommand,IEventListener,IMouseListner      }
{                                                                      }
{ 05 June, 2006 - version 1.0a2                                        }
{ - Some bug fixed.                                                    }
{                                                                      }
{ - 1.0, 19 May 2006                                                   }
{   First version                                                      }
{                                                                      }
{ Email: linfengle@gmail.com                                           }
{                                                                      }
{ The contents of this file are subject to the Mozilla Public License  }
{ Version 1.1 (the "License"); you may not use this file except in     }
{ compliance with the License. You may obtain a copy of the License at }
{ http://www.mozilla.org/MPL/                                          }
{                                                                      }
{ Software distributed under the License is distributed on an "AS IS"  }
{ basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See  }
{ the License for the specific language governing rights and           }
{ limitations under the License.                                       }
{                                                                      }
{ The Original Code is written in Delphi.                              }
{                                                                      }
{ The Initial Developer of the Original Code is Larry Le.              }
{ Copyright (C) eazisoft.com. All Rights Reserved.                     }
{                                                                      }
{**********************************************************************}

interface
uses windows, forms, Classes, Controls, Contnrs, sysutils, eMVC.logger;

const
  CMD_SYSTEM_START = 'SYSTEM STARTUP !@$%^&*()_+';
  CMD_SYSTEM_EXIT = 'System exit !@$%^&*()_+';
  CMD_SYSTEM_LOGIN = 'User login !@$%^&*()_+';

type
  TSendDirection =
    (sdGoToHeader,
    //controller received a command with this state,will send it to the Headquaters
  //all command will Create defaultly with sdGoToHeader state
    sdGotoNext);
  //controller received a command with this state,will send it to next controller

type

  IObserver = interface;
  IObservable = interface;
  TController = class;

  //OBserver, the view of MVC
  IObserver = interface
    ['{3E91264F-BBC0-44DF-8272-BD8EA9B5846C}']
    procedure UpdateView(o: TObject);
  end;

  //Defined for can't not use TObservable
  IObservable = interface
    ['{A7C4D942-011B-4141-97A7-5D36C443355F}']
    procedure RegObserver(observer: IObserver);
    procedure Notify(const o: TObject = nil);
  end;

  //Observable, the model of MVC
  TObservable = class(TInterfacedObject, IObservable)
  private
    iObservers: TClassList;
    icurrentObject: TObject;
  public
    constructor Create;
    destructor Destroy; override;
    procedure setCurrentObject(o: TObject);
    procedure RegObserver(observer: IObserver);
    procedure Notify(const o: TObject = nil);
    property CurrentObject: TObject read icurrentObject write icurrentObject;
  end;

  TCommand = class(TInterfacedObject)
  private
    iOwner: TController;
    iFreeParam: boolean;
    iCommandText: string;
    iDirection: TSendDirection;
    iParamRecord: pointer;
    iParamObject: TObject;
    iParamStr: string;
    iState: smallint;
    iCmdList: TList;
    fAutoRelease: boolean;
    function getAutoRelease: boolean;
  public
    constructor Create(ACommand: string = ''; const AParam: Pointer = nil;
      AParamObject: TObject = nil; AParamStr: string = '';
      Owner: TController = nil; ReleaseParam: boolean = true);
    destructor Destroy; override;
    property Owner: TController read iOwner write iOwner;
    function equals(ACmdTxt: string): boolean;
    function getCommandTxt: string;
    function getParamRecord: Pointer;
    function getParamObject: TObject;
    function getParamString: string;
    function getDirection: TSendDirection;
    procedure setDirection(ADirection: TSendDirection);
    property ParamStr: string read iParamStr write iParamStr;
    property ParamObject: TObject read iParamObject write iParamObject;
    property ParamRecord: Pointer read iParamRecord write iParamRecord;
    property AutoRelease: boolean read getAutoRelease write fAutoRelease;
    property State: smallint read iState write iState;
    property CommandText: string read iCommandText write iCommandText;
    procedure Add(cmd: TCommand);
    procedure Remove(cmd: TCommand);
    function getChildCount: integer;
    function getChildAt(i: integer): TCommand;
    procedure Execute(); virtual;
  end;

  TController = class(TInterfacedObject)
  private
    _CID: integer;
    iHeadquarters: TController;
    iNext: TController;
  protected
    function getID: integer;
    procedure setID(CID: integer);
    procedure DoCommand(ACommand: TCommand; const args: TObject = nil);
      overload;
      virtual;
    procedure DoCommand(ACommand: string); overload; virtual;
    procedure DoCommand(ACommand: string; const args: string = ''); overload;
      virtual;
    procedure DoCommand(ACommand: string; const args: TObject = nil); overload;
      virtual;
    procedure DoCommand(ACommand: string; const args: pointer = nil); overload;
      virtual;
  public
    class function NewController: TController; virtual;
    constructor Create;
    destructor Destroy; override;
    function getNext: TController;
    function getHeadquarters: TController;
    procedure SetHeadquarters(AHeadquarters: TController);
    procedure setNext(ANext: TController);
    procedure SendCommand(ACommand: TCommand; const args: TObject = nil);
      overload;
    procedure SendCommand(ACommand: string); overload;
    procedure SendCommand(ACommand: string; args: string); overload;
    procedure SendCommand(ACommand: string; args: TObject); overload;
    procedure SendCommand(ACommand: string; args: pointer); overload;
  end;

  TControlCenter = class(TController)
  private
    iIDCounter: integer;
    iControllerList: TInterfaceList;
    iLastController: TController;
    procedure ClearList;
  public
    procedure DoCommand(ACommand: TCommand; const args: TObject = nil);
      override;
    constructor Create;
    destructor Destroy; override;
    procedure RegController(AController: TController);
    procedure UnRegController(AController: TController);
    procedure run(const cmd: TCommand = nil);
    procedure writeDebug(info: string);
    procedure writeError(info: string);
    procedure turnOnDebugInfo(turnon: boolean);
  end;

var
  ControlCenter: TControlCenter;

implementation

//TCommand -----------------------------------

constructor TCommand.Create(ACommand: string = ''; const AParam: Pointer = nil;
  AParamObject: TObject = nil; AParamStr: string = '';
  Owner: TController = nil; ReleaseParam: boolean = True);
begin
  self.iParamRecord := Aparam;
  self.iParamStr := AParamStr;
  self.iParamObject := aParamObject;
  self.iOwner := Owner;
  self.iCommandText := Acommand;
  self.iFreeParam := releaseParam;
  AutoRelease := true;
  iCmdList := nil
end;

destructor TCommand.Destroy;
var
  i: integer;
begin
  if iFreeParam then
  begin
    try
      if assigned(iparamRecord) then
        freeMem(iparamRecord);
      if Assigned(iparamObject) then
        freeAndNil(iParamObject);
    except
    end;
  end;
  Owner := nil;
  if assigned(iCmdList) then
  begin
    for i := 0 to iCmdList.Count - 1 do
      TCommand(iCmdList[i]).Destroy;
    iCmdList.Clear;
    freeAndNil(iCmdList);
  end;
  inherited;
end;

function TCommand.equals(ACmdTxt: string): boolean;
begin
  result := self.icommandText = ACmdTxt;
end;

function TCommand.getCommandTxt: string;
begin
  result := self.iCommandText
end;

function TCommand.getParamRecord: Pointer;
begin
  result := self.iParamRecord;
end;

function TCommand.getParamObject: TObject;
begin
  result := self.iParamObject;
end;

function TCommand.getParamString: string;
begin
  result := self.iParamStr;
end;

function TCommand.getDirection: TSendDirection;
begin
  result := self.iDirection;
end;

procedure TCommand.setDirection(ADirection: TSendDirection);
begin
  self.iDirection := ADirection;
end;

procedure TCommand.Add(cmd: TCommand);
begin
  if iCmdList = nil then
    iCmdList := TList.Create;
  iCmdList.Add(cmd);
end;

procedure TCommand.Remove(cmd: TCommand);
var
  i: integer;
begin
  for i := 0 to iCmdList.Count - 1 do
    if iCmdList.Items[i] = cmd then
      iCmdList.Delete(i);
end;

function TCommand.getChildCount: integer;
begin
  if assigned(self.iCmdList) then
    result := self.iCmdList.Count
  else
    result := -1;
end;

function TCommand.getAutoRelease: boolean;
begin
  result := self.fAutoRelease;
end;

function TCommand.getChildAt(i: integer): TCommand;
begin
  if assigned(self.iCmdList) and (i >= 0) and (i < self.iCmdList.Count) then
    result := self.iCmdList[i]
  else
    result := nil;

end;

procedure TCommand.Execute();
var
  i: integer;
begin
  if assigned(iCmdList) then
  begin
    for i := 0 to iCmdList.Count - 1 do
      TCommand(iCmdList.Items[i]).Execute();
  end;
end;

//function TCommand.clone: TCommand;
//var
//  i: integer;
//  cmd: TCommand;
//begin
//  cmd := TCommand.Create(self.iCommandText, self.iParamRecord,
//    self.iParamObject,
//    self.ParamStr, self.iOwner, self.iFreeParam);
//
//  //because the cloned object need iParamRecord and iParamObject not be released
//  //but you must make sure the new cloned Tcommand instance will be disposed
//  self.iFreeParam := false;
//
//  if assigned(iCmdList) then
//  begin
//    for i := 0 to self.iCmdList.Count - 1 do
//    begin
//      cmd.add(TCommand(iCmdList.Items[i]).clone);
//    end;
//  end;
//  result := cmd;
//end;

//End of TCommand---------------------------------------------------------------

// TController

constructor TController.Create;
begin
  inherited;
end;

destructor TController.Destroy;
begin
  pointer(self.iHeadquarters) := nil;
  pointer(iNext) := nil;
  inherited;
end;

//all child class should override this function and has its own doCommand

procedure TController.DoCommand(ACommand: TCommand; const args: TObject = nil);
begin
  //do nothing
end;

procedure TController.DoCommand(ACommand: string; const args: string = '');
begin
  //do nothing
end;

procedure TController.DoCommand(ACommand: string; const args: TObject = nil);
begin
  //do nothing
end;

procedure TController.DoCommand(ACommand: string; const args: pointer = nil);
begin
  //do nothing
end;

procedure TController.DoCommand(ACommand: string);
begin
  //do nothing
end;

function TController.getID: integer;
begin
  result := self._CID;
end;

procedure TController.setID(CID: integer);
begin
  self._CID := CID;
end;

class function TController.NewController: TController;
begin
  result := TController.Create;
end;

procedure TController.setNext(ANext: TController);
begin
  self.iNext := ANext;
end;

procedure TController.SetHeadquarters(AHeadquarters: TController);
begin
  iHeadquarters := AHeadquarters;
end;

function TController.getHeadquarters: TController;
begin
  result := iHeadquarters;
end;

procedure TController.SendCommand(ACommand: string; args: string);
begin
  self.SendCommand(TCommand.Create(ACommand, nil, nil, args));
end;

procedure TController.SendCommand(ACommand: string; args: TObject);
begin
  //don't realease the args when this command released
  self.SendCommand(TCommand.Create(ACommand, nil, args, '', nil, false));
end;

procedure TController.SendCommand(ACommand: string; args: pointer);
begin
  //don't release the args when this command released
  self.SendCommand(TCommand.Create(ACommand, args, nil, '', nil, false));
end;

procedure TController.SendCommand(ACommand: string);
begin
  self.SendCommand(TCommand.Create(ACommand));
end;

procedure TController.SendCommand(ACommand: TCommand; const args: TObject =
  nil);
begin
  if not assigned(ACommand) then
    exit;
  //  Debug('ID=' + intToStr(self.getID) + ' CMD=' + ACommand.getCommandTxt);
  if (ACommand.getDirection = sdGoToHeader) then
  begin
    if (not assigned(self.iHeadquarters)) or
      //I am the header
    (self.getID = self.iHeadquarters.getID) then
      ACommand.setDirection(sdGotoNext)
    else
    begin
      self.iHeadquarters.SendCommand(ACommand, args);
      exit;
    end;
  end;

  //call do command of each controller
  self.DoCommand(ACommand, args);
  self.DoCommand(ACommand.getCommandTxt, ACommand.getParamString);
  self.DoCommand(ACommand.getCommandTxt, ACommand.getParamRecord);
  self.DoCommand(ACommand.getCommandTxt, ACommand.getParamObject);

  if assigned(self.iNext) then
    iNext.SendCommand(acommand, args)
  else
  begin
    if ACommand.getAutoRelease then
    begin
      //ACommand := nil; //and interfaced object can release like this
      freeAndNil(ACommand);
      if args <> nil then
      begin
        args.free;
      end;
    end;
  end;
end;

function TController.getNext: TController;
begin
  result := self.iNext;
end;

//TControlCenter ---------------------------------------------------------------

constructor TControlCenter.Create;
begin
  self.iControllerList := TInterfaceList.Create;
  self.iHeadquarters := TController.Create;
  self.iHeadquarters.SetHeadquarters(self.iHeadquarters);
  iLastController := nil;
  TLogger.getInstance.writeDebug('Control Center initialized!');
  iIDCounter := 0;
  self._CID := -1;
  inherited;
end;

procedure TControlCenter.ClearList;
var
  i: integer;
begin
  for i := 0 to iControllerList.Count - 1 do
  begin
    iControllerList.Items[i] := nil //this will release the object!!!
  end;
  iControllerList.Clear;
end;

destructor TControlCenter.Destroy;
begin
  ClearList;
  freeAndNil(iControllerList);
  freeAndNil(self.iHeadquarters);
  inherited;
end;

procedure TControlCenter.doCommand(ACommand: TCommand; const args: TObject =
  nil);
begin
  //  self.SendCommand(command, args);
end;

procedure TControlCenter.run(const cmd: TCommand = nil);
begin
  Application.Initialize;
  if cmd = nil then
    self.SendCommand(TCommand.Create(CMD_SYSTEM_START))
  else
    self.SendCommand(cmd);
  Application.Run;
end;

procedure TControlCenter.UnRegController(AController: TController);
begin
  self.iControllerList.Remove(AController);
end;

procedure TControlCenter.RegController(AController: TController);
begin
  if application.Terminated or (not assigned(AController)) then
    exit;

  iControllerList.Add(AController);

  inc(self.iIDCounter);
  AController.setID(self.iIDCounter);

  //the first one
  if iControllerList.Count = 1 then
  begin
    self.getHeadquarters.setNext(AController);
  end
  else
  begin
    iLastController.setNext(AController);

  end;
  //不能把Control Center 做为 SetHeadquarters，否则在程序释放的时候会出错
  AController.SetHeadquarters(self.iHeadquarters);
  iLastController := AController;
end;

procedure TControlCenter.writeDebug(info: string);
begin
  TLogger.getInstance.writeDebug(info);
end;

procedure TControlCenter.writeError(info: string);
begin
  TLogger.getInstance.writeError(info);
end;

procedure TControlCenter.turnOnDebugInfo(turnon: boolean);
begin
  TLogger.getInstance.debug := turnon
end;

//test use only
//

constructor TObservable.Create;
begin
  inherited;
  iObservers := TClassList.Create;
  icurrentObject := nil;
end;

destructor TObservable.destroy;
begin
  freeAndNil(iObservers);
  inherited;
end;

procedure TObservable.setCurrentObject(o: TObject);
begin
  self.currentObject := o;
end;

procedure TObservable.RegObserver(observer: IObserver);
begin
  if iObservers = nil then
    iObservers := TClassList.Create;
  iObservers.Add(TClass(observer));
end;

procedure TObservable.Notify(const o: TObject = nil);
var
  i: integer;
  observer: IObserver;
begin
  if iObservers = nil then
    exit;
  if o = nil then
    exit;
  self.setCurrentObject(o);

  for i := 0 to iObservers.Count - 1 do
  begin
    observer := IObserver(iObservers.Items[i]);
    observer.UpdateView(o);
  end;
end;

initialization
  begin
    ControlCenter := TControlCenter.Create;
  end;

finalization
  begin
    freeAndNil(ControlCenter);
  end;

end.

