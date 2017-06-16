{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/06/2017 21:47:38                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit TestSecondView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller;

type
  /// Interface para a VIEW
  ITestSecondView = interface(IView)
    ['{38EC34E3-568C-4FC4-B7C5-4240C45D27C9}']
    // incluir especializacoes aqui
    function getStubInt:integer;
    function GetStubString:string;
  end;

  /// Object Factory que implementa a interface da VIEW
  TTestSecondView = class(TFormFactory { TFORM } , IView,
    IThisAs<TTestSecondView>, ITestSecondView, IViewAs<ITestSecondView>)
    procedure FormFactoryViewEvent(AMessage: TJSONValue; var AHandled: Boolean);
  private
    FInited: Boolean;
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TTestSecondView;
    function ViewAs: ITestSecondView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
    function getStubInt:integer;
    function GetStubString:string;
    function GetShowModalStub:boolean;
  end;

Implementation

{$R *.DFM}


function TTestSecondView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TTestSecondView.ViewAs: ITestSecondView;
begin
  result := self;
end;

class function TTestSecondView.New(aController: IController): IView;
begin
  result := TTestSecondView.create(nil);
  result.Controller(aController);
end;

function TTestSecondView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TTestSecondView.FormFactoryViewEvent(AMessage: TJSONValue;
  var AHandled: Boolean);
begin
     AHandled := true;
end;

function TTestSecondView.GetShowModalStub: boolean;
begin
   result := true;
end;

function TTestSecondView.getStubInt: integer;
begin
  result := 1;
end;

function TTestSecondView.GetStubString: string;
begin
   result := 'test';
end;

procedure TTestSecondView.Init;
begin
  // incluir incializações aqui


end;

function TTestSecondView.This: TObject;
begin
  result := inherited This;
end;

function TTestSecondView.ThisAs: TTestSecondView;
begin
  result := self;
end;

function TTestSecondView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
