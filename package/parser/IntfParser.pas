unit IntfParser;

interface

uses
  CastaliaSimplePasPar,
  Classes,
  TokenClasses,
  TokenInterfaces;

type
  TIntfParser = class(TmwSimplePasPar)
  private
    FUnit: IUnit;
    FCurrentInterface: IInterfaceType;
    FCurrentFunction: IFunction;
    FCurrentMethod: IMethod;
    FCurrentParameter: IParameter;
    FCurrentProperty: IProperty;
    FCurrentTypeParam: IParameter;
    FLastTypeName: string;
  protected
    procedure InterfaceType; override;
    procedure TypeName; override;

    // generics
    procedure TypeParams; override;
    procedure TypeParamDeclList; override;
    procedure TypeArgs; override;
    procedure TypeParamDecl; override;
    procedure TypeParamList; override;
    procedure ConstraintList; override;
    procedure Constraint; override;

    procedure AncestorId; override;
    procedure ClassFunctionHeading; override;
    procedure FunctionMethodName; override;
    procedure ReturnTypeLower;override;
    procedure ReturnType; override;
    procedure ReturnTypeEnd;override;
    procedure ClassProcedureHeading; override;
    procedure ProcedureMethodName; override;
    procedure ParameterFormal; override;
    procedure ConstParameter; override;
    procedure VarParameter; override;
    procedure OutParameter; override;

    procedure ParameterName; override;
    procedure NewFormalParameterType; override;
    procedure ClassProperty; override;
    procedure PropertyName; override;
    procedure TypeId; override;
    procedure ReadAccessIdentifier; override;
    procedure WriteAccessIdentifier; override;
    procedure PropertyDefault; override;
    procedure IdentifierList; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Run(UnitName: string; SourceStream: TCustomMemoryStream);
      override;
    procedure LoadAndRun(const Filename: string);
    property AUnit: IUnit read FUnit;
  end;

implementation

uses
  SysUtils;

{ TIntfParser }

constructor TIntfParser.Create;
begin
  inherited;
  FUnit := CreateUnit;
  FCurrentInterface := nil;
  FCurrentFunction := nil;
  FCurrentMethod := nil;
  FCurrentParameter := nil;
  FCurrentProperty := nil;
  FLastTypeName := '';
end;

destructor TIntfParser.Destroy;
begin
  FUnit := nil;
  inherited;
end;

// ==============================================================================
// Interface level stuff.
// ==============================================================================
procedure TIntfParser.TypeName;
begin
  FLastTypeName := Lexer.Token;
  if (FCurrentInterface = nil) or (FCurrentInterface.name <> FLastTypeName) then
    FCurrentInterface := FUnit.Interfaces.Add;
  FCurrentInterface.name := FLastTypeName;

  FCurrentFunction := nil;
  FCurrentMethod := nil;
  FCurrentParameter := nil;
  FCurrentProperty := nil;

  inherited;
end;

procedure TIntfParser.TypeParamDecl;
begin
  if FCurrentInterface <> nil then
  begin
    FCurrentTypeParam := FCurrentInterface.TypeParams.Add;
    FCurrentTypeParam.Name := Lexer.Token;
  end;
  inherited;

end;

procedure TIntfParser.TypeParamDeclList;
begin

  inherited;
end;

procedure TIntfParser.TypeParamList;
begin
  inherited;

end;

procedure TIntfParser.TypeParams;
begin

  inherited;

end;

procedure TIntfParser.VarParameter;
begin
  if assigned(FCurrentMethod) then
    FCurrentParameter := FCurrentMethod.Params.Add
  else if assigned(FCurrentFunction) then
    FCurrentParameter := FCurrentFunction.Params.Add;
  FCurrentParameter.Modifier := pmVar;
  inherited;

end;

procedure TIntfParser.InterfaceType;
begin
  FCurrentInterface := FUnit.Interfaces.Add;
  FCurrentInterface.name := FLastTypeName;
  inherited;
  // FCurrentInterface := nil;
end;

procedure TIntfParser.LoadAndRun(const Filename: string);
var
  strmFile: TMemoryStream;
  str: TStringList;
begin
  strmFile := TMemoryStream.Create;
  str := TStringList.Create;
  try
    str.LoadFromFile(Filename);
    // str.SaveToStream(strmFile);
    Run(Filename, strmFile);
    Lexer.Origin := PWideChar(str.text);
    ParseFile;
  finally
    FreeAndNil(str);
    FreeAndNil(strmFile);
  end;
end;

// ==============================================================================
// Function stuff
// ==============================================================================
procedure TIntfParser.ClassFunctionHeading;
begin
  if FCurrentMethod <> nil then
    FCurrentMethod := nil;
  if assigned(FCurrentInterface) then
    FCurrentFunction := FCurrentInterface.Functions.Add;
  inherited;
  // FCurrentFunction := nil;
end;

procedure TIntfParser.FunctionMethodName;
begin
  if assigned(FCurrentFunction) then
    FCurrentFunction.name := Lexer.Token;
  inherited;
end;

procedure TIntfParser.ReturnType;
begin
  if assigned(FCurrentFunction) then
    FCurrentFunction.ReturnType := Lexer.Token;
  inherited;
end;

procedure TIntfParser.ReturnTypeEnd;
begin
  FCurrentFunction := nil;
  inherited;

end;

procedure TIntfParser.ReturnTypeLower;
begin
{  if assigned(FCurrentFunction) then
    FCurrentFunction.ReturnType := Lexer.Token;
}  inherited;
end;

// ==============================================================================
// Procedure stuff.
// ==============================================================================
procedure TIntfParser.ClassProcedureHeading;
begin
  if FCurrentFunction <> nil then
    FCurrentFunction := nil;

  if assigned(FCurrentInterface) then
    FCurrentMethod := FCurrentInterface.Methods.Add;
  inherited;
end;

procedure TIntfParser.ProcedureMethodName;
begin
  if assigned(FCurrentMethod) then
    FCurrentMethod.name := Lexer.Token;
  inherited;
end;
// ==============================================================================

procedure TIntfParser.NewFormalParameterType;
begin
  if assigned(FCurrentParameter) then
    FCurrentParameter.DataType := Lexer.Token;
  inherited;
end;

procedure TIntfParser.OutParameter;
begin
  if assigned(FCurrentMethod) then
    FCurrentParameter := FCurrentMethod.Params.Add
  else if assigned(FCurrentFunction) then
    FCurrentParameter := FCurrentFunction.Params.Add;
  FCurrentParameter.Modifier := pmVar;
  inherited;

end;

procedure TIntfParser.ParameterFormal;
begin
  if assigned(FCurrentMethod) then
    FCurrentParameter := FCurrentMethod.Params.Add
  else if assigned(FCurrentFunction) then
    FCurrentParameter := FCurrentFunction.Params.Add;
  inherited;
  // FCurrentParameter := nil;
end;

procedure TIntfParser.ParameterName;
begin
  if assigned(FCurrentParameter) then
    FCurrentParameter.name := Lexer.Token;
  inherited;
end;

procedure TIntfParser.ConstParameter;
begin
  if assigned(FCurrentMethod) then
    FCurrentParameter := FCurrentMethod.Params.Add
  else if assigned(FCurrentFunction) then
    FCurrentParameter := FCurrentFunction.Params.Add;
  FCurrentParameter.Modifier := pmConst;
  inherited;
  // FCurrentParameter := nil;
end;

procedure TIntfParser.Constraint;
begin
  inherited;

end;

procedure TIntfParser.ConstraintList;
begin
  if FCurrentTypeParam<>nil then
     FCurrentTypeParam.DataType := Lexer.Token;
  inherited;

end;

procedure TIntfParser.ClassProperty;
begin
  if assigned(FCurrentInterface) then
    FCurrentProperty := FCurrentInterface.Properties.Add;
  inherited;
  // FCurrentProperty := nil;
end;

procedure TIntfParser.PropertyName;
begin
  if assigned(FCurrentProperty) then
    FCurrentProperty.name := Lexer.Token;
  inherited;
end;

procedure TIntfParser.TypeArgs;
begin
  inherited;

end;

procedure TIntfParser.TypeId;
begin
  if assigned(FCurrentProperty) then
  begin
    if (FCurrentProperty.Index.name <> '') and
      (FCurrentProperty.Index.DataType = '') then
      FCurrentProperty.Index.DataType := Lexer.Token
    else
      FCurrentProperty.DataType := Lexer.Token;
  end;
  inherited;
end;

procedure TIntfParser.ReadAccessIdentifier;
begin
  if assigned(FCurrentProperty) then
    FCurrentProperty.Reader := Lexer.Token;
  inherited;
end;

procedure TIntfParser.WriteAccessIdentifier;
begin
  if assigned(FCurrentProperty) then
    FCurrentProperty.Writer := Lexer.Token;
  inherited;
end;

procedure TIntfParser.IdentifierList;
begin
  if assigned(FCurrentProperty) then
    FCurrentProperty.Index.name := Lexer.Token;
  inherited;
end;

procedure TIntfParser.AncestorId;
begin
  if assigned(FCurrentInterface) then
    FCurrentInterface.Ancestors.Add.name := Lexer.Token;
  inherited;
end;

procedure TIntfParser.Run(UnitName: string; SourceStream: TCustomMemoryStream);
begin
  FUnit.name := UnitName;
  inherited;
end;

procedure TIntfParser.PropertyDefault;
begin
  if assigned(FCurrentProperty) then
    FCurrentProperty.Default := True;
  inherited;
end;

end.
