unit oData.Interf;

interface

uses System.Classes, System.SysUtils;

Type

  IODataDecodeParams = interface;
  IODataParse = interface;

  IODataDecode = interface
    ['{E9DA95A9-534F-495E-9293-2657D4330D4C}']
    function Lock:IODataDecode;
    procedure UnLock;
    function GetParse:IODataParse;
    function This: TObject;
    procedure SetSelect(const Value: string);
    procedure SetFilter(const Value: string);
    procedure SetOrderBy(const Value: string);
    procedure SetSkip(const Value: integer);
    procedure SetExpand(const Value: string);
    procedure SetTop(const Value: integer);
    procedure SetFormat(const Value: string);
    procedure SetResource(const Value: string);
    procedure SetInLineCount(const Value: string);
    procedure SetSkipToken(const Value: string);
    function GetExpand: string;
    function GetFilter: string;
    function GetFormat: string;
    function GetInLineCount: string;
    function GetOrderBy: string;
    function GetResource: string;
    function GetSelect: string;
    function GetSkip: integer;
    function GetSkipToken: string;
    function GetTop: integer;
    procedure SetGroupBy(const Value: string);
    function GetGroupBy: string;
    function GetResourceParams: IODataDecodeParams;

    property Resource: string read GetResource write SetResource;
    property ResourceParams: IODataDecodeParams read GetResourceParams;
    function GetLevel(FLevel: integer;AAutoCreate:Boolean): IODataDecode;
    function hasChild: boolean;
    function Child: IODataDecode;
    function newChild: IODataDecode;

    function hasExpand:boolean;
    function ExpandItem(const idx:integer):IODataDecode;
    function newExpand( const ACollection:string):IODataDecode;
    function ExpandCount:integer;

    // define a list of fields
    property &Select: string read GetSelect write SetSelect;
    // define filter (aka where)
    property &Filter: string read GetFilter write SetFilter;
    // define orderby
    property &OrderBy: string read GetOrderBy write SetOrderBy;
    property &GroupBy:string read GetGroupBy write SetGroupBy;
    // expands relation collections
    property &Expand: string read GetExpand write SetExpand;
    // format response  (suport only json for now)
    property &Format: string read GetFormat write SetFormat;
    // pagination
    property &Skip: integer read GetSkip write SetSkip;
    property &Top: integer read GetTop write SetTop;
    property &SkipToken: string read GetSkipToken write SetSkipToken;
    property &InLineCount: string read GetInLineCount write SetInLineCount;


    function ToString: string;

  end;

  IODataDecodeParams = interface
    ['{F03C7F83-F379-4D27-AFC5-C6D85FC56DE0}']
    procedure AddPair(AKey: string;AValue: string);
    procedure AddOperator(const AOperator:string);
    procedure Clear;
    function Count: integer;
    function ContainKey(AKey: string): boolean;
    function KeyOfIndex(const idx:integer):string;
    function OperatorOfIndex(const idx:integer):string;
    function ValueOfIndex(const idx: integer): string;
  end;

  IODataDialect = interface
    ['{812DB60E-64D7-4290-99DB-F625EC52C6DA}']
    function createQuery(AValue: IODataDecode; AFilter: string;
      const AInLineCount: boolean = false): string;
  end;

  IODataParse = interface
    ['{10893BDD-CE9A-4F31-BB2E-8DF18EA5A91B}']
    procedure Parse(URL: string);
    function GetOData: IODataDecode;
    property oData: IODataDecode read GetOData; // write SetOData;
  end;


  IODataBase = interface
    ['{61D854AF-4773-4DD2-9648-AD93A4134F13}']
    procedure DecodeODataURL(CTX: TObject);
    function This: TObject;
    function GetDataset: TObject;
    procedure CreateExpandCollections(AQuery: TObject);
    function Collection: string;
    function GetInLineRecordCount: integer;
    procedure SetInLineRecordCount(const Value: integer);
    property InLineRecordCount: integer read GetInLineRecordCount
      Write SetInLineRecordCount;
    function GetParse: IODataParse;
  end;

implementation

end.
