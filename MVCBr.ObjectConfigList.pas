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

{
  Objetivo: é um gerenciador de componentes de configura a serem persistindo
  localmente pro INI ou JSON
  Alterações:
  02/04/2017 - por: amarildo lacerda
  + Adicionado suporte a JsonFile para a gravação dos dados
  + Adicionado interface para IniFile e JSONFile
}

unit MVCBr.ObjectConfigList;

interface

uses System.Classes, System.SysUtils, System.RTTI,
  System.JsonFiles, System.IniFiles,
{$IFDEF LINUX} {$ELSE}VCL.StdCtrls, VCL.Controls, {$ENDIF} MVCBr.Model,
  System.Generics.Collections;

type

{$IFDEF LINUX}
  TButton = TComponent;
  TGroupBox = TComponent;

  TComboBox = class(TComponent)
  public
    text: string;
  end;

  TLabel = class(TComponent)
  public
    Caption: string;
  end;

  TCheckBox = class(TComponent)
  public
    checked: boolean;
  end;

  TEdit = class(TComponent)
  public
    text: string;
  end;
{$ENDIF}

  TObjectConfigContentType = (ctIniFile, ctJsonFile);
  IObjectConfigListItem = interface;

  IObjectConfigList = interface
    ['{302562A0-2A11-43F6-A249-4BD42E1133F2}']
    function This: TObject;
    procedure ReadConfig;
    procedure WriteConfig;
    procedure RegisterControl(ASection: string; AText: string; AControl:
{$IFDEF LINUX} TComponent {$ELSE} TControl{$ENDIF}); overload;
    procedure Add(AControl: {$IFDEF LINUX} TComponent
{$ELSE} TControl{$ENDIF}); overload;
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

  IConfigFile = interface
    ['{136C5B69-9402-4B25-A772-A6425DBF16DD}']
    function ReadString(const Section, Ident, Default: string): string;
    procedure WriteString(const Section, Ident, Value: String);
    procedure WriteDateTime(const Section, Ident: string; Value: TDateTime);
    procedure WriteBool(const Section, Ident: string; Value: boolean);
    procedure WriteInteger(const Section, Ident: string; Value: integer);
    function ReadInteger(const Section, Ident: string;
      Default: integer): integer;
    function ReadBool(const Section, Ident: string; Default: boolean): boolean;
    function ReadDatetime(const Section, Ident: string; Default: TDateTime)
      : TDateTime;
    function ConfigFile: TObject;
  end;

  TObjectConfigListItem = class(TInterfacedObject, IObjectConfigListItem)
  private
    FControl: {$IFDEF LINUX} TComponent {$ELSE} TControl{$ENDIF};
    FSection: string;
    FItem: string;
    procedure SetSection(const Value: string);
    procedure SetItem(const Value: string);
    procedure SetValue(const Value: TValue);
    function GetValue: TValue;
    function GetItem: string;
    function GetSection: string;
  public
    class function new(ASection, AItem: string; AControl:
{$IFDEF LINUX} TComponent
{$ELSE} TControl{$ENDIF}): IObjectConfigListItem;
    property Section: string read GetSection write SetSection;
    property Item: string read GetItem write SetItem;
    property Value: TValue read GetValue write SetValue;
    function This: TObjectConfigListItem;
  end;

  TConfigIniFile = class(TInterfacedObject, IConfigFile)
  private
    FIniFile: TIniFile;
  public
    constructor create(AFileName: string);
    destructor destroy; override;
    function ReadString(const Section, Ident, Default: string): string;
    procedure WriteString(const Section, Ident, Value: String);
    procedure WriteDateTime(const Section, Ident: string; Value: TDateTime);
    procedure WriteBool(const Section, Ident: string; Value: boolean);
    procedure WriteInteger(const Section, Ident: string; Value: integer);
    function ReadInteger(const Section, Ident: string;
      Default: integer): integer;
    function ReadBool(const Section, Ident: string; Default: boolean): boolean;
    function ReadDatetime(const Section, Ident: string; Default: TDateTime)
      : TDateTime;
    function ConfigFile: TObject;
  end;

  TConfigJsonFile = class(TInterfacedObject, IConfigFile)
  private
    FJsonFile: TJsonFile;
  public
    constructor create(AFileName: string);
    destructor destroy; override;
    function ReadString(const Section, Ident, Default: string): string;
    procedure WriteString(const Section, Ident, Value: String);
    procedure WriteDateTime(const Section, Ident: string; Value: TDateTime);
    procedure WriteBool(const Section, Ident: string; Value: boolean);
    procedure WriteInteger(const Section, Ident: string; Value: integer);
    function ReadInteger(const Section, Ident: string;
      Default: integer): integer;
    function ReadBool(const Section, Ident: string; Default: boolean): boolean;
    function ReadDatetime(const Section, Ident: string; Default: TDateTime)
      : TDateTime;
    function ConfigFile: TObject;
  end;

  TObjectConfigModel = class(TModelFactory, IObjectConfigList)
  private
    FList: TInterfaceList;
    FFileName: string;
    FProcRead: TProc<IObjectConfigListItem>;
    FProcWrite: TProc<IObjectConfigListItem>;
    FContentFile: IConfigFile;
    FContentType: TObjectConfigContentType;
    FComponentFullPath: boolean;
    function GetItems(idx: integer): IObjectConfigListItem;
    procedure SetItems(idx: integer; const Value: IObjectConfigListItem);
    Function GetContentFile: IConfigFile;
    procedure SetFileName(const Value: string);
    function GetFileName: string;
    procedure SetContentType(const Value: TObjectConfigContentType);
    procedure SetComponentFullPath(const Value: boolean);
  public
    constructor create;
    destructor destroy; override;
    function This: TObject;
    class function new: IObjectConfigList;
    property ContentType: TObjectConfigContentType read FContentType
      write SetContentType;
    procedure ReadConfig; virtual;
    procedure WriteConfig; virtual;
    function Count: integer;
    property Items[idx: integer]: IObjectConfigListItem read GetItems
      write SetItems;
    procedure RegisterControl(ASection: string; AText: string; AControl:
{$IFDEF LINUX} TComponent {$ELSE} TControl{$ENDIF}); overload; virtual;
    procedure Add(AControl: {$IFDEF LINUX} TComponent
{$ELSE} TControl{$ENDIF}); overload; virtual;
    property FileName: string read GetFileName write SetFileName;
    procedure WriteItem(ASection, AItem: string; AValue: TValue); virtual;
    procedure ReadItem(ASection, AItem: string; out AValue: TValue); virtual;
    property ComponentFullPath: boolean read FComponentFullPath
      write SetComponentFullPath;
  end;

implementation

type
  TValueHelper = record helper for TValue
    function isBoolean: boolean;
    function isDatetime: boolean;
  end;

  { TObjectConfig }

function TObjectConfigModel.Count: integer;
begin
  result := FList.Count;
end;

constructor TObjectConfigModel.create;
begin
  FComponentFullPath := false;
  FContentType := ctJsonFile;
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
  inherited;
end;

function TObjectConfigModel.GetFileName: string;
begin
  result := FFileName;
end;

Function TObjectConfigModel.GetContentFile: IConfigFile;
begin
  if not assigned(FContentFile) then
    case ContentType of
      ctIniFile:
        FContentFile := TConfigIniFile.create(FFileName);
      ctJsonFile:
        FContentFile := TConfigJsonFile.create(FFileName);
    end;
  result := FContentFile;
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
  if FContentType = ctJsonFile then
    TJsonFile(GetContentFile.ConfigFile).LoadValues;
  if assigned(FProcRead) then
    for i := 0 to FList.Count - 1 do
      FProcRead(FList.Items[i] as IObjectConfigListItem);
end;

procedure TObjectConfigModel.ReadItem(ASection, AItem: string;
  out AValue: TValue);
begin
  with GetContentFile do
    if AValue.isBoolean then
      AValue := ReadBool(ASection, AItem, AValue.AsBoolean)
    else if AValue.isDatetime then
      AValue := ReadDatetime(ASection, AItem, AValue.AsExtended)
    else
      AValue := ReadString(ASection, AItem, AValue.AsString);
end;

procedure TObjectConfigModel.Add(AControl: {$IFDEF LINUX} TComponent
{$ELSE} TControl{$ENDIF});
var
  LItem: string;
begin
  if FComponentFullPath then
    LItem := AControl.className + '.' + AControl.name
  else
    LItem := AControl.name;
  RegisterControl('Config', LItem, AControl);
end;

procedure TObjectConfigModel.RegisterControl(ASection: string; AText: string;
  AControl: {$IFDEF LINUX} TComponent
{$ELSE} TControl{$ENDIF});
var
  obj: TObjectConfigListItem;
begin
  obj := TObjectConfigListItem.create;
  obj.Section := ASection;
  obj.Item := AText;
  obj.FControl := AControl;
  FList.Add(obj);
end;

procedure TObjectConfigModel.SetComponentFullPath(const Value: boolean);
begin
  FComponentFullPath := Value;
end;

procedure TObjectConfigModel.SetContentType(const Value
  : TObjectConfigContentType);
begin
  FContentFile := nil;
  FContentType := Value;
end;

procedure TObjectConfigModel.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TObjectConfigModel.SetItems(idx: integer;
  const Value: IObjectConfigListItem);
begin
  FList.Items[idx] := Value;
end;

function TObjectConfigModel.This: TObject;
begin
  result := self;
end;

procedure TObjectConfigModel.WriteConfig;
var
  i: integer;
begin
  if assigned(FProcRead) then
    for i := 0 to FList.Count - 1 do
      FProcWrite(FList.Items[i] as IObjectConfigListItem);
  if ContentType = ctJsonFile then
    with TJsonFile(GetContentFile.ConfigFile) do
    begin
      FileName := self.FFileName;
      UpdateFile;
    end;
end;

procedure TObjectConfigModel.WriteItem(ASection, AItem: string; AValue: TValue);
begin
  with GetContentFile do
    if AValue.isBoolean then
      WriteBool(ASection, AItem, AValue.AsBoolean)
    else if AValue.isDatetime then
      WriteDateTime(ASection, AItem, AValue.AsExtended)
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
  result := nil;
  if not assigned(FControl) then
    exit;

  if FControl.InheritsFrom(TEdit) then
    result := TEdit(FControl).text
  else if FControl.InheritsFrom(TCheckBox) then
    result := TCheckBox(FControl).checked
  else if FControl.InheritsFrom(TComboBox) then
    result := TComboBox(FControl).text;
end;

class function TObjectConfigListItem.new(ASection, AItem: string; AControl:
{$IFDEF LINUX} TComponent
{$ELSE} TControl{$ENDIF}): IObjectConfigListItem;
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
    TEdit(FControl).text := Value.AsString
  else if FControl.InheritsFrom(TCheckBox) then
    TCheckBox(FControl).checked := Value.AsBoolean
  else if FControl.InheritsFrom(TComboBox) then
    TComboBox(FControl).text := Value.AsString;
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
  result := TypeInfo = System.TypeInfo(TDateTime);
end;

{ TConfigIniFile }

constructor TConfigIniFile.create(AFileName: string);
begin
  inherited create;
  FIniFile := TIniFile.create(AFileName);
end;

destructor TConfigIniFile.destroy;
begin
  FIniFile.free;
  inherited;
end;

function TConfigIniFile.ReadBool(const Section, Ident: string;
  Default: boolean): boolean;
begin
  result := FIniFile.ReadBool(Section, Ident, Default);
end;

function TConfigIniFile.ReadDatetime(const Section, Ident: string;
  Default: TDateTime): TDateTime;
begin
  result := FIniFile.ReadDatetime(Section, Ident, Default);
end;

function TConfigIniFile.ReadInteger(const Section, Ident: string;
  Default: integer): integer;
begin
  result := FIniFile.ReadInteger(Section, Ident, Default);
end;

function TConfigIniFile.ReadString(const Section, Ident,
  Default: string): string;
begin
  result := FIniFile.ReadString(Section, Ident, Default);
end;

function TConfigIniFile.ConfigFile: TObject;
begin
  result := FIniFile;
end;

procedure TConfigIniFile.WriteBool(const Section, Ident: string;
  Value: boolean);
begin
  FIniFile.WriteBool(Section, Ident, Value);
end;

procedure TConfigIniFile.WriteDateTime(const Section, Ident: string;
  Value: TDateTime);
begin
  FIniFile.WriteDateTime(Section, Ident, Value);
end;

procedure TConfigIniFile.WriteInteger(const Section, Ident: string;
  Value: integer);
begin
  FIniFile.WriteInteger(Section, Ident, Value);
end;

procedure TConfigIniFile.WriteString(const Section, Ident, Value: String);
begin
  FIniFile.WriteString(Section, Ident, Value);
end;

{ TConfigJsonFile }

constructor TConfigJsonFile.create(AFileName: string);
begin
  inherited create;
  FJsonFile := TJsonFile.create(AFileName);
end;

destructor TConfigJsonFile.destroy;
begin
  FJsonFile.free;
  inherited;
end;

function TConfigJsonFile.ReadBool(const Section, Ident: string;
  Default: boolean): boolean;
begin
  result := FJsonFile.ReadBool(Section, Ident, Default);
end;

function TConfigJsonFile.ReadDatetime(const Section, Ident: string;
  Default: TDateTime): TDateTime;
begin
  result := FJsonFile.ReadDatetime(Section, Ident, Default);
end;

function TConfigJsonFile.ReadInteger(const Section, Ident: string;
  Default: integer): integer;
begin
  result := FJsonFile.ReadInteger(Section, Ident, Default);
end;

function TConfigJsonFile.ReadString(const Section, Ident,
  Default: string): string;
begin
  result := FJsonFile.ReadString(Section, Ident, Default);
end;

function TConfigJsonFile.ConfigFile: TObject;
begin
  result := FJsonFile;
end;

procedure TConfigJsonFile.WriteBool(const Section, Ident: string;
  Value: boolean);
begin
  FJsonFile.WriteBool(Section, Ident, Value);
end;

procedure TConfigJsonFile.WriteDateTime(const Section, Ident: string;
  Value: TDateTime);
begin
  FJsonFile.WriteDateTime(Section, Ident, Value);
end;

procedure TConfigJsonFile.WriteInteger(const Section, Ident: string;
  Value: integer);
begin
  FJsonFile.WriteInteger(Section, Ident, Value);
end;

procedure TConfigJsonFile.WriteString(const Section, Ident, Value: String);
begin
  FJsonFile.WriteString(Section, Ident, Value);
end;

end.
