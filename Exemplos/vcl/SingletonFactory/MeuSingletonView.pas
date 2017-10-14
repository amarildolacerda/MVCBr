{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 09/10/2017 22:47:09                                  // }
{ //************************************************************// }

/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit MeuSingletonView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.Controls, VCL.StdCtrls;

type
  /// Interface para a VIEW
  IMeuSingletonView = interface(IView)
    ['{9ED3AAE2-D7D1-4343-B219-597C9358CB7A}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TMeuSingletonView = class(TFormFactory { TFORM } , IView,
    IThisAs<TMeuSingletonView>, IMeuSingletonView, IViewAs<IMeuSingletonView>)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    FInited: boolean;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ThisAs: TMeuSingletonView;
    function ViewAs: IMeuSingletonView;
    function ShowView(const AProc: TProc<IView>): integer; override;
  end;

Implementation

uses
  Dialogs,
  MVCBr.Patterns.Singleton,
  singleton.MinhaClasse;
{$R *.DFM}

function TMeuSingletonView.ViewAs: IMeuSingletonView;
begin
  result := self;
end;

class function TMeuSingletonView.New(aController: IController): IView;
begin
  result := TMeuSingletonView.create(nil);
  result.Controller(aController);
end;

procedure TMeuSingletonView.Button1Click(Sender: TObject);
var
  MinhaClasseFactory: IMVCBrSingleton<TMinhaClasseAlvo>;
begin
  /// LOCAL
  /// criando a classe factory para singleton
  MinhaClasseFactory := TMVCBrSingleton<TMinhaClasseAlvo>.New();
  showMessage(MinhaClasseFactory.mudarFlag(true).ToString);



  /// Usando Global
  ///
  showMessage( MinhaClasseFactory.mudarFlag(false).toString);
end;

function TMeuSingletonView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    init;
    FInited := true;
  end;
end;

function TMeuSingletonView.ThisAs: TMeuSingletonView;
begin
  result := self;
end;

function TMeuSingletonView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
