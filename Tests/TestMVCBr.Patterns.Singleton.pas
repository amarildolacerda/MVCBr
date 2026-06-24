unit TestMVCBr.Patterns.Singleton;

interface

uses
  DUnitX.TestFramework, System.SysUtils,
  System.Classes,
  MVCBr.Patterns.Singleton;

type

  TClasseSingleton = class
  public
    Value: integer;
    procedure SetValue(v: integer);
  end;

  TestTMVCBrSingleton = class
  private
    FInstance: TMVCBrSingleton<TClasseSingleton>;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestNew;
    [Test]
    procedure TestDefault;
    [Test]
    procedure TestRelease;
    [Test]
    procedure TestProcedureOfClassSingleted;
  end;

implementation

{ TestTMVCBrPrototype }

procedure TestTMVCBrSingleton.SetUp;
begin
  FInstance := TMVCBrSingleton<TClasseSingleton>.NewAsObject;
end;

procedure TestTMVCBrSingleton.TearDown;
begin
  FInstance.Release;
  FInstance.Free;
end;

procedure TestTMVCBrSingleton.TestDefault;
var
  FClasse: TClasseSingleton;
begin
  // raise Exception.Create('Error Message');

  FClasse := FInstance.Default;
  Assert.IsNotNull(FClasse);

end;

procedure TestTMVCBrSingleton.TestNew;
begin
  // raise Exception.Create('Error Message');
  Assert.IsNotNull(FInstance);
end;

procedure TestTMVCBrSingleton.TestProcedureOfClassSingleted;
begin
   FInstance.default.SetValue(10);
   Assert.AreEqual( FInstance.default.value,10 );
end;

procedure TestTMVCBrSingleton.TestRelease;
begin
  // raise Exception.Create('Error Message');
  FInstance.Release;
  //Assert.IsNull(FInstance.InstanceWithoutInit);

end;

{ TClasseSingleton }

procedure TClasseSingleton.SetValue(v: integer);
begin
  Value := v;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTMVCBrSingleton);
end.
