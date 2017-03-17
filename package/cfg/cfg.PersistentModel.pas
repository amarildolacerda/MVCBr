{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 24/02/2017 01:10:02                                  //}
{//************************************************************//}
Unit  cfg.PersistentModel;
{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface
{.$I ..\inc\mvcbr.inc}
uses System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes, MVCBr.Interf, MVCBr.PersistentModel,
   cfg.PersistentModel.Interf, //%Interf,
MVCBr.Controller;
Type
  TcfgPersistentModel = class(TPersistentModelFactory,IcfgPersistentModel,    IThisAs<TcfgPersistentModel>)
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new():IcfgPersistentModel; overload;
    class function new(const AController:IController):IcfgPersistentModel;  overload;
    function ThisAs:TcfgPersistentModel;
      // implementaçoes
  end;
Implementation
constructor TcfgPersistentModel.Create;
begin
  inherited;
  ModelTypes := [mtPersistent];
end;
destructor TcfgPersistentModel.Destroy;
begin
  inherited;
end;
function TcfgPersistentModel.ThisAs: TcfgPersistentModel;
begin
  result := self;
end;
class function TcfgPersistentModel.new():IcfgPersistentModel;
begin
     result := new(nil);
end;
class function TcfgPersistentModel.new(const AController:IController):IcfgPersistentModel;
begin
   result :=  TcfgPersistentModel.create;
   result.controller(AController);
end;
Initialization
TMVCRegister.RegisterType<IcfgPersistentModel,TcfgPersistentModel>(TcfgPersistentModel.classname,true);
end.
