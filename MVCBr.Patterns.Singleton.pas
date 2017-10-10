/// <summary>
/// MVCBr.Patterns.Singleton is an implement to wrapper singleton for generic classes
/// </summary>
/// <auth>amarildo lacerda</auth>
unit MVCBr.Patterns.Singleton;

interface

uses System.Classes, System.SysUtils, System.Rtti;

type
  /// <summary> Interface for Singleton </summary>
  IMVCBrSingleton<T> = interface(TFunc<T>)
    ['{31284382-3961-40BB-B03D-C2F3C70D140D}']
    function Default: T;
    procedure Release;
  end;

  /// <summary> Class to implements singleton interface for concrete classes</summary>
  TMVCBrSingleton<T: Class> = class(TInterfacedObject, IMVCBrSingleton<T>)
  private
    FInstance: T;
  private
    FOwned: boolean;
    FClass: TClass;
  protected
    constructor InternalCreate;
    function Invoke: T;
  public
    /// <summary> DONT USE CREATE to get instance of singleted class, insteadof use NEW </summary>
    constructor Create;
    destructor Destroy; override;
    /// <summay> Create New instance of singleted class </summary>
    class function New(): IMVCBrSingleton<T>;overload;
    class function New(AObject: T; AOwned: boolean = true)
      : IMVCBrSingleton<T>;overload;
    /// <summary> Default check if instance exists, is not create it..</summary>
    /// <returns>instance of class</returns>
    function Default: T;
    /// <summary> Release Disposeof only instance, not singleton class </summary>
    procedure Release;
{$IFDEF DUNIT}
    /// <summary>  for DUNIT Unit Test Only </summary>
    function InstanceWithoutInit: T;
{$ENDIF}
  end;

implementation

{ TMVCBrSingleton<T> }

constructor TMVCBrSingleton<T>.Create;
begin
  raise exception.Create('Use class function NEW instead of create');
end;

{$IFDEF DUNIT}

function TMVCBrSingleton<T>.InstanceWithoutInit: T;
begin
  result := FInstance;
end;
{$ENDIF}

function TMVCBrSingleton<T>.Default: T;
begin
  result := Invoke;
end;

destructor TMVCBrSingleton<T>.Destroy;
begin
  if FOwned and assigned(FInstance) then
    FInstance.DisposeOf;
  inherited;
end;

constructor TMVCBrSingleton<T>.InternalCreate;
begin
  inherited Create;
end;

function TMVCBrSingleton<T>.Invoke: T;
begin
  if not assigned(FInstance) then
    FInstance := T(FClass.Create);
  result := FInstance;
end;

class function TMVCBrSingleton<T>.New: IMVCBrSingleton<T>;
begin
  result := New(nil, true);
end;

class function TMVCBrSingleton<T>.New(AObject: T; AOwned: boolean)
  : IMVCBrSingleton<T>;
var obj:TMVCBrSingleton<T>;
begin
  obj := self.InternalCreate;
  obj.FOwned := AOwned;
  obj.FClass := TClass(T);
  obj.FInstance := AObject;
  result := obj;
end;

procedure TMVCBrSingleton<T>.Release;
begin
  if assigned(FInstance) then
    FInstance.DisposeOf;
  FInstance := nil;
end;

end.
