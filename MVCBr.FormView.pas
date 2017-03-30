///
///  MVCBr.FormView - implements base class of FormView
///  Auth: amarildo lacerda
///  Date: jan/2017

{
  Changes:
   29-mar-2017
     + MainViewEvent  - send ViewEvent to MainView   by: amarildo lacerda
     + ViewEventOther  - send ViewEvent to other VIEW
}


unit MVCBr.FormView;

interface

uses {$IFDEF FMX} FMX.Forms, System.UiTypes, {$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, System.SysUtils, System.RTTI,
  MVCBr.ApplicationController, MVCBr.Interf, MVCBr.View;

type

{$IFDEF FMX}
  TFormClass = class of TForm;
{$ENDIF}
  TViewFactoryAdapter = class;

  IViewAdpater = interface(IView)
    ['{A5FCFDC8-67F2-4202-AED1-95314077F28F}']
    function Form: TForm;
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
    FForm: TForm;
    procedure DoClose(Sender: TObject; var Action: TCloseAction);
  public
    class function New(AClass: TFormClass; const AShowModal: boolean = true)
      : IView; overload;
    class function New(AForm: TForm; const AShowModal: boolean = true)
      : IView; overload;
    property isShowModal: boolean read FisShowModal write SetisShowModal;
    function ShowView(const AProc: TProc<IView>): Integer; override;
    function Form: TForm;
    function ThisAs: TViewFactoryAdapter;
    function This: TObject;
  end;

  /// <summary>
  /// TFormFactory é utilizado para herança dos TForms para transformar o FORM em VIEW no MVCBr
  /// </summary>
  TFormFactory = class(TForm, IMVCBrBase, IView)
  private
    FEventRef: Integer;
    FOnClose: TCloseEvent;
    FID: string;
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
    procedure SetOnClose(const Value: TCloseEvent);
    function GetText: string;
    procedure SetText(const Value: string);
  protected
    FOnCloseProc: TProc<IView>;
    FController: IController;
    FShowModal: boolean;
    // FViewModel:IViewModel;
    procedure DoCloseView(Sender: TObject; var ACloseAction: TCloseAction);
    procedure SetController(const AController: IController);
    function Controller(const AController: IController): IView; virtual;
    procedure AfterConstruction; override;
    procedure SetShowModal(const AShowModal: boolean);
    /// Retorna se a apresentação do formulário é ShowModal
    function GetShowModal: boolean;
  public
    function ApplicationControllerInternal: IApplicationController;
    function ApplicationController: TApplicationController;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetGuid(AII: IInterface): TGuid;
    function ViewEvent(AMessage: string): IView; virtual;
    function MainViewEvent(AMessage: string): IView; virtual;
    function ViewEventOther(AMessage: string): IView;
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); virtual;
    function GetID: string;
    property isShowModal: boolean read GetShowModal write SetShowModal;
    /// Retorna o controller ao qual a VIEW esta conectada
    function GetController: IController; virtual;
    /// Retorna o SELF
    function This: TObject; virtual;
    /// Executa um method genérico do FORM/VIEW
    function InvokeMethod<T>(AMethod: string; const Args: TArray<TValue>): T;
    function ResolveController(const IID: TGuid): IController;
      overload; virtual;
    function ResolveController<TIController>: TIController; overload;
    function GetModel<TIModel>: TIModel; overload;
    function GetModel(AII: TGuid): IModel; overload;
    /// Obter ou Alterar o valor de uma propriedade do ObjetoClass  (VIEW)
    property PropertyValue[ANome: string]: TValue read GetPropertyValue
      write SetPropertyValue;
    /// Apresenta o VIEW para o usuario
    function ShowView(const AProc: TProc<IView>): Integer; overload; virtual;
    function ShowView(const AProc: TProc<IView>; AShowModal: boolean): Integer;
      overload; virtual;
    function ShowView(const IIDController: TGuid; const AProc: TProc<IView>)
      : IView; overload; virtual;
    function ShowView(): IView; overload;
    procedure SetViewModel(const AViewModel: IViewModel); virtual;
    function GetViewModel: IViewModel; virtual;
    /// Evento para atualizar os dados da VIEW
    function Update: IView; virtual;

    property Text: string read GetText write SetText;

  published
    property OnClose: TCloseEvent read FOnClose write SetOnClose;
  end;

implementation

{ TViewFormFacotry }
procedure TFormFactory.AfterConstruction;
begin
  inherited;
  FShowModal := true;
end;

///  Set Controller to VIEW
function TFormFactory.Controller(const AController: IController): IView;
begin
  result := self;
  FController := AController;
end;

var
  LViewsCount: Integer = 0;  /// counter to instance of VIEW

constructor TFormFactory.Create(AOwner: TComponent);
begin
  inherited;
  FEventRef := 0;
  inc(LViewsCount);
  FID := classname + '_' + intToStr(LViewsCount);
end;

destructor TFormFactory.Destroy;
begin
  if assigned(FController) then
    FController.This.RevokeInstance(FController); // clear controller
  inherited;
end;

function TFormFactory.GetController: IController;
begin
  result := FController;
end;

function TFormFactory.GetGuid(AII: IInterface): TGuid;
begin
  result := TMVCBr.GetGuid(AII);
end;

function TFormFactory.GetID: string;
begin
  result := FID;
end;

function TFormFactory.GetModel(AII: TGuid): IModel;
begin
  FController.GetModel(AII, result);
end;

function TFormFactory.GetModel<TIModel>: TIModel;
begin
  result := FController.This.GetModel<TIModel>;
end;

function TFormFactory.GetPropertyValue(ANome: string): TValue;
begin
  result := TMVCBr.GetProperty(self, ANome);
end;

function TFormFactory.GetShowModal: boolean;
begin
  result := FShowModal;
end;

function TFormFactory.GetText: string;
begin
{$IFDEF FMX}
  result := inherited Caption;
{$ELSE}
  result := inherited Caption;
{$ENDIF}
end;

function TFormFactory.GetViewModel: IViewModel;
begin
  result := nil;
  if assigned(FController) then
    result := FController.GetModelByType(mtViewModel) as IViewModel;
end;

function TFormFactory.InvokeMethod<T>(AMethod: string;
  const Args: TArray<TValue>): T;
begin
  result := TMVCBr.InvokeMethod<T>(self, AMethod, Args);
end;

function TFormFactory.ResolveController(const IID: TGuid): IController;
begin
  result := FController.This.ResolveController(IID);
end;

function TFormFactory.ResolveController<TIController>: TIController;
begin
  result := GetController.This.ResolveController<TIController>();
end;

procedure TFormFactory.SetController(const AController: IController);
begin
  FController := AController;
end;

procedure TFormFactory.SetOnClose(const Value: TCloseEvent);
begin
  FOnClose := Value;
end;

procedure TFormFactory.DoCloseView(Sender: TObject;
  var ACloseAction: TCloseAction);
begin
  if assigned(FOnCloseProc) then
    FOnCloseProc(self);
  if assigned(FOnClose) then
    FOnClose(Sender, ACloseAction);
end;

function TFormFactory.ApplicationController: TApplicationController;
begin
  result := TApplicationController
    (MVCBr.ApplicationController.ApplicationController.This);
end;

function TFormFactory.ApplicationControllerInternal: IApplicationController;
begin
  result := MVCBr.ApplicationController.ApplicationController;
end;

procedure TFormFactory.DoCommand(ACommand: string;
  const AArgs: array of TValue);
begin

end;

function TFormFactory.ViewEventOther(AMessage: string): IView;
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
      ApplicationController.ViewEventOther(GetController, AMessage);
    finally
      dec(FEventRef);
    end;
  end;
end;

function TFormFactory.ViewEvent(AMessage: string): IView;
begin
  result := self;
  ///  use inherited this method on child
  ///  takecare put code here and start a loop whithout end
end;

function TFormFactory.MainViewEvent(AMessage: string): IView;
begin
  ApplicationController.MainView.ViewEvent(AMessage);
end;

procedure TFormFactory.SetPropertyValue(ANome: string; const Value: TValue);
begin
  TMVCBr.SetProperty(self, ANome, Value);
end;

procedure TFormFactory.SetShowModal(const AShowModal: boolean);
begin
  FShowModal := AShowModal;
end;

procedure TFormFactory.SetText(const Value: string);
begin
{$IFDEF FMX}
  Inherited Caption := Value;
{$ELSE}
  Inherited Caption := Value;
{$ENDIF}
end;

procedure TFormFactory.SetViewModel(const AViewModel: IViewModel);
begin
  // fazer herança
  if assigned(AViewModel) then
    AViewModel.View(self);

end;

function TFormFactory.ShowView(const IIDController: TGuid;
  const AProc: TProc<IView>): IView;
var
  LController: IController;
begin
  LController := ResolveController(IIDController);
  if assigned(LController) then
  begin
    result := LController.GetView;
    result.ShowView(AProc);
  end;
end;

function TFormFactory.ShowView(const AProc: TProc<IView>): Integer;
begin
  result := 0;
{$IFDEF MSWINDOWS}
  if FShowModal then
    result := ord(ShowModal);
  if assigned(AProc) then
    AProc(self);
{$ELSE}
  FOnCloseProc := AProc;
  OnClose := DoCloseView;
  Show;
{$ENDIF}
end;

function TFormFactory.This: TObject;
begin
  result := self;
end;

function TFormFactory.Update: IView;
begin
  result := self;
end;

{ TViewFactoryAdapter }

procedure TViewFactoryAdapter.DoClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if assigned(FOnProc) then
    FOnProc(self);
  if assigned(FForm) and assigned(FForm.OnClose) then
    FForm.OnClose(Sender, Action);
end;

function TViewFactoryAdapter.Form: TForm;
begin
  result := FForm;
end;

class function TViewFactoryAdapter.New(AForm: TForm;
  const AShowModal: boolean): IView;
var
  obj: TViewFactoryAdapter;
begin
  obj := TViewFactoryAdapter.Create;
  obj.FForm := AForm;
  obj.isShowModal := AShowModal;
  result := obj;
end;

class function TViewFactoryAdapter.New(AClass: TFormClass;
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
  FOnProc := AProc;
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
end;

function TViewFactoryAdapter.This: TObject;
begin
  result := self; // nao alterar... é esperado retornuar um view como retorno
end;

function TViewFactoryAdapter.ThisAs: TViewFactoryAdapter;
begin
  result := self;
end;

function TFormFactory.ShowView: IView;
begin
  result := self;
  ShowView(nil);
end;

function TFormFactory.ShowView(const AProc: TProc<IView>;
  AShowModal: boolean): Integer;
begin
  FShowModal := AShowModal;
  result := ShowView(AProc);
end;

end.
