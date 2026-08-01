unit TestMVCBr.BuilderModel;

interface

uses
  DUnitX.TestFramework, System.SysUtils, System.Classes, System.RTTI,
  MVCBr.Interf, MVCBr.BuilderModel, MVCBr.Patterns.Builder;

type
  TTestBuilderModel = class(TBuilderModelFactory)
  public
    procedure CreateSubClasses; override;
  end;

  TTestBuilderCommand = class(TMVCBrBuilderObject)
  public
    function Execute(AParam: TValue): TValue; override;
  end;

  [TestFixture]
  TestTBuilderModelFactory = class
  private
    FSut: TTestBuilderModel;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure Create_Default_ReturnsInstance;
    [Test]
    procedure This_ReturnsSelf;
    [Test]
    procedure GetID_ReturnsNonEmpty;
    [Test]
    procedure Builder_ReturnsInstance;
    [Test]
    procedure Builder_SameInstance_OnMultipleCalls;
    [Test]
    procedure Lazy_ReturnsInstance;
    [Test]
    procedure Add_Command_StoresIt;
    [Test]
    procedure Query_ByCommand_ReturnsObject;
    [Test]
    procedure Execute_Command_ReturnsValue;
    [Test]
    procedure FreeAllInstances_DoesNotRaise;
    [Test]
    procedure FreeInstance_DoesNotRaise;
    [Test]
    procedure Query_UnknownCommand_ReturnsNil;
  end;

implementation

{ TTestBuilderModel }

procedure TTestBuilderModel.CreateSubClasses;
begin
end;

{ TTestBuilderCommand }

function TTestBuilderCommand.Execute(AParam: TValue): TValue;
begin
  result := 'executed';
end;

{ TestTBuilderModelFactory }

procedure TestTBuilderModelFactory.SetUp;
begin
  FSut := TTestBuilderModel.Create;
end;

procedure TestTBuilderModelFactory.TearDown;
begin
  FSut.Free;
end;

procedure TestTBuilderModelFactory.Create_Default_ReturnsInstance;
begin
  Assert.IsNotNull(FSut, 'Should create instance');
  Assert.IsTrue(FSut is TTestBuilderModel, 'Should be TTestBuilderModel');
end;

procedure TestTBuilderModelFactory.This_ReturnsSelf;
var
  LObj: TObject;
begin
  LObj := FSut.This;
  Assert.IsNotNull(LObj, 'This should return a TObject');
  Assert.IsTrue(FSut = LObj, 'This should return self');
end;

procedure TestTBuilderModelFactory.GetID_ReturnsNonEmpty;
begin
  Assert.IsNotEmpty(FSut.GetID, 'GetID should not be empty after Create');
end;

procedure TestTBuilderModelFactory.Builder_ReturnsInstance;
begin
  Assert.IsNotNull(FSut.Builder, 'Builder should return instance');
end;

procedure TestTBuilderModelFactory.Builder_SameInstance_OnMultipleCalls;
begin
  Assert.AreSame(FSut.Builder, FSut.Builder,
    'Builder should be the same instance');
end;

procedure TestTBuilderModelFactory.Lazy_ReturnsInstance;
begin
  Assert.IsNotNull(FSut.Lazy, 'Lazy should return instance');
end;

procedure TestTBuilderModelFactory.Add_Command_StoresIt;
const
  CCmd = 'test';
var
  LResult: TMVCBrBuilderLazyItem;
begin
  LResult := FSut.Add(TValue.From<string>(CCmd), TTestBuilderCommand);
  Assert.IsNotNull(LResult, 'Add should return a builder item');
end;

procedure TestTBuilderModelFactory.Query_ByCommand_ReturnsObject;
const
  CCmd = 'findme';
var
  LResult: TMVCBrBuilderObject;
begin
  FSut.Add(TValue.From<string>(CCmd), TTestBuilderCommand);
  LResult := FSut.Query(TValue.From<string>(CCmd));
  Assert.IsNotNull(LResult, 'Query should find registered command');
  Assert.IsTrue(LResult is TTestBuilderCommand,
    'Query should return the correct type');
end;

procedure TestTBuilderModelFactory.Execute_Command_ReturnsValue;
const
  CCmd = 'exec';
var
  LResult: TValue;
begin
  FSut.Add(TValue.From<string>(CCmd), TTestBuilderCommand);
  LResult := FSut.Execute(TValue.From<string>(CCmd), TValue.From<string>(''));
  Assert.IsTrue(LResult.ToString = 'executed',
    'Execute should return the command result');
end;

procedure TestTBuilderModelFactory.FreeAllInstances_DoesNotRaise;
begin
  FSut.Add(TValue.From<string>('a'), TTestBuilderCommand);
  FSut.Add(TValue.From<string>('b'), TTestBuilderCommand);
  try
    FSut.FreeAllInstances;
    Assert.IsTrue(True, 'FreeAllInstances should not raise');
  except
    Assert.IsTrue(False, 'FreeAllInstances should not raise');
  end;
end;

procedure TestTBuilderModelFactory.FreeInstance_DoesNotRaise;
begin
  FSut.Add(TValue.From<string>('x'), TTestBuilderCommand);
  try
    FSut.FreeInstance(TValue.From<string>('x'));
    Assert.IsTrue(True, 'FreeInstance should not raise');
  except
    Assert.IsTrue(False, 'FreeInstance should not raise');
  end;
end;

procedure TestTBuilderModelFactory.Query_UnknownCommand_ReturnsNil;
var
  LResult: TMVCBrBuilderObject;
begin
  LResult := FSut.Query(TValue.From<string>('nonexistent'));
  Assert.IsNull(LResult, 'Query for unknown command should return nil');
end;

initialization
  TDUnitX.RegisterTestFixture(TestTBuilderModelFactory);
end.
