unit TestViewView;

interface

uses
  System.SysUtils, System.Classes, MVCBr.Interf,
  System.JSON,
  MVCBr.View, MVCBr.Controller;

type

  ITestViewView = interface(IView)
    ['{495C20E3-00C8-464C-84C4-1DBE7494B120}']
    function getStubInt: integer;
  end;

  TTestViewView = class(TViewFactory, IView, IThisAs<TTestViewView>,
    ITestViewView, IViewAs<ITestViewView>)
  private
    FInited: Boolean;
    FCount: integer;
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    class function New(aController: IController): IView;
    destructor Destroy; override;
    function This: TObject; override;
    function ThisAs: TTestViewView;
    function ViewAs: ITestViewView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
    function getStubInt: integer;
    function GetShowModalStub: Boolean;
    function ViewEvent(AMessage: string; var AHandled: Boolean): IView; override;
    function ViewEvent(AMessage: TJSONValue; var AHandled: Boolean): IView; override;
  end;

Implementation

function TTestViewView.UpdateView: IView;
begin
  result := self;
end;

function TTestViewView.ViewAs: ITestViewView;
begin
  result := self;
end;

class function TTestViewView.New(aController: IController): IView;
begin
  result := TTestViewView.create;
  result.Controller(aController);
end;

function TTestViewView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

destructor TTestViewView.Destroy;
begin
  inherited;
end;

function TTestViewView.ViewEvent(AMessage: string;
  var AHandled: Boolean): IView;
begin
  result := self;
  AHandled := true;
end;

function TTestViewView.ViewEvent(AMessage: TJSONValue;
  var AHandled: Boolean): IView;
begin
  result := self;
  inc(FCount);
  AHandled := true;
end;

function TTestViewView.GetShowModalStub: Boolean;
begin
  result := true;
end;

function TTestViewView.getStubInt: integer;
begin
  result := FCount;
end;

procedure TTestViewView.Init;
begin
  FCount := 1;
end;

function TTestViewView.This: TObject;
begin
  result := inherited This;
end;

function TTestViewView.ThisAs: TTestViewView;
begin
  result := self;
end;

function TTestViewView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
