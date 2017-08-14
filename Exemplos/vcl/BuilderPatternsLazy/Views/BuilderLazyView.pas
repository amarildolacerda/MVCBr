{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/07/2017 20:30:26                                  // }
{ //************************************************************// }

/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit BuilderLazyView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  FormulasCustos.Builder.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller,
  VCL.Controls, VCL.StdCtrls;

type
  /// Interface para a VIEW
  IBuilderLazyView = interface(IView)
    ['{B4BF06E2-4157-4FF4-8FCD-F0D6C5FB8805}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TBuilderLazyView = class(TFormFactory { TFORM } , IView,
    IThisAs<TBuilderLazyView>, IBuilderLazyView, IViewAs<IBuilderLazyView>)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
  private
    FInited: boolean;
  protected
    FFormulasCalculoCusto: IFormulasCustosBuilderModel;
    function Controller(const aController: IController): IView; override;
    procedure Init; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ThisAs: TBuilderLazyView;
    function ViewAs: IBuilderLazyView;
    function ShowView(const AProc: TProc<IView>): integer; override;
  end;

Implementation

{$R *.DFM}

uses Dialogs, FormulasCustos.Builder;

function TBuilderLazyView.ViewAs: IBuilderLazyView;
begin
  result := self;
end;

procedure TBuilderLazyView.Init;
begin
  FFormulasCalculoCusto := TFormulasCustosBuilderModel.New(GetController);
end;

class function TBuilderLazyView.New(aController: IController): IView;
begin
  result := TBuilderLazyView.create(nil);
  result.Controller(aController);

end;

procedure TBuilderLazyView.Button1Click(Sender: TObject);
var
  idProduto: double;
begin
  idProduto := 2;
  FFormulasCalculoCusto.Lazy.Query
    (TFormulasCustosModelCommands.cmd_margem_comercial)
  { with FFormulasCalculoCusto.Execute( TFormulasCustosModelCommands.cmd_margem_comercial, IdProduto  ) do
    begin
    ShowMessage( Response.asString );
    end; }
    end;

  function TBuilderLazyView.Controller(const aController: IController): IView;
  begin
    result := inherited Controller(aController);
    if not FInited then
    begin
      Init;
      FInited := true;
    end;
  end;

  function TBuilderLazyView.ThisAs: TBuilderLazyView;
  begin
    result := self;
  end;

  function TBuilderLazyView.ShowView(const AProc: TProc<IView>): integer;
  begin
    inherited;
  end;

end.
