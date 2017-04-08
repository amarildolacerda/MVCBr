{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 08/04/2017 12:03:25                                  // }
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
  MVCBr.View, MVCBr.FormView, MVCBr.Controller;

type
  /// Interface para a VIEW
  ITestSecondView = interface(IView)
    ['{19EF11CD-ADBC-4C57-BEB5-61B1C8C4796B}']
    // incluir especializacoes aqui
    function GetStubString: string;
  end;

  /// Object Factory que implementa a interface da VIEW
  TTestSecondView = class(TFormFactory { TFORM } , IView,
    IThisAs<TTestSecondView>, ITestSecondView, IViewAs<ITestSecondView>)
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
    function Update: IView; override;
    function GetStubString: string;
  end;

Implementation

{$R *.DFM}

function TTestSecondView.Update: IView;
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
