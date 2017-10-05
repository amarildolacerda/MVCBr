unit ormbr.model.clientes;

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
  [Table('CLIENTES', '')]
  [PrimaryKey('CODIGO', NotInc, NoSort, False, 'Chave primária')]
  TCLIENTES = class
  private
    { Private declarations } 
    FINATIVO: Nullable<Integer>;
    FCODIGO: Integer;
    FNOME: Nullable<String>;
    FENDERECO: Nullable<String>;
    FCIDADE: Nullable<String>;
    FESTADO: Nullable<String>;
  public 
    { Public declarations } 
    [Column('INATIVO', ftInteger)]
    [Dictionary('INATIVO', 'Mensagem de validação', '', '', '', taCenter)]
    property INATIVO: Nullable<Integer> read FINATIVO write FINATIVO;

    [Restrictions([NotNull])]
    [Column('CODIGO', ftInteger)]
    [Dictionary('CODIGO', 'Mensagem de validação', '', '', '', taCenter)]
    property CODIGO: Integer read FCODIGO write FCODIGO;

    [Column('NOME', ftString, 128)]
    [Dictionary('NOME', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property NOME: Nullable<String> read FNOME write FNOME;

    [Column('ENDERECO', ftString, 128)]
    [Dictionary('ENDERECO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property ENDERECO: Nullable<String> read FENDERECO write FENDERECO;

    [Column('CIDADE', ftString, 50)]
    [Dictionary('CIDADE', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property CIDADE: Nullable<String> read FCIDADE write FCIDADE;

    [Column('ESTADO', ftString, 50)]
    [Dictionary('ESTADO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property ESTADO: Nullable<String> read FESTADO write FESTADO;
  end;

implementation

initialization
  TRegisterClass.RegisterEntity(TCLIENTES)

end.
