{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 05/05/2017 11:12:00                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit NewMVCAppParametersView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.StdCtrls, VCL.Controls;

type
  /// Interface para a VIEW
  INewMVCAppParametersView = interface(IView)
    ['{78C01C67-C73F-4CD9-8B2C-20DDB8205487}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TNewMVCAppParametersView = class(TFormFactory { TFORM } , IView,
    IThisAs<TNewMVCAppParametersView>, INewMVCAppParametersView,
    IViewAs<INewMVCAppParametersView>)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    FInited: Boolean;
    procedure ParametersApply(AView:IView);
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TNewMVCAppParametersView;
    function ViewAs: INewMVCAppParametersView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

Implementation

{$R *.DFM}

uses ParametrosView, Parametros.Controller.Interf;

function TNewMVCAppParametersView.Update: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TNewMVCAppParametersView.ViewAs: INewMVCAppParametersView;
begin
  result := self;
end;

class function TNewMVCAppParametersView.New(aController: IController): IView;
begin
  result := TNewMVCAppParametersView.create(nil);
  result.Controller(aController);
end;

procedure TNewMVCAppParametersView.ParametersApply(AView: IView);
begin
  Memo1.lines.text := (AView as IParametrosView).GetWhereString;
end;

procedure TNewMVCAppParametersView.Button1Click(Sender: TObject);
begin
  ShowView(IParametrosController, nil, ParametersApply);
end;

function TNewMVCAppParametersView.Controller(const aController
  : IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TNewMVCAppParametersView.Init;
begin
  // incluir incializações aqui
end;

function TNewMVCAppParametersView.This: TObject;
begin
  result := inherited This;
end;

function TNewMVCAppParametersView.ThisAs: TNewMVCAppParametersView;
begin
  result := self;
end;

function TNewMVCAppParametersView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
