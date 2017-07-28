unit ormbr.model.cnae;

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
  [Table('CNAE', '')]
  [PrimaryKey('ID', NotInc, NoSort, False, 'Chave primária')]
  TCNAE = class
  private
    { Private declarations } 
    FID: Nullable<Currency>;
    FSECAO: Nullable<String>;
    FDENOMINACAO_SECAO: Nullable<String>;
    FDIVISAO: Nullable<String>;
    FDENOMINACAO_DIVISAO: Nullable<String>;
    FGRUPO: Nullable<String>;
    FDENOMINACAO_GRUPO: Nullable<String>;
    FCLASSE: Nullable<String>;
    FDENOMINACAO_CLASSE: Nullable<String>;
    FSUBCLASSE: Nullable<String>;
    FDENOMINACAO_SUBCLASSE: Nullable<String>;
  public 
    { Public declarations } 
    [Column('ID',ftCurrency)]
    [Dictionary('ID', 'Mensagem de validação', '0', '', '', taRightJustify)]
    property ID: Nullable<Currency> Index 0 read FID write FID;

    [Column('SECAO', ftString, 15)]
    [Dictionary('SECAO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property SECAO: Nullable<String> Index 1 read FSECAO write FSECAO;

    [Column('DENOMINACAO_SECAO', ftString, 200)]
    [Dictionary('DENOMINACAO_SECAO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property DENOMINACAO_SECAO: Nullable<String> Index 2 read FDENOMINACAO_SECAO write FDENOMINACAO_SECAO;

    [Column('DIVISAO', ftString, 15)]
    [Dictionary('DIVISAO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property DIVISAO: Nullable<String> Index 3 read FDIVISAO write FDIVISAO;

    [Column('DENOMINACAO_DIVISAO', ftString, 200)]
    [Dictionary('DENOMINACAO_DIVISAO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property DENOMINACAO_DIVISAO: Nullable<String> Index 4 read FDENOMINACAO_DIVISAO write FDENOMINACAO_DIVISAO;

    [Column('GRUPO', ftString, 15)]
    [Dictionary('GRUPO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property GRUPO: Nullable<String> Index 5 read FGRUPO write FGRUPO;

    [Column('DENOMINACAO_GRUPO', ftString, 200)]
    [Dictionary('DENOMINACAO_GRUPO', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property DENOMINACAO_GRUPO: Nullable<String> Index 6 read FDENOMINACAO_GRUPO write FDENOMINACAO_GRUPO;

    [Column('CLASSE', ftString, 15)]
    [Dictionary('CLASSE', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property CLASSE: Nullable<String> Index 7 read FCLASSE write FCLASSE;

    [Column('DENOMINACAO_CLASSE', ftString, 200)]
    [Dictionary('DENOMINACAO_CLASSE', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property DENOMINACAO_CLASSE: Nullable<String> Index 8 read FDENOMINACAO_CLASSE write FDENOMINACAO_CLASSE;

    [Column('SUBCLASSE', ftString, 15)]
    [Dictionary('SUBCLASSE', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property SUBCLASSE: Nullable<String> Index 9 read FSUBCLASSE write FSUBCLASSE;

    [Column('DENOMINACAO_SUBCLASSE', ftString, 200)]
    [Dictionary('DENOMINACAO_SUBCLASSE', 'Mensagem de validação', '', '', '', taLeftJustify)]
    property DENOMINACAO_SUBCLASSE: Nullable<String> Index 10 read FDENOMINACAO_SUBCLASSE write FDENOMINACAO_SUBCLASSE;
  end;

implementation

initialization
 TRegisterClass.RegisterEntity(TCNAE)

end.
