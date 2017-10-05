unit TestMVCBr.Patterns.Singleton;

interface

uses
  TestFramework, System.SysUtils,
  System.Classes,
  MVCBr.Patterns.Singleton;

type

  TClasseSingleton = class
  public
    Value: integer;
    procedure SetValue(v: integer);
  end;

  TestTMVCBrSingleton = class(TTestCase)
  private
    FInstance: TMVCBrSingleton<TClasseSingleton>;
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestNew;
    procedure TestDefault;
    procedure TestRelease;
    procedure TestProcedureOfClassSingleted;
  end;

implementation

{ TestTMVCBrPrototype }

procedure TestTMVCBrSingleton.SetUp;
begin
  inherited;
  FInstance := TMVCBrSingleton<TClasseSingleton>.New();
end;

procedure TestTMVCBrSingleton.TearDown;
begin
  inherited;
  FInstance.free;
end;

procedure TestTMVCBrSingleton.TestDefault;
var
  FClasse: TClasseSingleton;
begin
  // raise Exception.Create('Error Message');

  FClasse := FInstance.Default;
  CheckNotNull(FClasse);

end;

procedure TestTMVCBrSingleton.TestNew;
begin
  // raise Exception.Create('Error Message');
  CheckNotNull(FInstance);
end;

procedure TestTMVCBrSingleton.TestProcedureOfClassSingleted;
begin
   FInstance.default.SetValue(10);
   CheckEquals( FInstance.default.value,10 );
end;

procedure TestTMVCBrSingleton.TestRelease;
begin
  // raise Exception.Create('Error Message');
  FInstance.Release;
  CheckNull(FInstance.InstanceWithoutInit);

end;

{ TClasseSingleton }

procedure TClasseSingleton.SetValue(v: integer);
begin
  Value := v;
end;

initialization

RegisterTest(TestTMVCBrSingleton.Suite);

end.
