/// <summary>
///    Factory patterns MVCBr.Patterns.Factory to implements a wrapper generic factory classes
///    Factory class create instances of object in internal calls, some time
///       it would be create by caller and manager internal of factory class with
///       FOwned frag equal true
/// </summary>
/// <auth>
///    amarildo lacerda
/// </auth>
unit MVCBr.Patterns.Factory;

interface

uses System.Classes, System.SysUtils, System.Rtti;

type
  /// <summary> Interface for Factory Class </summary>
  IMVCBrFactoryClass<T> = interface(TFunc<T>)
    ['{31284382-3961-40BB-B03D-C2F3C70D140D}']
    function Default: T;
    procedure Release;
  end;

  /// <summary> Class to implements factory interface for concrete classes</summary>
  TMVCBrFactoryClass<T: Class> = class(TInterfacedObject, IMVCBrFactoryClass<T>)
  private
    FInstance: T;
  private
    FOwned: boolean;
    FClass: TClass;
    constructor InternalCreate;
    function Invoke: T;
  public
    /// <summary> DONT USE CREATE to get instance of factory class, insteadof use NEW </summary>
    constructor Create;
    destructor Destroy; override;
    /// <summay> Create New instance of factory class </summary>
    class function New(AOwned: boolean = true): TMVCBrFactoryClass<T>;overload;
    class function New(AObject:T;AOwned: boolean = true): TMVCBrFactoryClass<T>;overload;
    /// <summary> Default check if instance exists, is not create it..</summary>
    /// <returns>instance of class</returns>
    function Default: T;
    function GetInstance:T;virtual;
    /// <summary> Release Disposeof only instance, not factory class </summary>
    procedure Release;
{$IFDEF DUNIT}
    /// <summary>  for DUNIT Unit Test Only </summary>
    function InstanceWithoutInit: T;
{$ENDIF}
  end;

implementation

{ TMVCBrSingleton<T> }

constructor TMVCBrFactoryClass<T>.Create;
begin
  raise exception.Create('Use class function NEW instead of create');
end;

{$IFDEF DUNIT}

function TMVCBrFactoryClass<T>.InstanceWithoutInit: T;
begin
  result := FInstance;
end;
{$ENDIF}

function TMVCBrFactoryClass<T>.Default: T;
begin
  result := GetInstance;
end;

destructor TMVCBrFactoryClass<T>.Destroy;
begin
  if FOwned and assigned(FInstance) then
    FInstance.DisposeOf;
  inherited;
end;

function TMVCBrFactoryClass<T>.GetInstance: T;
begin
   result := invoke;
end;

constructor TMVCBrFactoryClass<T>.InternalCreate;
begin
  inherited Create;
end;

function TMVCBrFactoryClass<T>.Invoke: T;
begin
  if not assigned(FInstance) then
    FInstance := T(FClass.Create);
  result := FInstance;
end;

class function TMVCBrFactoryClass<T>.New(AObject: T;
  AOwned: boolean): TMVCBrFactoryClass<T>;
begin
  result := New(AOwned);
  result.FInstance := AObject;
end;

class function TMVCBrFactoryClass<T>.New(AOwned: boolean = true)
  : TMVCBrFactoryClass<T>;
begin
  result := self.InternalCreate;
  result.FOwned := AOwned;
  result.FClass := TClass(T);
end;

procedure TMVCBrFactoryClass<T>.Release;
begin
  if assigned(FInstance) then
    FInstance.DisposeOf;
  FInstance := nil;
end;

end.
