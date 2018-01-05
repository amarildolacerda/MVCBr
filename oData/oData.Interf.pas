{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.Interf;

interface

uses System.Classes, System.SysUtils, System.JSON, oData.Packet;

Type

  IODataDecodeParams = interface;
  IODataParse = interface;

  TODataDecodeAbstract = class abstract(TInterfacedObject)
  protected
    procedure SetSelect(const Value: string); virtual; abstract;
    procedure SetFilter(const Value: string); virtual; abstract;
    procedure SetOrderBy(const Value: string); virtual; abstract;
    procedure SetSkip(const Value: integer); virtual; abstract;
    procedure SetExpand(const Value: string); virtual; abstract;
    procedure SetTop(const Value: integer); virtual; abstract;
    procedure SetFormat(const Value: string); virtual; abstract;
    procedure SetResource(const Value: string); virtual; abstract;
    procedure SetCount(const Value: string); virtual; abstract;
    procedure SetSkipToken(const Value: string); virtual; abstract;
    function GetExpand: string; virtual; abstract;
    function GetFilter: string; virtual; abstract;
    function GetFormat: string; virtual; abstract;
    function GetCount: string; virtual; abstract;
    function GetOrderBy: string; virtual; abstract;
    function GetResource: string; virtual; abstract;
    function GetSelect: string; virtual; abstract;
    function GetSkip: integer; virtual; abstract;
    function GetSkipToken: string; virtual; abstract;
    function GetTop: integer; virtual; abstract;
    function GetResourceParams: IODataDecodeParams; virtual; abstract;
    procedure SetBaseURL(const Value: string); virtual; abstract;
    procedure SetGroupBy(const Value: string); virtual; abstract;
    function GetGroupBy: string; virtual; abstract;
    procedure SetSearch(const Value: string); virtual; abstract;
    function GetSearch: string; virtual; abstract;
    procedure Setdebug(const Value: string); virtual; abstract;
    function GetDebug: string; virtual; abstract;
  public
    function newExpand(const ACollection: string): TODataDecodeAbstract;
      virtual; abstract;
    property Resource: string read GetResource write SetResource;
    property ResourceParams: IODataDecodeParams read GetResourceParams;
    function hasChild: boolean; virtual; abstract;
    function Child: TODataDecodeAbstract; virtual; abstract;
    function newChild: TODataDecodeAbstract; virtual; abstract;
    function Lock: TODataDecodeAbstract;virtual; abstract;
    procedure Unlock;virtual; abstract;
    // write SetResourceParams;
    // define a list of fields
    property &Select: string read GetSelect write SetSelect;
    // define filter (aka where)
    property &Filter: string read GetFilter write SetFilter;
    property &Search: string read GetSearch write SetSearch;

    // define orderby
    property &OrderBy: string read GetOrderBy write SetOrderBy;
    // expands relation collections
    property &Expand: string read GetExpand write SetExpand;
    // format response  (suport only json for now)
    property &Format: string read GetFormat write SetFormat;
    // pagination
    property &Skip: integer read GetSkip write SetSkip;
    property &Top: integer read GetTop write SetTop;
    property &SkipToken: string read GetSkipToken write SetSkipToken;
    property &inLineCount: string read GetCount write SetCount;
    property &Debug: string read GetDebug write Setdebug;
    property &GroupBy: string read GetGroupBy write SetGroupBy;

  end;

  IODataDecode = interface
    ['{E9DA95A9-534F-495E-9293-2657D4330D4C}']
    function Lock: TODataDecodeAbstract;
    procedure UnLock;
    function GetParse: IODataParse;
    function This: TObject;
    procedure SetSelect(const Value: string);
    procedure SetFilter(const Value: string);
    procedure SetOrderBy(const Value: string);
    procedure SetSkip(const Value: integer);
    procedure SetExpand(const Value: string);
    procedure SetTop(const Value: integer);
    procedure SetFormat(const Value: string);
    procedure SetResource(const Value: string);
    procedure SetCount(const Value: string);
    procedure SetSkipToken(const Value: string);
    function GetExpand: string;
    function GetFilter: string;
    function GetFormat: string;
    function GetCount: string;
    function GetOrderBy: string;
    function GetResource: string;
    function GetSelect: string;
    function GetSkip: integer;
    function GetSkipToken: string;
    function GetTop: integer;
    procedure SetGroupBy(const Value: string);
    function GetGroupBy: string;
    function GetResourceParams: IODataDecodeParams;
    procedure SetSearch(const Value: string);
    function GetSearch: string;
    procedure Setdebug(const Value: string);
    function GetDebug: string;

    property Resource: string read GetResource write SetResource;
    property ResourceParams: IODataDecodeParams read GetResourceParams;
    function GetLevel(FLevel: integer; AAutoCreate: boolean)
      : TODataDecodeAbstract;
    function hasChild: boolean;
    function Child: TODataDecodeAbstract;
    function newChild: TODataDecodeAbstract;

    function hasExpand: boolean;
    function ExpandItem(const idx: integer): TODataDecodeAbstract;
    function newExpand(const ACollection: string): TODataDecodeAbstract;
    function ExpandCount: integer;

    // define a list of fields
    property &Select: string read GetSelect write SetSelect;
    // define filter (aka where)
    property &Filter: string read GetFilter write SetFilter;
    property &Search: string read GetSearch write SetSearch;

    // define orderby
    property &OrderBy: string read GetOrderBy write SetOrderBy;
    property &GroupBy: string read GetGroupBy write SetGroupBy;
    // expands relation collections
    property &Expand: string read GetExpand write SetExpand;
    // format response  (suport only json for now)
    property &Format: string read GetFormat write SetFormat;
    // pagination
    property &Skip: integer read GetSkip write SetSkip;
    property &Top: integer read GetTop write SetTop;
    property &SkipToken: string read GetSkipToken write SetSkipToken;
    property &inLineCount: string read GetCount write SetCount;
    property &Debug: string read GetDebug write Setdebug;

    function ToString: string;

  end;

  IODataDecodeParams = interface
    ['{F03C7F83-F379-4D27-AFC5-C6D85FC56DE0}']
    procedure AddPair(AKey: string; AValue: string);
    procedure AddOperator(const AOperator: string);
    procedure AddOperatorLink(const AOperatorLink: string);
    procedure Clear;
    function Count: integer;
    function ContainKey(AKey: string): boolean;
    function KeyOfIndex(const idx: integer): string;
    function OperatorOfIndex(const idx: integer): string;
    function OperatorLinkOfIndex(const idx: integer): string;
    function ValueOfIndex(const idx: integer): string;
  end;

  IODataDialect = interface
    ['{812DB60E-64D7-4290-99DB-F625EC52C6DA}']
    procedure Release;
    function GetResource: IInterface; overload;
    function createGETQuery(AValue: TODataDecodeAbstract; AFilter: string;
      const AInLineCount: boolean = false): string;
    function createDeleteQuery(oData: TODataDecodeAbstract; AJsonBody: TJsonValue;
      AKeys: string): string;
    function CreatePostQuery(oData: TODataDecodeAbstract;
      AJsonBody: TJsonValue): String;
    function createPATCHQuery(oData: TODataDecodeAbstract; AJsonBody: TJsonValue;
      AKeys: string): String;
    function GetResource(AResource: string): IInterface; overload;
    function AfterCreateSQL(var SQL: string): boolean;
  end;

  IODataParse = interface
    ['{10893BDD-CE9A-4F31-BB2E-8DF18EA5A91B}']
    procedure ParseURL(URL: string);
    procedure ParseURLParams(prms: string);
    procedure Release;
    function GetOData: TODataDecodeAbstract;
    property oData: TODataDecodeAbstract read GetOData; // write SetOData;
  end;

  IODataBase = interface
    ['{61D854AF-4773-4DD2-9648-AD93A4134F13}']
    procedure DecodeODataURL(CTX: TObject);
    function This: TObject;
    procedure Release;

    function ExecuteGET(AJsonBody: TJsonValue;
      var JSONResponse: TJSONObject): TObject;
    function ExecuteDELETE(ABody: string;
      var JSONResponse: TJSONObject): integer;
    function ExecutePOST(ABody: string; var JSON: TJSONObject): integer;
    function ExecutePATCH(ABody: string; var JSON: TJSONObject): integer;
    function ExecuteOPTIONS(var JSON: TJSONObject): integer;

    procedure CreateExpandCollections(AQuery: TObject);
    function Collection: string;
    function GetInLineRecordCount: integer;
    procedure SetInLineRecordCount(const Value: integer);
    property InLineRecordCount: integer read GetInLineRecordCount
      Write SetInLineRecordCount;
    function GetParse: IODataParse;
  end;

function GetODataConfigFilePath: string;
procedure SetODataConfigFilePath(APath: string);

implementation

uses {$IFDEF MSWINDOWS} WinApi.Windows, Registry, {$ENDIF} System.IniFiles;

var
  FConfigFilePath: string;

{$IFDEF MSWINDOWS}

function GetProgramFilesDir: String;
begin
  with TRegistry.create(KEY_QUERY_VALUE) do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion', True);
    result := ReadString('ProgramFilesDir');
    free;
  end;
end;
{$ENDIF}

procedure SetODataConfigFilePath(APath: string);
begin
  FConfigFilePath := APath;
end;

function GetODataConfigFilePath: string;
begin
  if FConfigFilePath = '' then
  begin
    FConfigFilePath := GetEnvironmentVariable('MVCBr');
    if FConfigFilePath = '' then
    begin
      FConfigFilePath := ExtractFilePath(ParamStr(0));
{$IFDEF MSWINDOWS}
      if not fileExists(FConfigFilePath + 'MVCBrServer.Config') then
        FConfigFilePath := GetProgramFilesDir + '\';
{$ENDIF}
      FConfigFilePath := FConfigFilePath + 'MVCBr\';
      ForceDirectories(FConfigFilePath);
    end;
  end;
  result := FConfigFilePath;
end;

Initialization

FConfigFilePath := '';

end.
