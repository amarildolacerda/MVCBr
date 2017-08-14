{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 09/07/2017 21:10:02                                  // }
{ //************************************************************// }

/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit NewMVCAppMouraoView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.Controls, VCL.StdCtrls;

type
  /// Interface para a VIEW
  INewMVCAppMouraoView = interface(IView)
    ['{E66520B9-3DE2-4C02-AE3F-9EFEC9B8860B}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TNewMVCAppMouraoView = class(TFormFactory { TFORM } , IView,
    IThisAs<TNewMVCAppMouraoView>, INewMVCAppMouraoView,
    IViewAs<INewMVCAppMouraoView>)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    FInited: boolean;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ThisAs: TNewMVCAppMouraoView;
    function ViewAs: INewMVCAppMouraoView;
    function ShowView(const AProc: TProc<IView>): integer; override;
  end;

Implementation

{$R *.DFM}

uses Dialogs, SegundoForm.Controller.Interf, CacularJuros.Model.Interf;

function TNewMVCAppMouraoView.ViewAs: INewMVCAppMouraoView;
begin
  result := self;
end;

class function TNewMVCAppMouraoView.New(aController: IController): IView;
begin
  result := TNewMVCAppMouraoView.create(nil);
  result.Controller(aController);
end;

procedure TNewMVCAppMouraoView.Button1Click(Sender: TObject);
var
  aController: IController;
begin
  ///
  ///
  aController := ResolveController(iSegundoFormController);
  aController.ShowView;
end;

procedure TNewMVCAppMouraoView.Button2Click(Sender: TObject);
var
  aController: iSegundoFormController;
begin
  aController := ResolveController<iSegundoFormController>;
  aController.ShowView;
end;

procedure TNewMVCAppMouraoView.Button3Click(Sender: TObject);
var
  AModel: ICacularJurosModel;
begin
  AModel := GetModel<ICacularJurosModel>;
  Showmessage(AModel.Calcular.toString);
end;

function TNewMVCAppMouraoView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    init;
    FInited := true;
  end;
end;

function TNewMVCAppMouraoView.ThisAs: TNewMVCAppMouraoView;
begin
  result := self;
end;

function TNewMVCAppMouraoView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
