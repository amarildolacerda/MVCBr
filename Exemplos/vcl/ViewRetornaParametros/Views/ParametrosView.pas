{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 05/05/2017 11:14:34                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit ParametrosView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.StdCtrls, VCL.Controls,
  VCL.ExtCtrls;

type
  /// Interface para a VIEW
  IParametrosView = interface(IView)
    ['{838227AC-E658-4193-91B9-25790379DF49}']
    // incluir especializacoes aqui

    function GetWhereString: string;

  end;

  /// Object Factory que implementa a interface da VIEW
  TParametrosView = class(TFormFactory { TFORM } , IView,
    IThisAs<TParametrosView>, IParametrosView, IViewAs<IParametrosView>)
    LabeledEdit1: TLabeledEdit;
    Button1: TButton;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FInited: Boolean;
  protected
    FWhere: string;
    procedure Init;
    procedure WhereBuilder;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TParametrosView;
    function ViewAs: IParametrosView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
    function GetWhereString: string;
  end;

Implementation

{$R *.DFM}

function TParametrosView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TParametrosView.ViewAs: IParametrosView;
begin
  result := self;
end;

procedure TParametrosView.WhereBuilder;
  procedure add( AText:string );
  begin
    if FWhere <> '' then
       FWhere := FWhere + ' and ' ;
    FWhere := FWhere + AText;
  end;
begin
  FWhere := '';
  if LabeledEdit1.text<>'' then
     add( 'email_from like ('+quotedStr(LabeledEdit1.text+'%')+')');
  if LabeledEdit2.text<>'' then
     add( 'email_to like ('+quotedStr(LabeledEdit2.text+'%')+')');
  if LabeledEdit3.text<>'' then
     add( 'email_subject like ('+quotedStr(LabeledEdit3.text+'%')+')');
end;

class function TParametrosView.New(aController: IController): IView;
begin
  result := TParametrosView.create(nil);
  result.Controller(aController);
end;

procedure TParametrosView.Button1Click(Sender: TObject);
begin
  WhereBuilder;
  close;
end;

function TParametrosView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TParametrosView.FormShow(Sender: TObject);
begin
  FWhere := '';
end;

function TParametrosView.GetWhereString: string;
begin
  result := FWhere;
end;

procedure TParametrosView.Init;
begin
  // incluir incializações aqui
end;

function TParametrosView.This: TObject;
begin
  result := inherited This;
end;

function TParametrosView.ThisAs: TParametrosView;
begin
  result := self;
end;

function TParametrosView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
