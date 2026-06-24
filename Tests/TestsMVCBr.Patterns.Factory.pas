unit TestsMVCBr.Patterns.Factory;

interface

uses
  DUnitX.TestFramework, System.SysUtils,
  System.Classes,
  MVCBr.Patterns.Factory;

type

  /// class to tester
  TClasse = class
  public
    Value: integer;
    procedure SetValue(v: integer);
  end;

  /// tests FactoryClass
  TestTMVCBrFactory = class
  private
    FInstance: TMVCBrFactoryClass<TClasse>;
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
    procedure TestProcedureOfClass;
  end;

implementation

{ TestTMVCBrPrototype }

procedure TestTMVCBrFactory.SetUp;
begin
  FInstance := TMVCBrFactoryClass<TClasse>.New();
end;

procedure TestTMVCBrFactory.TearDown;
begin
  FInstance.free;
end;

procedure TestTMVCBrFactory.TestDefault;
var
  FClasse: TClasse;
begin
  // raise Exception.Create('Error Message');

  FClasse := FInstance.Default;
  Assert.IsNotNull(FClasse);

end;

procedure TestTMVCBrFactory.TestNew;
begin
  // raise Exception.Create('Error Message');
  Assert.IsNotNull(FInstance);
end;

procedure TestTMVCBrFactory.TestProcedureOfClass;
begin
  FInstance.Default.SetValue(10);
  Assert.AreEqual(FInstance.Default.Value, 10);
end;

procedure TestTMVCBrFactory.TestRelease;
begin
  // raise Exception.Create('Error Message');
  FInstance.Release;
  //Assert.IsNull(FInstance.InstanceWithoutInit);

end;

{ TClasseSingleton }

procedure TClasse.SetValue(v: integer);
begin
  Value := v;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTMVCBrFactory);
end.
