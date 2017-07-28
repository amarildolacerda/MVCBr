unit MVCBr.Patterns.Lazy;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.RTTI,
  TypInfo;

const
  ObjCastGUID: TGUID = '{4324E01E-6BBA-4771-88D5-E5A8AD1E2AAE}';

type

  IMVCBrLazy<T: class> = interface(TFunc<T>)
    ['{31156284-3837-44A9-B0AD-CBD9BE3FB46B}']
    function IsCreated: Boolean;
    property Instance: T read Invoke;
    procedure Release;
    procedure FreeInstance;
  end;

  TMVCBrLazy<T: Class> = class(TInterfacedObject, IMVCBrLazy<T>, IInterface)
  private
    FCreated: Boolean;
    FGuid: TGUID;
    FInstance: T;
    FFactory: TFunc<T>;
    procedure Initialize;
    function Invoke: T;
  protected
    function QueryInterface(const AIID: TGUID; out Obj): HResult; stdcall;
  public
    constructor Create(AValueFactory: TFunc<T>); virtual;
    destructor Destroy; override;
    function Delegate(ADelegate: TFunc<T>): TMVCBrLazy<T>; virtual;
    function Implements(AGuid: TGUID): TMVCBrLazy<T>; virtual;
    procedure Release; virtual;
    function IsCreated: Boolean;
    property Instance: T read Invoke;
    function AsInstance<TBaseClass:Class>:TBaseClass;overload;
    function AsInterface<T: IInterface>: T; overload;
    function AsInterface: IInterface; overload;
    procedure FreeInstance; virtual;
  end;

  TMVCBrAggregatedLazy<T: IInterface> = class(TInterfacedObject, IInterface)
  private
    FCreated: Boolean;
    [unsafe]
    FInstance: T;
    FFactory: TFunc<T>;
    procedure Initialize;
    function GetInstance: T;
  protected
    function QueryInterface(const AIID: TGUID; out Obj): HResult; stdcall;
  public
    constructor Create(AValueFactory: TFunc<T>);
    destructor Destroy; override;
    procedure Release; virtual;
    function IsCreated: Boolean;
    property Instance: T read GetInstance;
  end;

  MVCBrLazy<T: class> = record
  strict private
    FLazy: IMVCBrLazy<T>;
    function GetInstance: T;
  private
  public
    class constructor Create;
    property Instance: T read GetInstance;
    class operator Implicit(const Value: MVCBrLazy<T>): IMVCBrLazy<T>; overload;
    class operator Implicit(const Value: MVCBrLazy<T>): T; overload;
    class operator Implicit(const Value: TFunc<T>): MVCBrLazy<T>; overload;
  end;

  TMVCBrLazyItem<T: Class> = Class(TMVCBrLazy<T>)
  public
    FCommand: TValue;
    FClass: TClass;
    FFunc: TFunc<T>;
  End;

  TThreadLazyList<T: Class> = class(TThreadList < TMVCBrLazyItem < T >> )
  end;

  IMVCBrLazyFactory<T: Class> = interface
    ['{1B2BF0A7-F693-4734-A0F4-DCB2D7218AD3}']
    function Add(ACommand: TValue; AClass: TClass): TMVCBrLazyItem<T>;
    function IndexOf(ACommand: TValue): Integer;
    function IsValid(Const Idx: Integer): Boolean;
    function Query(ACommand: TValue): TMVCBrLazyItem<T>;
    function LockList: TList<TMVCBrLazyItem<T>>;
    procedure UnlockList;
  end;

  TMVCBrLazyFactory<T: Class> = class(TInterfacedObject, IMVCBrLazyFactory<T>)
  private
    FList: TThreadLazyList<T>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    class function New(AClass: T): TMVCBrLazyFactory<T>;
    function IndexOf(ACommand: TValue): Integer; virtual;
    function IsValid(Const Idx: Integer): Boolean; virtual;
    function Add(ACommand: TValue; AClass: TClass): TMVCBrLazyItem<T>;
      overload; virtual;
    function Add<TBaseClass: Class>(ACommand: TValue)
      : TMVCBrLazyItem<TBaseClass>; overload;
    function Query(ACommand: TValue): TMVCBrLazyItem<T>;
    function LockList: TList<TMVCBrLazyItem<T>>;
    procedure UnlockList;
    procedure FreeInstance(ACommand: TValue); virtual;
    procedure FreeAllInstances; virtual;
    function Count: Integer;
  end;

implementation

uses {$IFNDEF BPL}
  System.RTTI.Helper,
{$ENDIF}MVCBr.Interf;

function TMVCBrLazy<T>.AsInstance<TBaseClass>: TBaseClass;
var obj:TObject;
begin
    result := nil;
    obj := Instance;
    if obj.InheritsFrom(TBaseClass) then
      result := TBaseClass( obj );
end;

function TMVCBrLazy<T>.AsInterface: IInterface;
begin
  supports(Instance, FGuid, result);
end;

function TMVCBrLazy<T>.AsInterface<T>: T;
var
  AGuid: TGUID;
begin
  result := nil;
  AGuid := TMVCBr.getGuid<T>;
  supports(Instance, FGuid, result);
end;

constructor TMVCBrLazy<T>.Create(AValueFactory: TFunc<T>);
begin
  FFactory := AValueFactory;
end;

function TMVCBrLazy<T>.Delegate(ADelegate: TFunc<T>): TMVCBrLazy<T>;
begin
  FFactory := ADelegate;
  result := self;
end;

destructor TMVCBrLazy<T>.Destroy;
begin
  if FCreated then
  begin
    if Assigned(FInstance) then
      FInstance.Free;
  end;
  inherited;
end;

procedure TMVCBrLazy<T>.FreeInstance;
begin
  FreeAndNil(FInstance);
  FCreated := false;
end;

function TMVCBrLazy<T>.Implements(AGuid: TGUID): TMVCBrLazy<T>;
begin
  FGuid := AGuid;
  result := self;
end;

procedure TMVCBrLazy<T>.Initialize;
begin
  if not FCreated then
  begin
    FInstance := FFactory();
    FCreated := True;
  end;
end;

function TMVCBrLazy<T>.Invoke: T;
begin
  Initialize();
  result := FInstance;
end;

function TMVCBrLazy<T>.IsCreated: Boolean;
begin
  result := FCreated;
end;

function TMVCBrLazy<T>.QueryInterface(const AIID: TGUID; out Obj): HResult;
begin
  if IsEqualGUID(AIID, ObjCastGUID) then
  begin
    Initialize;
  end;
  result := inherited;
end;

procedure TMVCBrLazy<T>.Release;
begin
end;

{ Lazy<T> }

class constructor MVCBrLazy<T>.Create;
begin
  // TRttiSingleton.GetInstance.GetRttiType(TypeInfo(T));
end;

function MVCBrLazy<T>.GetInstance: T;
begin
  result := FLazy();
end;

class operator MVCBrLazy<T>.Implicit(const Value: MVCBrLazy<T>): IMVCBrLazy<T>;
begin
  result := Value.FLazy;
end;

class operator MVCBrLazy<T>.Implicit(const Value: MVCBrLazy<T>): T;
begin
  result := Value.Instance;
end;

class operator MVCBrLazy<T>.Implicit(const Value: TFunc<T>): MVCBrLazy<T>;
begin
  result.FLazy := TMVCBrLazy<T>.Create(Value);
end;

{ TMVCBrAggregatedLazy<T> }

constructor TMVCBrAggregatedLazy<T>.Create(AValueFactory: TFunc<T>);
begin
  inherited Create;
  FFactory := AValueFactory;
end;

destructor TMVCBrAggregatedLazy<T>.Destroy;
begin
  if FCreated then
  begin
    FInstance := nil;
  end;
  inherited;
end;

procedure TMVCBrAggregatedLazy<T>.Initialize;
begin
  if not FCreated then
  begin
    FInstance := FFactory();
    FCreated := True;
  end;
end;

function TMVCBrAggregatedLazy<T>.GetInstance: T;
begin
  Initialize();
  result := FInstance;
end;

function TMVCBrAggregatedLazy<T>.IsCreated: Boolean;
begin
  result := FCreated;
end;

function TMVCBrAggregatedLazy<T>.QueryInterface(const AIID: TGUID;
  out Obj): HResult;
begin
  if IsEqualGUID(AIID, ObjCastGUID) then
  begin
    Initialize;
  end;
  result := inherited;
end;

procedure TMVCBrAggregatedLazy<T>.Release;
begin

end;

{ TMVCBrLazyFactory<T> }

function TMVCBrLazyFactory<T>.Add(ACommand: TValue; AClass: TClass)
  : TMVCBrLazyItem<T>;
var
  Obj: TMVCBrLazyItem<T>;
begin
  Obj := TMVCBrLazyItem<T>.Create(
    function: T
    begin
      result := T(AClass.Create);
    end);
  Obj.FCommand := ACommand;
  Obj.FClass := AClass;

  FList.Add(Obj);
  result := Obj;
end;

function TMVCBrLazyFactory<T>.Add<TBaseClass>(ACommand: TValue)
  : TMVCBrLazyItem<TBaseClass>;
begin
  result := TMVCBrLazyItem<TBaseClass>(Add(ACommand, TBaseClass));
end;

function TMVCBrLazyFactory<T>.Count: Integer;
begin
  with LockList do
    try
      result := Count;
    finally
      UnlockList;
    end;
end;

constructor TMVCBrLazyFactory<T>.Create;
begin
  inherited Create;
  FList := TThreadLazyList<T>.Create;
end;

destructor TMVCBrLazyFactory<T>.Destroy;
var
  o: TObject;
  i: Integer;
begin
  with LockList do
    try
      for i := Count - 1 downto 0 do
      begin
        o := items[i];
        o.DisposeOf;
        delete(i);
      end;
    finally
      UnlockList;
    end;
  FList.Free;
  inherited;
end;

procedure TMVCBrLazyFactory<T>.FreeAllInstances;
var
  i: Integer;
begin
  i := -1;
  with LockList do
    try
      for i := Count - 1 downto 0 do
        items[i].FreeInstance;
    finally
      UnlockList;
    end;
end;

procedure TMVCBrLazyFactory<T>.FreeInstance(ACommand: TValue);
var
  i: Integer;
begin
  i := IndexOf(ACommand);
  if IsValid(i) then
    with LockList do
      try
        items[i].FreeInstance;
      finally
        UnlockList;
      end;
end;

function TMVCBrLazyFactory<T>.LockList: TList<TMVCBrLazyItem<T>>;
begin
  result := FList.LockList;
end;

class function TMVCBrLazyFactory<T>.New(AClass: T): TMVCBrLazyFactory<T>;
begin
  result := TMVCBrLazyFactory<T>.Create;
end;

function TMVCBrLazyFactory<T>.Query(ACommand: TValue): TMVCBrLazyItem<T>;
var
  i: Integer;
begin
  result := nil;
  i := IndexOf(ACommand);
  if i >= 0 then
  begin
    with LockList do
      try
        result := items[i];
      finally
        UnlockList;
      end;
  end;
end;

function TMVCBrLazyFactory<T>.IndexOf(ACommand: TValue): Integer;
var
  i: Integer;
begin
  i := -1;
{$IFNDEF BPL}
  with LockList do
    try
      for i := 0 to Count - 1 do
        if items[i].FCommand.equals(ACommand) then
        begin
          result := i;
          exit;
        end;
    finally
      UnlockList;
    end;
{$ENDIF}
end;

function TMVCBrLazyFactory<T>.IsValid(const Idx: Integer): Boolean;
var
  n: Integer;
begin
  with LockList do
    try
      n := Count;
    finally
      UnlockList;
    end;
  result := (Idx >= 0) and (Idx < n);

end;

procedure TMVCBrLazyFactory<T>.UnlockList;
begin
  FList.UnlockList;
end;

end.
