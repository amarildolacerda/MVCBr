{ *************************************************************************** }
{ }
{ }
{ Copyright (C) Amarildo Lacerda }
{ }
{ https://github.com/amarildolacerda }
{ }
{ }
{ *************************************************************************** }
{ }
{ Licensed under the Apache License, Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. }
{ You may obtain a copy of the License at }
{ }
{ http://www.apache.org/licenses/LICENSE-2.0 }
{ }
{ Unless required by applicable law or agreed to in writing, software }
{ distributed under the License is distributed on an "AS IS" BASIS, }
{ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{ See the License for the specific language governing permissions and }
{ limitations under the License. }
{ }
{ *************************************************************************** }
unit MVCBr.ObjectConfigList;

interface

uses System.Classes, System.SysUtils, System.RTTI,
  VCL.StdCtrls, System.IniFiles, MVCBr.Model,
  VCL.Controls, System.Generics.Collections;

type
  IObjectConfigListItem = interface;

  IObjectConfigList = interface
    ['{302562A0-2A11-43F6-A249-4BD42E1133F2}']
    procedure ReadConfig;
    procedure WriteConfig;
    procedure RegisterControl(ASection: string; AText: string;
      AControl: TControl); overload;
    procedure Add(AControl: TControl); overload;
    procedure SetFileName(const Value: string);
    function GetFileName: string;
    property FileName: string read GetFileName write SetFileName;
    function Count: integer;
    function GetItems(idx: integer): IObjectConfigListItem;
    procedure SetItems(idx: integer; const Value: IObjectConfigListItem);
    property Items[idx: integer]: IObjectConfigListItem read GetItems
      write SetItems;
  end;

  TObjectConfigListItem = class;

  IObjectConfigListItem = interface
    ['{AD786625-5C1A-4486-B000-2F61BB0C0A27}']
    function This: TObjectConfigListItem;
    procedure SetSection(const Value: string);
    procedure SetItem(const Value: string);
    procedure SetValue(const Value: TValue);
    function GetValue: TValue;
    function GetItem: string;
    function GetSection: string;
    property Section: string read GetSection write SetSection;
    property Item: string read GetItem write SetItem;
    property Value: TValue read GetValue write SetValue;
  end;

  TObjectConfigListItem = class(TInterfacedObject, IObjectConfigListItem)
  private
    FControl: TControl;
    FSection: string;
    FItem: string;
    procedure SetSection(const Value: string);
    procedure SetItem(const Value: string);
    procedure SetValue(const Value: TValue);
    function GetValue: TValue;
    function GetItem: string;
    function GetSection: string;
  public
    class function new(ASection, AItem: string; AControl: TControl)
      : IObjectConfigListItem;
    property Section: string read GetSection write SetSection;
    property Item: string read GetItem write SetItem;
    property Value: TValue read GetValue write SetValue;
    function This: TObjectConfigListItem;
  end;

  TObjectConfigModel = class(TModelFactory, IObjectConfigList)
  private
    FList: TInterfaceList;
    FFileName: string;
    FProcRead: TProc<IObjectConfigListItem>;
    FProcWrite: TProc<IObjectConfigListItem>;
    FIniFile: TIniFile;
    function GetItems(idx: integer): IObjectConfigListItem;
    procedure SetItems(idx: integer; const Value: IObjectConfigListItem);
    Function GetIniFile: TIniFile;
    procedure SetFileName(const Value: string);
    function GetFileName: string;
  public
    constructor create;
    destructor destroy; override;
    class function new: IObjectConfigList;
    procedure ReadConfig; virtual;
    procedure WriteConfig; virtual;
    function Count: integer;
    property Items[idx: integer]: IObjectConfigListItem read GetItems
      write SetItems;
    procedure RegisterControl(ASection: string; AText: string;
      AControl: TControl); overload; virtual;
    procedure Add(AControl: TControl); overload; virtual;
    property FileName: string read GetFileName write SetFileName;
    procedure WriteItem(ASection, AItem: string; AValue: TValue); virtual;
    procedure ReadItem(ASection, AItem: string; out AValue: TValue); virtual;
  end;

implementation

type
  TValueHelper = record helper for TValue
    function isBoolean: boolean;
    function isDatetime:boolean;
  end;

  { TObjectConfig }

function TObjectConfigModel.Count: integer;
begin
  result := FList.Count;
end;

constructor TObjectConfigModel.create;
begin
  FList := TInterfaceList.create;
  FFileName := paramStr(0) + '.config';

  FProcRead := procedure(sender: IObjectConfigListItem)
    var
      FOut: TValue;
    begin
      FOut := sender.Value;
      ReadItem(sender.Section, sender.Item, FOut);
      sender.Value := FOut;
    end;

  FProcWrite := procedure(sender: IObjectConfigListItem)
    begin
      WriteItem(sender.Section, sender.Item, sender.Value);
    end;

end;

destructor TObjectConfigModel.destroy;
begin
  FList.DisposeOf;
  if assigned(FIniFile) then
    FIniFile.DisposeOf;
  inherited;
end;

function TObjectConfigModel.GetFileName: string;
begin
  result := FFileName;
end;

function TObjectConfigModel.GetIniFile: TIniFile;
begin
  if not assigned(FIniFile) then
    FIniFile := TIniFile.create(FFileName);
  result := FIniFile;
end;

function TObjectConfigModel.GetItems(idx: integer): IObjectConfigListItem;
begin
  result := FList.Items[idx] as IObjectConfigListItem;
end;

class function TObjectConfigModel.new: IObjectConfigList;
begin
  result := TObjectConfigModel.create;
end;

procedure TObjectConfigModel.ReadConfig;
var
  i: integer;
begin
  if assigned(FProcRead) then
    for i := 0 to FList.Count - 1 do
      FProcRead(FList.Items[i] as IObjectConfigListItem);
end;

procedure TObjectConfigModel.ReadItem(ASection, AItem: string; out AValue: TValue);
begin
  with GetIniFile do
    if AValue.isBoolean then
      AValue := readbool(ASection, AItem, AValue.AsBoolean)
    else if AValue.isDatetime then
      AValue := readDateTime(ASection,AItem,AValue.AsExtended)    
    else
      AValue := readString(ASection, AItem, AValue.AsString);
end;

procedure TObjectConfigModel.Add(AControl: TControl);
var
  LItem: string;
begin
  LItem := AControl.className + '.' + AControl.name;
  RegisterControl('Config', LItem, AControl);
end;

procedure TObjectConfigModel.RegisterControl(ASection: string; AText: string;
  AControl: TControl);
var
  obj: TObjectConfigListItem;
begin
  obj := TObjectConfigListItem.create;
  obj.Section := ASection;
  obj.Item := AText;
  obj.FControl := AControl;
  FList.add(obj);
end;

procedure TObjectConfigModel.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TObjectConfigModel.SetItems(idx: integer; const Value: IObjectConfigListItem);
begin
  FList.Items[idx] := Value;
end;

procedure TObjectConfigModel.WriteConfig;
var
  i: integer;
begin
  if assigned(FProcRead) then
    for i := 0 to FList.Count - 1 do
      FProcWrite(FList.Items[i] as IObjectConfigListItem);
end;

procedure TObjectConfigModel.WriteItem(ASection, AItem: string; AValue: TValue);
begin
  with GetIniFile do
    if AValue.isBoolean then
      WriteBool(ASection, AItem, AValue.AsBoolean)
    else if AValue.isDatetime then
      WriteDateTime(ASection,AItem, AValue.AsExtended)
    else
      WriteString(ASection, AItem, AValue.AsString);
end;

{ TObjectConfigItem }

function TObjectConfigListItem.GetItem: string;
begin
  result := FItem;
end;

function TObjectConfigListItem.GetSection: string;
begin
  result := FSection;
end;

function TObjectConfigListItem.GetValue: TValue;
begin
  if FControl.InheritsFrom(TEdit) then
    result := TEdit(FControl).text
  else if FControl.InheritsFrom(TCheckBox) then
    result := TCheckBox(FControl).Checked
  else if FControl.InheritsFrom(TComboBox) then
    result := TComboBox(FControl).text;

end;

class function TObjectConfigListItem.new(ASection, AItem: string;
  AControl: TControl): IObjectConfigListItem;
var
  obj: TObjectConfigListItem;
begin
  obj := TObjectConfigListItem.create;
  obj.FControl := AControl;
  obj.FSection := ASection;
  obj.FItem := AItem;
  result := obj;
end;

procedure TObjectConfigListItem.SetItem(const Value: string);
begin
  FItem := Value;
end;

procedure TObjectConfigListItem.SetSection(const Value: string);
begin
  FSection := Value;
end;

procedure TObjectConfigListItem.SetValue(const Value: TValue);
begin
  if FControl.InheritsFrom(TEdit) then
    TEdit(FControl).text := Value.asString
  else if FControl.InheritsFrom(TCheckBox) then
    TCheckBox(FControl).Checked := Value.AsBoolean
  else if FControl.InheritsFrom(TComboBox) then
    TComboBox(FControl).text := Value.asString;

end;

function TObjectConfigListItem.This: TObjectConfigListItem;
begin
  result := self;
end;



function TValueHelper.isBoolean: boolean;
begin
  result := TypeInfo = System.TypeInfo(boolean);
end;

function TValueHelper.isDatetime: boolean;
begin
   result := TypeInfo = System.TypeInfo(Tdatetime);
end;

end.
