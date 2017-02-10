{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br                                // }
{ //************************************************************// }
{ // Data: 09/02/2017 21:37:09                                  // }
{ //************************************************************// }
unit AureliosExemploView;

// Código gerado pelo assistente     MVCBr OTA
// www.tireideletra.com.br
{ .$I ..\inc\mvcbr.inc }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, StdCtrls, ComCtrls, ExtCtrls, Forms, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, AureliosExemplo.ViewModel.Interf,
  MVCBr.Controller;

type
  IAureliosExemploView = interface(IView)
    ['{DD07878B-2657-4ABE-B79E-34D3CEB7CFCC}']
    // incluir especializacoes aqui
  end;

  TAureliosExemploView = class(TFormFactory { TFORM } , IView,
    IThisAs<TAureliosExemploView>, IAureliosExemploView,
    IViewAs<IAureliosExemploView>)
  private
    FViewModel: IAureliosExemploViewModel;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ViewModel(const AViewModel: IAureliosExemploViewModel): IView;
    function This: TObject; override;
    function ThisAs: TAureliosExemploView;
    function ViewAs: IAureliosExemploView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

implementation

{$R *.fmx}

function TAureliosExemploView.Update: IView;
begin
  result := self;
  if assigned(FViewModel) then
    FViewModel.Update(self as IView);
  { codigo para atualizar a View vai aqui... }
end;

function TAureliosExemploView.ViewAs: IAureliosExemploView;
begin
  result := self;
end;

class function TAureliosExemploView.New(aController: IController): IView;
begin
  result := TAureliosExemploView.create(nil);
  result.Controller(aController);
end;

function TAureliosExemploView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
end;

function TAureliosExemploView.ViewModel(const AViewModel
  : IAureliosExemploViewModel): IView;
begin
  result := self;
  if assigned(AViewModel) then
    FViewModel := AViewModel;
end;

function TAureliosExemploView.This: TObject;
begin
  result := inherited This;
end;

function TAureliosExemploView.ThisAs: TAureliosExemploView;
begin
  result := self;
end;

function TAureliosExemploView.ShowView(const AProc: TProc<IView>): integer;
var
  vm: IModel;
begin
  if assigned(FController) then
  begin
    vm := FController.GetModelByType(mtViewModel);
    if assigned(vm) then
      supports(vm.This, IAureliosExemploViewModel, FViewModel);
  end;
  ShowModal;
  result := ord(ModalResult);
  if assigned(AProc) then
    AProc(self);
end;

end.
