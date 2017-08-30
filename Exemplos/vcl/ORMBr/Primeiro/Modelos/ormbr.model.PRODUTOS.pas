unit ormbr.model.produtos;

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
  [Table('PRODUTOS', '')]
  [PrimaryKey('CODIGO', NotInc, NoSort, False, 'Chave primária')]
  TPRODUTOS = class
  private
    { Private declarations } 
    FCODIGO: String;
    FDESCRICAO: Nullable<String>;
    FGRUPO: Nullable<String>;
    FUNIDADE: Nullable<String>;
  public 
    { Public declarations } 
    [Restrictions([NotNull])]
    [Column('CODIGO', ftString, 30)]
    [Dictionary('CODIGO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property CODIGO: String read FCODIGO write FCODIGO;

    [Column('DESCRICAO', ftString, 128)]
    [Dictionary('DESCRICAO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property DESCRICAO: Nullable<String> read FDESCRICAO write FDESCRICAO;

    [Column('GRUPO', ftString, 10)]
    [Dictionary('GRUPO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property GRUPO: Nullable<String> read FGRUPO write FGRUPO;

    [Column('UNIDADE', ftString, 5)]
    [Dictionary('UNIDADE', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property UNIDADE: Nullable<String> read FUNIDADE write FUNIDADE;

  end;

implementation

initialization
  TRegisterClass.RegisterEntity(TPRODUTOS)

end.
