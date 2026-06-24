unit TesteNewClassModelForm;

interface

uses
  DUnitX.TestFramework, eMVC.toolbox, Vcl.CheckLst, SysUtils, ComCtrls, Windows, StdCtrls,
  Messages, ExtCtrls, Controls, Classes, Dialogs, Forms, Buttons, Graphics,
  eMVC.NewClassModelForm;

type
  [TestFixture]
  TestTFormClassModel = class
  strict private
    FFormClassModel: TFormClassModel;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestShowClassModel;
  end;

implementation

procedure TestTFormClassModel.SetUp;
begin
  FFormClassModel := TFormClassModel.Create(nil);
end;

procedure TestTFormClassModel.TestShowClassModel;
begin
  fformClassModel.ShowModal;
end;

procedure TestTFormClassModel.TearDown;
begin
  FFormClassModel.Free;
  FFormClassModel := nil;
end;

end.

