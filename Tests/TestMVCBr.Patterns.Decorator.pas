unit TestMVCBr.Patterns.Decorator;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils, System.Classes,
  MVCBr.Patterns.Decorator;

type
  [TestFixture]
  TestTMVCBrDecorator = class
  public
    [Test]
    procedure Invoke_ReturnsDecorate;
    [Test]
    procedure This_ReturnsSelf;
    [Test]
    procedure Lock_ReturnsDecorate;
    [Test]
    procedure LockUnlock_DoesNotRaise;
  end;

implementation

{ TestTMVCBrDecorator }

procedure TestTMVCBrDecorator.Invoke_ReturnsDecorate;
var
  LSL: TStringList;
  LObj: TMVCBrDecorator<TStringList>;
begin
  LSL := TStringList.Create;
  try
    LObj := TMVCBrDecorator<TStringList>.Create(LSL);
    Assert.IsTrue(LSL = LObj.Decorate,
      'Decorate should return same object');
    LObj.Free;
  finally
    LSL.Free;
  end;
end;

procedure TestTMVCBrDecorator.This_ReturnsSelf;
var
  LSL: TStringList;
  LObj: TMVCBrDecorator<TStringList>;
begin
  LSL := TStringList.Create;
  try
    LObj := TMVCBrDecorator<TStringList>.Create(LSL);
    Assert.IsNotNull(LObj.This, 'This should return TObject');
    LObj.Free;
  finally
    LSL.Free;
  end;
end;

procedure TestTMVCBrDecorator.Lock_ReturnsDecorate;
var
  LSL: TStringList;
  LObj: TMVCBrDecorator<TStringList>;
begin
  LSL := TStringList.Create;
  try
    LObj := TMVCBrDecorator<TStringList>.Create(LSL);
    Assert.IsTrue(LSL = LObj.Lock, 'Lock should return decorate');
    LObj.UnLock;
    LObj.Free;
  finally
    LSL.Free;
  end;
end;

procedure TestTMVCBrDecorator.LockUnlock_DoesNotRaise;
var
  LSL: TStringList;
  LObj: TMVCBrDecorator<TStringList>;
begin
  LSL := TStringList.Create;
  try
    LObj := TMVCBrDecorator<TStringList>.Create(LSL);
    LObj.Lock;
    LObj.UnLock;
    LObj.Free;
  finally
    LSL.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTMVCBrDecorator);
end.
