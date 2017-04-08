{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 08/04/2017 10:52:03                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit TestViewView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller;

type
  /// Interface para a VIEW
  ITestViewView = interface(IView)
    ['{C32F6695-D88B-42C3-A605-04D878600545}']
    // incluir especializacoes aqui
    function getStubInt: integer;
  end;

  /// Object Factory que implementa a interface da VIEW
  TTestViewView = class(TFormFactory { TFORM } , IView, IThisAs<TTestViewView>,
    ITestViewView, IViewAs<ITestViewView>)
  private
    FInited: Boolean;
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TTestViewView;
    function ViewAs: ITestViewView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;

    function GetShowModalStub: Boolean;
    function getStubInt: integer;
    function ViewEvent(AMessage: string; var AHandled: Boolean): IView;
      overload; override;
    function ViewEvent(AJson: TJsonValue; var AHandled: Boolean): IView;
      overload; override;
  end;

Implementation

{$R *.DFM}

function TTestViewView.Update: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TTestViewView.ViewEvent(AJson: TJsonValue;
  var AHandled: Boolean): IView;
var
  txt: string;
begin
  result := self;
  if AJson.TryGetValue<string>('texto', txt) then
    AHandled := txt = 'test';
end;

function TTestViewView.ViewAs: ITestViewView;
begin
  result := self;
end;

function TTestViewView.ViewEvent(AMessage: string;
  var AHandled: Boolean): IView;
begin
  /// recebe um evento.
  ///
  if AMessage = 'teste.event' then
    AHandled := true;

end;

class function TTestViewView.New(aController: IController): IView;
begin
  result := TTestViewView.create(nil);
  result.Controller(aController);
end;

function TTestViewView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

function TTestViewView.GetShowModalStub: Boolean;
begin
  result := isShowModal;
end;

function TTestViewView.getStubInt: integer;
begin
  result := 1;
end;

procedure TTestViewView.Init;
begin
  // incluir incializações aqui
end;

function TTestViewView.This: TObject;
begin
  result := inherited This;
end;

function TTestViewView.ThisAs: TTestViewView;
begin
  result := self;
end;

function TTestViewView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
