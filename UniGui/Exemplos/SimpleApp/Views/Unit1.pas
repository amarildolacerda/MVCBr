unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  MVCBr.Interf, MVCBr.UniFrame,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniGUIBaseClasses, uniPanel, uniButton;

type
  IFramedTabsheetView = interface(IView)
    ['{564B29BB-4871-4AD4-9B51-7860686C855C}']
  end;

  TUniFrame1 = class(TUniFrameFactory, IFramedTabsheetView)
    UniPanel1: TUniPanel;
    UniButton1: TUniButton;
    UniButton2: TUniButton;
    procedure UniButton1Click(Sender: TObject);
    procedure UniButton2Click(Sender: TObject);
  private
    procedure SetText(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property Text: string write SetText;
    [weak]
    function GetController: IController; override;
  end;

implementation

{$R *.dfm}

uses Dialogs, MVCBr.Observable, Frame1.Controller, CalcularJuros.Model.Interf;

function TUniFrame1.GetController: IController;
begin
  if inherited GetController = nil then
    setController(TFrame1Controller.new(self, nil));
  result := inherited GetController;
end;

procedure TUniFrame1.SetText(const Value: string);
begin
  UniPanel1.caption := Value;
end;

procedure TUniFrame1.UniButton1Click(Sender: TObject);
begin

  /// send tab close message to MainForm
  TMVCBrObservable.DefaultContainer.send('TabClose', self.Name);
end;

procedure TUniFrame1.UniButton2Click(Sender: TObject);
begin
  showMessage('Frame: '+name+':'+ DateTimeToStr( GetModel<ICalcularJurosModel>.GetDateFinished) );
end;

end.
