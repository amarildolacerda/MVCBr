unit ORMBr.model.CLIENTES;

interface

uses
  DB,
  Classes,
  SysUtils,
  Generics.Collections,
  /// orm
  ORMBr.types.blob,
  ORMBr.types.lazy,
  ORMBr.types.mapping,
  ORMBr.types.nullable,
  ORMBr.mapping.Classes,
  ORMBr.mapping.register,
  ORMBr.mapping.attributes;

type

  [Entity]
  [Table('CLIENTES', '')]
  [PrimaryKey('CODIGO', NotInc, NoSort, false,
    'Código do Cliente é controle único')]
  TCLIENTES = class
  private
    { Private declarations }
    FCODIGO: nullable<Integer>;
    FNOME: nullable<String>;
    FENDERECO: nullable<String>;
    FCIDADE: nullable<String>;
    FESTADO: nullable<string>;
    Finativo: nullable<Integer>;
  public

    [Column('inativo', ftInteger)]
    [Dictionary('inativo', 'Indicar se o cliente é inativo', '', '',
      '', taLeftJustify)]
    property inativo: nullable<Integer> read Finativo write Finativo;

    { Public declarations }
    [Column('CODIGO', ftInteger)]
    [Dictionary('CODIGO', 'Mensagem de validação', '', '', '', taCenter)]
    property CODIGO: nullable<Integer> read FCODIGO write FCODIGO;

    [Column('NOME', ftString, 128)]
    [Dictionary('NOME', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property NOME: nullable<String> read FNOME write FNOME;

    [Column('ENDERECO', ftString, 128)]
    [Dictionary('ENDERECO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property ENDERECO: nullable<String> read FENDERECO write FENDERECO;

    [Column('CIDADE', ftString, 50)]
    [Dictionary('CIDADE', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property CIDADE: nullable<String> read FCIDADE write FCIDADE;

    [Column('ESTADO', ftString, 50)]
    [Dictionary('ESTADO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property ESTADO: nullable<String> read FESTADO write FESTADO;
  end;

implementation

initialization

TRegisterClass.RegisterEntity(TCLIENTES)

end.
