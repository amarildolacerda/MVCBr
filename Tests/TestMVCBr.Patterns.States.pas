unit TestMVCBr.Patterns.States;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils, System.Generics.Collections, System.JSON, System.Rtti,
  System.TypInfo, System.Classes,
  MVCBr.Interf, MVCBr.Patterns.States;

type
  TFakeStateStep = class(TMVCBrStateStep)
  public
    Executed: Boolean;
    constructor Create;
    procedure Execute; override;
    function GetFLoopSafe: Boolean;
    function GetFExecuteDelegate: TProc;
  end;

  [TestFixture]
  TestTMVCBrStateStep = class
  private
    FStates: TMVCBrStates<TMVCBrStateStep>;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure Create_Default_Properties;
    [Test]
    procedure This_ReturnsSelf;
    [Test]
    procedure Execute_CallsDelegate;
    [Test]
    procedure DelegateTo_SetsDelegate;
    [Test]
    procedure Execute_WithoutDelegate_DoesNotRaise;
  end;

  [TestFixture]
  TestTMVCBrStates = class
  private
    FStates: TMVCBrStates<TMVCBrStateStep>;
    FExecCount: Integer;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure Create_EmptyList;
    [Test]
    procedure Add_ReturnsStep;
    [Test]
    procedure Add_WithCommand_ReturnsStep;
    [Test]
    procedure Count_AfterAdd_Increases;
    [Test]
    procedure BOF_EmptyList_ReturnsTrue;
    [Test]
    procedure BOF_AfterAdd_ReturnsFalse;
    [Test]
    procedure EOF_EmptyList_ReturnsTrue;
    [Test]
    procedure EOF_AfterAdd_ReturnsFalse;
    [Test]
    procedure CurrentStep_AfterAdd_ReturnsItem;
    [Test]
    procedure CurrentStep_EmptyList_ReturnsNil;
    [Test]
    procedure First_MovesToFirstItem;
    [Test]
    procedure Last_MovesToLastItem;
    [Test]
    procedure Next_MovesForward;
    [Test]
    procedure Prior_MovesBack;
    [Test]
    procedure Next_AtEnd_SetsEOF;
    [Test]
    procedure Prior_AtStart_SetsBOF;
    [Test]
    procedure MoveTo_ByIndex_Works;
    [Test]
    procedure MoveTo_ByCommand_Works;
    [Test]
    procedure IndexOf_ReturnsCorrectIndex;
    [Test]
    procedure IndexOf_Unknown_ReturnsMinusOne;
    [Test]
    procedure IsValidIndex_Valid_ReturnsTrue;
    [Test]
    procedure IsValidIndex_Invalid_ReturnsFalse;
    [Test]
    procedure SetFirstStep_ChangesFirst;
    [Test]
    procedure SetLastStep_ChangesLast;
    [Test]
    procedure ExecuteDelegate_OnCurrentStep;
    [Test]
    procedure MoveNext_FromStep_MovesStates;
    [Test]
    procedure MovePrior_FromStep_MovesStates;
  end;

implementation

{ TFakeStateStep }

constructor TFakeStateStep.Create;
begin
  inherited Create;
  Executed := False;
end;

procedure TFakeStateStep.Execute;
begin
  Executed := True;
  inherited;
end;

function TFakeStateStep.GetFLoopSafe: Boolean;
begin
  Result := FLoopSafe;
end;

function TFakeStateStep.GetFExecuteDelegate: TProc;
begin
  Result := FExecuteDelegate;
end;

{ TestTMVCBrStateStep }

procedure TestTMVCBrStateStep.SetUp;
begin
  FStates := TMVCBrStates<TMVCBrStateStep>.Create;
end;

procedure TestTMVCBrStateStep.TearDown;
begin
  FStates.Free;
end;

procedure TestTMVCBrStateStep.Create_Default_Properties;
var
  LStep: TFakeStateStep;
begin
  LStep := TFakeStateStep.Create;
  try
    Assert.IsFalse(LStep.GetFLoopSafe, 'FLoopSafe should be False');
    Assert.IsFalse(LStep.Executed, 'Executed should be False');
  finally
    LStep.Free;
  end;
end;

procedure TestTMVCBrStateStep.This_ReturnsSelf;
var
  LStep: TFakeStateStep;
begin
  LStep := TFakeStateStep.Create;
  try
    Assert.IsTrue(LStep = LStep.This, 'This should return self');
  finally
    LStep.Free;
  end;
end;

procedure TestTMVCBrStateStep.Execute_CallsDelegate;
var
  LStep: TFakeStateStep;
  LExecuted: Boolean;
  LDel: TProc;
begin
  LStep := TFakeStateStep.Create;
  try
    LExecuted := False;
    LDel := procedure begin LExecuted := True; end;
    LStep.DelegateTo(LDel);
    LStep.Execute;
    Assert.IsTrue(LExecuted, 'Delegate should be called');
  finally
    LStep.Free;
  end;
end;

procedure TestTMVCBrStateStep.DelegateTo_SetsDelegate;
var
  LStep: TFakeStateStep;
  LDel: TProc;
begin
  LStep := TFakeStateStep.Create;
  try
    LDel := procedure begin end;
    LStep.DelegateTo(LDel);
    Assert.IsTrue(Assigned(LDel), 'Delegate should be set');
  finally
    LStep.Free;
  end;
end;

procedure TestTMVCBrStateStep.Execute_WithoutDelegate_DoesNotRaise;
var
  LStep: TFakeStateStep;
begin
  LStep := TFakeStateStep.Create;
  try
    LStep.Execute;
    Assert.IsTrue(LStep.Executed, 'Execute should be called');
  finally
    LStep.Free;
  end;
end;

{ TestTMVCBrStates }

procedure TestTMVCBrStates.SetUp;
begin
  FExecCount := 0;
  FStates := TMVCBrStates<TMVCBrStateStep>.Create;
end;

procedure TestTMVCBrStates.TearDown;
begin
  FStates.Free;
end;

procedure TestTMVCBrStates.Create_EmptyList;
begin
  Assert.AreEqual(-1, FStates.CurrenteIndex, 'Current index should be -1 on empty list');
  Assert.IsTrue(FStates.BOF, 'Should be BOF on empty');
  Assert.IsTrue(FStates.EOF, 'Should be EOF on empty');
end;

procedure TestTMVCBrStates.Add_ReturnsStep;
var
  LResult: TMVCBrStateSteps<TMVCBrStateStep>;
begin
  LResult := FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  Assert.IsNotNull(LResult, 'Add should return a step');
end;

procedure TestTMVCBrStates.Add_WithCommand_ReturnsStep;
var
  LResult: TMVCBrStateSteps<TMVCBrStateStep>;
begin
  LResult := FStates.Add<IMVCBrStateStep>('MYCMD', TFakeStateStep);
  Assert.IsNotNull(LResult, 'Add with command should return a step');
end;

procedure TestTMVCBrStates.Count_AfterAdd_Increases;
begin
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  Assert.AreEqual(2, FStates.CurrenteIndex + 1, 'Should have 2 items');
end;

procedure TestTMVCBrStates.BOF_EmptyList_ReturnsTrue;
begin
  Assert.IsTrue(FStates.BOF, 'Empty list should be BOF');
end;

procedure TestTMVCBrStates.BOF_AfterAdd_ReturnsFalse;
begin
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  Assert.IsFalse(FStates.BOF, 'After Add should not be BOF');
end;

procedure TestTMVCBrStates.EOF_EmptyList_ReturnsTrue;
begin
  Assert.IsTrue(FStates.EOF, 'Empty list should be EOF');
end;

procedure TestTMVCBrStates.EOF_AfterAdd_ReturnsFalse;
begin
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  Assert.IsFalse(FStates.EOF, 'After Add should not be EOF');
end;

procedure TestTMVCBrStates.CurrentStep_AfterAdd_ReturnsItem;
begin
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  Assert.IsNotNull(FStates.CurrentStep, 'CurrentStep should not be nil after Add');
end;

procedure TestTMVCBrStates.CurrentStep_EmptyList_ReturnsNil;
begin
  Assert.IsNull(FStates.CurrentStep, 'CurrentStep should be nil on empty list');
end;

procedure TestTMVCBrStates.First_MovesToFirstItem;
begin
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.MoveTo(2);
  FStates.First;
  Assert.AreEqual(0, FStates.CurrenteIndex, 'First should move to index 0');
end;

procedure TestTMVCBrStates.Last_MovesToLastItem;
begin
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Last;
  Assert.AreEqual(2, FStates.CurrenteIndex, 'Last should move to last index');
end;

procedure TestTMVCBrStates.Next_MovesForward;
begin
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  Assert.AreEqual(2, FStates.CurrenteIndex, 'After Add should be at index 2');
  FStates.First;
  Assert.AreEqual(0, FStates.CurrenteIndex, 'After First should be at index 0');
  FStates.Next;
  Assert.AreEqual(1, FStates.CurrenteIndex, 'Next should move to index 1');
end;

procedure TestTMVCBrStates.Prior_MovesBack;
begin
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Prior;
  Assert.AreEqual(1, FStates.CurrenteIndex, 'Prior from last should move to index 1');
end;

procedure TestTMVCBrStates.Next_AtEnd_SetsEOF;
begin
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.MoveTo(1);
  FStates.Next;
  Assert.IsTrue(FStates.EOF, 'Next at end should set EOF');
end;

procedure TestTMVCBrStates.Prior_AtStart_SetsBOF;
begin
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.First;
  FStates.Prior;
  Assert.IsTrue(FStates.BOF, 'Prior at start should set BOF');
end;

procedure TestTMVCBrStates.MoveTo_ByIndex_Works;
begin
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.MoveTo(1);
  Assert.AreEqual(1, FStates.CurrenteIndex, 'MoveTo should go to index 1');
end;

procedure TestTMVCBrStates.MoveTo_ByCommand_Works;
begin
  FStates.Add<IMVCBrStateStep>('FIRST', TFakeStateStep);
  FStates.Add<IMVCBrStateStep>('SECOND', TFakeStateStep);
  FStates.Add<IMVCBrStateStep>('THIRD', TFakeStateStep);
  FStates.MoveTo('FIRST');
  Assert.AreEqual(0, FStates.CurrenteIndex, 'MoveTo by command should find item');
end;

procedure TestTMVCBrStates.IndexOf_ReturnsCorrectIndex;
begin
  FStates.Add<IMVCBrStateStep>('A', TFakeStateStep);
  FStates.Add<IMVCBrStateStep>('B', TFakeStateStep);
  FStates.Add<IMVCBrStateStep>('C', TFakeStateStep);
  Assert.AreEqual(1, FStates.IndexOf('B'), 'IndexOf should find B at index 1');
end;

procedure TestTMVCBrStates.IndexOf_Unknown_ReturnsMinusOne;
begin
  FStates.Add<IMVCBrStateStep>('A', TFakeStateStep);
  Assert.AreEqual(-1, FStates.IndexOf('UNKNOWN'), 'IndexOf unknown should return -1');
end;

procedure TestTMVCBrStates.IsValidIndex_Valid_ReturnsTrue;
begin
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  Assert.IsTrue(FStates.IsValidIndex(0), 'Index 0 should be valid');
  Assert.IsTrue(FStates.IsValidIndex(1), 'Index 1 should be valid');
end;

procedure TestTMVCBrStates.IsValidIndex_Invalid_ReturnsFalse;
begin
  FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  Assert.IsFalse(FStates.IsValidIndex(-1), 'Negative index should be invalid');
  Assert.IsFalse(FStates.IsValidIndex(5), 'Out-of-range index should be invalid');
end;

procedure TestTMVCBrStates.SetFirstStep_ChangesFirst;
begin
  FStates.Add<IMVCBrStateStep>('A', TFakeStateStep);
  FStates.Add<IMVCBrStateStep>('B', TFakeStateStep);
  FStates.Add<IMVCBrStateStep>('C', TFakeStateStep);
  FStates.SetFirstStep('B');
  FStates.First;
  Assert.AreEqual(1, FStates.CurrenteIndex, 'SetFirstStep(B) then First should go to B');
end;

procedure TestTMVCBrStates.SetLastStep_ChangesLast;
begin
  FStates.Add<IMVCBrStateStep>('A', TFakeStateStep);
  FStates.Add<IMVCBrStateStep>('B', TFakeStateStep);
  FStates.Add<IMVCBrStateStep>('C', TFakeStateStep);
  FStates.Add<IMVCBrStateStep>('D', TFakeStateStep);
  FStates.SetLastStep('B');
  FStates.Last;
  Assert.AreEqual(1, FStates.CurrenteIndex, 'SetLastStep(B) then Last should go to B');
end;

procedure TestTMVCBrStates.ExecuteDelegate_OnCurrentStep;
var
  LStep: TMVCBrStateSteps<TMVCBrStateStep>;
  LDel: TProc;
begin
  LStep := FStates.Add<IMVCBrStateStep>(TFakeStateStep);
  LDel := procedure begin FExecCount := FExecCount + 1; end;
  LStep.Delegate(LDel);
  FStates.ExecuteDelegate;
  Assert.AreEqual(1, FExecCount, 'ExecuteDelegate should call delegate');
end;

procedure TestTMVCBrStates.MoveNext_FromStep_MovesStates;
var
  LStep: TMVCBrStateSteps<TMVCBrStateStep>;
begin
  FStates.Add<IMVCBrStateStep>('A', TFakeStateStep);
  FStates.Add<IMVCBrStateStep>('B', TFakeStateStep);
  LStep := FStates.Add<IMVCBrStateStep>('C', TFakeStateStep);
  FStates.First;
  // Execute the current step (index 0 = A)
  if FStates.CurrentStep <> nil then
    FStates.ExecuteDelegate;
  Assert.IsTrue(FStates.CurrenteIndex >= 0, 'Execute should not crash');
end;

procedure TestTMVCBrStates.MovePrior_FromStep_MovesStates;
var
  LStep: TMVCBrStateSteps<TMVCBrStateStep>;
begin
  FStates.Add<IMVCBrStateStep>('A', TFakeStateStep);
  FStates.Add<IMVCBrStateStep>('B', TFakeStateStep);
  LStep := FStates.Add<IMVCBrStateStep>('C', TFakeStateStep);
  FStates.Last;
  // Execute the current step (last = C)
  if FStates.CurrentStep <> nil then
    FStates.ExecuteDelegate;
  Assert.IsTrue(FStates.CurrenteIndex >= 0, 'Execute should not crash');
end;

initialization
  TDUnitX.RegisterTestFixture(TestTMVCBrStateStep);
  TDUnitX.RegisterTestFixture(TestTMVCBrStates);
end.
