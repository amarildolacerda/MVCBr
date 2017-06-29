{

  MVCBr.FormView - implements base class of FormView
  Auth: amarildo lacerda
  Date: jan/2017

  Changes:
  29-mar-2017
  + MainViewEvent  - send ViewEvent to MainView   by: amarildo lacerda
  + ViewEventOther  - send ViewEvent to other VIEW
}

unit MVCBr.FormView;

interface

uses {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, System.UiTypes, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, System.SysUtils, System.RTTI, System.JSON,
  MVCBr.ApplicationController, MVCBr.Interf, MVCBr.View;

type

{$IFDEF FMX}
  TFormClass = class of TForm;
{$ENDIF}
  TViewFactoryAdapter = class;

  IViewAdpater = interface(IView)
    ['{A5FCFDC8-67F2-4202-AED1-95314077F28F}']
    function Form: {$IFDEF LINUX} TComponent {$ELSE} TForm{$ENDIF};
    function ThisAs: TViewFactoryAdapter;
  end;

  /// <summary>
  /// TViewFactoryAdpater é um conector para receber um FORM,
  /// a ser utilizado para formularios que não herdam diretamente de TFormFactory
  /// </summary>
  TViewFactoryAdapter = class(TViewFactory, IViewAdpater)
  private
    FisShowModal: boolean;
    FOnProc: TProc<IView>;
    procedure SetisShowModal(const Value: boolean);
  protected
    FForm: {$IFDEF LINUX} TComponent {$ELSE} TForm{$ENDIF};
{$IFDEF LINUX}
{$ELSE}
    procedure DoClose(Sender: TObject; var Action: TCloseAction);
{$ENDIF}
  public
    class function New(AClass: {$IFDEF LINUX} TComponentClass
{$ELSE} TFormClass{$ENDIF}; const AShowModal: boolean = true): IView; overload;
    class function New(AForm: {$IFDEF LINUX} TComponent
{$ELSE} TForm{$ENDIF}; const AShowModal: boolean = true): IView; overload;
    property isShowModal: boolean read FisShowModal write SetisShowModal;
    function ShowView(const AProc: TProc<IView>): Integer; override;
    function Form: {$IFDEF LINUX} TComponent {$ELSE} TForm{$ENDIF};
    function ThisAs: TViewFactoryAdapter;
    function This: TObject; override;
  end;

  TViewEventJsonNotify = procedure(AMessage: TJsonValue; var AHandled: boolean)
    of object;
  TViewCommandNotify = procedure(ACommand: string; const AArgs: array of TValue)
    of object;

  /// <summary>
  /// TFormFactory é utilizado para herança dos TForms para transformar o FORM em VIEW no MVCBr
  /// </summary>
  TCustomFormFactory = class({$IFDEF LINUX} TComponent{$ELSE} TForm{$ENDIF},
    IMVCBrBase, IView, IMVCBrObserver)
  private
    FEventRef: Integer;
    FID: string;
    FOnViewEvent: TViewEventJsonNotify;
    FOnCommandEvent: TViewCommandNotify;
    FOnViewUpdate: TNotifyEvent;
    FOnViewInit: TNotifyEvent;

{$IFDEF LINUX}
    FCaption: string;
{$ELSE}
    FOnClose: TCloseEvent;
    procedure SetOnClose(const Value: TCloseEvent);
{$ENDIF}
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
    procedure SetOnViewEvent(const Value: TViewEventJsonNotify);
    procedure SetOnCommandEvent(const Value: TViewCommandNotify);
    procedure SetOnViewUpdate(const Value: TNotifyEvent);
    procedure SetOnViewInit(const Value: TNotifyEvent);
  protected
    FOnCloseProc: TProc<IView>;
    [unsafe]
    FController: IController;
    FShowModal: boolean;
    // FViewModel:IViewModel;
{$IFDEF LINUX}
{$ELSE}
    procedure DoCloseView(Sender: TObject; var ACloseAction: TCloseAction);
{$ENDIF}
    procedure SetController(const AController: IController);
    function Controller(const AController: IController): IView; virtual;
    procedure SetShowModal(const AShowModal: boolean);
    /// Retorna se a apresentação do formulário é ShowModal
    function GetShowModal: boolean;
    function GetTitle: string; virtual;
    procedure SetTitle(const Value: string); virtual;
  public
    procedure AfterConstruction; override;
    procedure Init; virtual;
    function ApplicationControllerInternal: IApplicationController;
    function ApplicationController: TApplicationController;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Release; virtual;
    function GetGuid(AII: IInterface): TGuid;
    function ViewEvent(AMessage: string; var AHandled: boolean): IView;
      overload; virtual;
    function ViewEvent(AMessage: TJsonValue; var AHandled: boolean): IView;
      overload; virtual;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean);
      overload; virtual;
    function Update:IView;overload;virtual;
    function MainViewEvent(AMessage: string; var AHandled: boolean)
      : IView; virtual;
    function ViewEventOther(AMessage: string; var AHandled: boolean): IView;
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); virtual;
    function GetID: string;
    property isShowModal: boolean read GetShowModal write SetShowModal;
    /// Retorna o controller ao qual a VIEW esta conectada
    function GetController: IController; virtual;
    function AttachController(AInterface: TGuid; AOwnedFree: boolean = true)
      : IController; overload; virtual;
    function AttachController<TIController: IInterface>: TIController; overload;
    function AttachModel<TIModel: IModel>(AModelClass
      : TModelFactoryAbstractClass): TIModel;
    /// Retorna o SELF
    function This: TObject; virtual;
    /// Executa um method genérico do FORM/VIEW
    function InvokeMethod<T>(AMethod: string; const Args: TArray<TValue>): T;
    function ResolveController(const IID: TGuid): IController;
      overload; virtual;
    procedure RevokeController(IID: TGuid); overload;
    procedure RevokeController(TIController: IController); overload;
    function ResolveController<TIController: IController>
      : TIController; overload;
    function GetModel<TIModel>: TIModel; overload;
    function GetModel(AII: TGuid): IModel; overload;
    /// Obter ou Alterar o valor de uma propriedade do ObjetoClass  (VIEW)
    property PropertyValue[ANome: string]: TValue read GetPropertyValue
      write SetPropertyValue;
    function GetView<TIView: IInterface>: TIView; overload;
    function FindView(AGuid: TGuid): IView;
    /// Apresenta o VIEW para o usuario
    function ShowView(const IIDController: TGuid;
      const AProcBeforeShow: TProc<IView>; const AProcONClose: TProc<IView>)
      : IView; overload; virtual;
    function ShowView(const AProcBeforeShow: TProc<IView>): Integer;
      overload; virtual;
    function ShowView(const AProcBeforeShow: TProc<IView>; AShowModal: boolean)
      : IView; overload; virtual;
    function ShowView(const AProcBeforeShow: TProc<IView>;
      const AProcONClose: TProc<IView>): IView; overload; virtual;
    function ShowView(const IIDController: TGuid;
      const AProcBeforeShow: TProc<IView>): IView; overload; virtual;
    function ShowView(const IIDController: TGuid): IView; overload; virtual;
    function ShowView(): IView; overload;
    procedure SetViewModel(const AViewModel: IViewModel); virtual;
    function GetViewModel: IViewModel; virtual;
    /// Evento para atualizar os dados da VIEW
    function UpdateView: IView; virtual;

    procedure UpdateObserver(AJson: TJsonValue); overload; virtual;
    procedure UpdateObserver(AName: string; AJson: TJsonValue);
      overload; virtual;
    procedure UpdateObserver(AName: string; AMensagem: String);
      overload; virtual;
    function Observable: IMVCBrObservable; virtual;
    procedure RegisterObserver(const AName: String);
    procedure UnRegisterObserver(const AName: String);

    property Text: string read GetTitle write SetTitle;

{$IFDEF LINUX}
{$ELSE}
    property OnClose: TCloseEvent read FOnClose write SetOnClose;
{$ENDIF}
    property OnViewInit: TNotifyEvent read FOnViewInit write SetOnViewInit;
    property OnViewEvent: TViewEventJsonNotify read FOnViewEvent
      write SetOnViewEvent;
    property OnViewCommand: TViewCommandNotify read FOnCommandEvent
      write SetOnCommandEvent;
    property OnViewUpdate: TNotifyEvent read FOnViewUpdate
      write SetOnViewUpdate;
  end;

  TFormFactory = class(TCustomFormFactory)
  published
{$IFDEF LINUX}
{$ELSE}
    property OnClose;
{$ENDIF}
    property OnViewEvent;
    property OnViewCommand;
    property OnViewUpdate;
    property OnViewInit;
  end;

implementation

{ TViewFormFacotry }
procedure TCustomFormFactory.AfterConstruction;
begin
  inherited;
  FShowModal := true;
end;

/// Set Controller to VIEW
function TCustomFormFactory.Controller(const AController: IController): IView;
begin
  result := self;
  SetController(AController);
end;

var
  LViewsCount: Integer = 0;
  /// counter to instance of VIEW

constructor TCustomFormFactory.Create(AOwner: TComponent);
begin
  inherited;
  FEventRef := 0;
  inc(LViewsCount);
  FID := classname + '_' + intToStr(LViewsCount);
end;

destructor TCustomFormFactory.Destroy;
begin
  if assigned(FController) then
  begin
    FController.This.RevokeInstance(FController);
    // clear controller
    FController.Release;
    FController := nil;
  end;
  inherited;
end;

function TCustomFormFactory.GetController: IController;
begin
  result := FController;
end;

function TCustomFormFactory.GetGuid(AII: IInterface): TGuid;
begin
  result := TMVCBr.GetGuid(AII);
end;

function TCustomFormFactory.GetID: string;
begin
  result := FID;
end;

function TCustomFormFactory.GetModel(AII: TGuid): IModel;
begin
  FController.GetModel(AII, result);
end;

function TCustomFormFactory.GetModel<TIModel>: TIModel;
begin
  result := FController.This.GetModel<TIModel>;
end;

function TCustomFormFactory.GetView<TIView>: TIView;
var
  AGuid: TGuid;
  AView: IView;
begin
  AGuid := TMVCBr.GetGuid<TIView>;
  AView := FindView(AGuid);
  if assigned(AView) then
    result := TIView(AView);
end;

function TCustomFormFactory.GetPropertyValue(ANome: string): TValue;
begin
  result := TMVCBr.GetProperty(self, ANome);
end;

function TCustomFormFactory.GetShowModal: boolean;
begin
  result := FShowModal;
end;

function TCustomFormFactory.GetTitle: string;
begin
{$IFDEF LINUX}
  result := FCaption;
{$ELSE}
{$IFDEF FMX}
  result := inherited Caption;
{$ELSE}
  result := inherited Caption;
{$ENDIF}
{$ENDIF}
end;

function TCustomFormFactory.GetViewModel: IViewModel;
begin
  result := nil;
  if assigned(FController) then
    result := FController.GetModelByType(mtViewModel) as IViewModel;
end;

procedure TCustomFormFactory.Init;
begin
  if assigned(FOnViewInit) then
    FOnViewInit(self);
end;

function TCustomFormFactory.InvokeMethod<T>(AMethod: string;
  const Args: TArray<TValue>): T;
begin
  result := TMVCBr.InvokeMethod<T>(self, AMethod, Args);
end;

function TCustomFormFactory.AttachController(AInterface: TGuid;
  AOwnedFree: boolean = true): IController;
begin
  result := FController;
  if not assigned(FController) then
  begin
    FController := ApplicationController.AttachController(AInterface)
      as IController;
    FController.This.ViewOwnedFree := AOwnedFree;
    result := FController;
    result.View(self);
  end;
end;

function TCustomFormFactory.AttachController<TIController>: TIController;
var
  AGuid: TGuid;
begin
  AGuid := TMVCBr.GetGuid<TIController>;
  result := AttachController(AGuid);
end;

function TCustomFormFactory.AttachModel<TIModel>(AModelClass
  : TModelFactoryAbstractClass): TIModel;
var
  o: TObject;
  AGuid: TGuid;
begin
  o := AModelClass.Create;
  AGuid := TMVCBr.GetGuid<TIModel>;
  Supports(o, AGuid, result);
  GetController.AttachModel(result);
end;

procedure TCustomFormFactory.RegisterObserver(const AName: String);
begin
  TMVCBr.RegisterObserver(AName, self);
end;

procedure TCustomFormFactory.Release;
begin
   if assigned(FController) then
      FController.Release;
  FController := nil;
end;

function TCustomFormFactory.ResolveController(const IID: TGuid): IController;
begin
  result := ApplicationController.ThisAs.ResolveController(IID);
end;

function TCustomFormFactory.ResolveController<TIController>: TIController;
begin
  result := ApplicationController.ThisAs.ResolveController<TIController>();
end;

procedure TCustomFormFactory.RevokeController(TIController: IController);
var
  IID: TGuid;
begin
  IID := TMVCBr.GetGuid(TIController);
  RevokeController(IID);
end;

procedure TCustomFormFactory.RevokeController(IID: TGuid);
begin
  ApplicationController.RevokeController(IID);
end;

procedure TCustomFormFactory.SetController(const AController: IController);
begin
  FController := AController.This.Default as IController;
end;

procedure TCustomFormFactory.SetOnCommandEvent(const Value: TViewCommandNotify);
begin
  FOnCommandEvent := Value;
end;

procedure TCustomFormFactory.SetOnViewEvent(const Value: TViewEventJsonNotify);
begin
  FOnViewEvent := Value;
end;

procedure TCustomFormFactory.SetOnViewInit(const Value: TNotifyEvent);
begin
  FOnViewInit := Value;
end;

procedure TCustomFormFactory.SetOnViewUpdate(const Value: TNotifyEvent);
begin
  FOnViewUpdate := Value;
end;

{$IFDEF LINUX}
{$ELSE}

procedure TCustomFormFactory.SetOnClose(const Value: TCloseEvent);
begin
  FOnClose := Value;
end;

procedure TCustomFormFactory.DoCloseView(Sender: TObject;
  var ACloseAction: TCloseAction);
begin
  if assigned(FOnCloseProc) then
    FOnCloseProc(self);
  if assigned(FOnClose) then
    FOnClose(Sender, ACloseAction);
end;
{$ENDIF}

function TCustomFormFactory.ApplicationController: TApplicationController;
begin
  result := TApplicationController
    (MVCBr.ApplicationController.ApplicationController.This);
end;

function TCustomFormFactory.ApplicationControllerInternal
  : IApplicationController;
begin
  result := MVCBr.ApplicationController.ApplicationController;
end;

procedure TCustomFormFactory.DoCommand(ACommand: string;
  const AArgs: array of TValue);
begin
  if assigned(FOnCommandEvent) then
    FOnCommandEvent(ACommand, AArgs);
end;

function TCustomFormFactory.FindView(AGuid: TGuid): IView;
begin
  result := ApplicationController.FindView(AGuid);
end;

function TCustomFormFactory.ViewEvent(AMessage: TJsonValue;
  var AHandled: boolean): IView;
begin
  result := self;
  if assigned(FOnViewEvent) then
    FOnViewEvent(AMessage, AHandled);
end;

function TCustomFormFactory.ViewEventOther(AMessage: string;
  var AHandled: boolean): IView;
begin
  result := self;
  if FEventRef = 0 then
  begin
    /// check NO LOOP
    /// takecare with this lines... dont put your code in LOOP
    /// sometimes you will need some override to broken LOOPs
    /// if other view call this event, it will drop at second calls
    /// a better implementation its call ViewEvent to 1 VIEW only by her TGUID (IInterface)
    inc(FEventRef);
    try
      ApplicationController.ViewEventOther(GetController, AMessage, AHandled);
    finally
      dec(FEventRef);
    end;
  end;
end;

function TCustomFormFactory.ViewEvent(AMessage: string;
  var AHandled: boolean): IView;
var
  j: TJsonObject;
begin
  /// use inherited this method on child
  /// takecare put code here and start a loop whithout end
  result := self;
  if assigned(FOnViewEvent) then
  begin
    j := TJsonObject.Create();
    try
      j.addPair('message', AMessage);
      FOnViewEvent(j, AHandled);
    finally
      j.free;
    end;
  end;
end;

function TCustomFormFactory.MainViewEvent(AMessage: string;
  var AHandled: boolean): IView;
var
  AView: IView;
begin
  if Supports(ApplicationController.MainView, IView, AView) then
    AView.ViewEvent(AMessage, AHandled);
end;

function TCustomFormFactory.Observable: IMVCBrObservable;
begin
  result := TMVCBr.Observable;
end;

procedure TCustomFormFactory.SetPropertyValue(ANome: string;
  const Value: TValue);
begin
  TMVCBr.SetProperty(self, ANome, Value);
end;

procedure TCustomFormFactory.SetShowModal(const AShowModal: boolean);
begin
  FShowModal := AShowModal;
end;

procedure TCustomFormFactory.SetTitle(const Value: string);
begin
{$IFDEF LINUX}
  FCaption := Value;
{$ELSE}
{$IFDEF FMX}
  Inherited Caption := Value;
{$ELSE}
  Inherited Caption := Value;
{$ENDIF}
{$ENDIF}
end;

procedure TCustomFormFactory.SetViewModel(const AViewModel: IViewModel);
begin
  // fazer herança
  if assigned(AViewModel) then
    AViewModel.View(self);

end;

function TCustomFormFactory.ShowView(const AProcBeforeShow,
  AProcONClose: TProc<IView>): IView;
begin
  FOnCloseProc := AProcONClose;
{$IFDEF LINUX}
{$ELSE}
  inherited OnClose := DoCloseView;
{$ENDIF}
  result := self;
  ShowView(AProcBeforeShow);
end;

function TCustomFormFactory.ShowView(const IIDController: TGuid): IView;
begin
  result := ShowView(IIDController,
    procedure(Sender: IView)
    begin
      // stub to nothing..
    end);
end;

function TCustomFormFactory.ShowView(const IIDController: TGuid;
const AProcBeforeShow: TProc<IView>): IView;
var
  LController: IController;
begin
  result := nil;
  LController := ResolveController(IIDController);
  if assigned(LController) then
  begin
    result := LController.GetView;
    result.ShowView(AProcBeforeShow);
  end;
end;

function TCustomFormFactory.ShowView(const AProcBeforeShow
  : TProc<IView>): Integer;
begin
  result := 0;
  if assigned(AProcBeforeShow) then
    AProcBeforeShow(self);
{$IFDEF LINUX}
{$ELSE}
{$IFDEF MSWINDOWS}
{$IFDEF FMX}
  Show;
  result := 0;
{$ELSE}
  if FShowModal then
    result := ord(ShowModal);
{$ENDIF}
{$ELSE}
  Show;
{$ENDIF}
{$ENDIF}
end;

function TCustomFormFactory.ShowView(const IIDController: TGuid;
const AProcBeforeShow: TProc<IView>; const AProcONClose: TProc<IView>): IView;
var
  ctrl: IController;
begin
  result := nil;
  ctrl := ResolveController(IIDController);
  if assigned(ctrl) then
  begin
    result := ctrl.GetView;
    if assigned(result) then
      result.ShowView(AProcBeforeShow, AProcONClose);
  end;
end;

function TCustomFormFactory.This: TObject;
begin
  result := self;
end;

procedure TCustomFormFactory.UnRegisterObserver(const AName: String);
begin
  TMVCBr.UnRegisterObserver(AName, self);
end;

procedure TCustomFormFactory.Update(AJsonValue: TJsonValue;
var AHandled: boolean);
begin
  ViewEvent(AJsonValue, AHandled);
end;

function TCustomFormFactory.Update: IView;
begin
  result := self;
end;

procedure TCustomFormFactory.UpdateObserver(AName, AMensagem: String);
var
  j: TJsonObject;
begin
  j := TJsonObject.Create;
  try
    j.addPair('message', AMensagem);
    UpdateObserver(AName, j);
  finally
    j.free;
  end;
end;

procedure TCustomFormFactory.UpdateObserver(AName: string; AJson: TJsonValue);
begin
  TMVCBr.UpdateObserver(AName, AJson);
end;

procedure TCustomFormFactory.UpdateObserver(AJson: TJsonValue);
begin
  TMVCBr.UpdateObserver(AJson);
end;

function TCustomFormFactory.UpdateView: IView;
begin
  result := self;
  if assigned(FOnViewUpdate) then
    FOnViewUpdate(self);

end;

{ TViewFactoryAdapter }
{$IFDEF LINUX}
{$ELSE}

procedure TViewFactoryAdapter.DoClose(Sender: TObject;
var Action: TCloseAction);
begin
  if assigned(FOnProc) then
    FOnProc(self);
  if assigned(FForm) and assigned(FForm.OnClose) then
    FForm.OnClose(Sender, Action);
end;
{$ENDIF}

function TViewFactoryAdapter.Form:
{$IFDEF LINUX} TComponent{$ELSE} TForm{$ENDIF};
begin
  result := FForm;
end;

class function TViewFactoryAdapter.New(AForm:
{$IFDEF LINUX} TComponent{$ELSE} TForm{$ENDIF};
const AShowModal: boolean): IView;
var
  obj: TViewFactoryAdapter;
begin
  obj := TViewFactoryAdapter.Create;
  obj.FForm := AForm;
  obj.isShowModal := AShowModal;
  result := obj;
end;

class function TViewFactoryAdapter.New(AClass:
{$IFDEF LINUX} TComponentClass{$ELSE} TFormClass{$ENDIF};
const AShowModal: boolean): IView;
var
  obj: TViewFactoryAdapter;
begin
  obj := TViewFactoryAdapter.Create;
  obj.FForm := AClass.Create(nil);
  obj.isShowModal := AShowModal;
  result := obj;
end;

procedure TViewFactoryAdapter.SetisShowModal(const Value: boolean);
begin
  FisShowModal := Value;
end;

function TViewFactoryAdapter.ShowView(const AProc: TProc<IView>): Integer;
begin
  result := 0;
  FOnProc := AProc;
{$IFDEF LINUX}
{$ELSE}
  if isShowModal then
  begin
    result := ord(FForm.ShowModal);
    if assigned(AProc) then
      AProc(self);
  end
  else
  begin
    FForm.OnClose := DoClose;
    FForm.Show;
  end;
{$ENDIF}
end;

function TViewFactoryAdapter.This: TObject;
begin
  result := self; // nao alterar... é esperado retornuar um view como retorno
end;

function TViewFactoryAdapter.ThisAs: TViewFactoryAdapter;
begin
  result := self;
end;

function TCustomFormFactory.ShowView: IView;
begin
  result := self;
  ShowView(nil);
end;

function TCustomFormFactory.ShowView(const AProcBeforeShow: TProc<IView>;
AShowModal: boolean): IView;
begin
  FShowModal := AShowModal;
  result := self;
  ShowView(AProcBeforeShow);
end;

end.
