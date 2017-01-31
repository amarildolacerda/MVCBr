unit MVCBr.ModuleModel;

interface

uses
  Forms, Graphics, System.UITypes, System.SysUtils, System.Classes,
  MVCBr.Interf;

type
  TModuleFactory = class({$IFDEF BPL}TDataModule, {$ELSE} TForm,
    {$ENDIF} IModuleModel, IModel)
  private
    { Private declarations }
    FController: IController;
    FID: string;
    FModelTypes: TModelTypes;
  protected
    function This: TObject; virtual;
    function GetID: string; virtual;
    function ID(const AID: String): IModel; virtual;
    function Update: IModel; virtual;

    function Controller(const AController: IController): IModel; virtual;
    function GetModelTypes: TModelTypes; virtual;
    function GetController: IController;
    procedure SetModelTypes(const AModelType: TModelTypes);
    property ModelTypes: TModelTypes read GetModelTypes write SetModelTypes;
    procedure AfterInit; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
  published
  end;


implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}
{ TModuleFactory }

procedure TModuleFactory.AfterInit;
begin
  // chamado apos;;
end;

function TModuleFactory.Controller(const AController: IController): IModel;
begin
  result := self as IModel;
  FController := AController;
end;

constructor TModuleFactory.Create(AOwner: TComponent);
begin
  inherited;
  BorderIcons:=[];

  // FFont:= TFont.Create;
end;

destructor TModuleFactory.destroy;
begin
  // FFont.Free;
  inherited;
end;

function TModuleFactory.GetController: IController;
begin
  result := FController;
end;

function TModuleFactory.GetID: string;
begin
  result := FID;
end;

function TModuleFactory.GetModelTypes: TModelTypes;
begin
  result := FModelTypes;
end;

function TModuleFactory.ID(const AID: String): IModel;
begin
  result := self as IModel;
  FID := AID;
end;

procedure TModuleFactory.SetModelTypes(const AModelType: TModelTypes);
begin
  FModelTypes := AModelType;
end;

function TModuleFactory.This: TObject;
begin
  result := self;
end;

function TModuleFactory.Update: IModel;
begin
  result := self as IModel;
end;

initialization

end.
