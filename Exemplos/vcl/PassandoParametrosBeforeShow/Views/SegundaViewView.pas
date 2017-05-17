{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/05/2017 23:00:33                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit SegundaViewView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.Controls, VCL.StdCtrls;

type

  TSegundaViewView =class;

  /// Interface para a VIEW
  ISegundaViewView = interface(IView)
    ['{74896202-500F-46F8-B456-822C294FB65D}']
    // incluir especializacoes aqui
    procedure Parametro1(txt: string);
    function ThisAs: TSegundaViewView;
  end;

  /// Object Factory que implementa a interface da VIEW
  TSegundaViewView = class(TFormFactory { TFORM } , IView,
    IThisAs<TSegundaViewView>, ISegundaViewView, IViewAs<ISegundaViewView>)
    Edit1: TEdit;
  private
    FInited: Boolean;
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TSegundaViewView;
    function ViewAs: ISegundaViewView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;

    procedure Parametro1(txt: string);

  end;

Implementation

{$R *.DFM}

function TSegundaViewView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TSegundaViewView.ViewAs: ISegundaViewView;
begin
  result := self;
end;

class function TSegundaViewView.New(aController: IController): IView;
begin
  result := TSegundaViewView.create(nil);
  result.Controller(aController);
end;

procedure TSegundaViewView.Parametro1(txt: string);
begin
  Edit1.text := txt;
end;

function TSegundaViewView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TSegundaViewView.Init;
begin
  // incluir incializações aqui
end;

function TSegundaViewView.This: TObject;
begin
  result := inherited This;
end;

function TSegundaViewView.ThisAs: TSegundaViewView;
begin
  result := self;
end;

function TSegundaViewView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
