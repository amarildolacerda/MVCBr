unit ORMBr.model.VENDAS_ITEM;

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
  [Table('VENDAS_ITEM', '')]
  [PrimaryKey('DATA', NotInc, NoSort, False, 'Chave primária')]
  [PrimaryKey('DOCUMENTO', NotInc, NoSort, False, 'Chave primária')]
  TVENDAS_ITEM = class
  private
    { Private declarations }
    FDATA: TDateTime;
    FDOCUMENTO: Integer;
    FPRODUTOS_CODIGO: Nullable<String>;
    FQTDE: Nullable<Currency>;
    FPRECO: Nullable<Currency>;
    FVALOR: Nullable<Currency>;
  public
    { Public declarations }
    [Restrictions([NotNull])]
    [Column('DATA', ftDateTime)]
    [Dictionary('DATA', 'Mensagem de validação', 'Date', '', '!##/##/####;1;_', taCenter)]
    property DATA: TDateTime read FDATA write FDATA;

    [Restrictions([NotNull])]
    [Column('DOCUMENTO', ftInteger)]
    [Dictionary('DOCUMENTO', 'Mensagem de validação', '', '', '', taCenter)]
    property DOCUMENTO: Integer read FDOCUMENTO write FDOCUMENTO;

    [Column('PRODUTOS_CODIGO', ftString, 30)]
    [Dictionary('PRODUTOS_CODIGO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property PRODUTOS_CODIGO: Nullable<String> read FPRODUTOS_CODIGO write FPRODUTOS_CODIGO;

    [Column('QTDE', ftCurrency,15,4)]
    [Dictionary('QTDE', 'Mensagem de validação', '0', '', '', taRightJustify)]
    property QTDE: Nullable<Currency> read FQTDE write FQTDE;

    [Column('PRECO', ftCurrency,15,4)]
    [Dictionary('PRECO', 'Mensagem de validação', '0', '', '', taRightJustify)]
    property PRECO: Nullable<Currency> read FPRECO write FPRECO;

    [Column('VALOR', ftCurrency,15,4)]
    [Dictionary('VALOR', 'Mensagem de validação', '0', '', '', taRightJustify)]
    property VALOR: Nullable<Currency> read FVALOR write FVALOR;
  end;

implementation

initialization
  TRegisterClass.RegisterEntity(TVENDAS_ITEM)

end.
