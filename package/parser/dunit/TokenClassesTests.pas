unit TokenClassesTests;

interface

uses
  TestFrameWork,
  TokenClasses,
  TokenInterfaces;

type
  TUnitTests = class(TTestCase)
  protected
    FUnit: IUnit;
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestUnit;
    procedure TestAddInterface;
    procedure TestAddFunction;
  end;

implementation

{ TUnitTests }

procedure TUnitTests.SetUp;
begin
  FUnit := CreateUnit;
end;

procedure TUnitTests.TearDown;
begin
  FUnit := nil;
end;

procedure TUnitTests.TestUnit;
begin
  Check(Assigned(FUnit), 'FUnit not assigned');
  Check(Assigned(FUnit.Interfaces), 'Interfaces not assigned');
end;

procedure TUnitTests.TestAddInterface;
var
  AIntf, BIntf: IInterfaceType;
begin
  AIntf := FUnit.Interfaces.Add;
  Check(Assigned(AIntf), 'First Interface not created properly');
  AIntf.Name := 'AIntf';
  BIntf := FUnit.Interfaces.Add;
  Check(Assigned(BIntf), 'Second Interface not created properly');
  BIntf.Name := 'BIntf';
  AIntf := nil;
  BIntf := nil;
  Check(Assigned(FUnit.Interfaces), 'Interfaces freed prematurely');
  CheckEquals(2, FUnit.Interfaces.Count, 'Interface Count incorrect');
  Check(Assigned(FUnit.Interfaces[0]), 'First Interface not assigned');
  CheckEquals('AIntf', FUnit.Interfaces[0].Name, 'First Interface freed prematurely');
  Check(Assigned(FUnit.Interfaces[1]), 'Second Interface not assigned');
  CheckEquals('BIntf', FUnit.Interfaces[1].Name, 'Second Interface freed prematurely');
end;

procedure TUnitTests.TestAddFunction;
var
  AIntf: IInterfaceType;
  AFunc, BFunc: IFunction;
begin
  AIntf := FUnit.Interfaces.Add;
  AFunc := AIntf.Functions.Add;
  AFunc.Name := 'AFunc';
  Check(Assigned(AFunc), 'AFunc not created correctly');
  BFunc := AIntf.Functions.Add;
  BFunc.Name := 'BFunc';
  Check(Assigned(BFunc), 'BFunc not created correctly');
  AFunc := nil;
  BFunc := nil;
  CheckEquals(AIntf.Functions.Count, 2, 'Function Count incorrect');
  Check(Assigned(AIntf.Functions[0]), 'First Function not assigned');
  CheckEquals('AFunc', AIntf.Functions[0].Name, 'First Function freed prematurely');
  Check(Assigned(AIntf.Functions[1]), 'Second Function not assigned');
  CheckEquals('BFunc', AIntf.Functions[1].Name, 'Second Function freed prematurely');
end;

initialization
  RegisterTest('Token Classes Tests', TUnitTests.Suite);

end.
