unit MVCBr.BuilderModel;

interface

Uses System.Classes, System.SysUtils,
  MVCBr.Interf, MVCBr.Model, MVCBr.Patterns.Builder,
  System.RTTI;

Type

  IBuilderModel = interface(IModel)
    ['{1AA3DFCE-3950-472F-831F-EDA9B43F7F30}']
    function invoke: TMVCBrBuilderLazyFactory;
    property Builder: TMVCBrBuilderLazyFactory read invoke;
    function Add(ACommand: TValue; AClass: TMVCBrBuilderObjectClass):TMVCBrBuilderLazyItem;
    procedure FreeAllInstances;
    procedure FreeInstance(ACommand: TValue);
    Function Query(ACommand: TValue): TMVCBrBuilderObject;
  end;

  IBuilderModel<T> = interface(TFunc<T>)
    ['{3F4A0478-28C5-4E35-8CB8-7D32C0009868}']
    property Builder: T read invoke;
  end;

  TBuiltObjectFactory = class(TMVCBrBuilderObject)
  public
  end;

  TBuiltResult = TValue;

  TBuilderModelFactory = Class(TModelFactory,
    IBuilderModel<TMVCBrBuilderLazyFactory>)
  private
    FBuilder: TMVCBrBuilderLazyFactory;
  protected
    function Invoke: TMVCBrBuilderLazyFactory;
  public

    Constructor Create; override;

    property Builder: TMVCBrBuilderLazyFactory read invoke;
    Destructor Destroy; override;
    procedure CreateSubClasses; virtual; Abstract;

    function Add(ACommand: TValue; AClass: TMVCBrBuilderObjectClass):TMVCBrBuilderLazyItem;
    procedure FreeAllInstances;
    procedure FreeInstance(ACommand: TValue);
    Function Query(ACommand: TValue): TMVCBrBuilderObject; overload;
    function Query<T: Class>(ACommand: TValue): T; overload;

  End;

implementation

{ TModelBuilderFactory }

function TBuilderModelFactory.Add(ACommand: TValue;
  AClass: TMVCBrBuilderObjectClass):TMVCBrBuilderLazyItem;
begin
  result := Builder.Add(ACommand, AClass);
end;

constructor TBuilderModelFactory.Create;
begin
  inherited;
  ModelTypes := [mtPattern];
  CreateSubClasses;

end;

destructor TBuilderModelFactory.Destroy;
begin
  freeAndNil(FBuilder);
  inherited;
end;

procedure TBuilderModelFactory.FreeAllInstances;
begin
  if assigned(FBuilder) then
    FBuilder.FreeAllInstances;
end;

procedure TBuilderModelFactory.FreeInstance(ACommand: TValue);
begin
  if assigned(FBuilder) then
    FBuilder.FreeInstance(ACommand);
end;

function TBuilderModelFactory.invoke: TMVCBrBuilderLazyFactory;
begin
  if not assigned(FBuilder) then
    FBuilder := TMVCBrBuilderLazyFactory.new;
  result := FBuilder;
end;

function TBuilderModelFactory.Query(ACommand: TValue): TMVCBrBuilderObject;
begin
  result := nil;
  if assigned(FBuilder) then
    result := FBuilder.Query<TMVCBrBuilderObject>(ACommand);
end;

function TBuilderModelFactory.Query<T>(ACommand: TValue): T;
begin
  result := nil;
  if assigned(FBuilder) then
    result := FBuilder.Query<T>(ACommand);
end;

end.
