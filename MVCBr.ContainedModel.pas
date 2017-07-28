unit MVCBr.ContainedModel;

interface

uses
  System.Classes, System.Sysutils,
  System.Generics.Collections,
  System.ThreadSafe, MVCBr.Interf, MVCBr.Model;

type

  TMVCBrContainedModelFactory<T: IModel> = class(TModelFactory)
  private
    FList: TThreadSafeInterfaceList<T>;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Release; override;
    function LockList: TList<T>; virtual;
    procedure UnLockList; virtual;
    property Default: TThreadSafeInterfaceList<T> read FList;
    function Add( AModel:T ):Integer;
  end;

implementation

{ TMVCBrContainedModel<T> }

function TMVCBrContainedModelFactory<T>.Add(AModel: T): Integer;
begin
  result := FList.add(AModel);
end;

constructor TMVCBrContainedModelFactory<T>.Create;
begin
  inherited;
  FList := TThreadSafeInterfaceList<T>.Create;
end;

destructor TMVCBrContainedModelFactory<T>.Destroy;
begin
  Release;
  FList.free;
  FList := nil;
  inherited;
end;

function TMVCBrContainedModelFactory<T>.LockList: TList<T>;
begin
  result := FList.LockList;
end;

procedure TMVCBrContainedModelFactory<T>.Release;
var i:integer;
begin
    for I :=  FList.count-1 downto 0 do
      begin
         FList.items[i].release;
         FList.items[i] := nil;
         FList.delete(i);
      end;
end;

procedure TMVCBrContainedModelFactory<T>.UnLockList;
begin
  FList.UnLockList;
end;

end.
