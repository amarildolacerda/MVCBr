unit TestMVCBr.Patterns.Adapter;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils, System.Classes,
  MVCBr.Patterns.Adapter;

type
  [TestFixture]
  TestTMVCBrAdapter = class
  public
    [Test]
    procedure Adapter_ReturnsSameObject;
    [Test]
    procedure This_ReturnsSelf;
    [Test]
    procedure SetInstance_ReplacesAdapter;
  end;

implementation

{ TestTMVCBrAdapter }

procedure TestTMVCBrAdapter.Adapter_ReturnsSameObject;
var
  LSL: TStringList;
  LObj: TMVCBrAdapter<TStringList>;
begin
  LSL := TStringList.Create;
  LObj := TMVCBrAdapter<TStringList>.Create(LSL, False);
  LObj.FreeOnExit := False;
  Assert.IsTrue(LSL = LObj.Adapter,
    'Adapter should return same object');
  LObj.Free;
  LSL.Free;
end;

procedure TestTMVCBrAdapter.This_ReturnsSelf;
var
  LSL: TStringList;
  LObj: TMVCBrAdapter<TStringList>;
begin
  LSL := TStringList.Create;
  LObj := TMVCBrAdapter<TStringList>.Create(LSL, False);
  LObj.FreeOnExit := False;
  Assert.IsNotNull(LObj.This, 'This should return TObject');
  LObj.Free;
  LSL.Free;
end;

procedure TestTMVCBrAdapter.SetInstance_ReplacesAdapter;
var
  LSL1, LSL2: TStringList;
  LObj: TMVCBrAdapter<TStringList>;
begin
  LSL1 := TStringList.Create;
  LSL2 := TStringList.Create;
  LObj := TMVCBrAdapter<TStringList>.Create(LSL1, False);
  LObj.FreeOnExit := False;
  LObj.SetInstance(LSL2, False);
  Assert.IsTrue(LSL2 = LObj.Adapter,
    'SetInstance should replace adapter');
  LObj.Free;
  LSL1.Free;
  LSL2.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTMVCBrAdapter);
end.
