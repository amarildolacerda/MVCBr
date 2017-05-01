unit eMVC.Config;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.RTTI,
  System.Generics.Collections, MVCBr.ObjectConfigList,
  eMVC.OTAUtilities,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

const
  mvc_maxConfig = 1;
  mvc_createSubFolder = 0;

type

  TMVCConfig = class;

  IMVCConfig = interface
    ['{4CC5DC73-B326-4468-8F04-3BD5F4F0C9F5}']
    function This: TMVCConfig;
    procedure ReadConfig;
    procedure WriteConfig;
    function IsCreateSubFolder: boolean;
    procedure ShowView(AProc: TProc);
  end;

  TMVCConfig = class(TForm, IMVCConfig)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Button1: TButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FConfig: IObjectConfigList;
    FCanceled: boolean;
    { Private declarations }
    procedure RegisterControls;
    function GetValues(idx: Integer): TValue;
    procedure SetValues(idx: Integer; const Value: TValue);
  public
    { Public declarations }
    procedure Init;
    function This: TMVCConfig;
    class function New: IMVCConfig;
    procedure ReadConfig;
    procedure WriteConfig;
    property Values[idx: Integer]: TValue read GetValues write SetValues;
    function IsCreateSubFolder: boolean;
    procedure ShowView(AProc: TProc);
  end;

implementation

{$R *.dfm}

uses IniFiles, eMVC.ToolBox;

var
  LMvcConfig: IMVCConfig;

procedure TMVCConfig.Button1Click(Sender: TObject);
begin
  WriteConfig;
  FCanceled := false;
  close;
end;

procedure TMVCConfig.FormCreate(Sender: TObject);
begin
  FConfig := TObjectConfigModel.New;
  RegisterControls;
end;

procedure TMVCConfig.FormShow(Sender: TObject);
begin
  FCanceled := true;
  Init;
end;

function TMVCConfig.GetValues(idx: Integer): TValue;
begin
  result := FConfig.items[idx].Value;
end;

procedure TMVCConfig.Init;
begin
  ReadConfig;
end;

function TMVCConfig.IsCreateSubFolder: boolean;
begin
  result := GetValues(mvc_createSubFolder).AsBoolean;
end;

class function TMVCConfig.New: IMVCConfig;
var
  obj: TMVCConfig;
begin
  if LMvcConfig=nil then
  begin
    obj := TMVCConfig.create(nil);
    LMvcConfig := obj;
    obj.Init;
  end;
  result := LMvcConfig;

end;

procedure TMVCConfig.ReadConfig;
begin
 try
  FConfig.ReadConfig;
 except
  on e:exception do
     DEBUG(e.message);
 end;
end;

procedure TMVCConfig.RegisterControls;
begin

  FConfig.Add(CheckBox1); // mvc_createSubFolder

end;

procedure TMVCConfig.SetValues(idx: Integer; const Value: TValue);
begin
  FConfig.items[idx].Value := Value;
end;

procedure TMVCConfig.ShowView(AProc: TProc);
begin
  showmodal;
  if not FCanceled then
    if assigned(AProc) then
      AProc;
end;

function TMVCConfig.This: TMVCConfig;
begin
  result := self;
end;

procedure TMVCConfig.WriteConfig;
begin
 try
  FConfig.WriteConfig;
 except
  on e:exception do
     DEBUG(e.message);

 end;
end;

end.
