unit MVCBr.DesignEditors.Helper;

interface

uses System.Classes, DesignIntf, DesignEditors;

type
  TMVCBrBaseComponentEditor = class(TComponentEditor)
  strict private
    FOldEditor: IComponentEditor;
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
  protected
    function GetLinkToTypeClass: TComponentClass; virtual; abstract;
  public
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
    destructor Destroy; override;

    function LocalGetVerb(AIndex: integer): string; virtual;
    function LocalGetVerbCount: integer; virtual;
    procedure LocalExecuteVerb(AIndex: integer); virtual;

  end;

procedure MVCBrDebugLogEditor(ATexto: string);

implementation

uses WinApi.Windows;

procedure MVCBrDebugLogEditor(ATexto: string);
begin
  OutputDebugString({$IFDEF UNICODE}PWideChar{$ELSE}PAnsiChar{$ENDIF}(ATexto));
end;

{ TRestSocialBaseEditor }
VAR
  PrevEditorClass: TComponentEditorClass = NIL;

constructor TMVCBrBaseComponentEditor.Create(AComponent: TComponent; ADesigner: IDesigner);
var
  cmp: TComponent;
  Editor: IComponentEditor;
begin
  inherited;
  cmp := GetLinkToTypeClass.Create(nil);
  try
    Editor := GetComponentEditor(cmp, NIL);
    IF Assigned(Editor) THEN
    BEGIN
      PrevEditorClass := TComponentEditorClass((Editor AS TObject).ClassType);
    END;
    IF Assigned(PrevEditorClass) THEN
      FOldEditor := TComponentEditor(PrevEditorClass.Create(AComponent, ADesigner));
  finally
    Editor := NIL;
    cmp.Free;
  end;
end;

destructor TMVCBrBaseComponentEditor.Destroy;
begin
  inherited;
end;

procedure TMVCBrBaseComponentEditor.ExecuteVerb(Index: integer);
var
  idx: integer;
begin
  // DebugLog('ExecuteVerb: ' + intTostr(index));
  if index < FOldEditor.GetVerbCount then
  begin
    FOldEditor.ExecuteVerb(index)
  end
  else
  begin
    idx := index - FOldEditor.GetVerbCount;
    LocalExecuteVerb(idx);
  end;
end;

function TMVCBrBaseComponentEditor.GetVerb(Index: integer): string;
var
  idx: integer;
begin
  // DebugLog('GetVerb: ' + intTostr(index));
  if index < FOldEditor.GetVerbCount then
    result := FOldEditor.GetVerb(index)
  else
  begin
    idx := index - FOldEditor.GetVerbCount;
    result := LocalGetVerb(idx);
  end;
end;

function TMVCBrBaseComponentEditor.GetVerbCount: integer;
begin

  result := FOldEditor.GetVerbCount + LocalGetVerbCount;
  // DebugLogEditor('GetVerbCount: ' + intTostr(result));

end;

procedure TMVCBrBaseComponentEditor.LocalExecuteVerb(AIndex: integer);
begin

end;

function TMVCBrBaseComponentEditor.LocalGetVerb(AIndex: integer): string;
begin
  result := '';
end;

function TMVCBrBaseComponentEditor.LocalGetVerbCount: integer;
begin
  result := 0;
end;

end.
