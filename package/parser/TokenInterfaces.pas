unit TokenInterfaces;

interface

uses
  Classes;

type
  IWriteable = interface
    ['{79957D46-7745-11DD-828E-0090F52BA021}']
    function Write: string;
  end;

  INamedItem = interface(IWriteable)
    ['{7CA7F662-7745-11DD-828E-0090F52BA021}']
    function GetName: string;
    procedure SetName(const Value: string);
    property Name: string read GetName write SetName;
  end;

  TParameterModifier = (pmNone, pmVar, pmConst, pmOut);

  IParameter = interface(INamedItem)
    ['{7F302314-7745-11DD-828E-0090F52BA021}']
    function GetModifier: TParameterModifier;
    function GetType: string;
    procedure SetModifier(const Value: TParameterModifier);
    procedure SetType(const Value: string);
    property DataType: string read GetType write SetType;
    property Modifier: TParameterModifier read GetModifier write SetModifier;
  end;

  IGenericList = interface(IWriteable)
    ['{815CA66C-7745-11DD-828E-0090F52BA021}']
    function GetCount: Integer;
    property Count: Integer read GetCount;
  end;

  IParameterList = interface(IGenericList)
    ['{83B8EC72-7745-11DD-828E-0090F52BA021}']
    function Add: IParameter;
    function GetItems(Index: Integer): IParameter;
    property Items[Index: Integer]: IParameter read GetItems; default;
  end;

  TMethodInheritance = (miNone, miVirtual, miDynamic, miOverride, miReintroduce);
  TMethodModifier = (mmNone, mmStdCall, mmCdecl);

  IMethod = interface(INamedItem)
    ['{86650D66-7745-11DD-828E-0090F52BA021}']
    function GetParams: IParameterList;
    function GetInheritance: TMethodInheritance;
    procedure SetInheritance(const Value: TMethodInheritance);
    function GetModifier: TMethodModifier;
    procedure SetModifier(const Value: TMethodModifier);
    function GetOverloaded: Boolean;
    procedure SetOverloaded(const Value: Boolean);
    property Params: IParameterList read GetParams;
    property Inheritance: TMethodInheritance read GetInheritance write SetInheritance;
    property Modifier: TMethodModifier read GetModifier write SetModifier;
    property Overloaded: Boolean read GetOverloaded write SetOverloaded;
  end;

  IMethodList = interface(IGenericList)
    ['{88F0CB24-7745-11DD-828E-0090F52BA021}']
    function Add: IMethod;
    function GetItems(Index: Integer): IMethod;
    property Items[Index: Integer]: IMethod read GetItems; default;
  end;

  IFunction = interface(IMethod)
    ['{8B10CDAA-7745-11DD-828E-0090F52BA021}']
    function GetReturnType: string;
    procedure SetReturnType(const Value: string);
    property ReturnType: string read GetReturnType write SetReturnType;
  end;

  IFunctionList = interface(IGenericList)
    ['{8DAEC6D4-7745-11DD-828E-0090F52BA021}']
    function Add: IFunction;
    function GetItems(Index: Integer): IFunction;
    property Items[Index: Integer]: IFunction read GetItems; default;
  end;

  IProperty = interface(IParameter)
    ['{8FB6C350-7745-11DD-828E-0090F52BA021}']
    function GetDefault: Boolean;
    procedure SetDefault(const Value: Boolean);
    function GetIndex: IParameter;
    function GetReader: string;
    procedure SetReader(const Value: string);
    function GetWriter: string;
    procedure SetWriter(const Value: string);
    property Default: Boolean read GetDefault write SetDefault;
    property Index: IParameter read GetIndex;
    property Reader: string read GetReader write SetReader;
    property Writer: string read GetWriter write SetWriter;
  end;

  IPropertyList = interface(IGenericList)
    ['{926E3970-7745-11DD-828E-0090F52BA021}']
    function Add: IProperty;
    function GetItems(Index: Integer): IProperty;
    property Items[Index: Integer]: IProperty read GetItems; default;
  end;

  IAncestor = INamedItem;

  IAncestorList = interface(IGenericList)
    ['{9A6E5D3A-7745-11DD-828E-0090F52BA021}']
    function Add: IAncestor;
    function GetItems(Index: Integer): IAncestor;
    property Items[Index: Integer]: IAncestor read GetItems; default;
  end;

  IInterfaceType = interface(INamedItem)
    ['{9CB6BB50-7745-11DD-828E-0090F52BA021}']
    function GetAncestors: IAncestorList;
    function GetFunctions: IFunctionList;
    function GetMethods: IMethodList;
    function GetProperties: IPropertyList;
    property Ancestors: IAncestorList read GetAncestors;
    property Functions: IFunctionList read GetFunctions;
    property Methods: IMethodList read GetMethods;
    property Properties: IPropertyList read GetProperties;
  end;

  IInterfacesList = interface(IGenericList)
    ['{9EEFB28C-7745-11DD-828E-0090F52BA021}']
    function Add: IInterfaceType;
    function GetItems(Index: Integer): IInterfaceType;
    property Items[Index: Integer]: IInterfaceType read GetItems; default;
  end;

  IUnit = interface(INamedItem)
    ['{A0FD7564-7745-11DD-828E-0090F52BA021}']
    function GetInterfaces: IInterfacesList;
    function GetUsesUnits: TStrings;
    property Interfaces: IInterfacesList read GetInterfaces;
    property UsesUnits: TStrings read GetUsesUnits;
  end;

implementation

end.
 