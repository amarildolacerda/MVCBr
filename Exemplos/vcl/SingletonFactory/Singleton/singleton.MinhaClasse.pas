unit singleton.MinhaClasse;

interface

uses MVCBr.Patterns.singleton;

type

  /// minha classe alvo
  TMinhaClasseAlvo = class(TObject)
  public
    function mudarFlag(AValue: Boolean): Integer;
  end;


  /// criando uma classe factory filha
  TMinhaClasseFactory = class(TMVCBrSingleton<TMinhaClasseAlvo>)
  end;

var
  MinhaClasseFactory: IMVCBrSingleton<TMinhaClasseAlvo>;

implementation

{ TMinhaClasseAlvo }

function TMinhaClasseAlvo.mudarFlag(AValue: Boolean): Integer;
begin
  result := ord(AValue);
end;

initialization

MinhaClasseFactory := TMinhaClasseFactory.new() ;




end.
