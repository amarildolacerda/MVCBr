{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 01/05/2017 15:04:55                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit UsandoTLayoutView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, FMX.Controls,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Types, FMX.Layouts;

type
  /// Interface para a VIEW
  IUsandoTLayoutView = interface(IView)
    ['{A3C84396-B53C-43F0-92F5-F1677F582085}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TUsandoTLayoutView = class(TFormFactory { TFORM } , IView,
    IThisAs<TUsandoTLayoutView>, IUsandoTLayoutView,
    IViewAs<IUsandoTLayoutView>)
    Layout1: TLayout;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    FInited: Boolean;
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TUsandoTLayoutView;
    function ViewAs: IUsandoTLayoutView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

Implementation

{$R *.fmx}

uses segundoForm.Controller.Interf;

function TUsandoTLayoutView.Update: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TUsandoTLayoutView.ViewAs: IUsandoTLayoutView;
begin
  result := self;
end;

class function TUsandoTLayoutView.New(aController: IController): IView;
begin
  result := TUsandoTLayoutView.create(nil);
  result.Controller(aController);
end;

procedure TUsandoTLayoutView.Button1Click(Sender: TObject);
var
  segundoForm: IsegundoFormController;
  layout: ILayout;
begin
  segundoForm := ResolveController<IsegundoFormController>;
  segundoForm.Embedded( Layout1  );
end;

function TUsandoTLayoutView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TUsandoTLayoutView.Init;
begin
  // incluir incializações aqui
end;

function TUsandoTLayoutView.This: TObject;
begin
  result := inherited This;
end;

function TUsandoTLayoutView.ThisAs: TUsandoTLayoutView;
begin
  result := self;
end;

function TUsandoTLayoutView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
