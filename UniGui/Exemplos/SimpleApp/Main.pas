unit Main;

{

  Need to define UniGUI on project options as DEFINE

}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  MVCBr.Interf, MVCBr.UniForm,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniButton, uniPageControl,
  uniGUIBaseClasses, uniPanel;

type

  IMainFormView = interface(IView)
    ['{BC6D9A92-F6D4-47DD-BB2D-43C7C5718E65}']
  end;

  TMainForm = class(TUniFormFactory, IMainFormView)
    UniPanel1: TUniPanel;
    UniPageControl1: TUniPageControl;
    UniButton1: TUniButton;
    UniButton2: TUniButton;
    procedure UniButton1Click(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniButton2Click(Sender: TObject);
  private
    { Private declarations }
    FrameCount: integer;
  public
    { Public declarations }
    procedure CloseFramedTabsheet(AFrameName: string);
    [weak]
    function GetController: IController; override;
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Dialogs,
  MainForm.Controller,
  MVCBr.Observable, System.Json, System.Json.Helper,
  UniGuiFrame, uniGUIVars, MainModule, uniGUIApplication, Unit1,
  CalcularJuros.Model.Interf;

type
  TFramedTabSheet = class(TUniTabSheet)
  public
    UniFrame: TUniFrame;
  end;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

procedure TMainForm.CloseFramedTabsheet(AFrameName: string);
var
  i: integer;
  ts: TObject;
begin
  with { MainForm. } UniPageControl1 do
    for i := 0 to pageCount - 1 do
      with TFramedTabSheet(Pages[i]) do
        if UniFrame.Name = AFrameName then
        begin
          ts := TFramedTabSheet(Pages[i]);
          ts.free;
          exit;
        end;
end;

function TMainForm.GetController: IController;
begin
  /// Init Controller if it is need;

  if inherited GetController = nil then
    SetController(TMainFormController.new(self, nil));
  Result := inherited GetController;

end;

procedure TMainForm.UniButton1Click(Sender: TObject);
var
  ts: TFramedTabSheet;
begin
  ts := TFramedTabSheet.create( { MainForm. } UniPageControl1);
  ts.caption := 'T: ' + FormatDateTime('hh:mm:ss', now);
  ts.PageControl := { MainForm. } UniPageControl1;

  inc(FrameCount);
  ts.UniFrame := TUniFrame1.create(ts);
  ts.UniFrame.Name := 'UniFrame1_' + FrameCount.toString;
  ts.UniFrame.Parent := ts;
  ts.UniFrame.Align := alClient;
  ts.UniFrame.Show;

  TUniFrame1(ts.UniFrame).text := ts.UniFrame.Name;

  { MainForm. } UniPageControl1.activePageIndex :=
  { MainForm. } UniPageControl1.pageCount - 1;

end;

procedure TMainForm.UniButton2Click(Sender: TObject);
begin
  showMessage(GetModel<ICalcularJurosModel>.Calcular.toString);
end;

procedure TMainForm.UniFormCreate(Sender: TObject);
begin
  FrameCount := 0;

  /// / create observable to Tab Close
  TMVCBrObservable.DefaultContainer.Register('TabClose',
    procedure(dados: TJsonValue)
    begin
      CloseFramedTabsheet(TJsonObject(dados).s('message'));
    end);

end;

initialization

RegisterAppFormClass(TMainForm);

end.
