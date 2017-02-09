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
    FLastTypeName: string;
  protected
    procedure InterfaceType; override;
    procedure TypeName; override;
    procedure AncestorId; override;
    procedure ClassFunctionHeading; override;
    procedure FunctionMethodName; override;
    procedure ReturnType; override;
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
    procedure Run(UnitName: string; SourceStream: TCustomMemoryStream); override;
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

//==============================================================================
// Interface level stuff.
//==============================================================================
procedure TIntfParser.TypeName;
begin

  FLastTypeName := Lexer.Token;
  if FCurrentInterface<>nil then
     FCurrentInterface.name := FLastTypeName;
  inherited;
end;

procedure TIntfParser.VarParameter;
begin
  if Assigned(FCurrentMethod) then
    FCurrentParameter := FCurrentMethod.Params.Add
  else if Assigned(FCurrentFunction) then
    FCurrentParameter := FCurrentFunction.Params.Add;
  FCurrentParameter.Modifier := pmVar;
  inherited;

end;

procedure TIntfParser.InterfaceType;
begin
  FCurrentInterface := FUnit.Interfaces.Add;
  FCurrentInterface.Name := FLastTypeName;
  inherited;
  //FCurrentInterface := nil;
end;

procedure TIntfParser.LoadAndRun(const Filename: string);
var
  strmFile: TMemoryStream;
  str:TStringList;
begin
  strmFile := TMemoryStream.Create;
  str:=TStringList.create;
  try
    str.LoadFromFile(Filename);
//    str.SaveToStream(strmFile);
    Run(Filename, strmFile);
    Lexer.Origin := PWideChar( str.text );
    ParseFile;
  finally
    FreeAndNil(str);
    FreeAndNil(strmFile);
  end;
end;

//==============================================================================
// Function stuff
//==============================================================================
procedure TIntfParser.ClassFunctionHeading;
begin
  if Assigned(FCurrentInterface) then
    FCurrentFunction := FCurrentInterface.Functions.Add;
  inherited;
//  FCurrentFunction := nil;
end;

procedure TIntfParser.FunctionMethodName;
begin
  if Assigned(FCurrentFunction) then
    FCurrentFunction.Name := Lexer.Token;
  inherited;
end;

procedure TIntfParser.ReturnType;
begin
  if Assigned(FCurrentFunction) then
    FCurrentFunction.ReturnType := Lexer.Token;
  inherited;
end;

//==============================================================================
// Procedure stuff.
//==============================================================================
procedure TIntfParser.ClassProcedureHeading;
begin
  if Assigned(FCurrentInterface) then
    FCurrentMethod := FCurrentInterface.Methods.Add;
  inherited;
  //FCurrentMethod := nil;
end;

procedure TIntfParser.ProcedureMethodName;
begin
  if Assigned(FCurrentMethod) then
    FCurrentMethod.Name := Lexer.Token;
  inherited;
end;
//==============================================================================

procedure TIntfParser.NewFormalParameterType;
begin
  if Assigned(FCurrentParameter) then
    FCurrentParameter.DataType := Lexer.Token;
  inherited;
end;

procedure TIntfParser.OutParameter;
begin
  if Assigned(FCurrentMethod) then
    FCurrentParameter := FCurrentMethod.Params.Add
  else if Assigned(FCurrentFunction) then
    FCurrentParameter := FCurrentFunction.Params.Add;
  FCurrentParameter.Modifier := pmVar;
  inherited;

end;

procedure TIntfParser.ParameterFormal;
begin
  if Assigned(FCurrentMethod) then
    FCurrentParameter := FCurrentMethod.Params.Add
  else if Assigned(FCurrentFunction) then
    FCurrentParameter := FCurrentFunction.Params.Add;
  inherited;
//  FCurrentParameter := nil;
end;

procedure TIntfParser.ParameterName;
begin
  if Assigned(FCurrentParameter) then
    FCurrentParameter.Name := Lexer.Token;
  inherited;
end;

procedure TIntfParser.ConstParameter;
begin    
  if Assigned(FCurrentMethod) then
    FCurrentParameter := FCurrentMethod.Params.Add
  else if Assigned(FCurrentFunction) then
    FCurrentParameter := FCurrentFunction.Params.Add;
  FCurrentParameter.Modifier := pmConst;
  inherited;
//  FCurrentParameter := nil;
end;

procedure TIntfParser.ClassProperty;
begin
  if Assigned(FCurrentInterface) then
    FCurrentProperty := FCurrentInterface.Properties.Add;
  inherited;
//  FCurrentProperty := nil;
end;

procedure TIntfParser.PropertyName;
begin
  if Assigned(FCurrentProperty) then
    FCurrentProperty.Name := Lexer.Token;
  inherited;
end;

procedure TIntfParser.TypeId;
begin
  if Assigned(FCurrentProperty) then
  begin
    if (FCurrentProperty.Index.Name <> '') and (FCurrentProperty.Index.DataType = '') then
      FCurrentProperty.Index.DataType := Lexer.Token 
    else
      FCurrentProperty.DataType := Lexer.Token;
  end;
  inherited;
end;

procedure TIntfParser.ReadAccessIdentifier;
begin
  if Assigned(FCurrentProperty) then
    FCurrentProperty.Reader := Lexer.Token;
  inherited;
end;

procedure TIntfParser.WriteAccessIdentifier;
begin
  if Assigned(FCurrentProperty) then
    FCurrentProperty.Writer := Lexer.Token;
  inherited;
end;

procedure TIntfParser.IdentifierList;
begin
  if Assigned(FCurrentProperty) then
    FCurrentProperty.Index.Name := Lexer.Token;
  inherited;
end;

procedure TIntfParser.AncestorId;
begin
  if Assigned(FCurrentInterface) then
    FCurrentInterface.Ancestors.Add.Name := Lexer.Token;
  inherited;
end;

procedure TIntfParser.Run(UnitName: string;
  SourceStream: TCustomMemoryStream);
begin
  FUnit.Name := UnitName;
  inherited;
end;

procedure TIntfParser.PropertyDefault;
begin
  if Assigned(FCurrentProperty) then
    FCurrentProperty.Default := True;
  inherited;
end;

end.
