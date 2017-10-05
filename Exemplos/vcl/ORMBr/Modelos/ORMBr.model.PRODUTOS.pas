unit ORMBr.model.PRODUTOS;

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
  [PrimaryKey('CODIGO')]
  TPRODUTOS = class
  private
    { Private declarations } 
    FCODIGO: Nullable<String>;
    FDESCRICAO: Nullable<String>;
    FGRUPO: Nullable<String>;
    FUNIDADE: Nullable<String>;
    FPRECO: Nullable<Double>;
  public 
    { Public declarations } 
    [Column('CODIGO', ftString, 30)]
    [Dictionary('CODIGO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property CODIGO: Nullable<String> read FCODIGO write FCODIGO;

    [Column('DESCRICAO', ftString, 128)]
    [Dictionary('DESCRICAO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property DESCRICAO: Nullable<String> read FDESCRICAO write FDESCRICAO;

    [Column('GRUPO', ftString, 10)]
    [Dictionary('GRUPO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property GRUPO: Nullable<String> read FGRUPO write FGRUPO;

    [Column('UNIDADE', ftString, 5)]
    [Dictionary('UNIDADE', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property UNIDADE: Nullable<String> read FUNIDADE write FUNIDADE;

    [Column('PRECO', ftFloat,15,4)]
    [Dictionary('PRECO', 'Mensagem de validação', '0', '0.00', '0.00', taRightJustify)]
    property PRECO: Nullable<double> read FPRECO write FPRECO;
  end;

implementation

initialization
  TRegisterClass.RegisterEntity(TPRODUTOS)

end.
