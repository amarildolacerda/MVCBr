{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 08/04/2017 14:51:26                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit eFinPriceView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.types,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, FMX.MultiView, FMX.StdCtrls,
  FMX.types, FMX.Controls, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects,
  MVCBr.Component, MVCBr.PageView, MVCBr.FMX.LayoutViewManager, FMX.Gestures,
  FMX.ListBox;

type
  /// Interface para a VIEW
  IeFinPriceView = interface(IView)
    ['{8196A77A-E6CC-4387-ACBB-E2346FD66720}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TeFinPriceView = class(TFormFactory { TFORM } , IView,
    IThisAs<TeFinPriceView>, IeFinPriceView, IViewAs<IeFinPriceView>)
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    SpeedButton1: TSpeedButton;
    MultiView1: TMultiView;
    Rectangle1: TRectangle;
    FMXLayoutViewManager1: TFMXLayoutViewManager;
    Rectangle2: TRectangle;
    Layout2: TLayout;
    Label1: TLabel;
    ScrollBox1: TVertScrollBox;
    GestureManager1: TGestureManager;
    Layout1: TLayout;
    Timer1: TTimer;
    ListBox1: TListBox;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure ScrollBox1CalcContentBounds(Sender: TObject;
      var ContentBounds: TRectF);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    FInited: Boolean;
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    procedure showDrawer(AShow: Boolean);
    procedure DoGetMoveControlEvent(Sender: TObject; FocusedControl: TControl;
      var MoveControl: TControl);
    procedure RestorePosition;
    procedure UpdateKBBounds;
    function HideKeyboard: Boolean;
  protected
    FHardwareBack: integer;
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TeFinPriceView;
    function ViewAs: IeFinPriceView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

Implementation

{$R *.FMX}

uses System.threading, System.Math, System.UiTypes,
  tabelaPriceView, tabelaPrice.Controller.Interf, FMX.platform,
  FMX.VirtualKeyboard ;

procedure TeFinPriceView.RestorePosition;
begin
  ScrollBox1.ViewportPosition := PointF(ScrollBox1.ViewportPosition.X, 0);
  Layout1.Align := TAlignLayout.Client;
  ScrollBox1.RealignContent;
end;

procedure TeFinPriceView.UpdateKBBounds;
var
  LFocused: TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(ScrollBox1.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
      (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
      Layout1.Align := TAlignLayout.Horizontal;
      ScrollBox1.RealignContent;
      Application.ProcessMessages;
      ScrollBox1.ViewportPosition := PointF(ScrollBox1.ViewportPosition.X,
        LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffset then
    RestorePosition;
end;

procedure TeFinPriceView.DoGetMoveControlEvent(Sender: TObject;
  FocusedControl: TControl; var MoveControl: TControl);
begin
  if (FocusedControl.Parent <> nil) and
    (FocusedControl.Parent.InheritsFrom(TControl)) then
    MoveControl := Layout1;
end;

function TeFinPriceView.Update: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TeFinPriceView.ViewAs: IeFinPriceView;
begin
  result := self;
end;

class function TeFinPriceView.New(aController: IController): IView;
begin
  result := TeFinPriceView.Create(nil);
  result.Controller(aController);
end;

procedure TeFinPriceView.ScrollBox1CalcContentBounds(Sender: TObject;
  var ContentBounds: TRectF);
begin
  if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
      2 * ClientHeight - FKBBounds.Top);
  end;

end;

procedure TeFinPriceView.Button1Click(Sender: TObject);
var
  LHandled: Boolean;
begin
  showDrawer(False);
  ///  inicia a VIEW um uma ABA do TabControl
  FMXLayoutViewManager1.AddView(ITabelaPriceController);
  ///  envia Event para ativar a ABA correta
  applicationController.ViewEvent('tab.equivalente', LHandled);
end;

function TeFinPriceView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := True;
  end;
end;

procedure TeFinPriceView.FormCreate(Sender: TObject);
begin
  VKAutoShowMode := TVKAutoShowMode.Always;
  ScrollBox1.OnCalcContentBounds := ScrollBox1CalcContentBounds;
  FHardwareBack := 0;
  MultiView1.Mode := TMultiViewMode.Drawer;
end;

procedure TeFinPriceView.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;

procedure TeFinPriceView.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  if EventInfo.GestureID = sgiDown then
  begin
     HideKeyboard;
  end;
end;

function TeFinPriceView.HideKeyboard: Boolean;
var
  FService: IFMXVirtualKeyboardService;
begin
  result := False;
  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService,
    IInterface(FService));
  if (FService <> nil) and (TVirtualKeyboardState.vksVisible
    in FService.VirtualKeyBoardState) then
  begin
    Timer1.Enabled := False;
    FService.HideVirtualKeyboard;
    inc(FHardwareBack);
    Timer1.Enabled := True;
    result := True;
  end;
end;

procedure TeFinPriceView.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var
  FService: IFMXVirtualKeyboardService;
begin
  if Key = vkHardwareBack then
  begin
    if HideKeyboard then
      Key := 0
    else
    begin
      Timer1.Enabled := False;
      if FHardwareBack = 0 then
        Key := 0;
      /// nao encerra o app
      inc(FHardwareBack);
      Timer1.Enabled := True;
    end;
  end;
end;

procedure TeFinPriceView.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition;

end;

procedure TeFinPriceView.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;

end;

procedure TeFinPriceView.Init;
begin
  // incluir incializações aqui
 { TTask.Create(
    procedure
    begin
      sleep(50);
      tthread.Queue(nil,
        procedure
        begin
          FMXLayoutViewManager1.AddView(ITabelaPriceController);
          showDrawer(False);
        end);
    end).start;
    }
end;

function TeFinPriceView.This: TObject;
begin
  result := inherited This;
end;

function TeFinPriceView.ThisAs: TeFinPriceView;
begin
  result := self;
end;

procedure TeFinPriceView.Timer1Timer(Sender: TObject);
begin
  FHardwareBack := 0;
end;

procedure TeFinPriceView.showDrawer(AShow: Boolean);
begin
  if AShow then
    MultiView1.ShowMaster
  else
    MultiView1.HideMaster;
end;

function TeFinPriceView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

procedure TeFinPriceView.SpeedButton2Click(Sender: TObject);
var
  LHandled: Boolean;
  ctrl: ITabelaPriceController;
  View: ItabelaPriceView;
  layout: ILayout;
begin
  { opção sem ViewManager
    ctrl := resolveController<ItabelaPriceController>;
    view := ctrl.GetView as ItabelaPriceView;
    supports(view.This,ILayout,layout);

    Layout2.AddObject( Layout.GetLayout as TLayout  );
  }

  /// com viewManager
  FMXLayoutViewManager1.AddView(ITabelaPriceController);
  showDrawer(False);

  ///  envia envento para mostar a ABA correta.
  applicationController.ViewEvent('tab.valores', LHandled);

end;

end.
