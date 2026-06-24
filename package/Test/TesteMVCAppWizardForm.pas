unit TesteMVCAppWizardForm;

interface

uses
  DUnitX.TestFramework, Windows, Buttons, eMVC.toolbox, Forms, Dialogs, Controls,
  Classes, ExtCtrls,
  SysUtils, ComCtrls, Graphics, Messages, eMVC.AppWizardForm, StdCtrls;

type
  [TestFixture]
  TestTFormAppWizard = class
  strict private
    FFormAppWizard: TFormAppWizard;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestShowAppWizard;
    [Test]
    procedure TestShowConfig;
  end;

implementation

procedure TestTFormAppWizard.SetUp;
begin
  FFormAppWizard := TFormAppWizard.Create(nil);
end;

procedure TestTFormAppWizard.TearDown;
begin
  FFormAppWizard.Free;
  FFormAppWizard := nil;
end;

procedure TestTFormAppWizard.TestShowAppWizard;
begin
  FFormAppWizard.showmodal;
end;

procedure TestTFormAppWizard.TestShowConfig;
begin
  FFormAppWizard.config.Click;
end;

end.
