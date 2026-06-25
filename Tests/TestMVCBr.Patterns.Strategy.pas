unit TestMVCBr.Patterns.Strategy;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils, System.Classes,
  MVCBr.Patterns.Strategy;

type
  [TestFixture]
  TestTMVCBrStrategy = class
  public
    [Test]
    procedure StrategyProperty_GetSet_Works;
    [Test]
    procedure This_ReturnsSelf;
    [Test]
    procedure Invoke_WithAssignedStrategy_ReturnsInstance;
  end;

implementation

{ TestTMVCBrStrategy }

procedure TestTMVCBrStrategy.StrategyProperty_GetSet_Works;
var
  LObj: TMVCBrStrategy<TStringList>;
  LSL: TStringList;
begin
  LSL := TStringList.Create;
  LObj := TMVCBrStrategy<TStringList>.Create;
  LObj.Strategy := LSL;
  Assert.IsTrue(LSL = LObj.Strategy,
    'Strategy property should return set value');
  LObj.Free;
end;

procedure TestTMVCBrStrategy.This_ReturnsSelf;
var
  LObj: TMVCBrStrategy<TStringList>;
begin
  LObj := TMVCBrStrategy<TStringList>.Create;
  Assert.IsNotNull(LObj.This, 'This should return TObject');
  Assert.IsTrue(LObj = LObj.This, 'This should return self');
  LObj.Free;
end;

procedure TestTMVCBrStrategy.Invoke_WithAssignedStrategy_ReturnsInstance;
var
  LObj: TMVCBrStrategy<TStringList>;
  LSL: TStringList;
begin
  LSL := TStringList.Create;
  LObj := TMVCBrStrategy<TStringList>.Create;
  LObj.Strategy := LSL;
  Assert.IsTrue(LSL = LObj.Strategy,
    'Invoke should return the assigned instance');
  LObj.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTMVCBrStrategy);
end.
