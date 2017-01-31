unit eMVC.BrowseFolder;

interface

{$I DELPHI.INC}

uses Windows,
{$IFDEF COMPILER19_UP}
  VCL.Forms,
{$ELSE}
  Forms,
{$ENDIF}
  Classes, ShlObj {,OLE2} , ActiveX;

type
  TBrowseForFolderDialog = class(Tcomponent)
  private
    bi: TBROWSEINFO;
    str: Array [0 .. MAX_PATH] of Char;
    pIDListItem: PItemIDList;
    pStr: PChar;
    procedure SetTitle(Title: String);
    function GetTitle: String;
    function GetPath: String;
  public
    property Title: string read GetTitle write SetTitle;
    function Execute: Boolean;
    property Path: string read GetPath;
  end;

  // procedure register;

implementation

// procedure register;
// begin
// RegisterComponents('Dialogs', [TBrowseForFolderDialog]);
// end;

procedure TBrowseForFolderDialog.SetTitle(Title: String);
begin
  bi.lpszTitle := PChar(Title);
end;

function TBrowseForFolderDialog.GetTitle: String;
begin
  Result := bi.lpszTitle;
end;

function TBrowseForFolderDialog.GetPath: String;
begin
  Result := pStr;
end;

function TBrowseForFolderDialog.Execute: Boolean;
begin
  bi.hwndOwner := GetActiveWindow;
  bi.pidlRoot := nil;
  bi.pszDisplayName := @str;
  bi.ulFlags := BIF_RETURNONLYFSDIRS;
  bi.lpfn := nil;
  pIDListItem := SHBrowseForFolder(bi);
  if pIDListItem <> nil then
  begin
    pStr := @str;
    SHGetPathFromIDList(pIDListItem, pStr);
    CoTaskMemFree(pIDListItem);
    Result := True;
  end
  else
    Result := False;
end;

end.
