unit ORMBr.model.GRUPOS;

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
  [Table('GRUPOS', '')]
  [PrimaryKey('CODIGO', NotInc, NoSort, False, 'Chave primária')]
  TGRUPOS = class
  private
    { Private declarations } 
    FCODIGO: String;
    FNOME: Nullable<String>;
  public 
    { Public declarations } 
    [Restrictions([NotNull])]
    [Column('CODIGO', ftString, 10)]
    [Dictionary('CODIGO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property CODIGO: String read FCODIGO write FCODIGO;

    [Column('NOME', ftString, 128)]
    [Dictionary('NOME', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property NOME: Nullable<String> read FNOME write FNOME;
  end;

implementation

initialization
  TRegisterClass.RegisterEntity(TGRUPOS)

end.
