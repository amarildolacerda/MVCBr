unit ORMBr.model.VENDAS;

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
  [Table('VENDAS', '')]
  [PrimaryKey('DATA', NotInc, NoSort, False, 'Chave primária')]
  [PrimaryKey('DOCUMENTO', NotInc, NoSort, False, 'Chave primária')]
  TVENDAS = class
  private
    { Private declarations } 
    FDATA: TDateTime;
    FDOCUMENTO: Integer;
    FCLIENTE: Nullable<Integer>;
    FTOTAL: Nullable<Currency>;
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

    [Column('CLIENTE', ftInteger)]
    [Dictionary('CLIENTE', 'Mensagem de validação', '', '', '', taCenter)]
    property CLIENTE: Nullable<Integer> read FCLIENTE write FCLIENTE;

    [Column('TOTAL', ftCurrency)]
    [Dictionary('TOTAL', 'Mensagem de validação', '0', '', '', taRightJustify)]
    property TOTAL: Nullable<Currency> read FTOTAL write FTOTAL;
  end;

implementation

initialization
  TRegisterClass.RegisterEntity(TVENDAS)

end.
