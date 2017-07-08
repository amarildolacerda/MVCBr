unit MVCBr.VCLReg;

interface

uses System.Classes, System.SysUtils, DesignIntf, DesignEditors;

procedure Register;

implementation

uses MVCBr.ModuleModel, MVCBr.FormView;

procedure register;
begin
  RegisterCustomModule(TFormFactory, TCustomModule);
  RegisterCustomModule(TModuleFactory, TCustomModule);
  RegisterClass(TFormFactory);
  RegisterClass(TModuleFactory);
end;




end.
