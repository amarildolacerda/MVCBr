unit MVCBr.FormView;

interface

uses Forms, System.Classes, System.SysUtils, System.RTTI,
  MVCBr.Interf, MVCBr.View;

type

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
    class function New(AClass: TFormClass; const AShowModal: boolean = true): IView;
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
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
  protected
    FController: IController;
    FShowModal: boolean;
    procedure SetController(const AController: IController);
    function Controller(const AController: IController): IView; virtual;
    procedure AfterConstruction; override;
    procedure SetShowModal(const AShowModal: boolean);
    /// Retorna se a apresentação do formulário é ShowModal
    function GetShowModal: boolean;
  public
    property isShowModal: boolean read GetShowModal write SetShowModal;
    /// Retorna o controller ao qual a VIEW esta conectada
    function GetController: IController; virtual;
    /// Retorna o SELF
    function This: TObject; virtual;
    /// Executa um method genérico do FORM/VIEW
    function InvokeMethod<T>(AMethod: string; const Args: TArray<TValue>): T;
    /// Obter ou Alterar o valor de uma propriedade do ObjetoClass  (VIEW)
    property PropertyValue[ANome: string]: TValue read GetPropertyValue write SetPropertyValue;
    /// Apresenta o VIEW para o usuario
    function ShowView(const AProc: TProc<IView>): Integer; virtual;
    /// Evento para atualizar os dados da VIEW
    function Update: IView; virtual;
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

function TFormFactory.GetController: IController;
begin
  result := FController;
end;

function TFormFactory.GetPropertyValue(ANome: string): TValue;
begin
  result := TMVCBr.GetProperty(self, ANome);
end;

function TFormFactory.GetShowModal: boolean;
begin
  result := FShowModal;
end;

function TFormFactory.InvokeMethod<T>(AMethod: string; const Args: TArray<TValue>): T;
begin
  result := TMVCBr.InvokeMethod<T>(self, AMethod, Args);
end;

procedure TFormFactory.SetController(const AController: IController);
begin
  FController := AController;
end;

procedure TFormFactory.SetPropertyValue(ANome: string; const Value: TValue);
begin
  TMVCBr.SetProperty(self, ANome, Value);
end;

procedure TFormFactory.SetShowModal(const AShowModal: boolean);
begin
  FShowModal := AShowModal;
end;

function TFormFactory.ShowView(const AProc: TProc<IView>): Integer;
begin
  result := 0;
  if FShowModal then
    result := ord(ShowModal);
  if assigned(AProc) then
    AProc(self);
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

procedure TViewFactoryAdapter.DoClose(Sender: TObject; var Action: TCloseAction);
begin
  if assigned(FOnProc) then
    FOnProc(self);
end;

function TViewFactoryAdapter.Form: TForm;
begin
  result := FForm;
end;

class function TViewFactoryAdapter.New(AClass: TFormClass; const AShowModal: boolean): IView;
var
  obj: TViewFactoryAdapter;
begin
  obj := TViewFactoryAdapter.create;
  obj.FForm := AClass.create(nil);
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
    FForm.show;
  end;
end;

function TViewFactoryAdapter.ThisAs: TViewFactoryAdapter;
begin
  result := self;
end;

end.
