unit MVCBr.Patterns.Mediator;

interface

Uses System.Classes, System.SysUtils,
  System.RTTI,
  System.Generics.Collections;

type

  TMVCBrParticipant = class;
  TMVCBrParticipantClass = class of TMVCBrParticipant;
  TMVCBrMediator<T: Class> = class;

  TMVCBrParticipant = class(TInterfacedObject)
  private
    FID: TValue;
    FMediator: TObject;
    procedure SetID(const Value: TValue);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Mediator: TMVCBrMediator<TMVCBrParticipant>;
    property ID: TValue read FID write SetID;
    procedure Release;
    procedure Receive(AMessage: TValue); virtual;
    procedure SendAll(AMessage: TValue); virtual;
    procedure Send(AId: TValue; AMessage: TValue); virtual;
    procedure SendOthers(AMessage: TValue); virtual;
  end;

  IMVCBrMediator<T:Class> = interface
    ['{F4612E9C-45EC-4CD2-BEAE-81C03A2FCB3A}']
    procedure Release;
    function GetItems(idx: Integer): T;
    procedure SetItems(idx: Integer; const Value: T);
    function This: TObject;
    function Add(aValue: TMVCBrParticipant): Integer; overload;
    function Add: TMVCBrParticipant; overload;
    function Count: Integer;
    property Items[idx: Integer]: T read GetItems
      write SetItems;
    procedure Remove(idx: Integer);
    function DelegateTo(AFunc: TFunc<TMVCBrParticipant>): IMVCBrMediator<T>;
    Function SendAll(AMessage: TValue): Boolean;
    Function SendOthers(AIDTo: TValue; AMessage: TValue): Boolean;
    function Send(AIDTo: TValue; AMessage: TValue): Integer;
  end;

  TMVCBrMediator<T: Class> = class(TInterfacedObject, IMVCBrMediator<T>)
  private
    FDelegateTo: TFunc<TMVCBrParticipant>;
    FClass: TMVCBrParticipantClass;
    FInstance: TThreadList<T>;
  protected
    function Invoke: TThreadList<T>; virtual;
    function GetItems(idx: Integer): T; virtual;
    procedure SetItems(idx: Integer; const Value: T); virtual;
    procedure InternalDelete(AItem: T); virtual;
  public
    constructor Create(AClass: TMVCBrParticipantClass);
    class Function New(AClass: TMVCBrParticipantClass): IMVCBrMediator<T>;
    destructor Destroy; override;
    procedure ForEach(AFunc: TFunc<T, Boolean>);
    procedure ForEachDown(AFunc: TFunc<T, Boolean>);
    function This: TObject; virtual;
    procedure Clear; virtual;
    procedure Release; virtual;
    function DelegateTo(AFunc: TFunc<TMVCBrParticipant>): IMVCBrMediator<T>;
    function Add(aValue: TMVCBrParticipant): Integer; overload; virtual;
    function Add: TMVCBrParticipant; overload; virtual;
    function Count: Integer; virtual;
    property Items[idx: Integer]: T read GetItems
      write SetItems;
    procedure Remove(idx: Integer); virtual;
    Function SendAll(AMessage: TValue): Boolean; virtual;
    function Send(AIDTo: TValue; AMessage: TValue): Integer; virtual;
    Function SendOthers(AIDTo: TValue; AMessage: TValue): Boolean;
  end;

implementation

uses System.RTTI.Helper;

{ TMVCBrMediator<T> }

function TMVCBrMediator<T>.Add(aValue: TMVCBrParticipant): Integer;
begin
  aValue.FMediator := self;
  Invoke.Add(aValue);
  result := Count - 1;
end;

function TMVCBrMediator<T>.Add: TMVCBrParticipant;
begin
  if assigned(FDelegateTo) then
    result := FDelegateTo()
  else
    result := FClass.Create;
  Add(result);
end;

procedure TMVCBrMediator<T>.Clear;
var
  obj: T;
begin
  if assigned(FInstance) then
    with FInstance.LockList do
      try
        while Count > 0 do
        begin
          obj := Items[0];
          TMVCBrParticipant(obj).Release;
          freeAndNil(obj);
        end;
      finally
        FInstance.UnlockList;
      end;
end;

function TMVCBrMediator<T>.Count: Integer;
begin
  with Invoke do
    with LockList do
      try
        result := Count;
      finally
        FInstance.UnlockList;
      end;
end;

constructor TMVCBrMediator<T>.Create(AClass: TMVCBrParticipantClass);
begin
  inherited Create;
  FClass := AClass;
  if not assigned(FClass) then
    FClass := TMVCBrParticipant;
end;

function TMVCBrMediator<T>.DelegateTo(AFunc: TFunc<TMVCBrParticipant>)
  : IMVCBrMediator<T>;
begin
  FDelegateTo := AFunc;
end;

destructor TMVCBrMediator<T>.Destroy;
begin
  Clear;
  if assigned(FInstance) then
    FInstance.DisposeOf;
  inherited;
end;

procedure TMVCBrMediator<T>.ForEach(AFunc: TFunc<T, Boolean>);
var
  i: Integer;
begin
  if assigned(FInstance) and assigned(AFunc) then
    with FInstance.LockList do
      try
        for i := 0 to Count - 1 do
          if AFunc(Items[i]) then
            break;
      finally
        FInstance.UnlockList;
      end;
end;

procedure TMVCBrMediator<T>.ForEachDown
  (AFunc: TFunc<T, Boolean>);
var
  i: Integer;
begin
  if assigned(FInstance) and assigned(AFunc) then
    with FInstance.LockList do
      try
        for i := Count - 1 downto 0 do
          if AFunc(Items[i]) then
            break;
      finally
        FInstance.UnlockList;
      end;
end;

function TMVCBrMediator<T>.GetItems(idx: Integer): T;
begin
  result := nil;
  if assigned(FInstance) then
    with FInstance.LockList do
      try
        result := Items[idx];
      finally
        FInstance.UnlockList;
      end;

end;

procedure TMVCBrMediator<T>.InternalDelete(AItem: T);
var
  i: Integer;
begin
  if assigned(FInstance) then
    with FInstance.LockList do
      try
        i := IndexOf(AItem);
        if i >= 0 then
          delete(i);
      finally
        FInstance.UnlockList;
      end;
end;

function TMVCBrMediator<T>.Invoke: TThreadList<T>;
begin
  if not assigned(FInstance) then
    FInstance := TThreadList<T>.Create;
  result := FInstance;
end;

class function TMVCBrMediator<T>.New(AClass: TMVCBrParticipantClass)
  : IMVCBrMediator<T>;
begin
  result := TMVCBrMediator<T>.Create(AClass);
end;

procedure TMVCBrMediator<T>.Release;
var
  i: Integer;
begin
  if assigned(FInstance) then
    with FInstance.LockList do
      try
        for i := Count - 1 Downto 0 do
          TMVCBrParticipant(Items[i]).Release;
      finally
        FInstance.UnlockList;
      end;
  Clear;
end;

procedure TMVCBrMediator<T>.Remove(idx: Integer);
var
  obj: T;
begin
  if assigned(FInstance) then
    with FInstance.LockList do
      try
        obj := Items[idx];
        TMVCBrParticipant(obj).Release;
        obj.DisposeOf;
      finally
        FInstance.UnlockList;
      end;
end;

function TMVCBrMediator<T>.Send(AIDTo, AMessage: TValue): Integer;
begin
  ForEach(
    function(item: T): Boolean
    begin
      with TMVCBrParticipant(Item) do
      if AIDTo.Equals(ID) then
      begin
        Receive(AMessage);
        result := true; // break;
      end;
    end);

end;

function TMVCBrMediator<T>.SendAll(AMessage: TValue): Boolean;
begin
  ForEach(
    function(item: T): Boolean
    begin
     TMVCBrParticipant(item).Receive(AMessage);
    end);
end;

function TMVCBrMediator<T>.SendOthers(AIDTo, AMessage: TValue): Boolean;
begin
  ForEach(
    function(item: T): Boolean
    begin
      with TMVCBrParticipant(Item) do
      if not ID.Equals(AIDTo) then
        Receive(AMessage);
    end);
end;

procedure TMVCBrMediator<T>.SetItems(idx: Integer;
const Value: T);
begin
  if assigned(FInstance) then
    with FInstance.LockList do
      try
        Items[idx] := Value;
      finally
        FInstance.UnlockList;
      end;
end;

function TMVCBrMediator<T>.This: TObject;
begin
  result := self;
end;

{ TMVCBrParticipant }

constructor TMVCBrParticipant.Create;
begin
  inherited Create;
  FID := TGuid.NewGuid.ToString;
end;

destructor TMVCBrParticipant.Destroy;
begin
  if assigned(FMediator) then
    Mediator.InternalDelete(self);
  inherited;
end;

function TMVCBrParticipant.Mediator: TMVCBrMediator<TMVCBrParticipant>;
begin
  result := TMVCBrMediator<TMVCBrParticipant>(FMediator);
end;

procedure TMVCBrParticipant.Release;
begin

end;

procedure TMVCBrParticipant.Receive(AMessage: TValue);
begin

end;

procedure TMVCBrParticipant.Send(AId, AMessage: TValue);
begin
  if AId.Equals(ID) then
    Receive(AMessage)
  else
    Mediator.Send(AId, AMessage);
end;

procedure TMVCBrParticipant.SendAll(AMessage: TValue);
begin
  Receive(AMessage);
  SendOthers(AMessage);
end;

procedure TMVCBrParticipant.SendOthers(AMessage: TValue);
begin
  if assigned(FMediator) then
    Mediator.SendOthers(ID, AMessage);
end;

procedure TMVCBrParticipant.SetID(const Value: TValue);
begin
  FID := Value;
end;

end.
