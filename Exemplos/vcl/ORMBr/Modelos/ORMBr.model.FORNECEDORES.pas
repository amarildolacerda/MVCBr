unit ORMBr.model.FORNECEDORES;

interface

uses
  DB, 
  Classes, 
  SysUtils, 
  Generics.Collections, 
  /// orm 
  ormbr.types.blob, 
  ormbr.types.lazy, 
  ormbr.types.mapping, 
  ormbr.types.nullable, 
  ormbr.mapping.classes, 
  ormbr.mapping.register, 
  ormbr.mapping.attributes; 

type
  [Entity]
  [Table('FORNECEDORES', '')]
  TFORNECEDORES = class
  private
    { Private declarations } 
    FCODIGO: Nullable<Integer>;
    FNOME: Nullable<String>;
  public 
    { Public declarations } 
    [Column('CODIGO', ftInteger)]
    [Dictionary('CODIGO', 'Mensagem de validação', '', '', '', taCenter)]
    property CODIGO: Nullable<Integer> read FCODIGO write FCODIGO;

    [Column('NOME', ftString, 128)]
    [Dictionary('NOME', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property NOME: Nullable<String> read FNOME write FNOME;
  end;

implementation

initialization
  TRegisterClass.RegisterEntity(TFORNECEDORES)

end.
