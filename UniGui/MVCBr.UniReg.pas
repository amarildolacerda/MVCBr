unit MVCBr.UniReg;

interface

uses System.Classes, System.SysUtils, DesignIntf, DesignEditors;

implementation

uses MVCBr.UniFormView, MVCBr.UniFrameView, uniGuiForm, uniGuiFrame;

procedure Register;
begin

  RegisterCustomModule(TUniFrame, TCustomModule);
  RegisterCustomModule(TUniForm, TCustomModule);
  //RegisterClass(TUniFrame);
  //RegisterClass(TUniForm);

  RegisterCustomModule(TUniFormFactory, TCustomModule);
  RegisterCustomModule(TUniFrameFactory, TCustomModule);
  RegisterClass(TUniFormFactory);
  RegisterClass(TUniFrameFactory);



  //UnlistPublishedProperty(TUniFrameFactory,'ClientHeight');


end;

end.
