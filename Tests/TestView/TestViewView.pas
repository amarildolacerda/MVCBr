{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/06/2017 21:46:56                                  // }
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
    ['{495C20E3-00C8-464C-84C4-1DBE7494B120}']
    // incluir especializacoes aqui
    function getStubInt: integer;
  end;

  /// Object Factory que implementa a interface da VIEW
  TTestViewView = class(TFormFactory { TFORM } , IView, IThisAs<TTestViewView>,
    ITestViewView, IViewAs<ITestViewView>)
    procedure FormFactoryViewEvent(AMessage: TJSONValue; var AHandled: Boolean);
  private
    FInited: Boolean;
    FCount:integer;
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    destructor Destroy;override;
    function This: TObject; override;
    function ThisAs: TTestViewView;
    function ViewAs: ITestViewView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
    function getStubInt: integer;
    function GetShowModalStub:Boolean;
  end;

Implementation

{$R *.DFM}

function TTestViewView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TTestViewView.ViewAs: ITestViewView;
begin
  result := self;
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

destructor TTestViewView.Destroy;
begin

  inherited;
end;

procedure TTestViewView.FormFactoryViewEvent(AMessage: TJSONValue;
  var AHandled: Boolean);
begin
    inc(FCount);
    AHandled := true;
end;

function TTestViewView.GetShowModalStub: Boolean;
begin
  result := true;
end;

function TTestViewView.getStubInt: integer;
begin
  result := FCount;
end;

procedure TTestViewView.Init;
begin
  FCount := 1;
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
