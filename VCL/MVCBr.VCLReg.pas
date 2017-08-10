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
  MVCBr.HTTPRestClient,
  MVCBr.IdHTTPRestClient,
  MVCBr.HTTPRestClientEditor,
  MVCBr.ObjectConfigList;



procedure Register;
begin
  RegisterCustomModule(TFormFactory, TCustomModule);
  RegisterCustomModule(TModuleFactory, TCustomModule);
  RegisterCustomModule(TFrameFactory, TCustomModule);

  RegisterComponents(CMVCBrComponentPalletName, [TVCLPageViewManager]);

  RegisterComponents(CMVCBrComponentPalletName, [THTTPRestClient,TIdHTTPRestClient]);
  RegisterComponentEditor(THTTPRestClient, THTTPRestClientCompEditor);

  RegisterComponents(CMVCBrComponentPalletName,
    [TObjectConfigModel, TDBObjectConfigModel]);


  RegisterClass(TFormFactory);
  RegisterClass(TModuleFactory);
  RegisterClass(TFrameFactory);

end;

end.
