{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 09/07/2017 21:16:53                                  // }
{ //************************************************************// }

/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit SegundoFormView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller;

type
  /// Interface para a VIEW
  ISegundoFormView = interface(IView)
    ['{0A7763C6-7E6F-4675-BEDA-16E41005EA36}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TSegundoFormView = class(TFormFactory { TFORM } , IView,
    IThisAs<TSegundoFormView>, ISegundoFormView, IViewAs<ISegundoFormView>)
  private
    FInited: boolean;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ThisAs: TSegundoFormView;
    function ViewAs: ISegundoFormView;
    function ShowView(const AProc: TProc<IView>): integer; override;
  end;

Implementation

{$R *.DFM}

function TSegundoFormView.ViewAs: ISegundoFormView;
begin
  result := self;
end;

class function TSegundoFormView.New(aController: IController): IView;
begin
  result := TSegundoFormView.create(nil);
  result.Controller(aController);
end;

function TSegundoFormView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    init;
    FInited := true;
  end;
end;

function TSegundoFormView.ThisAs: TSegundoFormView;
begin
  result := self;
end;

function TSegundoFormView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
