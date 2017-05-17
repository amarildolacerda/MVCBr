{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 19/02/2017 19:38:52                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit dBowserView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.Controls, VCL.OleCtrls,
  SHDocVw;

type
  /// Interface para a VIEW
  IdBowserView = interface(IView)
    ['{A1E6F144-BB74-493C-9ADF-3E2C6D0246A1}']
    // incluir especializacoes aqui
    procedure GoToURL(AURL:String);
  end;

  /// Object Factory que implementa a interface da VIEW
  TdBowserView = class(TFormFactory { TFORM } , IView, IThisAs<TdBowserView>,
    IdBowserView, IViewAs<IdBowserView>)
    WebBrowser1: TWebBrowser;
  private
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TdBowserView;
    function ViewAs: IdBowserView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
    procedure GoToURL(AURL:String);
  end;

Implementation

{$R *.DFM}

function TdBowserView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TdBowserView.ViewAs: IdBowserView;
begin
  result := self;
end;

procedure TdBowserView.GoToURL(AURL: String);
begin
   WebBrowser1.Navigate(AURL);
end;

class function TdBowserView.New(aController: IController): IView;
begin
  result := TdBowserView.create(nil);
  result.Controller(aController);
end;

function TdBowserView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
end;

function TdBowserView.This: TObject;
begin
  result := inherited This;
end;

function TdBowserView.ThisAs: TdBowserView;
begin
  result := self;
end;

function TdBowserView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
