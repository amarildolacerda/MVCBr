{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 04/07/2017 21:51:17                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit NewMVCAppFACADEView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.StdCtrls, VCL.Controls,
  MVCBr.Patterns.Facade, System.RTTI,
  VCL.ExtCtrls;

type
  /// Interface para a VIEW
  INewMVCAppFACADEView = interface(IView)
    ['{7007BB69-CCAB-438E-ABB4-7BAE09090F52}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TNewMVCAppFACADEView = class(TFormFactory { TFORM } , IView, IThisAs<TNewMVCAppFACADEView>, INewMVCAppFACADEView, IViewAs<INewMVCAppFACADEView>)
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FFacade: TMVCBrFacade;
    FInited: boolean;
  protected
    function Controller(const aController: IController): IView; override;

    procedure CriarComandos;
    procedure mensagem(txt: string);

  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ThisAs: TNewMVCAppFACADEView;
    function ViewAs: INewMVCAppFACADEView;
    function ShowView(const AProc: TProc<IView>): integer; override;
  end;

Implementation

{$R *.DFM}

uses ACBrSATClass, PDVSat.Model.Interf, PDVSat.Comandos;

function TNewMVCAppFACADEView.ViewAs: INewMVCAppFACADEView;
begin
  result := self;
end;

procedure TNewMVCAppFACADEView.CriarComandos;
begin

  /// processo 1
  FFacade.Add('P1',
    function(Sender: TValue): boolean
    begin
      mensagem('executou processo 1');
    end);

  /// processo 2
  FFacade.Add('P2',
    function(Sender: TValue): boolean
    begin
      mensagem('executou processo 2');
    end);

  /// processo 2
  FFacade.Add('P3',
    function(Sender: TValue): boolean
    begin
      mensagem('executou processo 3');
    end);

end;

procedure TNewMVCAppFACADEView.FormCreate(Sender: TObject);
begin

  FFacade := TMVCBrFacade.New;
  CriarComandos;

end;

procedure TNewMVCAppFACADEView.FormDestroy(Sender: TObject);
begin
  FFacade.free;
end;

procedure TNewMVCAppFACADEView.mensagem(txt: string);
begin
  Memo1.lines.Add(txt);
end;

class function TNewMVCAppFACADEView.New(aController: IController): IView;
begin
  result := TNewMVCAppFACADEView.create(nil);
  result.Controller(aController);
end;

procedure TNewMVCAppFACADEView.Button1Click(Sender: TObject);
begin
  FFacade.Execute('P' + (RadioGroup1.ItemIndex + 1).ToString, nil);
end;

procedure TNewMVCAppFACADEView.Button2Click(Sender: TObject);
var
  AModel: IPDVSatModel;
  FSatStatus: TACBrSATStatus;
begin

  AModel := GetModel(IPDVSatModel) as IPDVSatModel;
  AModel.ExecutarComando(TPDVSatComandos.cmd_GravarEstatus, FSatStatus);

  /// AModel.ExecutarComando( 'xxxxx',  Dado);

end;

function TNewMVCAppFACADEView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    init;
    FInited := true;
  end;
end;

function TNewMVCAppFACADEView.ThisAs: TNewMVCAppFACADEView;
begin
  result := self;
end;

function TNewMVCAppFACADEView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
