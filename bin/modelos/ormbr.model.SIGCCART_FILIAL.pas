unit ormbr.model.sigccart_filial;

interface

uses
  Classes, 
  SysUtils, 
  Generics.Collections, 
  DB, 
  /// orm 
  ormbr.mapping.attributes, 
  ormbr.types.mapping, 
  ormbr.types.nullable, 
  ormbr.mapping.register, 
  ormbr.mapping.classes; 

type
  [Entity]
  [Table('SIGCCART_FILIAL', '')]
  [PrimaryKey('CODIGO', NotInc, NoSort, False, 'Chave primária')]
  [PrimaryKey('FILIAL', NotInc, NoSort, False, 'Chave primária')]
  TSIGCCART_FILIAL = class
  private
    { Private declarations } 
    FTAXACREDITOPARCELADA: Nullable<Currency>;
    FTAXAADMIN: Nullable<Currency>;
    FPRAZO: Nullable<Currency>;
    FCODIGO: Nullable<Currency>;
    FFILIAL: Nullable<Currency>;
  public 
    { Public declarations } 
    [Column('TAXACREDITOPARCELADA',ftCurrency)]
    [Dictionary('TAXACREDITOPARCELADA', 'Mensagem de validação', '0', '', '', taRightJustify)]
    property TAXACREDITOPARCELADA: Nullable<Currency> Index 0 read FTAXACREDITOPARCELADA write FTAXACREDITOPARCELADA;

    [Column('TAXAADMIN',ftCurrency)]
    [Dictionary('TAXAADMIN', 'Mensagem de validação', '0', '', '', taRightJustify)]
    property TAXAADMIN: Nullable<Currency> Index 1 read FTAXAADMIN write FTAXAADMIN;

    [Column('PRAZO',ftCurrency)]
    [Dictionary('PRAZO', 'Mensagem de validação', '0', '', '', taRightJustify)]
    property PRAZO: Nullable<Currency> Index 2 read FPRAZO write FPRAZO;

    [Column('CODIGO',ftCurrency)]
    [Dictionary('CODIGO', 'Mensagem de validação', '0', '', '', taRightJustify)]
    property CODIGO: Nullable<Currency> Index 3 read FCODIGO write FCODIGO;

    [Column('FILIAL',ftCurrency)]
    [Dictionary('FILIAL', 'Mensagem de validação', '0', '', '', taRightJustify)]
    property FILIAL: Nullable<Currency> Index 4 read FFILIAL write FFILIAL;
  end;

implementation

initialization
 TRegisterClass.RegisterEntity(TSIGCCART_FILIAL)

end.
