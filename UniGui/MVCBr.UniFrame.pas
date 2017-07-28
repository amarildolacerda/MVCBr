unit MVCBr.UniFrame;

interface

uses
  System.Classes, System.SysUtils,
  MVCBr.Interf, MVCBr.View, MVCBr.ApplicationController,
  MVCBr.Observable,
  System.Json, System.RTTI, System.UiTypes,
  uniGUIClasses, uniGuiApplication, uniGUIRegClasses, uniGUIFrame;

type

  TViewEventJsonNotify = procedure(AMessage: TJsonValue; var AHandled: boolean)
    of object;
  TViewCommandNotify = procedure(ACommand: string; const AArgs: array of TValue)
    of object;

  TUniGuiCloseEvent = procedure(sender: TObject; var Action: TCloseAction);

  TUniFrameFactory = class(TUniFrame, IView)
  private
    FID: string;
    [weak]
    FController: IController;
    [weak]
    FViewModel: IViewModel;
    FOnCommandEvent: TViewCommandNotify;
    FOnViewEvent: TViewEventJsonNotify;
    FOnViewUpdate: TNotifyEvent;
    FOnViewInit: TNotifyEvent;
    FOnCloseProc: TProc<IView>;
    FOnClose: TUniGuiCloseEvent;
    FOldCreateOrder: boolean;
    FPixelsPerInch: integer;
    FTextHeight: integer;
    procedure SetOnCommandEvent(const Value: TViewCommandNotify);
    procedure SetOnViewEvent(const Value: TViewEventJsonNotify);
    procedure SetOnViewInit(const Value: TNotifyEvent);
    procedure SetOnViewUpdate(const Value: TNotifyEvent);
    procedure DoCloseView(sender: TObject; var ACloseAction: TCloseAction);
    procedure SetOnClose(const Value: TUniGuiCloseEvent);
  protected
    // IMVCIOC
    procedure release;

    // IMVCBBase
    [weak]
    function ApplicationControllerInternal: IApplicationController;
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
    property PropertyValue[ANome: string]: TValue read GetPropertyValue
      write SetPropertyValue;
    function GetGuid(AII: IInterface): TGuid;
    procedure Send(ACommand: string; AParam: TJsonValue); virtual;

    // IViewBase
    function This: TObject;
    function ShowView(const AProc: TProc<IView>): integer; overload; virtual;
    [weak]
    function ShowView(): IView; overload; virtual;
    [weak]
    function UpdateView: IView; virtual;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean); overload;

    // IView
    [weak]
    function ViewEvent(AMessage: string; var AHandled: boolean): IView;
      overload;
    [weak]
    function ViewEvent(AMessage: TJsonValue; var AHandled: boolean)
      : IView; overload;
    [weak]
    function Controller(const AController: IController): IView;
    [weak]
    function GetController: IController; virtual;
    procedure SetController(const AController: IController);
    [weak]
    function GetModel(AII: TGuid): IModel; overload;
    [weak]
    function GetViewModel: IViewModel;
    procedure SetViewModel(const AViewModel: IViewModel);
    function GetID: string;
    function GetTitle: String;
    procedure SetTitle(Const AText: String);
    property Title: string read GetTitle write SetTitle;
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); virtual;
    [weak]
    function ShowView(const AProcBeforeShow: TProc<IView>; AShowModal: boolean)
      : IView; overload;
    [weak]
    function ShowView(const AProcBeforeShow: TProc<IView>;
      const AProcOnClose: TProc<IView>): IView; overload;
    procedure UpdateObserver(AJson: TJsonValue); overload;
    procedure UpdateObserver(AName: string; AJson: TJsonValue); overload;
    procedure Init;

    property OnClose: TUniGuiCloseEvent read FOnClose write SetOnClose;

    // extra
    function ResolveController<TIController: IController>: TIController;
    [weak]
    function GetModel<TIModel>: TIModel; overload;
  published
    property OnViewInit: TNotifyEvent read FOnViewInit write SetOnViewInit;
    property OnViewEvent: TViewEventJsonNotify read FOnViewEvent
      write SetOnViewEvent;
    property OnViewCommand: TViewCommandNotify read FOnCommandEvent
      write SetOnCommandEvent;
    property OnViewUpdate: TNotifyEvent read FOnViewUpdate
      write SetOnViewUpdate;
    property ClientHeight;
    property ClientWidth;
    property OldCreateOrder: boolean read FOldCreateOrder write FOldCreateOrder;
    property PixelsPerInch: integer read FPixelsPerInch write FPixelsPerInch;
    property TextHeight: integer read FTextHeight write FTextHeight;

    procedure FrameClose;

  end;

  IUniFrameAdapter = interface(IView)
    ['{03A69573-AC43-4F3A-B542-8068ABB8CA42}']
    function Default: TUniFrame;
    function ShowView(): IView;
  end;

  TUniFrameAdapter = class(TViewFactory, IUniFrameAdapter)
  private
    FFrameClass: TUniFrameClass;
    FInstance: TUniFrame;
    FOwner: TComponent;
  public
    class Function New(FUniFrameClass: TUniFrameClass; AOwner: TComponent)
      : IUniFrameAdapter; overload;
    class Function New(FUniFrame: TUniFrame; AOwner: TComponent)
      : IUniFrameAdapter; overload;
    function Default: TUniFrame;
    [weak]
    function ShowView(): IView;
  end;

implementation

uses System.Json.Helper;

{ TUniViewFactory }

function TUniFrameFactory.ApplicationControllerInternal: IApplicationController;
begin
  result := MVCBr.ApplicationController.ApplicationController;
end;

function TUniFrameFactory.Controller(const AController: IController): IView;
begin
  result := self;
  SetController(AController);
end;

procedure TUniFrameFactory.DoCommand(ACommand: string;
  const AArgs: array of TValue);
begin

end;

procedure TUniFrameFactory.FrameClose;
var
  j: IJsonObject;
begin
  j := TInterfacedJSON.New();
  j.addpair('command', 'close');
  j.addpair('classname', self.ClassName);
  TMVCBrObservable.DefaultContainer.Send('frame_command', j.JsonValue);
end;

function TUniFrameFactory.GetController: IController;
begin
  result := FController;
end;

function TUniFrameFactory.GetGuid(AII: IInterface): TGuid;
begin
  result := TMVCBr.GetGuid(AII);
end;

function TUniFrameFactory.GetID: string;
begin
  result := FID;
end;

function TUniFrameFactory.GetModel(AII: TGuid): IModel;
begin
  FController.GetModel(AII, result);
end;

function TUniFrameFactory.GetPropertyValue(ANome: string): TValue;
begin
  result := TMVCBr.GetProperty(self, ANome);
end;

function TUniFrameFactory.GetTitle: String;
begin
  result := Caption;
end;

function TUniFrameFactory.GetViewModel: IViewModel;
begin
  result := FViewModel;
end;

procedure TUniFrameFactory.Init;
begin
  // if not assigned(FController) then
  // raise Exception.Create('Não tem um controller associado');
end;

procedure TUniFrameFactory.release;
begin
  FController := nil;
end;

procedure TUniFrameFactory.Send(ACommand: string; AParam: TJsonValue);
begin
  TMVCBrObservable.DefaultContainer.Send(ACommand, AParam);
end;

procedure TUniFrameFactory.SetController(const AController: IController);
begin
  FController := AController;
end;

procedure TUniFrameFactory.SetOnClose(const Value: TUniGuiCloseEvent);
begin
  FOnClose := Value;
end;

procedure TUniFrameFactory.SetOnCommandEvent(const Value: TViewCommandNotify);
begin
  FOnCommandEvent := Value;
end;

procedure TUniFrameFactory.SetOnViewEvent(const Value: TViewEventJsonNotify);
begin
  FOnViewEvent := Value;
end;

procedure TUniFrameFactory.SetOnViewInit(const Value: TNotifyEvent);
begin
  FOnViewInit := Value;
end;

procedure TUniFrameFactory.SetOnViewUpdate(const Value: TNotifyEvent);
begin
  FOnViewUpdate := Value;
end;

procedure TUniFrameFactory.SetPropertyValue(ANome: string; const Value: TValue);
begin
  TMVCBr.SetProperty(self, ANome, Value);
end;

procedure TUniFrameFactory.SetTitle(const AText: String);
begin
  Caption := AText;
end;

procedure TUniFrameFactory.SetViewModel(const AViewModel: IViewModel);
begin
  FViewModel := AViewModel;
end;

procedure TUniFrameFactory.DoCloseView(sender: TObject;
  var ACloseAction: TCloseAction);
begin
  if assigned(FOnCloseProc) then
    FOnCloseProc(self);
  if assigned(FOnClose) then
    FOnClose(sender, ACloseAction);
end;

function TUniFrameFactory.ShowView(const AProcBeforeShow,
  AProcOnClose: TProc<IView>): IView;
begin
  FOnCloseProc := AProcOnClose;

  result := self;
  ShowView(AProcBeforeShow);

end;

function TUniFrameFactory.ShowView(const AProc: TProc<IView>): integer;
begin
  result := -1;
  // implements on overrided code
  if assigned(AProc) then
    AProc(self);
  Show;
  result := 0;
end;

function TUniFrameFactory.ShowView: IView;
begin
  result := self;
  ShowView;
end;

function TUniFrameFactory.This: TObject;
begin
  result := self;
end;

function TUniFrameFactory.ShowView(const AProcBeforeShow: TProc<IView>;
  AShowModal: boolean): IView;
begin
  result := self;
  ShowView(AProcBeforeShow);
end;

procedure TUniFrameFactory.UpdateObserver(AJson: TJsonValue);
begin

end;

procedure TUniFrameFactory.Update(AJsonValue: TJsonValue;
  var AHandled: boolean);
begin
  ViewEvent(AJsonValue, AHandled);

end;

procedure TUniFrameFactory.UpdateObserver(AName: string; AJson: TJsonValue);
begin

end;

function TUniFrameFactory.UpdateView: IView;
begin
  result := self;
end;

function TUniFrameFactory.ViewEvent(AMessage: string;
  var AHandled: boolean): IView;
begin

end;

function TUniFrameFactory.ViewEvent(AMessage: TJsonValue;
  var AHandled: boolean): IView;
begin
  result := self;
end;

function TUniFrameFactory.ResolveController<TIController>: TIController;
begin
  result := TApplicationController(ApplicationControllerInternal.This)
    .ResolveController<TIController>;
end;

function TUniFrameFactory.GetModel<TIModel>: TIModel;
begin
  result := GetController.This.GetModel<TIModel>
end;

{ TUniFrameAdapter }

function TUniFrameAdapter.Default: TUniFrame;
begin
  if not assigned(FInstance) then
    FInstance := FFrameClass.Create(FOwner);
  result := FInstance;
end;

class Function TUniFrameAdapter.New(FUniFrameClass: TUniFrameClass;
  AOwner: TComponent): IUniFrameAdapter;
var
  obj: TUniFrameAdapter;
begin
  obj := TUniFrameAdapter.Create;
  obj.FFrameClass := FUniFrameClass;
  obj.FOwner := AOwner;
  result := obj;
end;

class function TUniFrameAdapter.New(FUniFrame: TUniFrame; AOwner: TComponent)
  : IUniFrameAdapter;
var
  o: TUniFrameAdapter;
begin
  o := TUniFrameAdapter.Create;
  o.FFrameClass := TUniFrameClass(FUniFrame.ClassType);
  o.FInstance := FUniFrame;
  o.FOwner := AOwner;
  result := o;
end;

function TUniFrameAdapter.ShowView: IView;
var
  II: TValue;
begin
  result := self;
  with default do
  begin
    TMVCBr.SetProperty(FInstance, 'Controller', GetController.This);
    FInstance.Show;
  end;
end;

end.
