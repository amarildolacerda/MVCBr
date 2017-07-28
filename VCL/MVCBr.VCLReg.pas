unit MVCBr.VCLReg;

interface

uses System.Classes, System.SysUtils, DesignIntf, DesignEditors;

procedure Register;

implementation

uses
  MVCBr.Common,
  MVCBr.FormView,
  MVCBr.VCL.PageView,
  MVCBr.ModuleModel,
  MVCBr.HTTPRestClient, MVCBr.HTTPRestClientEditor,
  MVCBr.ObjectConfigList;

procedure Register;
begin
  RegisterCustomModule(TFormFactory, TCustomModule);
  RegisterCustomModule(TModuleFactory, TCustomModule);

  RegisterComponents(CMVCBrComponentPalletName, [TVCLPageViewManager]);

  RegisterComponents(CMVCBrComponentPalletName, [THTTPRestClient]);
  RegisterComponentEditor(THTTPRestClient, THTTPRestClientCompEditor);

  RegisterComponents(CMVCBrComponentPalletName,
    [TObjectConfigModel, TDBObjectConfigModel]);


  RegisterClass(TFormFactory);
  RegisterClass(TModuleFactory);

end;

end.
