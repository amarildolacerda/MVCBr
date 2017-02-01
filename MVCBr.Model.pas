unit MVCBr.Model;

interface

Uses System.Classes, System.SysUtils, System.Generics.collections, MVCBr.Interf;

type

  TMVCInterfacedObject = Class(TMVCFactoryAbstract)
  public
    class function New(AClass: TInterfacedClass): IInterface;
    function GetOwned: TComponent; virtual;
  end;

  TModelFactory = class;

  TModelFactoryClass = class of TModelFactory;

  TModelFactory = class(TMVCInterfacedObject, IModel)
  private
    FOwned: TComponent;
    FID: string;
    FModelTypes: TModelTypes;
    function GetModelTypes: TModelTypes;
    procedure SetModelTypes(const AModelTypes: TModelTypes);
  private
    FController: IController;
    procedure SetID(const AID:string);
  public

    constructor create; virtual;
    destructor destroy; override;
    function GetController: IController;
    function GetOwned: TComponent; override;
    function Controller(const AController: IController): IModel; virtual;
    function This: TObject; virtual;
    function GetID: string; virtual;
    function ID(const AID: String): IModel;
    function Update: IModel;virtual;
    property ModelTypes: TModelTypes read GetModelTypes write SetModelTypes
      default [mtCommon];
    procedure AfterInit; virtual;
  end;

implementation

{ TModelClass }

constructor TModelFactory.create;
begin
  inherited create;
  FOwned := TComponent.create(nil);
  ID ( self.classname );
end;

destructor TModelFactory.destroy;
begin
  FOwned.DisposeOf;
  UnRegisterClass(GetClass(FID));
  inherited;
end;

function TModelFactory.GetController: IController;
begin
  result := FController;
end;

function TModelFactory.GetID: string;
begin
  result := FID;
end;

function TModelFactory.GetModelTypes: TModelTypes;
begin
  result := FModelTypes;
end;

function TModelFactory.GetOwned: TComponent;
begin
  result := FOwned;
end;

function TModelFactory.ID(const AID: String): IModel;
begin
  result := self;
  SetID(AID);
end;

procedure TModelFactory.SetID(const AID: string);
begin
  if FID<>'' then
     UnRegisterClass(GetClass(FID));
  FID := AID;
  RegisterClassAlias( TPersistentClass(Self.ClassType)   ,FID);

end;

procedure TModelFactory.SetModelTypes(const AModelTypes: TModelTypes);
begin
  FModelTypes := AModelTypes;
end;

procedure TModelFactory.AfterInit;
begin
  // chamado apos a conclusao do controller
end;

function TModelFactory.Controller(const AController: IController): IModel;
begin
  result := self;
  FController := AController;
end;

function TModelFactory.This: TObject;
begin
  result := self;
end;

function TModelFactory.Update: IModel;
begin
  result := self;
end;

{ TMVCInterfacedObject }

function TMVCInterfacedObject.GetOwned: TComponent;
begin
  result := nil;
end;

class function TMVCInterfacedObject.New(AClass: TInterfacedClass): IInterface;
begin
  result := AClass.create;
end;

end.
