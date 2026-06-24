unit TestSecondView;

interface

uses
  System.SysUtils, System.Classes, MVCBr.Interf,
  System.JSON,
  MVCBr.View, MVCBr.Controller;

type

  TTestSecondView = class;

  ITestSecondView = interface(IView)
    ['{38EC34E3-568C-4FC4-B7C5-4240C45D27C9}']
    function getStubInt: integer;
    function GetStubString: string;
    function ThisAs: TTestSecondView;
  end;

  TTestSecondView = class(TViewFactory, IView,
    IThisAs<TTestSecondView>, ITestSecondView, IViewAs<ITestSecondView>)
  private
    FInited: Boolean;
    FCountRef: integer;
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TTestSecondView;
    function ViewAs: ITestSecondView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
    function getStubInt: integer;
    function GetStubString: string;
    function GetShowModalStub: Boolean;
    procedure Update(AJson: TJSONValue; var AHandled: boolean); override;
    function ViewEvent(AMessage: TJSONValue; var AHandled: Boolean): IView; override;
  end;

Implementation

procedure TTestSecondView.Update(AJson: TJSONValue; var AHandled: boolean);
begin
  inc(FCountRef);
end;

function TTestSecondView.UpdateView: IView;
begin
  result := self;
end;

function TTestSecondView.ViewAs: ITestSecondView;
begin
  result := self;
end;

class function TTestSecondView.New(aController: IController): IView;
begin
  result := TTestSecondView.create;
  result.Controller(aController);
end;

function TTestSecondView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

function TTestSecondView.ViewEvent(AMessage: TJSONValue;
  var AHandled: Boolean): IView;
begin
  result := self;
  AHandled := true;
end;

function TTestSecondView.GetShowModalStub: Boolean;
begin
  result := true;
end;

function TTestSecondView.getStubInt: integer;
begin
  result := FCountRef;
end;

function TTestSecondView.GetStubString: string;
begin
  result := 'test';
end;

procedure TTestSecondView.Init;
begin
  FCountRef := 1;
end;

function TTestSecondView.This: TObject;
begin
  result := inherited This;
end;

function TTestSecondView.ThisAs: TTestSecondView;
begin
  result := self;
end;

function TTestSecondView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
