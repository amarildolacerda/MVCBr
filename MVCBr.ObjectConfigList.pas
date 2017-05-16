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
  System.JsonFiles, System.IniFiles, Data.DB,
{$IFDEF LINUX} {$ELSE}VCL.StdCtrls, VCL.Controls, {$ENDIF} MVCBr.Model,
  MVCBr.Component,
  System.Generics.Collections;

{$I translate/MVCBr.Translate.inc}

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

  TObjectConfigContentType = (ctIniFile, ctJsonFile, ctDataset);
  IObjectConfigListItem = interface;

  IObjectConfigListComum = interface
    ['{372B1554-E8BF-493A-AC15-1E7D415B3640}']
    function This: TObject;
    procedure ReadConfig;
    procedure WriteConfig;
    procedure RegisterControl(ASection: string; AText: string; AControl:
{$IFDEF LINUX} TComponent {$ELSE} TControl{$ENDIF}); overload;
    procedure Add(AControl: {$IFDEF LINUX} TComponent
{$ELSE} TControl{$ENDIF}); overload;
    function Count: integer;
    function GetItems(idx: integer): IObjectConfigListItem;
    procedure SetItems(idx: integer; const Value: IObjectConfigListItem);
    property Items[idx: integer]: IObjectConfigListItem read GetItems
      write SetItems;
  end;

  IObjectConfigList = interface(IObjectConfigListComum)
    ['{302562A0-2A11-43F6-A249-4BD42E1133F2}']
    procedure SetFileName(const Value: string);
    function GetFileName: string;
    property FileName: string read GetFileName write SetFileName;
  end;

  IDBObjectConfigList = interface(IObjectConfigListComum)
    ['{7D11135B-D9E7-44FB-BF40-4DB182C85ECD}']
    procedure SetDataset(const Value: TDataset);
    function GetDataset: TDataset;
    property Dataset: TDataset read GetDataset write SetDataset;
    function GetGroupID: string;
    procedure SetGroupID(const Value: string);
    property GroupID: string read GetGroupID write SetGroupID;
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
    destructor Destroy; override;
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
  protected
  public
    constructor create(AFileName: string); overload; virtual;
    destructor Destroy; override;
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

  TObjectConfigModelCustom = class(TComponentFactory)
  private
    FList: TInterfaceList;
    FProcRead: TProc<IObjectConfigListItem>;
    FProcWrite: TProc<IObjectConfigListItem>;
    FComponentFullPath: boolean;
    function GetItems(idx: integer): IObjectConfigListItem;
    procedure SetItems(idx: integer; const Value: IObjectConfigListItem);
    Function GetContentFile: IConfigFile; virtual;
    procedure SetComponentFullPath(const Value: boolean);
    function GetComponentFullPath:boolean;
  protected
    procedure ReadConfig; virtual; abstract;
    procedure WriteConfig; virtual; abstract;
    procedure WriteItem(ASection, AItem: string; AValue: TValue); virtual;
    procedure ReadItem(ASection, AItem: string; out AValue: TValue); virtual;

  public
    constructor Create(AOwner: TComponent); overload; override;
    destructor Destroy; override;
    function This: TObject;override;
    function Count: integer;
    property Items[idx: integer]: IObjectConfigListItem read GetItems
      write SetItems;
    procedure RegisterControl(ASection: string; AText: string; AControl:
{$IFDEF LINUX} TComponent {$ELSE} TControl{$ENDIF}); overload; virtual;
    procedure Add(AControl: {$IFDEF LINUX} TComponent
{$ELSE} TControl{$ENDIF}); overload; virtual;
    property ComponentFullPath: boolean read GetComponentFullPath
      write SetComponentFullPath;

  end;

  TObjectConfigModel = Class(TObjectConfigModelCustom, IObjectConfigList)
  private
    FFileName: string;
    FContentFile: IConfigFile;
    FContentType: TObjectConfigContentType;
  protected
    procedure SetFileName(const Value: string);
    function GetFileName: string;
    Function GetContentFile: IConfigFile; override;
    procedure SetContentType(const Value: TObjectConfigContentType);
  public
    constructor Create(AOwner: TComponent); override;
    class function new: IObjectConfigList; static;
    property FileName: string read GetFileName write SetFileName;
    property ContentType: TObjectConfigContentType read FContentType
      write SetContentType;
    procedure WriteConfig; override;
    procedure ReadConfig; override;
    procedure WriteItem(ASection, AItem: string; AValue: TValue); override;
    procedure ReadItem(ASection, AItem: string; out AValue: TValue); override;
    function ToString: String; override;
  end;

  TDBConfigColumnNames = record
    ColumnIdent: string;
    ColumnSection: string;
    ColumnItem: string;
    ColumnValue: string;
  end;

  TDBObjectConfigModel = class(TObjectConfigModelCustom, IObjectConfigListComum,
    IDBObjectConfigList)
  private
    FGroupID: string;
    FDataset: TDataset;
    FColumnNames: TDBConfigColumnNames;
    procedure SetDataset(const Value: TDataset);
    function GetDataset: TDataset;
    function GetGroupID: string;
    procedure SetGroupID(const Value: string);
    procedure SetColumnNames(const Value: TDBConfigColumnNames);
    function FilterBuilder(ASection: string; AItem: string): string;
  protected
    procedure WriteConfig; override;
    procedure ReadConfig; override;
  public
    constructor Create(AOwner: TComponent); override;
    class function new: IDBObjectConfigList; static;
    procedure WriteItem(ASection, AItem: string; AValue: TValue); override;
    procedure ReadItem(ASection, AItem: string; out AValue: TValue); override;
  published
    property Dataset: TDataset read GetDataset write SetDataset;
    property GroupID: string read GetGroupID write SetGroupID;

    property ColumnNames: TDBConfigColumnNames read FColumnNames
      write SetColumnNames;
  end;

procedure Register;

implementation

uses MVCBr.Comum;

procedure Register;
begin
  RegisterComponents(mvcbr_pkg_component_title,
    [TObjectConfigModel, TDBObjectConfigModel]);
end;

type
  TValueHelper = record helper for TValue
    function isBoolean: boolean;
    function isDatetime: boolean;
  end;

  { TObjectConfig }

function TObjectConfigModelCustom.Count: integer;
begin
  result := FList.Count;
end;

constructor TObjectConfigModelCustom.create(AOwner: TComponent);
begin
  inherited;
  FComponentFullPath := false;
  FList := TInterfaceList.create;

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

constructor TObjectConfigModel.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FContentType := ctJsonFile;
  FFileName := paramStr(0) + '.config';
end;

destructor TObjectConfigModelCustom.Destroy;
begin
  FList.DisposeOf;
  inherited;
end;

function TObjectConfigModel.GetFileName: string;
begin
  result := FFileName;
end;

{$D+}

function TObjectConfigModelCustom.GetComponentFullPath: boolean;
begin
  result := FComponentFullPath;
end;

Function TObjectConfigModelCustom.GetContentFile: IConfigFile;
begin
end;
{$D-}

function TObjectConfigModelCustom.GetItems(idx: integer): IObjectConfigListItem;
begin
  result := FList.Items[idx] as IObjectConfigListItem;
end;

class function TObjectConfigModel.new: IObjectConfigList;
begin
  result := TObjectConfigModel.create(nil);
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

procedure TObjectConfigModelCustom.Add(AControl: {$IFDEF LINUX} TComponent
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

procedure TObjectConfigModelCustom.ReadItem(ASection, AItem: string;
  out AValue: TValue);
begin
  /// inherits
end;

procedure TObjectConfigModelCustom.RegisterControl(ASection: string;
  AText: string; AControl: {$IFDEF LINUX} TComponent
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

procedure TObjectConfigModelCustom.SetComponentFullPath(const Value: boolean);
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

procedure TObjectConfigModelCustom.SetItems(idx: integer;
  const Value: IObjectConfigListItem);
begin
  FList.Items[idx] := Value;
end;

function TObjectConfigModelCustom.This: TObject;
begin
  result := self;
end;

function TObjectConfigModel.ToString: String;
begin
  case ContentType of
    ctIniFile:
      result := TConfigIniFile(FContentFile.ConfigFile).FIniFile.ToString;
    { TODO: ??? }
    ctJsonFile:
      result := TConfigJsonFile(FContentFile.ConfigFile).FJsonFile.ToJson;
  end;
end;

procedure TObjectConfigModelCustom.WriteItem(ASection, AItem: string;
  AValue: TValue);
begin
  // inherits
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
    end
  else
    with TIniFile(GetContentFile.ConfigFile) do
    begin
      // FileName := self.FFileName;
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

destructor TConfigIniFile.Destroy;
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

destructor TConfigJsonFile.Destroy;
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

{ TDBObjectConfigModel }

constructor TDBObjectConfigModel.create(AOwner: TComponent);
begin
  inherited;
  FGroupID := msgocl_SectionGroup;
  FColumnNames.ColumnIdent := msgocl_ColumanNames_File;
  FColumnNames.ColumnSection := msgocl_ColumanNames_Section;
  FColumnNames.ColumnItem := msgocl_ColumanNames_Item;
  FColumnNames.ColumnValue := msgocl_ColumanNames_Value;
end;

function TDBObjectConfigModel.GetDataset: TDataset;
begin
  result := FDataset;
end;

function TDBObjectConfigModel.GetGroupID: string;
begin
  result := FGroupID;
end;

class function TDBObjectConfigModel.new: IDBObjectConfigList;
begin
  result := TDBObjectConfigModel.create(nil);
end;

procedure TDBObjectConfigModel.ReadConfig;
var
  i: integer;
begin
  inherited;
  if csDesigning in ComponentState then
    exit;
  assert(assigned(FDataset), msgocl_AssertDataSet);
  if not FDataset.active then
    FDataset.active := true;
  for i := 0 to FList.Count - 1 do
    FProcRead(FList.Items[i] as IObjectConfigListItem);

end;

procedure TDBObjectConfigModel.ReadItem(ASection, AItem: string;
  out AValue: TValue);
begin
  FDataset.Filter := FilterBuilder(ASection, AItem);
  FDataset.Filtered := true;
  if not FDataset.eof then
  begin
    with FDataset do
      if AValue.isBoolean then
        AValue := FieldByname(msgocl_ColumanNames_Value).AsBoolean
      else if AValue.isDatetime then
        AValue := FieldByname(msgocl_ColumanNames_Value).asDateTime
      else
        AValue := FieldByname(msgocl_ColumanNames_Value).AsString;
  end;
end;

function TDBObjectConfigModel.FilterBuilder(ASection: string;
  AItem: string): string;
begin
  result := format(' %s = %s and %s = %s and %s = %s ',
    [msgocl_ColumanNames_File, quotedStr(FGroupID), msgocl_ColumanNames_Section,
    quotedStr(ASection), msgocl_ColumanNames_Item, quotedStr(AItem)]);
end;

procedure TDBObjectConfigModel.SetColumnNames(const Value
  : TDBConfigColumnNames);
begin
  FColumnNames := Value;
end;

procedure TDBObjectConfigModel.SetDataset(const Value: TDataset);
begin
  FDataset := Value;
end;

procedure TDBObjectConfigModel.SetGroupID(const Value: string);
begin
  FGroupID := Value;
end;

procedure TDBObjectConfigModel.WriteConfig;
begin
  inherited;
  if csDesigning in ComponentState then
    exit;

  if FDataset.State in dsEditModes then
    FDataset.post;
end;

procedure TDBObjectConfigModel.WriteItem(ASection, AItem: string;
  AValue: TValue);
begin
  FDataset.Filter := FilterBuilder(ASection, AItem);
  FDataset.Filtered := true;
  if FDataset.eof then
  begin
    FDataset.append;
    FDataset.FieldByname(msgocl_ColumanNames_File).AsString := FGroupID;
    FDataset.FieldByname(msgocl_ColumanNames_Section).AsString := ASection;
    FDataset.FieldByname(msgocl_ColumanNames_Item).AsString := AItem;
  end
  else
    FDataset.edit;
  FDataset.FieldByname(msgocl_ColumanNames_Value).Value := AValue.AsVariant;
  if FDataset.State in dsEditModes then
    FDataset.post;
end;

{ TObjectConfigModel }

function TObjectConfigModel.GetContentFile: IConfigFile;
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

end.
