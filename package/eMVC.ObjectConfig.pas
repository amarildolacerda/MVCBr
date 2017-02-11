{
  MVCBr - amarildo lacerda
}
unit eMVC.ObjectConfig;

interface

uses System.Classes, System.SysUtils, System.RTTI,
  VCL.StdCtrls, System.IniFiles,
  VCL.Controls, System.Generics.Collections;

type
  IObjectConfigItem = interface;

  IObjectConfig = interface
    ['{302562A0-2A11-43F6-A249-4BD42E1133F2}']
    procedure ReadConfig;
    procedure WriteConfig;
    procedure RegisterControl(ASection: string; AText: string;
      AControl: TControl); overload;
    procedure RegisterControl(AControl: TControl); overload;
    procedure SetFileName(const Value: string);
    function GetFileName: string;
    property FileName: string read GetFileName write SetFileName;
    function Count: integer;
    function GetItems(idx: integer): IObjectConfigItem;
    procedure SetItems(idx: integer; const Value: IObjectConfigItem);
    property Items[idx: integer]: IObjectConfigItem read GetItems
      write SetItems;
  end;

  TObjectConfigItem = class;

  IObjectConfigItem = interface
    ['{AD786625-5C1A-4486-B000-2F61BB0C0A27}']
    function This: TObjectConfigItem;
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

  TObjectConfigItem = class(TInterfacedObject, IObjectConfigItem)
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
      : IObjectConfigItem;
    property Section: string read GetSection write SetSection;
    property Item: string read GetItem write SetItem;
    property Value: TValue read GetValue write SetValue;
    function This: TObjectConfigItem;
  end;

  TObjectConfig = class(TInterfacedObject, IObjectConfig)
  private
    FList: TInterfaceList;
    FFileName: string;
    FProcRead: TProc<IObjectConfigItem>;
    FProcWrite: TProc<IObjectConfigItem>;
    FIniFile: TIniFile;
    function GetItems(idx: integer): IObjectConfigItem;
    procedure SetItems(idx: integer; const Value: IObjectConfigItem);
    Function GetIniFile: TIniFile;
    procedure SetFileName(const Value: string);
    function GetFileName: string;
  public
    constructor create;
    destructor destroy; override;
    class function new: IObjectConfig;
    procedure ReadConfig; virtual;
    procedure WriteConfig; virtual;
    function Count: integer;
    property Items[idx: integer]: IObjectConfigItem read GetItems
      write SetItems;
    procedure RegisterControl(ASection: string; AText: string;
      AControl: TControl); overload; virtual;
    procedure RegisterControl(AControl: TControl); overload; virtual;
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

function TObjectConfig.Count: integer;
begin
  result := FList.Count;
end;

constructor TObjectConfig.create;
begin
  FList := TInterfaceList.create;
  FFileName := paramStr(0) + '.config';

  FProcRead := procedure(sender: IObjectConfigItem)
    var
      FOut: TValue;
    begin
      FOut := sender.Value;
      ReadItem(sender.Section, sender.Item, FOut);
      sender.Value := FOut;
    end;

  FProcWrite := procedure(sender: IObjectConfigItem)
    begin
      WriteItem(sender.Section, sender.Item, sender.Value);
    end;

end;

destructor TObjectConfig.destroy;
begin
  FList.DisposeOf;
  if assigned(FIniFile) then
    FIniFile.DisposeOf;
  inherited;
end;

function TObjectConfig.GetFileName: string;
begin
  result := FFileName;
end;

function TObjectConfig.GetIniFile: TIniFile;
begin
  if not assigned(FIniFile) then
    FIniFile := TIniFile.create(FFileName);
  result := FIniFile;
end;

function TObjectConfig.GetItems(idx: integer): IObjectConfigItem;
begin
  result := FList.Items[idx] as IObjectConfigItem;
end;

class function TObjectConfig.new: IObjectConfig;
begin
  result := TObjectConfig.create;
end;

procedure TObjectConfig.ReadConfig;
var
  i: integer;
begin
  if assigned(FProcRead) then
    for i := 0 to FList.Count - 1 do
      FProcRead(FList.Items[i] as IObjectConfigItem);
end;

procedure TObjectConfig.ReadItem(ASection, AItem: string; out AValue: TValue);
begin
  with GetIniFile do
    if AValue.isBoolean then
      AValue := readbool(ASection, AItem, AValue.AsBoolean)
    else if AValue.isDatetime then
      AValue := readDateTime(ASection,AItem,AValue.AsExtended)    
    else
      AValue := readString(ASection, AItem, AValue.AsString);
end;

procedure TObjectConfig.RegisterControl(AControl: TControl);
var
  LItem: string;
begin
  LItem := AControl.className + '.' + AControl.name;
  RegisterControl('Config', LItem, AControl);
end;

procedure TObjectConfig.RegisterControl(ASection: string; AText: string;
  AControl: TControl);
var
  obj: TObjectConfigItem;
begin
  obj := TObjectConfigItem.create;
  obj.Section := ASection;
  obj.Item := AText;
  obj.FControl := AControl;
  FList.add(obj);
end;

procedure TObjectConfig.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TObjectConfig.SetItems(idx: integer; const Value: IObjectConfigItem);
begin
  FList.Items[idx] := Value;
end;

procedure TObjectConfig.WriteConfig;
var
  i: integer;
begin
  if assigned(FProcRead) then
    for i := 0 to FList.Count - 1 do
      FProcWrite(FList.Items[i] as IObjectConfigItem);
end;

procedure TObjectConfig.WriteItem(ASection, AItem: string; AValue: TValue);
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

function TObjectConfigItem.GetItem: string;
begin
  result := FItem;
end;

function TObjectConfigItem.GetSection: string;
begin
  result := FSection;
end;

function TObjectConfigItem.GetValue: TValue;
begin
  if FControl.InheritsFrom(TEdit) then
    result := TEdit(FControl).text
  else if FControl.InheritsFrom(TCheckBox) then
    result := TCheckBox(FControl).Checked
  else if FControl.InheritsFrom(TComboBox) then
    result := TComboBox(FControl).text;

end;

class function TObjectConfigItem.new(ASection, AItem: string;
  AControl: TControl): IObjectConfigItem;
var
  obj: TObjectConfigItem;
begin
  obj := TObjectConfigItem.create;
  obj.FControl := AControl;
  obj.FSection := ASection;
  obj.FItem := AItem;
  result := obj;
end;

procedure TObjectConfigItem.SetItem(const Value: string);
begin
  FItem := Value;
end;

procedure TObjectConfigItem.SetSection(const Value: string);
begin
  FSection := Value;
end;

procedure TObjectConfigItem.SetValue(const Value: TValue);
begin
  if FControl.InheritsFrom(TEdit) then
    TEdit(FControl).text := Value.asString
  else if FControl.InheritsFrom(TCheckBox) then
    TCheckBox(FControl).Checked := Value.AsBoolean
  else if FControl.InheritsFrom(TComboBox) then
    TComboBox(FControl).text := Value.asString;

end;

function TObjectConfigItem.This: TObjectConfigItem;
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
