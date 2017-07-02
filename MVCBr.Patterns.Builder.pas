unit MVCBr.Patterns.Builder;

interface

uses
  System.Classes, System.SysUtils,
  System.RTTI.Helper,
  System.RTTI, System.Generics.Collections;

type


  TMVCBrBuilderItem<T, TResult> = class;

   IMVCBrBuilderItem<T, TResult> = interface
    ['{0EA84140-4B56-494B-8C09-B39A3E7F400F}']
    procedure Release;
    function This: TObject;
    function Execute(AParam: T): IMVCBrBuilderItem<T, TResult>;
    function Response: TResult;
    end;


  TMVCBrBuilder<T, TResult> = class
  private
   [unsafe]
   [weak]
    FList: TThreadList<IMVCBrBuilderItem<T, TResult>>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    class function New: TMVCBrBuilder<T, TResult>; overload;
    class function New(ACommand: TValue; ABuilderFunc: TFunc<T, TResult>)
      : TMVCBrBuilder<T, TResult>; overload;
    function Add(ACommand: TValue; ABuilderFunc: TFunc<T, TResult>)
      : TMVCBrBuilderItem<T, TResult>; virtual;
    function Execute(ACommand: TValue; AParam: T)
      : IMVCBrBuilderItem<T, TResult>; virtual;
    function Query(ACommand: TValue): IMVCBrBuilderItem<T, TResult>; virtual;
    procedure Release; virtual;
    procedure Clear; virtual;
    function IndexOf(ACommand: TValue): Integer;
    procedure Remove(AItem: TMVCBrBuilderItem<T, TResult>); overload; virtual;
    procedure Remove(ACommand: TValue); overload; virtual;
    function Contains(ACommand: TValue): Boolean; virtual;
    function This: TObject; virtual;

  end;

  IMVCBrBuilder<T, TResult> = interface
    ['{1C86D407-8F67-411F-AEA8-D90BBC6AA91A}']
    procedure Release;
    function This: TObject;
    function Add(ACommand: TValue; ABuilderFunc: TFunc<T, TResult>)
      : IMVCBrBuilderItem<T, TResult>;
    function Query(ACommand: TValue): IMVCBrBuilderItem<T, TResult>;
    function Execute(ACommand: TValue; AParam: T)
      : IMVCBrBuilderItem<T, TResult>;
    function Contains(ACommand: TValue): Boolean;
    procedure Remove(ACommand: TValue);
  end;

  TMVCBrBuilderItem<T, TResult> = Class(TInterfacedObject,IMVCBrBuilderItem<T, TResult>)
  public
  private
    FCommand: TValue;
    FDelegate: TFunc<T, TResult>;
    FResult: TResult;
    [weak]
    FBuilder: TMVCBrBuilder<T, TResult>;
  public
    constructor Create(ABuilder: TMVCBrBuilder<T, TResult>; ACommand: TValue;
      ADelegate: TFunc<T, TResult>);
    destructor Destroy; override;
    class function New(ABuilder: TMVCBrBuilder<T, TResult>; ACommand: TValue;
      ADelegate: TFunc<T, TResult>): TMVCBrBuilderItem<T, TResult>;
    function Execute(AParam: T): IMVCBrBuilderItem<T, TResult>; virtual;
    function Response: TResult; virtual;
    procedure Release; virtual;
    function This: TObject; virtual;
    function ThisAs: TMVCBrBuilderItem<T, TResult>;
  end;

  TMVCBrBuilderFactory<T, TResult> = class(TInterfacedObject,
    IMVCBrBuilder<T, TResult>)
  private
   [weak]
    FWrapper: TMVCBrBuilder<T, TResult>;
  public
    constructor Create(AClass: TMVCBrBuilder<T, TResult>); virtual;
    destructor Destroy; override;
    class function New: IMVCBrBuilder<T, TResult>; virtual;
    function This: TObject; virtual;
    procedure Release; virtual;
    function Add(ACommand: TValue; ABuilderFunc: TFunc<T, TResult>)
      : IMVCBrBuilderItem<T, TResult>; virtual;
    function Execute(ACommand: TValue; AParam: T)
      : IMVCBrBuilderItem<T, TResult>; virtual;
    function Query(ACommand: TValue): IMVCBrBuilderItem<T, TResult>; virtual;
    procedure Remove(ACommand: TValue); overload; virtual;
    function Contains(ACommand: TValue): Boolean; virtual;
  end;

implementation

{ TMVCBrBuilderFactory<T> }

function TMVCBrBuilder<T, TResult>.Add(ACommand: TValue;
  ABuilderFunc: TFunc<T, TResult>): TMVCBrBuilderItem<T, TResult>;
begin
  result := TMVCBrBuilderItem<T, TResult>.New(self, ACommand, ABuilderFunc);
  FList.Add(result);
end;

procedure TMVCBrBuilder<T, TResult>.Clear;
begin
  Release;
  FList.Clear;
end;

constructor TMVCBrBuilder<T, TResult>.Create();
begin
  FList := TThreadList< IMVCBrBuilderItem < T, TResult >>.Create;
end;

destructor TMVCBrBuilder<T, TResult>.Destroy;
var
  i: Integer;
begin
  FList.free;
  FList := nil;
  inherited;
end;

function TMVCBrBuilder<T, TResult>.Contains(ACommand: TValue): Boolean;
begin

  try
    result := IndexOf(ACommand) >= 0;
  except
    /// workaround early freed interface
    result := false;
  end;
end;

class function TMVCBrBuilder<T, TResult>.New(ACommand: TValue;
  ABuilderFunc: TFunc<T, TResult>): TMVCBrBuilder<T, TResult>;
begin
  result := TMVCBrBuilder<T, TResult>.New;
  result.Add(ACommand, ABuilderFunc);
end;

function TMVCBrBuilder<T, TResult>.Query(ACommand: TValue)
  : IMVCBrBuilderItem<T, TResult>;
var
  i: Integer;
begin
  result := nil;
  i := IndexOf(ACommand);
  with FList.LockList do
    try
      if (i >= 0) and (i < FList.LockList.count) then
        result := items[i];
    finally
      FList.UnlockList;
    end;
end;

function TMVCBrBuilder<T, TResult>.Execute(ACommand: TValue; AParam: T)
  : IMVCBrBuilderItem<T, TResult>;
begin
  result := Query(ACommand);
  Assert(assigned(result), 'Builder Command not found');
  result.Execute(AParam)
end;

function TMVCBrBuilder<T, TResult>.IndexOf(ACommand: TValue): Integer;
var
  i: Integer;
begin
  i := -1;
  with FList.LockList do
    try
      for i := count - 1 downto 0 do
      begin
        if TMVCBrBuilderItem<T, TResult>(items[i].This).FCommand.Equals(ACommand)
        then
        begin
          result := i;
          exit;
        end;
      end;
    finally
      FList.UnlockList;
    end;
end;

class function TMVCBrBuilder<T, TResult>.New: TMVCBrBuilder<T, TResult>;
begin
  result := TMVCBrBuilder<T, TResult>.Create;
end;

procedure TMVCBrBuilder<T, TResult>.Release;
var
  i: Integer;
begin
  {
    with FList.LockList do
    try
    for i := count - 1 downto 0 do
    try
    items[i].Release;
    except
    /// workaround;
    end;
    finally
    FList.UnlockList;
    end;
  }
end;

procedure TMVCBrBuilder<T, TResult>.Remove(ACommand: TValue);
var
  i: Integer;
begin
  i := IndexOf(ACommand);
  if i >= 0 then
    with FList.LockList do
      try
        Delete(i);
      finally
        FList.UnlockList;
      end;
end;

procedure TMVCBrBuilder<T, TResult>.Remove
  (AItem: TMVCBrBuilderItem<T, TResult>);
begin
  try
    if Contains(AItem.FCommand) then
    begin
      AItem.Release;
      Remove(AItem.FCommand);
    end;
  except
    /// workaroud for early freed
  end;
end;

function TMVCBrBuilder<T, TResult>.This: TObject;
begin
  result := self;
end;

{ TMVCBrBuilderItem<T> }

destructor TMVCBrBuilderItem<T, TResult>.Destroy;
begin
  inherited;
end;

function TMVCBrBuilderItem<T, TResult>.Execute(AParam: T)
  : IMVCBrBuilderItem<T, TResult>;
begin
  result := self;
  FResult := FDelegate(AParam);
end;

class function TMVCBrBuilderItem<T, TResult>.New
  (ABuilder: TMVCBrBuilder<T, TResult>; ACommand: TValue;
  ADelegate: TFunc<T, TResult>): TMVCBrBuilderItem<T, TResult>;
begin
  result := TMVCBrBuilderItem<T, TResult>.Create(ABuilder, ACommand, ADelegate);
end;

constructor TMVCBrBuilderItem<T, TResult>.Create
  (ABuilder: TMVCBrBuilder<T, TResult>; ACommand: TValue;
  ADelegate: TFunc<T, TResult>);
begin
  inherited Create;
  FCommand := ACommand;
  FDelegate := ADelegate;
  FBuilder := ABuilder;
end;

procedure TMVCBrBuilderItem<T, TResult>.Release;
begin
  if assigned(FBuilder) then
    FBuilder.Remove(self);
  FBuilder := nil;

end;

function TMVCBrBuilderItem<T, TResult>.Response: TResult;
begin
  result := FResult;
end;

function TMVCBrBuilderItem<T, TResult>.This: TObject;
begin
  result := self;
end;

function TMVCBrBuilderItem<T, TResult>.ThisAs: TMVCBrBuilderItem<T, TResult>;
begin
  result := self;
end;

{ TMVCBrBuilderFactory<T, TResult> }

function TMVCBrBuilderFactory<T, TResult>.Add(ACommand: TValue;
  ABuilderFunc: TFunc<T, TResult>): IMVCBrBuilderItem<T, TResult>;
begin
  result := FWrapper.Add(ACommand, ABuilderFunc);
end;

function TMVCBrBuilderFactory<T, TResult>.Contains(ACommand: TValue): Boolean;
begin
  result := FWrapper.Contains(ACommand);
end;

constructor TMVCBrBuilderFactory<T, TResult>.Create
  (AClass: TMVCBrBuilder<T, TResult>);
begin
  inherited Create;
  FWrapper := AClass;
end;

destructor TMVCBrBuilderFactory<T, TResult>.Destroy;
begin
  if assigned(FWrapper) then
    FWrapper.free;
  inherited;
end;

function TMVCBrBuilderFactory<T, TResult>.Execute(ACommand: TValue; AParam: T)
  : IMVCBrBuilderItem<T, TResult>;
begin
  result := FWrapper.Execute(ACommand, AParam);
end;

class function TMVCBrBuilderFactory<T, TResult>.New: IMVCBrBuilder<T, TResult>;
begin
  result := TMVCBrBuilderFactory<T, TResult>.Create
    (TMVCBrBuilder<T, TResult>.Create);
end;

function TMVCBrBuilderFactory<T, TResult>.Query(ACommand: TValue)
  : IMVCBrBuilderItem<T, TResult>;
begin
  result := FWrapper.Query(ACommand);
end;

procedure TMVCBrBuilderFactory<T, TResult>.Release;
begin
  if assigned(FWrapper) then
    FWrapper.Release;
end;

procedure TMVCBrBuilderFactory<T, TResult>.Remove(ACommand: TValue);
begin
  FWrapper.Remove(ACommand);
end;

function TMVCBrBuilderFactory<T, TResult>.This: TObject;
begin
  result := self;
end;

end.
