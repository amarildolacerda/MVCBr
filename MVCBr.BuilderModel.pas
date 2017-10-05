unit MVCBr.BuilderModel;

interface

Uses System.Classes, System.SysUtils,
  MVCBr.Interf, MVCBr.Model, MVCBr.Patterns.Builder,
  MVCBr.Patterns.Lazy,
  System.RTTI;

Type
  /// <summary>
  /// Interface to BuilderModel object
  /// </summary>
  IBuilderModel = interface(IModel)
    ['{1AA3DFCE-3950-472F-831F-EDA9B43F7F30}']
    function invoke: TMVCBrBuilderLazyFactory;
    property Builder: TMVCBrBuilderLazyFactory read invoke;
    function Add(ACommand: TValue; AClass: TMVCBrBuilderObjectClass)
      : TMVCBrBuilderLazyItem;
    procedure FreeAllInstances;
    procedure FreeInstance(ACommand: TValue);
    Function Query(ACommand: TValue): TMVCBrBuilderObject;
    function Execute(ACommand: TValue; AParam: TValue): TValue;
    { IMVCBrBuilderItemResult }
    function Lazy: TMVCBrLazyFactory<TObject>;
  end;

  IBuilderModel<T> = interface(TFunc<T>)
    ['{3F4A0478-28C5-4E35-8CB8-7D32C0009868}']
    property Builder: T read invoke;
  end;

  TBuiltObjectFactory = TMVCBrBuilderObject;

  IBuiltObject = IMVCBrBuilderObject;

  // TBuiltResult = TValue;

  /// <summary>
  /// Builder Model Factory to support command into Models
  /// </summary>
  TBuilderModelFactory = Class(TModelFactory,
    IBuilderModel<TMVCBrBuilderLazyFactory>)
  private
    FBuilder: TMVCBrBuilderLazyFactory;
    FLazy: TMVCBrLazyFactory<TObject>;
  protected
    function invoke: TMVCBrBuilderLazyFactory;
    function InvokeLazy: TMVCBrLazyFactory<TObject>;
  public
    Function GetInstance: TMVCBrBuilderLazyFactory;virtual;
    Constructor Create; override;
    /// builder class
    property Builder: TMVCBrBuilderLazyFactory read GetInstance;
    Destructor Destroy; override;
    procedure CreateSubClasses; virtual; Abstract;

    /// add command to builder
    function Add(ACommand: TValue; AClass: TMVCBrBuilderObjectClass)
      : TMVCBrBuilderLazyItem; overload;
    /// free instances
    procedure FreeAllInstances;
    procedure FreeInstance(ACommand: TValue);
    /// execute builder command
    function Execute(ACommand: TValue; AParam: TValue): TValue;
    /// search for builder command
    Function Query(ACommand: TValue): TMVCBrBuilderObject; overload;
    /// search and cast builder command
    function Query<T: Class>(ACommand: TValue): T; overload;

    /// generic TClass can place in Lazy Object List
    function Lazy: TMVCBrLazyFactory<TObject>;

  End;

implementation

{ TModelBuilderFactory }

function TBuilderModelFactory.Add(ACommand: TValue;
  AClass: TMVCBrBuilderObjectClass): TMVCBrBuilderLazyItem;
begin
  result := Builder.Add(ACommand, AClass);
end;

constructor TBuilderModelFactory.Create;
begin
  inherited;
{$IFNDEF BPL}
  ModelTypes := [mtPattern];
{$ENDIF}
  CreateSubClasses;

end;

destructor TBuilderModelFactory.Destroy;
begin
  if assigned(FBuilder) then
    FBuilder.DisposeOf;
  if assigned(FLazy) then
    FLazy.DisposeOf;
  inherited;
end;

function TBuilderModelFactory.Execute(ACommand, AParam: TValue): TValue;
begin
  result := Builder.Execute(ACommand, AParam);
end;

procedure TBuilderModelFactory.FreeAllInstances;
begin
  if assigned(FBuilder) then
    FBuilder.FreeAllInstances;
  if assigned(FLazy) then
    FLazy.FreeAllInstances;
end;

procedure TBuilderModelFactory.FreeInstance(ACommand: TValue);
begin
  if assigned(FBuilder) then
    FBuilder.FreeInstance(ACommand);
  if assigned(FLazy) then
    FLazy.FreeInstance(ACommand);
end;

function TBuilderModelFactory.GetInstance: TMVCBrBuilderLazyFactory;
begin
  result := invoke;
end;

function TBuilderModelFactory.InvokeLazy: TMVCBrLazyFactory<TObject>;
begin
  if not assigned(FLazy) then
    FLazy := TMVCBrLazyFactory<TObject>.Create;
  result := FLazy;
end;

function TBuilderModelFactory.invoke: TMVCBrBuilderLazyFactory;
begin
  if not assigned(FBuilder) then
    FBuilder := TMVCBrBuilderLazyFactory.new;
  result := FBuilder;
end;

function TBuilderModelFactory.Lazy: TMVCBrLazyFactory<TObject>;
begin
  result := InvokeLazy;
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
