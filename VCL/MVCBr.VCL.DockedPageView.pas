/// <summary>
/// experimental...... nao usar ainda
/// Objetivo: Criar um ambiente dockable para o TabSheet
/// </summary>
unit MVCBr.VCL.DockedPageView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, VCL.Graphics,
  VCL.ComCtrls,
  VCL.Controls, VCL.Forms, VCL.Dialogs;

type

  /// <summary>
  /// DockedPageView tem por finalidade mostrar um TabSheet dentro de um formulário
  /// fora do pagecontrol.
  /// </summary>
  TMVCBrDockedPageView = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FDocked: Boolean;
    FPageControl: TPageControl;
    FTabSheet: TTabSheet;
    { Private declarations }
  protected
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;

  public
    { Public declarations }
    constructor Create(APageControl: TPageControl;
      ATabSheet: TTabSheet); virtual;
    destructor Destroy; override;
    /// <summary>
    /// Cria um form e passa o conteudo do TabSheet para um o formulário
    /// aplica show;
    /// </summary>
    class function CreateDocked(APageControl: TPageControl;
      ATabSheet: TTabSheet): TMVCBrDockedPageView; // teste OK;
    /// <summary>
    /// Move os componente da Origem para o Destino
    /// </summary>
    class procedure MoveControlsTo(AOrigem, ADest: TWinControl); static;
    // teste OK;

    procedure UnDockPageView;
    procedure DockPageView;
  end;

  /// <summary>
  /// Em teste... nao usar
  /// </summary>
  TMVCBrDockablePageViewManager = class(TComponent)
  private
    FFireStartDock: Boolean;
    FDockable: Boolean;
    FPageControl: TPageControl;
    procedure PrepareDocker(ACtrl: TForm);
    procedure SetDockable(const Value: Boolean);
    procedure DoGetSiteInfo(Sender: TObject; DockClient: TControl;
      var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
    procedure DoDockOver(Sender: TObject; Source: TDragDockObject;
      X, Y: integer; State: TDragState; var Accept: Boolean);
    procedure DoFormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure DoFormEndDock(Sender, Target: TObject; X, Y: integer);
    procedure Release;
    function GetWinControl: TWinControl;
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;

  public
    procedure Save; virtual;
    procedure Load; virtual;
    constructor Create(APageControl: TPageControl); virtual;
    destructor Destroy; override;
    property Dockable: Boolean read FDockable write SetDockable;
    function AddPage(APage: TTabSheet): TTabSheet;
  end;

implementation

{$R *.dfm}

uses MVCBr.VCL.DockUtils;

{ TMVCBrDockedPageView }

constructor TMVCBrDockedPageView.Create(APageControl: TPageControl;
  ATabSheet: TTabSheet);
begin
  inherited Create(APageControl);
  FPageControl := APageControl;
  FTabSheet := ATabSheet;
  Caption := FTabSheet.Caption;
end;

class function TMVCBrDockedPageView.CreateDocked(APageControl: TPageControl;
  ATabSheet: TTabSheet): TMVCBrDockedPageView;
begin
  result := TMVCBrDockedPageView.Create(APageControl, ATabSheet);
  result.DockPageView;
  result.Show;
end;

destructor TMVCBrDockedPageView.Destroy;
begin

  inherited;
end;

procedure TMVCBrDockedPageView.DockPageView;
begin
  TMVCBrDockedPageView.MoveControlsTo(FTabSheet, self);
  FTabSheet.TabVisible := false;
  FDocked := true;
end;

procedure TMVCBrDockedPageView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  UnDockPageView;
  Action := TCloseAction.caFree;
end;

class procedure TMVCBrDockedPageView.MoveControlsTo(AOrigem: TWinControl;
  ADest: TWinControl);
var
  i: integer;
begin
  for i := AOrigem.ControlCount - 1 downto 0 do
  begin
    if i >= AOrigem.ControlCount then
      continue;
    try
      if AOrigem.Controls[i].InheritsFrom(TControl) then
        AOrigem.Controls[i].Parent := ADest;
    except
    end;
  end;
end;

procedure TMVCBrDockedPageView.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited;
  if (AOperation = TOperation.opRemove) then
  begin
    if (AComponent = FTabSheet) then
    begin
      FTabSheet := nil;
    end;
    if (AComponent = FPageControl) then
    begin
      FTabSheet := nil;
      FPageControl := nil;
    end;
  end;
end;

procedure TMVCBrDockedPageView.UnDockPageView;
begin
  try
    TMVCBrDockedPageView.MoveControlsTo(self, FTabSheet);
    FTabSheet.TabVisible := true;
  except
  end;
  FDocked := false;
end;

type
  TWinControlHack = class(TWinControl)
  public
    property OnGetSiteInfo;
  end;

  { TMVCBrDockablePageView }
procedure TMVCBrDockablePageViewManager.DoGetSiteInfo(Sender: TObject;
  DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint;
  var CanDock: Boolean);
begin
  CanDock := Sender.Equals(FPageControl);
  if CanDock then
  begin
    // := true;
  end;
end;

procedure TMVCBrDockablePageViewManager.Load;
begin

end;

procedure TMVCBrDockablePageViewManager.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited;
  if (AOperation = TOperation.opRemove) and (AComponent = FPageControl) then
    FPageControl := nil;
end;

procedure TMVCBrDockablePageViewManager.PrepareDocker(ACtrl: TForm);
begin
  // ACtrl.DockSite := FDockable;
  if FDockable then
  begin
    FPageControl.OnGetSiteInfo := DoGetSiteInfo;
    FPageControl.OnDockOver := DoDockOver;
    FPageControl.DragMode := TDragMode.dmAutomatic;
    FPageControl.DragKind := TDragKind.dkDock;
  end
  else
  begin
    FPageControl.DragMode := TDragMode.dmManual;
    FPageControl.DragKind := TDragKind.dkDrag;
    FPageControl.OnGetSiteInfo := nil;
    FPageControl.OnDockOver := nil;
  end;
end;

destructor TMVCBrDockablePageViewManager.Destroy;
begin
  Release;
  inherited;
end;

procedure TMVCBrDockablePageViewManager.DoDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: integer; State: TDragState;
  var Accept: Boolean);
begin
  Accept := Source.InheritsFrom(TTabSheet);
end;

function TMVCBrDockablePageViewManager.GetWinControl: TWinControl;
begin
  result := TWinControl(owner);
end;

procedure TMVCBrDockablePageViewManager.DoFormStartDock(Sender: TObject;
  var DragObject: TDragDockObject);
var
  i, n: integer;
begin
  if not FDockable then
    Abort;
  if (assigned(TWinControl(Sender).Parent)) then
    if TWinControl(Sender).Parent.InheritsFrom(TTabSheet) then
    begin
      with TPageControl(TWinControl(Sender).Parent.Parent) do
        for i := 0 to PageCount - 1 do
          if pages[i].TabVisible then
            inc(n);
      if n <= 1 then
        Abort; // a ultima tabsheet nao pode ser movida...
    end;
  FFireStartDock := true;
  DragObject := TTransparentDragDockObject.Create(GetWinControl);
end;

function TMVCBrDockablePageViewManager.AddPage(APage: TTabSheet): TTabSheet;
begin
  result := APage;
end;

constructor TMVCBrDockablePageViewManager.Create(APageControl: TPageControl);
begin
  inherited Create(APageControl);
  FPageControl := APageControl;
  if FPageControl.Parent.InheritsFrom(TForm) then
    with TForm(FPageControl.Parent) do
    begin
      OnStartDock := DoFormStartDock;
      OnEndDock := DoFormEndDock;
    end;
end;

procedure TMVCBrDockablePageViewManager.Release;
begin
  if assigned(FPageControl) and assigned(FPageControl.Parent) then
    if FPageControl.Parent.InheritsFrom(TForm) then
      with TForm(FPageControl.Parent) do
      begin
        OnStartDock := nil;
        OnEndDock := nil;
      end;

end;

procedure TMVCBrDockablePageViewManager.DoFormEndDock(Sender, Target: TObject;
  X, Y: integer);
begin
  if FFireStartDock then
  begin
    // FDocked := (assigned(TWinControl(sender).Parent));
    if FDockable then
      Save;
  end;
  FFireStartDock := false;
end;

procedure TMVCBrDockablePageViewManager.Save;
begin

end;

procedure TMVCBrDockablePageViewManager.SetDockable(const Value: Boolean);
begin
  FDockable := Value;
  if Value then
    Load;
  if assigned(FPageControl) and assigned(FPageControl.owner) then
    if FPageControl.owner.InheritsFrom(TForm) then
      PrepareDocker(TForm(FPageControl.owner));

end;

end.
