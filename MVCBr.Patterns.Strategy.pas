unit MVCBr.Patterns.Strategy;

interface

uses System.Classes, System.SysUtils;

type

  IMVCBrStrategy = interface
    ['{3FA5AD7A-D4C4-41F0-B283-7BE29E1A89E7}']
    function This: TObject;
    function Implements(AImplements: TGuid): IMVCBrStrategy;
    function AsInterface: IInterface;
  end;

  TMVCBrStrategy<T: Class> = class(TInterfacedObject, IMVCBrStrategy)
  private
    FDelegate: TFunc<T>;
    FStrategy: T;
    FImplements: TGuid;
    function Invoke: T;
    procedure SetInvoke(const Value: T);
  public
    constructor Create; virtual;
    class function New: IMVCBrStrategy; overload;static;
    class function New(AInstance: T): IMVCBrStrategy; overload; static;
    destructor Destroy; override;
    function This: TObject;
    function DelegateTo(ADelegate: TFunc<T>): IMVCBrStrategy;
    function Implements(AImplements: TGuid): IMVCBrStrategy;
    function AsInterface: IInterface;
    property Strategy: T read Invoke Write SetInvoke;
  end;

implementation

{ TMVCBrStrategy<T> }

function TMVCBrStrategy<T>.AsInterface: IInterface;
begin
  supports(FStrategy, FImplements, result);
end;

constructor TMVCBrStrategy<T>.Create;
begin
  inherited Create;
end;

function TMVCBrStrategy<T>.DelegateTo(ADelegate: TFunc<T>): IMVCBrStrategy;
begin
  result := self;
  FDelegate := ADelegate;
end;

destructor TMVCBrStrategy<T>.Destroy;
begin
  FreeAndNil(FStrategy);
  inherited;
end;

function TMVCBrStrategy<T>.Invoke: T;
begin
  if (not assigned(FStrategy)) and assigned(FDelegate) then
    FStrategy := FDelegate();
  result := FStrategy;
end;

function TMVCBrStrategy<T>.Implements(AImplements: TGuid): IMVCBrStrategy;
begin
  result := self;
  FImplements := AImplements;
end;

class function TMVCBrStrategy<T>.New(AInstance: T): IMVCBrStrategy;
var
  obj: TMVCBrStrategy<T>;
begin
  obj := TMVCBrStrategy<T>.Create;
  obj.Strategy := AInstance;
  result := obj;
end;

class function TMVCBrStrategy<T>.New: IMVCBrStrategy;
var
  AInstance: TMVCBrStrategy<T>;
begin
  AInstance := TMVCBrStrategy<T>.Create;
  result := AInstance;
end;

procedure TMVCBrStrategy<T>.SetInvoke(const Value: T);
begin
  FStrategy := Value;
end;

function TMVCBrStrategy<T>.This: TObject;
begin
  result := self;
end;

end.
