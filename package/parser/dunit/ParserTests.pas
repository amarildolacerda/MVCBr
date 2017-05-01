unit ParserTests;

interface    

uses
  IntfParser,
  TestFrameWork,
  TokenClasses,
  TokenInterfaces;

type
  TParserTests = class(TTestCase)
  { TODO:
    1.  Parse interface uses clause.
    2.  Parse and store enumerated type?
    3.  Then do the writer and test it.
  }
  private
    FParser: TIntfParser;
    procedure DoTestParameter(param: IParameter; IntfNum, PropNum: Integer; Name, DataType: string; Modifier: TParameterModifier);
    procedure DoTestProperty(prop: IProperty; IntfNum, PropNum: Integer; Name, DataType, Reader, Writer: string; Default: Boolean);
    procedure DoTestMethod(method: IMethod; IntfNum, MethodNum: Integer; Name: string; Inheritance: TMethodInheritance; Modifier: TMethodModifier; Overloaded: Boolean);
    procedure DoTestFunction(func: IFunction; IntfNum, FuncNum: Integer; Name, DataType: string);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestUnit;
    procedure TestInterfaces;
    procedure TestFunctions;
    procedure TestMethods;
    procedure TestProperties;
  end;

implementation

uses
  Classes,
  SysUtils;

const
  UNIT_NAME = 'TestClasses';
  FILE_NAME = 'TestInterfaces.pas';

{ TParserTests }

procedure TParserTests.SetUp;
var
  srcStream: TMemoryStream;
begin
  FParser := TIntfParser.Create;
  srcStream := TMemoryStream.Create;
  try
    srcStream.LoadFromFile(FILE_NAME);
    FParser.Run(UNIT_NAME, srcStream);
  finally
    FreeAndNil(srcStream);
  end;
end;

procedure TParserTests.TearDown;
begin
  FreeAndNil(FParser);

end;

procedure TParserTests.DoTestFunction(func: IFunction; IntfNum, FuncNum: Integer; Name, DataType: string);
begin
  CheckEquals(Name,     func.Name,       Format('Interface[%d] Function[%d] Name', [IntfNum, FuncNum]));
  CheckEquals(DataType, func.ReturnType, Format('Interface[%d] Function[%d] Type', [IntfNum, FuncNum]));
end;

procedure TParserTests.TestFunctions;
var
  intf: IInterfaceType;
  func: IFunction;
  param: IParameter;
begin
  intf := FParser.AUnit.Interfaces[0];
  CheckEquals(2, FParser.AUnit.Interfaces[0].Functions.Count);

  //function GetOne: string;
  func := intf.Functions[0];
  DoTestFunction(func, 0, 0, 'GetOne', 'string');
  CheckEquals(0, func.Params.Count);
  CheckEquals('function GetOne: string;', func.Write);

  //function GetTwo(Index: Integer): Boolean;
  func := intf.Functions[1];
  DoTestFunction(func, 0, 1, 'GetTwo', 'Boolean');
  CheckEquals(1, func.Params.Count);         
  param := func.Params[0];
  DoTestParameter(param, 1, 0, 'Index', 'Integer', pmNone);
  CheckEquals('function GetTwo(Index: Integer): Boolean;', func.Write);

  intf := FParser.AUnit.Interfaces[1];
  CheckEquals(1, intf.Functions.Count);

  //function GetThree: TEnumeratedType;
  func := intf.Functions[0];
  DoTestFunction(func, 1, 0, 'GetThree', 'TEnumeratedType');
  CheckEquals(0, func.Params.Count);
  CheckEquals('function GetThree: TEnumeratedType;', func.Write);
end;

procedure TParserTests.TestInterfaces;
begin
  CheckEquals(2, FParser.AUnit.Interfaces.Count, 'Interface Count not correct');
  CheckEquals('ITestInterfaceOne', FParser.AUnit.Interfaces[0].Name, 'Interface 1 Name incorrect');
  CheckEquals('ITestInterfaceTwo', FParser.AUnit.Interfaces[1].Name, 'Interface 2 Name incorrect');
end;

procedure TParserTests.DoTestMethod(method: IMethod; IntfNum, MethodNum: Integer; Name: string; Inheritance: TMethodInheritance;
  Modifier: TMethodModifier; Overloaded: Boolean);
begin
  CheckEquals(Name, method.Name,             Format('Interface[%d] Method[%d] Name', [IntfNum, MethodNum]));
  Check(Inheritance = method.Inheritance,    Format('Interface[%d] Method[%d] Inheritance', [IntfNum, MethodNum]));
  Check(Modifier = method.Modifier,          Format('Interface[%d] Method[%d] Modifier', [IntfNum, MethodNum]));
  CheckEquals(Overloaded, method.Overloaded, Format('Interface[%d] Method[%d] Overloaded', [IntfNum, MethodNum]));
end;

procedure TParserTests.TestMethods;
var
  Method: IMethod;
begin
  CheckEquals(2, FParser.AUnit.Interfaces[0].Methods.Count);
  //procedure SetOne(const Value: string);
  Method := FParser.AUnit.Interfaces[0].Methods[0];
  DoTestMethod(Method, 0, 0, 'SetOne', miNone, mmNone, False);
  DoTestParameter(Method.Params[0], 0, 0, 'Value', 'string', pmConst);
  CheckEquals('procedure SetOne(const Value: string);', Method.Write);

  //procedure SetTwo(Index: Integer; const Value: Boolean);
  Method := FParser.AUnit.Interfaces[0].Methods[1];
  DoTestMethod(Method, 0, 0, 'SetTwo', miNone, mmNone, False);
  DoTestParameter(Method.Params[0], 1, 0, 'Index', 'Integer', pmNone);
  DoTestParameter(Method.Params[1], 1, 1, 'Value', 'Boolean', pmConst);
  CheckEquals('procedure SetTwo(Index: Integer; const Value: Boolean);', Method.Write);

  CheckEquals(1, FParser.AUnit.Interfaces[1].Methods.Count);
  //procedure SetFour(const Value: TEnumeratedType);
  Method := FParser.AUnit.Interfaces[1].Methods[0];
  DoTestMethod(Method, 0, 0, 'SetFour', miNone, mmNone, False);
  DoTestParameter(Method.Params[0], 0, 0, 'Value', 'TEnumeratedType', pmConst);
  CheckEquals('procedure SetFour(const Value: TEnumeratedType);', Method.Write);
end;

procedure TParserTests.DoTestProperty(prop: IProperty; IntfNum, PropNum: Integer; Name, DataType, Reader, Writer: string; Default: Boolean);
begin
  CheckEquals(Name,     prop.Name,     Format('Interface[%d] Property[%d] Name',     [IntfNum, PropNum]));
  CheckEquals(DataType, prop.DataType, Format('Interface[%d] Property[%d] DataType', [IntfNum, PropNum]));
  CheckEquals(Reader,   prop.Reader,   Format('Interface[%d] Property[%d] Reader',   [IntfNum, PropNum]));
  CheckEquals(Writer,   prop.Writer,   Format('Interface[%d] Property[%d] Writer',   [IntfNum, PropNum]));
  CheckEquals(Default,  prop.Default,  Format('Interface[%d] Property[%d] Default',  [IntfNum, PropNum]));
end;

procedure TParserTests.DoTestParameter(param: IParameter; IntfNum, PropNum: Integer; Name, DataType: string; Modifier: TParameterModifier);
begin
  CheckEquals(Name,     param.Name,     Format('Interface[%d] Property[%d] Parameter Name',     [IntfNum, PropNum]));
  CheckEquals(DataType, param.DataType, Format('Interface[%d] Property[%d] Parameter Type',     [IntfNum, PropNum]));
  Check(Modifier = param.Modifier,      Format('Interface[%d] Property[%d] Parameter Modifier', [IntfNum, PropNum]));
end;

procedure TParserTests.TestProperties;
var
  intf: IInterfaceType;
begin
  intf := FParser.AUnit.Interfaces[0];
  CheckEquals(2, intf.Properties.Count, 'Interface 0 Property Count');

  //property One: string read GetOne write SetOne;
  DoTestProperty(intf.Properties[0], 0, 0, 'One', 'string', 'GetOne', 'SetOne', false);
  DoTestParameter(intf.Properties[0].Index, 0, 0, '', '', pmNone);
  CheckEquals('property One: string read GetOne write SetOne;', intf.Properties[0].Write);

  //property Two[Index: Integer]: Boolean read GetTwo write SetTwo; default;
  DoTestProperty(intf.Properties[1], 0, 1, 'Two', 'Boolean', 'GetTwo', 'SetTwo', true);
  DoTestParameter(intf.Properties[1].Index, 0, 1, 'Index', 'Integer', pmNone);
  CheckEquals('property Two[Index: Integer]: Boolean read GetTwo write SetTwo; default;', intf.Properties[1].Write);
                                                     
  intf := FParser.AUnit.Interfaces[1];
  CheckEquals(2, intf.Properties.Count, 'Interface 1 Property Count');

  //property Three: TEnumeratedType read GetThree;
  DoTestProperty(intf.Properties[0], 1, 0, 'Three', 'TEnumeratedType', 'GetThree', '', false);
  DoTestParameter(intf.Properties[0].Index, 1, 0, '', '', pmNone);
  CheckEquals('property Three: TEnumeratedType read GetThree;', intf.Properties[0].Write);

  //property Four: TEnumeratedType write SetFour;
  DoTestProperty(intf.Properties[1], 1, 1, 'Four', 'TEnumeratedType', '', 'SetFour', false);
  DoTestParameter(intf.Properties[1].Index, 1, 1, '', '', pmNone);
  CheckEquals('property Four: TEnumeratedType write SetFour;', intf.Properties[1].Write);
end;

procedure TParserTests.TestUnit;
begin
  CheckEquals(UNIT_NAME, FParser.AUnit.Name, 'Unit Name not correct');
end; 

initialization
  RegisterTest('Parser Tests', TParserTests.Suite);

end.
 