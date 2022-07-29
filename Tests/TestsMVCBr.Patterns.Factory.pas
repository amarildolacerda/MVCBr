unit TestsMVCBr.Patterns.Factory;

interface

uses
  TestFramework, System.SysUtils,
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
  TestTMVCBrFactory = class(TTestCase)
  private
    FInstance: TMVCBrFactoryClass<TClasse>;
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestNew;
    procedure TestDefault;
    procedure TestRelease;
    procedure TestProcedureOfClass;
  end;

implementation

{ TestTMVCBrPrototype }

procedure TestTMVCBrFactory.SetUp;
begin
  inherited;
  FInstance := TMVCBrFactoryClass<TClasse>.New();
end;

procedure TestTMVCBrFactory.TearDown;
begin
  inherited;
  FInstance.free;
end;

procedure TestTMVCBrFactory.TestDefault;
var
  FClasse: TClasse;
begin
  // raise Exception.Create('Error Message');

  FClasse := FInstance.Default;
  CheckNotNull(FClasse);

end;

procedure TestTMVCBrFactory.TestNew;
begin
  // raise Exception.Create('Error Message');
  CheckNotNull(FInstance);
end;

procedure TestTMVCBrFactory.TestProcedureOfClass;
begin
  FInstance.Default.SetValue(10);
  CheckEquals(FInstance.Default.Value, 10);
end;

procedure TestTMVCBrFactory.TestRelease;
begin
  // raise Exception.Create('Error Message');
  FInstance.Release;
  //CheckNull(FInstance.InstanceWithoutInit);

end;

{ TClasseSingleton }

procedure TClasse.SetValue(v: integer);
begin
  Value := v;
end;

initialization

RegisterTest(TestTMVCBrFactory.Suite);

end.
