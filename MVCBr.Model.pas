unit MVCBr.Model;

interface

Uses System.Classes, System.SysUtils, System.Generics.collections, MVCBr.Interf;

type

  TMVCInterfacedList<T> = class(TInterfaceList)
  public
  end;

  TMVCInterfacedObject = Class(TInterfacedObject)
  public
    class function New(AClass: TInterfacedClass): IInterface;
  end;

  TModelFactory = class;

  TModelFactoryClass = class of TModelFactory;

  TModelFactory = class(TMVCInterfacedObject, IModel)
  private
    FController: IController;
    FID: string;
    FModelTypes: TModelTypes;
    function GetModelTypes: TModelTypes;
    procedure SetModelTypes(const AModelTypes: TModelTypes);
  public
    constructor create; virtual;

    function Controller(const AController: IController): IModel; virtual;
    function This: TObject; virtual;
    function GetID: string; virtual;
    function ID(const AID: String): IModel;
    function Update: IModel;
    property ModelTypes: TModelTypes read GetModelTypes write SetModelTypes
      default [mtCommon];

  end;

implementation

{ TModelClass }

constructor TModelFactory.create;
begin
  inherited create;
  FID := self.classname;
end;

function TModelFactory.GetID: string;
begin

end;

function TModelFactory.GetModelTypes: TModelTypes;
begin
  result := FModelTypes;
end;

function TModelFactory.ID(const AID: String): IModel;
begin
  result := self;
  FID := AID;
end;

procedure TModelFactory.SetModelTypes(const AModelTypes: TModelTypes);
begin
  FModelTypes := AModelTypes;
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

class function TMVCInterfacedObject.New(AClass: TInterfacedClass): IInterface;
begin
  result := AClass.create;
end;

end.
