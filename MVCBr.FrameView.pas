unit MVCBr.FrameView;

interface

uses System.Classes, Forms, System.SysUtils,
  System.JSON, System.RTTI,
  MVCBr.Interf;

Type

  IFrameView = interface(IView)
    ['{97C0656C-FD84-4E9E-985B-03614FA19D15}']
  end;

  TFrameFactory = class(TFrame, IFrameView, IView)

  private
    FID, FTitle: string;
    FViewModel: IViewModel;
    FController: IController;
  protected
    function RefCount:Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function This: TObject;
    procedure Release; virtual;
    [weak]
    Function Controller(const AController: IController): IView; virtual;
    [weak]
    function GetController: IController; virtual;
    procedure SetController(Const AController: IController); virtual;
    [weak]
    function ShowView(): IView; overload; virtual;
    [weak]
    function UpdateView: IView; virtual;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean);
      overload; virtual;

    [weak]
    function ViewEvent(AMessage: string; var AHandled: boolean): IView;
      overload; virtual;
    [weak]
    function ViewEvent(AMessage: TJsonValue; var AHandled: boolean): IView;
      overload; virtual;
    [weak]
    function GetModel(AII: TGuid): IModel;
    [weak]
    function GetViewModel: IViewModel; virtual;
    procedure SetViewModel(const AViewModel: IViewModel); virtual;
    function GetID: string; virtual;
    function GetTitle: String; virtual;
    procedure SetTitle(Const AText: String); virtual;
    property Title: string read GetTitle write SetTitle;
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); virtual;
    function ShowView(const AProcBeforeShow: TProc<IView>): integer; overload;
    [weak]
    function ShowView(const AProcBeforeShow: TProc<IView>; AShowModal: boolean)
      : IView; overload;
    [weak]
    function ShowView(const AProcBeforeShow: TProc<IView>;
      const AProcOnClose: TProc<IView>): IView; overload; virtual;
    procedure UpdateObserver(AJson: TJsonValue); overload; virtual;
    procedure UpdateObserver(AName: string; AJson: TJsonValue);
      overload; virtual;
    procedure Init; virtual;
    [weak]
    function ApplicationControllerInternal: IApplicationController;
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
    property PropertyValue[ANome: string]: TValue read GetPropertyValue
      write SetPropertyValue;
    function GetGuid(AII: IInterface): TGuid;

  end;

implementation

uses MVCBr.ApplicationController, MVCBr.MiddlewareFactory;

{ TFrameFactory }

function TFrameFactory.ApplicationControllerInternal: IApplicationController;
begin
  result := ApplicationController;
end;

function TFrameFactory.Controller(const AController: IController): IView;
begin
  result := self;
  FController := AController;
end;

constructor TFrameFactory.Create(AOwner: TComponent);
begin
  inherited;
  TMVCBrMiddlewareFactory.SendBeforeEvent(middFrame, self);
end;

destructor TFrameFactory.Destroy;
begin
  TMVCBrMiddlewareFactory.SendAfterEvent(middFrame, self);
  inherited;
end;

procedure TFrameFactory.DoCommand(ACommand: string;
  const AArgs: array of TValue);
begin

end;

function TFrameFactory.GetController: IController;
begin
  result := FController;
end;

function TFrameFactory.GetGuid(AII: IInterface): TGuid;
begin
  result := TMVCBr.GetGuid(AII);
end;

function TFrameFactory.GetID: string;
begin
  result := FID;
end;

function TFrameFactory.GetModel(AII: TGuid): IModel;
begin
  result := FController.GetModel(AII);
end;

function TFrameFactory.GetPropertyValue(ANome: string): TValue;
begin
  result := TMVCBr.GetProperty(self, ANome);
end;

function TFrameFactory.GetTitle: String;
begin
  result := FTitle;
end;

function TFrameFactory.GetViewModel: IViewModel;
begin
  result := FViewModel;
end;

procedure TFrameFactory.Init;
begin
   // abstract;
end;

function TFrameFactory.RefCount: Integer;
begin
   result := _AddRef;
   _Release;
end;

procedure TFrameFactory.Release;
begin
  FViewModel := nil;
  FController := nil;
end;

procedure TFrameFactory.SetController(const AController: IController);
begin
  FController := AController;
end;

procedure TFrameFactory.SetPropertyValue(ANome: string; const Value: TValue);
begin
  TMVCBr.SetProperty(self, ANome, Value);
end;

procedure TFrameFactory.SetTitle(const AText: String);
begin
  FTitle := AText;
end;

procedure TFrameFactory.SetViewModel(const AViewModel: IViewModel);
begin
  FViewModel := AViewModel;
end;

function TFrameFactory.ShowView(const AProcBeforeShow,
  AProcOnClose: TProc<IView>): IView;
begin
  result := self;
  show;
end;

function TFrameFactory.ShowView: IView;
begin
  result := self;
  show;
end;

function TFrameFactory.This: TObject;
begin
  result := self;
end;

function TFrameFactory.ShowView(const AProcBeforeShow: TProc<IView>): integer;
begin
  result := 0;
  show;
  result := 1;
end;

function TFrameFactory.ShowView(const AProcBeforeShow: TProc<IView>;
  AShowModal: boolean): IView;
begin
  result := self;
  show;
end;

procedure TFrameFactory.UpdateObserver(AJson: TJsonValue);
begin
 // abstract;
end;

procedure TFrameFactory.Update(AJsonValue: TJsonValue; var AHandled: boolean);
begin
  AHandled := false;
end;

procedure TFrameFactory.UpdateObserver(AName: string; AJson: TJsonValue);
begin
  // abstract;
end;

function TFrameFactory.UpdateView: IView;
begin
  result := self;
end;

function TFrameFactory.ViewEvent(AMessage: string;
  var AHandled: boolean): IView;
begin
  // abstract;
end;

function TFrameFactory.ViewEvent(AMessage: TJsonValue;
  var AHandled: boolean): IView;
begin
  // abstract;
end;

end.
