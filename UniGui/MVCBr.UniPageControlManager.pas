unit MVCBr.UniPageControlManager;

interface

uses System.Classes, System.SysUtils,
  MVCBr.Interf, MVCBr.PageView, MVCBr.UniFrame,
  uniPageControl, UniGuiFrame;

type

  TUniPageControlManager = class(TCustomPageViewFactory)
  protected
    function GetPageControlEx: TUniPageControl;
    procedure SetPageControlEx(const Value: TUniPageControl);
    function GetPageTabClass: TComponentClass; override;
    function GetPageContainerClass: TComponentClass; override;
    function NewTab(APageView: IPageView): TObject; override;

  published
    property PageControl: TUniPageControl read GetPageControlEx
      write SetPageControlEx;
    function AddFrame(ACaption: String; AFrame: TUniFrameClass)
      : IPageView; virtual;

  end;

implementation

uses VCL.Controls;

type

  TUniTabSheetView = class(TUniTabSheet)
  public
    PageView: IPageView;
  end;

function TUniPageControlManager.GetPageTabClass: TComponentClass;
begin
  result := TUniTabSheetView;
end;

{ TUniPageViewFactory }

function TUniPageControlManager.AddFrame(ACaption: String; AFrame: TUniFrameClass)
  : IPageView;
var
  ref: TUniFrame;
  vw: IView;
begin
  // checa se o formulario ja esta carregao e reutiliza
  result := FindViewByClassName(AFrame.ClassName);
  if assigned(result) then
  begin
    SetActivePage(result.This.Tab);
    exit;
  end;
  // instancia novo formulario
  ref := AFrame.Create(self);
  if supports(ref, IView, vw) then
  begin
    vw.Title := ACaption;
    result := inherited AddView(vw);
    ref.Parent := TUniTabSheetView(result.This.Tab);
    TUniTabSheetView(result.This.Tab).caption := ACaption;
    ref.show;
    ref.Align := alClient;
    exit;
  end;
  // usa um stub para embeded de uma formulario como (sem IVIEW)
  result := inherited AddView(TUniFrameAdapter.New(ref, FPageContainer));
  ref.Parent := TUniTabSheetView(result.This.Tab);
  ref.Align := alClient;
end;

function TUniPageControlManager.GetPageContainerClass: TComponentClass;
begin
  result := TUniPageControl;
end;

function TUniPageControlManager.GetPageControlEx: TUniPageControl;
begin
  result := TUniPageControl(FPageContainer);
end;

function TUniPageControlManager.NewTab(APageView: IPageView): TObject;
var
  Tab: TUniTabSheetView;
begin
  Tab := GetPageTabClass.Create(FPageContainer) as TUniTabSheetView;
  Tab.PageControl := TUniPageControl(FPageContainer);
  Tab.PageView := APageView;
  TUniPageControl(FPageContainer).ActivePage := Tab;
  result := Tab;
  // if assigned(FAfterTabCreate) then
  // FAfterTabCreate(tab);
end;

procedure TUniPageControlManager.SetPageControlEx(const Value: TUniPageControl);
begin
  FPageContainer := Value;
end;

end.
