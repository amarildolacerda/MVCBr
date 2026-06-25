unit TestMVCBr.Patterns.Builder;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils, System.Classes, System.Rtti,
  MVCBr.Patterns.Builder;

type
  [TestFixture]
  TestTMVCBrBuilder = class
  private
    FBuilder: TMVCBrBuilder<string, string>;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure New_CreatesInstance;
    [Test]
    procedure Add_WithCommandAndDelegate_AddsItem;
    [Test]
    procedure Count_AfterAdd_ReturnsOne;
    [Test]
    procedure Execute_WithCommand_ReturnsResult;
    [Test]
    procedure This_ReturnsSelf;
  end;

  [TestFixture]
  TestTMVCBrBuilderFactory = class
  public
    [Test]
    procedure New_ReturnsInterface;
    [Test]
    procedure Add_AndExecute_Works;
  end;

  [TestFixture]
  TestTMVCBrBuilderLazy = class
  public
    [Test]
    procedure Add_WithClass_CreatesItem;
    [Test]
    procedure Query_ReturnsInstance;
  end;

implementation

{ TestTMVCBrBuilder }

procedure TestTMVCBrBuilder.SetUp;
begin
  FBuilder := TMVCBrBuilder<string, string>.New;
end;

procedure TestTMVCBrBuilder.TearDown;
begin
  FBuilder.Free;
end;

procedure TestTMVCBrBuilder.New_CreatesInstance;
begin
  Assert.IsNotNull(FBuilder, 'New should create instance');
end;

procedure TestTMVCBrBuilder.Add_WithCommandAndDelegate_AddsItem;
var
  LItem: TMVCBrBuilderItem<string, string>;
begin
  LItem := FBuilder.Add('hello',
    function(AParam: string): string
    begin
      Result := 'Hello ' + AParam;
    end);
  Assert.IsNotNull(LItem, 'Add should return item');
  Assert.AreEqual(1, FBuilder.Count, 'Count should be 1');
end;

procedure TestTMVCBrBuilder.Count_AfterAdd_ReturnsOne;
begin
  FBuilder.Add('hello',
    function(AParam: string): string
    begin
      Result := 'Hello ' + AParam;
    end);
  Assert.AreEqual(1, FBuilder.Count);
end;

procedure TestTMVCBrBuilder.Execute_WithCommand_ReturnsResult;
begin
  FBuilder.Add('hello',
    function(AParam: string): string
    begin
      Result := 'Hello ' + AParam;
    end);
  Assert.AreEqual('Hello World', FBuilder.Execute('hello', 'World'));
end;

procedure TestTMVCBrBuilder.This_ReturnsSelf;
begin
  Assert.IsNotNull(FBuilder.This);
  Assert.IsTrue(FBuilder = FBuilder.This);
end;

{ TestTMVCBrBuilderFactory }

procedure TestTMVCBrBuilderFactory.New_ReturnsInterface;
var
  LFactory: IMVCBrBuilder<string, string>;
begin
  LFactory := TMVCBrBuilderFactory<string, string>.New;
  Assert.IsNotNull(LFactory, 'New should return interface');
end;

procedure TestTMVCBrBuilderFactory.Add_AndExecute_Works;
var
  LFactory: IMVCBrBuilder<string, string>;
begin
  LFactory := TMVCBrBuilderFactory<string, string>.New;
  LFactory.Add('hello',
    function(AParam: string): string
    begin
      Result := 'Hi ' + AParam;
    end);
  Assert.AreEqual('Hi There', LFactory.Execute('hello', 'There'));
end;

{ TestTMVCBrBuilderLazy }

procedure TestTMVCBrBuilderLazy.Add_WithClass_CreatesItem;
var
  LFactory: TMVCBrBuilderLazyFactory;
  LItem: TMVCBrBuilderLazyItem;
begin
  LFactory := TMVCBrBuilderLazyFactory.New;
  try
    LItem := LFactory.Add('test', TStringList);
    Assert.IsNotNull(LItem, 'Add should return item');
    Assert.AreEqual(1, LFactory.Count);
  finally
    LFactory.Free;
  end;
end;

procedure TestTMVCBrBuilderLazy.Query_ReturnsInstance;
var
  LFactory: TMVCBrBuilderLazyFactory;
  LSL: TStringList;
begin
  LFactory := TMVCBrBuilderLazyFactory.New;
  try
    LFactory.Add('test', TStringList);
    LSL := LFactory.Query<TStringList>('test');
    Assert.IsNotNull(LSL, 'Query should return instance');
    Assert.IsTrue(LSL is TStringList);
  finally
    LFactory.FreeAllInstances;
    LFactory.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTMVCBrBuilder);
  TDUnitX.RegisterTestFixture(TestTMVCBrBuilderFactory);
  TDUnitX.RegisterTestFixture(TestTMVCBrBuilderLazy);
end.
