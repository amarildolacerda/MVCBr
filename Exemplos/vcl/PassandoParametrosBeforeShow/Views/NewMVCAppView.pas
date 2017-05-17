{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/05/2017 22:59:43                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit NewMVCAppView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.Controls, VCL.StdCtrls;

type
  /// Interface para a VIEW
  INewMVCAppView = interface(IView)
    ['{B65B0116-AAB3-4F0B-973C-2148E36796C0}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TNewMVCAppView = class(TFormFactory { TFORM } , IView,
    IThisAs<TNewMVCAppView>, INewMVCAppView, IViewAs<INewMVCAppView>)
    Button1: TButton;
    Edit1: TEdit;
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
    function ThisAs: TNewMVCAppView;
    function ViewAs: INewMVCAppView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
  end;

Implementation

{$R *.DFM}

uses SegundaView.Controller.Interf, Dialogs, SegundaViewView;

function TNewMVCAppView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TNewMVCAppView.ViewAs: INewMVCAppView;
begin
  result := self;
end;

class function TNewMVCAppView.New(aController: IController): IView;
begin
  result := TNewMVCAppView.create(nil);
  result.Controller(aController);
end;

procedure TNewMVCAppView.Button1Click(Sender: TObject);
begin
  ShowView(ISegundaViewController,
    procedure(ASegundaView: IView)   // beforeShow
    begin
        // Opção recomendade para o MVC - Opção Limpa
        (ASegundaView as ISegundaViewView).Parametro1(  edit1.text   );

        // Segunda opção Dirty
        // (ASegundaView.this as TSegundaViewView).Parametro1(edit1.text);

        // Terceira Opção Dirty
        // (ASegundaView as ISegundaViewView).ThisAs.parametro1(edit1.text);


    end);
end;

function TNewMVCAppView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TNewMVCAppView.Init;
begin
  // incluir incializações aqui
end;

function TNewMVCAppView.This: TObject;
begin
  result := inherited This;
end;

function TNewMVCAppView.ThisAs: TNewMVCAppView;
begin
  result := self;
end;

function TNewMVCAppView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
