unit TokenClasses;

interface   

uses
  TokenInterfaces;

function CreateUnit: IUnit;

implementation

uses
  Classes,
  SysUtils;

type
  TNamedItem = class(TInterfacedObject, INamedItem)
  private 
    FName: string;
    function GetName: string;
    procedure SetName(const Value: string);
  public
    function Write: string; virtual;
    property Name: string read GetName write SetName;
  end;

  TGenericList = class(TInterfacedObject, IGenericList)
  private
    function GetCount: Integer;
  protected
    FList: IInterfaceList;
  public
    constructor Create;
    function Write: string; virtual; abstract;
    property Count: Integer read GetCount;
  end;

  TParameter = class(TNamedItem, IParameter)
  private
    FModifier: TParameterModifier;
    FType: string;
    function GetType: string;
    procedure SetType(const Value: string);
    function GetModifier: TParameterModifier;
    procedure SetModifier(const Value: TParameterModifier);
    function WriteModifier: string;
  public
    function Write: string; override;
    property DataType: string read GetType write SetType;
    property Modifier: TParameterModifier read GetModifier write SetModifier;
  end;

  TParameterList = class(TGenericList, IParameterList)
  private
    function Add: IParameter;
    function GetItems(Index: Integer): IParameter;
  public                                     
    function Write: string; override;
    property Items[Index: Integer]: IParameter read GetItems; default;
  end;

  TMethod = class(TParameter, IMethod)
  private
    FParams: IParameterList;
    FInheritance: TMethodInheritance;
    FModifier: TMethodModifier;
    FOverloaded: Boolean;
    function GetParams: IParameterList;  
    function GetInheritance: TMethodInheritance;
    procedure SetInheritance(const Value: TMethodInheritance);
    function GetModifier: TMethodModifier;
    procedure SetModifier(const Value: TMethodModifier);
    function GetOverloaded: Boolean;
    procedure SetOverloaded(const Value: Boolean);
    function WriteParams: string;
    function WriteModifiers: string;
  public
    constructor Create;
    destructor Destroy; override;
    function Write: string; override;
    property Params: IParameterList read GetParams; 
    property Inheritance: TMethodInheritance read GetInheritance write SetInheritance;
    property Modifier: TMethodModifier read GetModifier write SetModifier;
    property Overloaded: Boolean read GetOverloaded write SetOverloaded;
  end;

  TMethodList = class(TGenericList, IMethodList)
  private
    function Add: IMethod;
    function GetItems(Index: Integer): IMethod;
  public
    property Items[Index: Integer]: IMethod read GetItems; default;
  end; 

  TFunction = class(TMethod, IFunction)
  private
    FReturnType: string;
    function GetReturnType: string;
    procedure SetReturnType(const Value: string);
    function WriteParams: string;
  public
    function Write: string; override;
    property ReturnType: string read GetReturnType write SetReturnType;
  end;

  TFunctionList = class(TGenericList, IFunctionList)
  private
    function Add: IFunction;
    function GetItems(Index: Integer): IFunction;
  public
    property Items[Index: Integer]: IFunction read GetItems; default;
  end;

  TProperty = class(TParameter, IProperty)
  private
    FIndex: IParameter;
    FDefault: Boolean;
    FReader: string;
    FWriter: string;
    function GetDefault: Boolean;
    procedure SetDefault(const Value: Boolean);
    function GetIndex: IParameter;
    function GetReader: string;
    function GetWriter: string;
    procedure SetReader(const Value: string);
    procedure SetWriter(const Value: string);
    function WriteDefault: string;
    function WriteIndex: string;
    function WriteReader: string;
    function WriteWriter: string;
  public
    constructor Create;
    function Write: string; override;
    property Default: Boolean read GetDefault write SetDefault;
    property Index: IParameter read GetIndex;
    property Reader: string read GetReader write SetReader;
    property Writer: string read GetWriter write SetWriter;
  end;

  TPropertyList = class(TGenericList, IPropertyList)
  private
    function Add: IProperty;
    function GetItems(Index: Integer): IProperty;
  public
    property Items[Index: Integer]: IProperty read GetItems; default;
  end;

  TAncestor = class(TInterfacedObject, IAncestor)
  private
    FName: string;
    function GetName: string;
    procedure SetName(const Value: string);
  public
    function Write: string;
    property Name: string read GetName write SetName;
  end;

  TAncestorList = class(TGenericList, IAncestorList)
  private
    function Add: IAncestor;
    function GetItems(Index: Integer): IAncestor;
  public
    property Items[Index: Integer]: IAncestor read GetItems; default;
  end;

  TInterface = class(TNamedItem, IInterfaceType)
  private
    FAncestors: IAncestorList;
    FFunctions: IFunctionList;
    FMethods: IMethodList;
    FProperties: IPropertyList;
    FTypeParams : IParameterList;
    function GetAncestors: IAncestorList;
    function GetFunctions: IFunctionList;
    function GetMethods: IMethodList;
    function GetProperties: IPropertyList;
    function GetTypeParams : IParameterList;
  public
    constructor Create;
    destructor Destroy; override;
    property Ancestors: IAncestorList read GetAncestors;
    property Functions: IFunctionList read GetFunctions;
    property Methods: IMethodList read GetMethods;
    property Properties: IPropertyList read GetProperties;
    property TypeParams:IParameterList read GetTypeParams;
  end;

  TInterfacesList = class(TGenericList, IInterfacesList)
  private
    function Add: IInterfaceType;
    function GetItems(Index: Integer): IInterfaceType;
  public
    property Items[Index: Integer]: IInterfaceType read GetItems; default;
  end;

  TUnit = class(TNamedItem, IUnit)
  private
    FInterfaces: IInterfacesList;
    FUsesUnits: TStrings;
    function GetInterfaces: IInterfacesList;
    function GetUsesUnits: TStrings;
  public
    constructor Create;
    destructor Destroy; override;
    property Interfaces: IInterfacesList read GetInterfaces;
    property UsesUnits: TStrings read GetUsesUnits;
  end;

function CreateUnit: IUnit;
begin
  Result := TUnit.Create;
end;

{ TParameter }

function TParameter.GetModifier: TParameterModifier;
begin
  Result := FModifier;
end;

function TParameter.GetType: string;
begin
  Result := FType;
end;

procedure TParameter.SetModifier(const Value: TParameterModifier);
begin
  FModifier := Value;
end;

procedure TParameter.SetType(const Value: string);
begin
  FType := Value;
end;

function TParameter.Write: string;
begin
  Result := Format('%s%s: %s', [WriteModifier, Name, DataType]);
end;

function TParameter.WriteModifier: string;
begin
  case FModifier of
    pmNone:  Result := '';
    pmVar:   Result := 'var ';
    pmConst: Result := 'const ';
    pmOut:   Result := 'out ';
  end;
end;

{ TParameterList }

function TParameterList.Add: IParameter;
begin
  Result := TParameter.Create;
  FList.Add(Result);
end;

function TParameterList.GetItems(Index: Integer): IParameter;
begin
  Result := IParameter(FList.Items[Index]);
end;

function TParameterList.Write: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
  begin
    Result := Result + Items[i].Write + '; ';
  end;
  Result := Copy(Result, 1, Length(Result) - 2);
end;

{ TMethod }

constructor TMethod.Create;
begin
  inherited;
  FParams := TParameterList.Create;
end;

destructor TMethod.Destroy;
begin
  FParams := nil;
  inherited;
end;

function TMethod.GetInheritance: TMethodInheritance;
begin
  Result := FInheritance;
end;

function TMethod.GetModifier: TMethodModifier;
begin
  Result := FModifier;
end;

function TMethod.GetOverloaded: Boolean;
begin
  Result := FOverloaded;
end;

function TMethod.GetParams: IParameterList;
begin
  Result := FParams;
end;

procedure TMethod.SetInheritance(const Value: TMethodInheritance);
begin
  FInheritance := Value;
end;

procedure TMethod.SetModifier(const Value: TMethodModifier);
begin
  FModifier := Value;
end;

procedure TMethod.SetOverloaded(const Value: Boolean);
begin
  FOverloaded := Value;
end;

function TMethod.Write: string;
begin
  Result := Format('procedure %s%s;%s', [Name, WriteParams, WriteModifiers]); 
end;

function TMethod.WriteModifiers: string;
var
  sInheritance: string;
  sModifiers: string;
  sOverloaded: string;
begin
  case Inheritance of
    miNone:        sInheritance := '';
    miVirtual:     sInheritance := ' virtual;';
    miDynamic:     sInheritance := ' dynamic;';
    miOverride:    sInheritance := ' override;';
    miReintroduce: sInheritance := ' reintroduce;';
  end;
  case Modifier of
    mmNone:    sModifiers := '';
    mmStdCall: sModifiers := ' stdcall;';
    mmCdecl:   sModifiers := ' cdecl;';
  end;
  if Overloaded then
    sOverloaded := ' overloaded;'
  else
    sOverloaded := '';
  Result := Format('%s%s%s', [sInheritance, sModifiers, sOverloaded]);
end;

function TMethod.WriteParams: string;
begin
  Result := FParams.Write;
  if (Result <> '') then
    Result := Format('(%s)', [Result]);
end;

{ TNamedItem }

function TNamedItem.GetName: string;
begin
  Result := FName;
end;

procedure TNamedItem.SetName(const Value: string);
begin
  FName := Value;
end;

function TNamedItem.Write: string;
begin
  Result := Name;
end;

{ TGenericList }

constructor TGenericList.Create;
begin
  inherited;
  FList := TInterfaceList.Create;
end;

function TGenericList.GetCount: Integer;
begin
  Result := FList.Count;
end;

{ TMethodList }

function TMethodList.Add: IMethod;
begin
  Result := TMethod.Create;
  FList.Add(Result);
end;

function TMethodList.GetItems(Index: Integer): IMethod;
begin
  Result := IMethod(FList.Items[Index]);
end;

{ TFunction }

function TFunction.GetReturnType: string;
begin
  Result := FReturnType;
end;

procedure TFunction.SetReturnType(const Value: string);
begin
  FReturnType := Value;
end;

function TFunction.Write: string;
begin
  Result := Format('function %s%s: %s;', [Name, WriteParams, ReturnType])
end;

function TFunction.WriteParams: string;
begin
  Result := FParams.Write;
  if (Result <> '') then
    Result := Format('(%s)', [Result]);
end;

{ TFunctionList }

function TFunctionList.Add: IFunction;
begin
  Result := TFunction.Create;
  FList.Add(Result);
end;

function TFunctionList.GetItems(Index: Integer): IFunction;
begin
  Result := IFunction(FList.Items[Index]);
end;

{ TProperty }

constructor TProperty.Create;
begin
  inherited;
  FIndex := TParameter.Create;
end;

function TProperty.GetDefault: Boolean;
begin
  Result := FDefault;
end;

function TProperty.GetIndex: IParameter;
begin
  Result := FIndex;
end;

function TProperty.GetReader: string;
begin
  Result := FReader;
end;

function TProperty.GetWriter: string;
begin
  Result := FWriter;
end;

procedure TProperty.SetDefault(const Value: Boolean);
begin
  FDefault := Value;
end;

procedure TProperty.SetReader(const Value: string);
begin
  FReader := Value;
end;

procedure TProperty.SetWriter(const Value: string);
begin
  FWriter := Value;
end;

function TProperty.Write: string;
begin
  Result := Format('property %s%s: %s%s%s;%s', [Name, WriteIndex, DataType, WriteReader, WriteWriter, WriteDefault]);
end;

function TProperty.WriteDefault: string;
begin
  if Default then
    Result := ' default;'
  else
    Result := '';
end;

function TProperty.WriteIndex: string;
begin
  if (Index.Name <> '') then
    Result := Format('[%s: %s]', [Index.Name, Index.DataType])
  else
    Result := '';
end;

function TProperty.WriteReader: string;
begin
  if (Reader <> '') then
    Result := Format(' read %s', [Reader])
  else
    Result := '';
end;

function TProperty.WriteWriter: string;
begin
  if (Writer <> '') then
    Result := Format(' write %s', [Writer])
  else
    Result := '';
end;

{ TPropertyList }

function TPropertyList.Add: IProperty;
begin
  Result := TProperty.Create;
  FList.Add(Result);
end;

function TPropertyList.GetItems(Index: Integer): IProperty;
begin
  Result := IProperty(FList.Items[Index]);
end;

{ TInterface }

constructor TInterface.Create;
begin
  inherited;
  FTypeParams := TParameterList.Create;
  FAncestors := TAncestorList.Create;
  FFunctions := TFunctionList.Create;
  FMethods := TMethodList.Create;
  FProperties := TPropertyList.Create;
end;

destructor TInterface.Destroy;
begin
  FAncestors := nil;
  FFunctions := nil;
  FMethods := nil;
  FProperties := nil;
  FTypeParams := nil;
  inherited;
end;

function TInterface.GetAncestors: IAncestorList;
begin
  Result := FAncestors;
end;

function TInterface.GetFunctions: IFunctionList;
begin
  Result := FFunctions;
end;

function TInterface.GetMethods: IMethodList;
begin
  Result:= FMethods;
end;

function TInterface.GetProperties: IPropertyList;
begin
  Result := FProperties;
end;

function TInterface.GetTypeParams: IParameterList;
begin
  result := FTypeParams;
end;

{ TInterfacesList }

function TInterfacesList.Add: IInterfaceType;
begin
  Result := TInterface.Create;
  FList.Add(Result);
end;

function TInterfacesList.GetItems(Index: Integer): IInterfaceType;
begin
  Result := FList.Items[Index] as IInterfaceType;
end;

{ TUnit }

constructor TUnit.Create;
begin
  inherited;
  FInterfaces := TInterfacesList.Create;
  FUsesUnits := TStringList.Create;
end;

destructor TUnit.Destroy;
begin
  FInterfaces := nil;
  FreeAndNil(FUsesUnits);
  inherited;
end;

function TUnit.GetInterfaces: IInterfacesList;
begin
  Result := FInterfaces;
end;

function TUnit.GetUsesUnits: TStrings;
begin
  Result := FUsesUnits;
end;

{ TAncestorList }

function TAncestorList.Add: IAncestor;
begin
  Result := TAncestor.Create;
  FList.Add(Result);
end;

function TAncestorList.GetItems(Index: Integer): IAncestor;
begin
  Result := IAncestor(FList.Items[Index]);
end;

{ TAncestor }

function TAncestor.GetName: string;
begin
  Result := FName;
end;

procedure TAncestor.SetName(const Value: string);
begin
  FName := Value;
end;

function TAncestor.Write: string;
begin
  Result := Name;
end;

end.
 