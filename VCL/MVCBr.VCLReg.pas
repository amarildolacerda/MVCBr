unit MVCBr.VCLReg;

interface

uses System.Classes, System.SysUtils, DesignIntf, DesignEditors;

procedure Register;

implementation

{$R HTTPRestClient.res}

uses
  MVCBr.Common,
  MVCBr.FormView,
  MVCBr.FrameView,
  MVCBr.VCL.PageView,
  MVCBr.ModuleModel,
  MVCBr.ObjectConfigList;



procedure Register;
begin
  RegisterCustomModule(TFormFactory, TCustomModule);
  //RegisterCustomModule(TFMXFormFactory, TCustomModule);
  RegisterCustomModule(TModuleFactory, TCustomModule);
  RegisterCustomModule(TFrameFactory, TCustomModule);

  RegisterComponents(CMVCBrComponentPalletName, [TVCLPageViewManager]);

  RegisterComponents(CMVCBrComponentPalletName,
    [TObjectConfigModel, TDBObjectConfigModel]);


  RegisterClass(TFormFactory);
  //RegisterClass(TFMXFormFactory);
  RegisterClass(TModuleFactory);
  RegisterClass(TFrameFactory);

end;

end.
