{ *************************************************************************** }
{ }
{ Projeto MVCBr }
{ Coder: Ivan Cesar }
{ }
{ *************************************************************************** }
{ }
{ Licensed under the Apache License, Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. }
{ You may obtain a copy of the License at }
{ }
{ http://www.apache.org/licenses/LICENSE-2.0 }
{ }
{ Unless required by applicable law or agreed to in writing, software }
{ distributed under the License is distributed on an "AS IS" BASIS, }
{ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{ See the License for the specific language governing permissions and }
{ limitations under the License. }
{ }
{ *************************************************************************** }
{
  Objetivo: base para utilizar em conjunto com um Dataset para capturar as alterações em um DeltaJSON

  Marcações:
  +  adicionado recurso
  -  retirado
  *  alteração
  =  nao ocorreu mudança que interfira relacionamento codigo anterior.

  Alterações:
  23/03/2017 + procedure SetApplyUpdateDelegate( const AProc:TProc ); por: amarildo lacerda
  06/05/2017 * alterado ModifiedDataRowToJsonObject - checar TProviderFlag.pfInUpdate; por: Ivan Cesar

}
{ *************************************************************************** }
unit MVCBr.ODataDataSet.Common;

interface

uses
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.DateUtils,
  System.Variants,
  System.TypInfo,
  System.StrUtils,
  MVCBr.Common,
  Data.DB,
  Data.FmtBcd,
  Data.SqlTimSt,
  System.NetEncoding;

type
  IODataDataSet = interface
    ['{EC7FCAF9-00F2-467C-943F-2ECBC8D7BF9C}']
    procedure DoBeforeDelete;
    procedure DoBeforePost;
    function GetChanges: TJSONArray;
    function GetKeyFields: string;
    function GetUpdateTable: string;
    procedure SetKeyFields(const AValue: string);
    procedure SetUpdateTable(const AValue: string);
    procedure SetApplyUpdateDelegate(const AProc: TProc<TDataset>);
    function UpdatesPending: Boolean;
    procedure ClearChanges;
    procedure SetLoading(const ALoading:boolean);
    function GetLoading:Boolean;
    property Changes: TJSONArray read GetChanges;
    property KeyFields: string read GetKeyFields write SetKeyFields;
    property UpdateTable: string read GetUpdateTable write SetUpdateTable;
  end;

function ModifiedDataRowToJsonObject(ADataSet: TDataset; AKeyFields: string)
  : TJSONObject;
function DeletedDataRowToJsonObject(ADataSet: TDataset; AKeyFields: string)
  : TJSONObject;

implementation

function MatchKeyField(const AField, AFieldList: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  I := 1;
  while (I <= AFieldList.Length) do
    if SameText(ExtractFieldName(AFieldList, I).Trim, AField.Trim) then
    begin
      Result := True;
      Break;
    end;
end;

function FieldIsModified(const AField: TField): Boolean;
begin
  if AField.IsBlob then
    Exit((AField as TBlobField).Modified);
  if (VarIsNull(AField.OldValue)) and (AField.NewValue = Unassigned) then
    Exit(False)
  else
    Exit(not VarSameValue(AField.OldValue, AField.NewValue));
end;

procedure DataRowToJsonObject(const AField: TField; AJsonObject: TJSONObject);
var
  LFieldName: string;
  LSqlTimeStamp: TSQLTimeStamp;
  LMemoryStream: TMemoryStream;
  LStringStream: TStringStream;
begin
  LFieldName := AField.FullName.ToLowerInvariant;

  if AField.IsNull then
  begin
    AJsonObject.AddPair(LFieldName, TJSONNull.Create);
    Exit;
  end;

  case AField.DataType of
    TFieldType.ftSmallint, TFieldType.ftInteger, TFieldType.ftWord,
      TFieldType.ftLongWord, TFieldType.ftAutoInc, TFieldType.ftShortint:
      AJsonObject.AddPair(LFieldName, TJSONNumber.Create(AField.AsInteger));

    TFieldType.ftLargeint:
      AJsonObject.AddPair(LFieldName, TJSONNumber.Create(AField.AsLargeInt));

    TFieldType.ftSingle, TFieldType.ftFloat:
      AJsonObject.AddPair(LFieldName, TJSONNumber.Create(AField.AsFloat));

    TFieldType.ftWideString, TFieldType.ftMemo, TFieldType.ftWideMemo,
      TFieldType.ftFixedWideChar:
      AJsonObject.AddPair(LFieldName, AField.AsWideString);

    TFieldType.ftString, TFieldType.ftFixedChar:
      AJsonObject.AddPair(LFieldName, AField.AsString);

    TFieldType.ftDate, TFieldType.ftDateTime:
      AJsonObject.AddPair(LFieldName, DateToISO8601(AField.AsDateTime));

    TFieldType.ftTime:
      AJsonObject.AddPair(LFieldName, FormatDateTime('hh:nn:ss:zzz',
        AField.AsDateTime));

    TFieldType.ftTimeStamp:
      begin
        LSqlTimeStamp := AField.AsSQLTimeStamp;
        AJsonObject.AddPair(LFieldName,
          SQLTimeStampToStr('yyyy-mm-dd hh:nn:ss:zzz', LSqlTimeStamp));
      end;

    TFieldType.ftCurrency:
      AJsonObject.AddPair(LFieldName, TJSONNumber.Create(AField.AsCurrency));

    TFieldType.ftExtended:
      AJsonObject.AddPair(LFieldName, TJSONNumber.Create(AField.AsExtended));

    TFieldType.ftBCD, TFieldType.ftFMTBcd:
      AJsonObject.AddPair(LFieldName,
        TJSONNumber.Create(BcdToDouble(AField.AsBcd)));

    TFieldType.ftBoolean:
      begin
        if AField.AsBoolean then
          AJsonObject.AddPair(LFieldName, TJSONTrue.Create)
        else
          AJsonObject.AddPair(LFieldName, TJSONFalse.Create);
      end;

    TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftStream,
      TFieldType.ftFmtMemo:
      begin
        LMemoryStream := TMemoryStream.Create;
        try
          TBlobField(AField).SaveToStream(LMemoryStream);
          LMemoryStream.Position := 0;
          LStringStream := TStringStream.Create('', TEncoding.ASCII);
          try
            TNetEncoding.Base64.Encode(LMemoryStream, LStringStream);
            LStringStream.Position := 0;
            AJsonObject.AddPair(LFieldName, LStringStream.DataString);
          finally
            LStringStream.DisposeOf;
          end;
        finally
          LMemoryStream.DisposeOf;
        end;
      end;
  else
    raise ENotSupportedException.CreateFmt
      ('O campo "%s" possui um tipo não suportado ("%s")',
      [LFieldName, GetEnumName(TypeInfo(TFieldType),
      Integer(AField.DataType))]);
  end;
end;

procedure CheckDataSet(const ADataSet: TDataset);
begin
  Assert(Assigned(ADataSet), 'ADataSet deve ser informado e estar instanciado.'
    + sLineBreak);
  Assert(ADataSet.Active, 'O dataset não está ativo.' + sLineBreak);
end;

function ModifiedDataRowToJsonObject(ADataSet: TDataset; AKeyFields: string)
  : TJSONObject;
var
  I: Integer;
  LRowChangeType: TRowSetChangeType;
  LFieldIsKey: Boolean;
  LFieldModified: Boolean;
begin
  CheckDataSet(ADataSet);
  Assert(ADataSet.State in [dsInsert, dsEdit],
    'O dataset não está em edição ou inserção.' + sLineBreak);
  Assert(not AKeyFields.Trim.IsEmpty, 'AKeyFields deve ser informado.' +
    sLineBreak);
  if ADataSet.State = dsInsert then
    LRowChangeType := rctInserted
  else
    LRowChangeType := rctModified;
  Result := TJSONObject.Create(TJSONPair.Create(CRowStateKey,
    TDataRowChangeTypeName[LRowChangeType]));
  for I := 0 to Pred(ADataSet.FieldCount) do
  begin
    LFieldIsKey := MatchKeyField(ADataSet.Fields[I].FullName, AKeyFields);
    LFieldModified := FieldIsModified(ADataSet.Fields[I]);
    if ADataSet.Fields[I].IsNull then
      if LFieldIsKey then
        raise Exception.CreateFmt
          ('O campo "%s" está definido como chave primária, ele não pode ser nulo.',
          [ADataSet.Fields[I].FullName]);
    if (not(TProviderFlag.pfInUpdate in ADataSet.Fields[I].ProviderFlags)) and
      (not(TProviderFlag.pfInWhere in ADataSet.Fields[I].ProviderFlags)) then
      continue;
    if (LFieldIsKey) or (LFieldModified) then
      DataRowToJsonObject(ADataSet.Fields[I], Result);
  end;
end;

function DeletedDataRowToJsonObject(ADataSet: TDataset; AKeyFields: string)
  : TJSONObject;
var
  I: Integer;
begin
  CheckDataSet(ADataSet);
  Assert(not AKeyFields.Trim.IsEmpty, 'AKeyFields deve ser informado.' +
    sLineBreak);
  Result := TJSONObject.Create(TJSONPair.Create(CRowStateKey,
    TDataRowChangeTypeName[rctDeleted]));
  for I := 0 to Pred(ADataSet.FieldCount) do
  begin
    if MatchKeyField(ADataSet.Fields[I].FullName, AKeyFields) then
      DataRowToJsonObject(ADataSet.Fields[I], Result);
  end;
end;

end.
