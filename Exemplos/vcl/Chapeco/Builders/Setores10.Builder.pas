{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 16/07/2017 01:31:57                                  //}
{//************************************************************//}

Unit Setores10.Builder;

interface
uses
   System.SysUtils,
   {$IFDEF FMX} FMX.Forms,
   {$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf, MVCBr.Model,MVCBr.BuilderModel,
  Setores10.Builder.Interf,
  MVCBr.Patterns.Builder,  MVCBr.Controller,
  System.RTTI;
Type

 TSetores10Builder = class(TBuilderModelFactory,
                ISetores10Builder, IThisAs<TSetores10Builder>)
 protected
    procedure CreateSubClasses; override;
 public
    class function new(): ISetores10Builder; overload;
    class function new(const AController: IController):
ISetores10Builder; overload;
    function ThisAs: TSetores10Builder;
 // implementaçoes
  end;

Implementation

//uses Builder.Model.Classe1;

/// Add Sub-Classes of Builder

procedure TSetores10Builder.CreateSubClasses;
begin
/// Add Sub-Classes here
  //FBuilder.Add('comandoA', TSubClass1Item);
end;

function TSetores10Builder.ThisAs: TSetores10Builder;
begin
  result := self;
end;

class function TSetores10Builder.new(): ISetores10Builder;
begin
  result := new(nil);
 end;

class function TSetores10Builder.new(const AController:IController)
             : ISetores10Builder;
begin
  result := TSetores10Builder.Create;
  result.Controller(AController);
end;

Initialization

 TMVCRegister.RegisterType<ISetores10Builder, TSetores10Builder>
  (TSetores10Builder.classname, true);

end.
