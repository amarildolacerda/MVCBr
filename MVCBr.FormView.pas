unit MVCBr.FormView;

interface

uses {$IFDEF FMX} FMX.Forms, System.UiTypes, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, System.SysUtils, System.RTTI,
  MVCBr.Interf, MVCBr.View;

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
    class function New(AClass: TFormClass;
      const AShowModal: boolean = true): IView;
    property isShowModal: boolean read FisShowModal write SetisShowModal;
    function ShowView(const AProc: TProc<IView>): Integer; override;
    function Form: TForm;
    function ThisAs: TViewFactoryAdapter;
  end;

  /// <summary>
  /// TFormFactory é utilizado para herança dos TForms para transformar o FORM em VIEW no MVCBr
  /// </summary>
  TFormFactory = class(TForm, IMVCBrBase, IView)
  private
    FOnClose: TCloseEvent;
    FID: string;
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
    procedure SetOnClose(const Value: TCloseEvent);
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
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetID: string;
    property isShowModal: boolean read GetShowModal write SetShowModal;
    /// Retorna o controller ao qual a VIEW esta conectada
    function GetController: IController; virtual;
    /// Retorna o SELF
    function This: TObject; virtual;
    /// Executa um method genérico do FORM/VIEW
    function InvokeMethod<T>(AMethod: string; const Args: TArray<TValue>): T;
    function ResolveController(const IID: TGuid): IController; virtual;
    /// Obter ou Alterar o valor de uma propriedade do ObjetoClass  (VIEW)
    property PropertyValue[ANome: string]: TValue read GetPropertyValue
      write SetPropertyValue;
    /// Apresenta o VIEW para o usuario
    function ShowView(const AProc: TProc<IView>): Integer; overload; virtual;
    function ShowView(const IIDController: TGuid; const AProc: TProc<IView>)
      : IView; overload; virtual;
    function ShowView(): IView; overload;
    procedure SetViewModel(const AViewModel: IViewModel); virtual;
    function GetViewModel: IViewModel; virtual;
    /// Evento para atualizar os dados da VIEW
    function Update: IView; virtual;
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

function TFormFactory.Controller(const AController: IController): IView;
begin
  result := self;
  FController := AController;
end;

var LFormCount:integer=0;
constructor TFormFactory.Create(AOwner: TComponent);
begin
  inherited;
  inc (LFormCount);
  FID := classname+'_'+intToStr(LFormCount);
end;

destructor TFormFactory.Destroy;
begin
  if assigned(FController) then
    FController.This.RevokeInstance(FController);
  inherited;
end;

function TFormFactory.GetController: IController;
begin
  result := FController;
end;

function TFormFactory.GetID: string;
begin
  result := FID;
end;

function TFormFactory.GetPropertyValue(ANome: string): TValue;
begin
  result := TMVCBr.GetProperty(self, ANome);
end;

function TFormFactory.GetShowModal: boolean;
begin
  result := FShowModal;
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

procedure TFormFactory.SetPropertyValue(ANome: string; const Value: TValue);
begin
  TMVCBr.SetProperty(self, ANome, Value);
end;

procedure TFormFactory.SetShowModal(const AShowModal: boolean);
begin
  FShowModal := AShowModal;
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

function TViewFactoryAdapter.ThisAs: TViewFactoryAdapter;
begin
  result := self;
end;

function TFormFactory.ShowView: IView;
begin
  result := self;
  ShowView(nil);
end;

end.
