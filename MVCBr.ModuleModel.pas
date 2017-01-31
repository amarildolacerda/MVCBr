unit MVCBr.ModuleModel;

interface

uses
  System.SysUtils, System.Classes,
  MVCBr.Interf;

type
  TModuleFactory = class(TDataModule,IModuleModel)
  private
    { Private declarations }
    FController:IController;
    FID:string;
    FModelTypes : TModelTypes;
  protected
    function This: TObject;virtual;
    function GetID: string;virtual;
    function ID(const AID: String): IModel;virtual;
    function Update: IModel;virtual;

    function Controller(const AController: IController): IModel;virtual;
    function GetModelTypes: TModelTypes;virtual;
    function GetController:IController;
    procedure SetModelTypes(const AModelType: TModelTypes);
    property ModelTypes: TModelTypes read GetModelTypes write SetModelTypes;

  public
    { Public declarations }
  end;

var
  ModuleFactory: TModuleFactory;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TModuleFactory }

function TModuleFactory.Controller(const AController: IController): IModel;
begin
   result := self as IModel;
   FController := AController;
end;

function TModuleFactory.GetController: IController;
begin
  Result := FController;
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

end.
