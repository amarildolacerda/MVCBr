unit TestMVCBr.IoC;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  MVCBr.Interf;

type

  ITestIoCInterface = interface(IMVCBrIOC)
    ['{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}']
    function GetValue: Integer;
    procedure SetValue(AValue: Integer);
  end;

  ITestIoCInterface2 = interface(IMVCBrIOC)
    ['{B2C3D4E5-F6A7-8901-BCDE-F12345678901}']
    function GetName: string;
  end;

  TTestIoCClass = class(TInterfacedObject, ITestIoCInterface)
  private
    FValue: Integer;
  public
    function GetValue: Integer;
    procedure SetValue(AValue: Integer);
    procedure release;
  end;

  TTestIoCClass2 = class(TInterfacedObject, ITestIoCInterface2)
  public
    function GetName: string;
    procedure release;
  end;

  [TestFixture]
  TestTMVCBrIoC = class
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure RegisterInterfaced_Singleton_ReturnsSameInstance;
    [Test]
    procedure RegisterInterfaced_Transient_ReturnsDifferentInstances;
    [Test]
    procedure RegisterInterfaced_WithGuid_ResolvesByInterface;
    [Test]
    procedure ResolveInterfaced_Registered_ReturnsInstance;
    [Test]
    procedure ResolveInterfaced_NotRegistered_ReturnsNil;
    [Test]
    procedure Revoke_Singleton_ClearsInstance;
    [Test]
    procedure Clear_RemovesAllRegistrations;
    [Test]
    procedure HasService_Registered_ReturnsTrue;
    [Test]
    procedure HasService_NotRegistered_ReturnsFalse;
    [Test]
    procedure RegisterType_WithDelegate_ResolvesInstance;
    [Test]
    procedure ResolveInterfaced_Named_RegistersSeparately;
  end;

implementation

uses
  MVCBr.IoC;

{ TTestIoCClass }

function TTestIoCClass.GetValue: Integer;
begin
  result := FValue;
end;

procedure TTestIoCClass.SetValue(AValue: Integer);
begin
  FValue := AValue;
end;

procedure TTestIoCClass.release;
begin
  // ARC release
end;

{ TTestIoCClass2 }

function TTestIoCClass2.GetName: string;
begin
  result := 'TestIoC';
end;

procedure TTestIoCClass2.release;
begin
  // ARC release
end;

{ TestTMVCBrIoC }

procedure TestTMVCBrIoC.SetUp;
begin
  TMVCBrIoC.DefaultContainer.Clear;
end;

procedure TestTMVCBrIoC.TearDown;
begin
  TMVCBrIoC.DefaultContainer.Clear;
end;

procedure TestTMVCBrIoC.RegisterInterfaced_Singleton_ReturnsSameInstance;
var
  LInstance1: ITestIoCInterface;
  LInstance2: ITestIoCInterface;
begin
  TMVCBr.RegisterInterfaced<ITestIoCInterface>(
    'TestIoC', ITestIoCInterface, TTestIoCClass, True);

  LInstance1 := TMVCBr.ResolveInterfaced<ITestIoCInterface>('TestIoC');
  LInstance2 := TMVCBr.ResolveInterfaced<ITestIoCInterface>('TestIoC');

  Assert.IsNotNull(LInstance1);
  Assert.IsNotNull(LInstance2);
  Assert.AreSame(LInstance1 as TObject, LInstance2 as TObject,
    'Singleton deve retornar a mesma instância');
end;

procedure TestTMVCBrIoC.RegisterInterfaced_Transient_ReturnsDifferentInstances;
var
  LInstance1: ITestIoCInterface;
  LInstance2: ITestIoCInterface;
begin
  TMVCBr.RegisterInterfaced<ITestIoCInterface>(
    'TestIoC', ITestIoCInterface, TTestIoCClass, False);

  LInstance1 := TMVCBr.ResolveInterfaced<ITestIoCInterface>('TestIoC');
  LInstance2 := TMVCBr.ResolveInterfaced<ITestIoCInterface>('TestIoC');

  Assert.IsNotNull(LInstance1);
  Assert.IsNotNull(LInstance2);
  Assert.AreNotSame(LInstance1 as TObject, LInstance2 as TObject,
    'Transient deve retornar instâncias diferentes');
end;

procedure TestTMVCBrIoC.RegisterInterfaced_WithGuid_ResolvesByInterface;
var
  LInstance: ITestIoCInterface;
  LGUID: TGUID;
begin
  LGUID := ITestIoCInterface;
  TMVCBr.RegisterInterfaced<ITestIoCInterface>(
    'TestIoC', LGUID, TTestIoCClass, True);

  LInstance := TMVCBr.ResolveInterfaced<ITestIoCInterface>('TestIoC');

  Assert.IsNotNull(LInstance);
  Assert.AreEqual(0, LInstance.GetValue,
    'Instância deve ser criada com valor padrão');
end;

procedure TestTMVCBrIoC.ResolveInterfaced_Registered_ReturnsInstance;
var
  LInstance: ITestIoCInterface;
begin
  TMVCBr.RegisterInterfaced<ITestIoCInterface>(
    'TestIoC', ITestIoCInterface, TTestIoCClass, True);

  LInstance := TMVCBr.ResolveInterfaced<ITestIoCInterface>('TestIoC');

  Assert.IsNotNull(LInstance);
end;

procedure TestTMVCBrIoC.ResolveInterfaced_NotRegistered_ReturnsNil;
var
  LInstance: ITestIoCInterface;
begin
  LInstance := TMVCBr.ResolveInterfaced<ITestIoCInterface>('NaoExiste');

  Assert.IsNull(LInstance, 'Resolve de interface não registrada deve retornar nil');
end;

procedure TestTMVCBrIoC.Revoke_Singleton_ClearsInstance;
var
  LInstance1: ITestIoCInterface;
  LInstance2: ITestIoCInterface;
  LGUID: TGUID;
begin
  LGUID := ITestIoCInterface;
  TMVCBr.RegisterInterfaced<ITestIoCInterface>(
    'TestIoC', LGUID, TTestIoCClass, True);

  LInstance1 := TMVCBr.ResolveInterfaced<ITestIoCInterface>('TestIoC');
  Assert.IsNotNull(LInstance1);

  TMVCBr.Revoke(LGUID);

  LInstance2 := TMVCBr.ResolveInterfaced<ITestIoCInterface>('TestIoC');
  Assert.IsNotNull(LInstance2, 'Revoke deve permitir nova criação');

  LInstance1 := nil;
  LInstance2 := nil;
end;

procedure TestTMVCBrIoC.Clear_RemovesAllRegistrations;
var
  LInstance: ITestIoCInterface;
begin
  TMVCBr.RegisterInterfaced<ITestIoCInterface>(
    'TestIoC', ITestIoCInterface, TTestIoCClass, True);

  TMVCBrIoC.DefaultContainer.Clear;

  LInstance := TMVCBr.ResolveInterfaced<ITestIoCInterface>('TestIoC');
  Assert.IsNull(LInstance, 'Clear deve remover todos os registros');
end;

procedure TestTMVCBrIoC.HasService_Registered_ReturnsTrue;
begin
  TMVCBr.RegisterInterfaced<ITestIoCInterface>(
    'TestIoC', ITestIoCInterface, TTestIoCClass, True);

  Assert.IsTrue(
    TMVCBrIoC.DefaultContainer.HasService<ITestIoCInterface>('TestIoC'),
    'HasService deve retornar True para interface registrada');
end;

procedure TestTMVCBrIoC.HasService_NotRegistered_ReturnsFalse;
begin
  Assert.IsFalse(
    TMVCBrIoC.DefaultContainer.HasService<ITestIoCInterface>('NaoExiste'),
    'HasService deve retornar False para interface não registrada');
end;

procedure TestTMVCBrIoC.RegisterType_WithDelegate_ResolvesInstance;
var
  LInstance: ITestIoCInterface;
  LDelegate: TActivatorDelegate<ITestIoCInterface>;
begin
  LDelegate := function: ITestIoCInterface
  begin
    result := TTestIoCClass.Create;
  end;

  TMVCBrIoC.DefaultContainer.RegisterType<ITestIoCInterface>(LDelegate, 'TestDelegate');

  LInstance := TMVCBrIoC.DefaultContainer.Resolve<ITestIoCInterface>('TestDelegate');

  Assert.IsNotNull(LInstance, 'Resolve com delegate deve retornar instância');
end;

procedure TestTMVCBrIoC.ResolveInterfaced_Named_RegistersSeparately;
var
  LInstance1: ITestIoCInterface;
  LInstance2: ITestIoCInterface;
begin
  TMVCBr.RegisterInterfaced<ITestIoCInterface>(
    'Teste1', ITestIoCInterface, TTestIoCClass, True);
  TMVCBr.RegisterInterfaced<ITestIoCInterface>(
    'Teste2', ITestIoCInterface, TTestIoCClass, True);

  LInstance1 := TMVCBr.ResolveInterfaced<ITestIoCInterface>('Teste1');
  LInstance2 := TMVCBr.ResolveInterfaced<ITestIoCInterface>('Teste2');

  Assert.IsNotNull(LInstance1);
  Assert.IsNotNull(LInstance2);
  LInstance1.SetValue(10);
  Assert.AreEqual(10, LInstance1.GetValue);
  Assert.AreEqual(0, LInstance2.GetValue,
    'Registros devem ser independentes');
end;

initialization

TDUnitX.RegisterTestFixture(TestTMVCBrIoC);

end.
