{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 08/04/2017 11:23:33                                  //}
{//************************************************************//}
Unit  Test.Model;
{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface
{.$I ..\inc\mvcbr.inc}
uses System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes, MVCBr.Interf, MVCBr.Model,
   Test.Model.Interf, //%Interf,
MVCBr.Controller;
Type
  TTestModel = class(TModelFactory,ITestModel,    IThisAs<TTestModel>)
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new():ITestModel; overload;
    class function new(const AController:IController):ITestModel;  overload;
    function ThisAs:TTestModel;
      // implementaçoes
  end;
Implementation
constructor TTestModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
end;
destructor TTestModel.Destroy;
begin
  inherited;
end;
function TTestModel.ThisAs: TTestModel;
begin
  result := self;
end;
class function TTestModel.new():ITestModel;
begin
     result := new(nil);
end;
class function TTestModel.new(const AController:IController):ITestModel;
begin
   result :=  TTestModel.create;
   result.controller(AController);
end;
Initialization
TMVCRegister.RegisterType<ITestModel,TTestModel>(TTestModel.classname,true);
end.
