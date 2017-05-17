{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 26/03/2017 11:40:55                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit FormChildSampleView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.Controls, VCL.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  /// Interface para a VIEW
  IFormChildSampleView = interface(IView)
    ['{2E701A59-BD5A-4A94-BDC4-F1C445083A99}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TFormChildSampleView = class(TFormFactory { TFORM } , IView,
    IThisAs<TFormChildSampleView>, IFormChildSampleView,
    IViewAs<IFormChildSampleView>)
    Button1: TButton;
    Panel1: TPanel;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    FInited: Boolean;
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TFormChildSampleView;
    function ViewAs: IFormChildSampleView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
  end;

Implementation

{$R *.DFM}

uses  FormChild.Controller.Interf,RegrasNegocios.Model.Interf,
  embededForm.Controller.Interf, embededFormView;

function TFormChildSampleView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TFormChildSampleView.ViewAs: IFormChildSampleView;
begin
  result := self;
end;

class function TFormChildSampleView.New(aController: IController): IView;
begin
  result := TFormChildSampleView.create(nil);
  result.Controller(aController);
end;

procedure TFormChildSampleView.Button1Click(Sender: TObject);
var aController:IFormChildController;
begin
   aController := resolveController<IFormChildController>;
   aController.ShowView();
end;

procedure TFormChildSampleView.Button2Click(Sender: TObject);
var
   AModel:IRegrasNegociosModel;
begin
   AModel := GetModel<IRegrasNegociosModel>;
   AModel.Validar('Show Model Validar()');
end;

procedure TFormChildSampleView.Button3Click(Sender: TObject);
var h:boolean;
begin
   applicationController.ViewEvent( 'generic message to all VIEW', h );
end;

procedure TFormChildSampleView.Button4Click(Sender: TObject);
var h:Boolean;
begin
   ApplicationController.ViewEvent(IEmbededFormView,'Message to: EmbededFormView',h);
end;

procedure TFormChildSampleView.Button5Click(Sender: TObject);
var h:boolean;
begin
  ResolveController<IEmbededFormController>.ViewEvent('Message via controller',h);
end;

function TFormChildSampleView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TFormChildSampleView.Init;
var
   ACtrl:IEmbededFormController;
   AForm:TForm;
begin
  // incluir incializações aqui

   // embeded form...
   ACtrl :=  resolveController<IEmbededFormController>;
   AForm := TForm(ACtrl.GetView.This);
   AForm.parent := TabSheet1;
   AForm.BorderStyle := bsNone;
   AForm.Align := alClient;
   AForm.Show;

end;



function TFormChildSampleView.This: TObject;
begin
  result := inherited This;
end;

function TFormChildSampleView.ThisAs: TFormChildSampleView;
begin
  result := self;
end;

function TFormChildSampleView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
