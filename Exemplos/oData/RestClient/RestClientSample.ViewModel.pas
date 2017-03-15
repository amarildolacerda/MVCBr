{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 10/03/2017 19:20:22                                  // }
{ //************************************************************// }
Unit RestClientSample.ViewModel;

interface

{ .$I ..\inc\mvcbr.inc }
uses Data.DB, MVCBr.Interf, MVCBr.ViewModel, firedac.comp.client, Data.FireDACJsonReflect,  RestClientSample.ViewModel.Interf;

Type
  /// Object Factory para o ViewModel
  TRestClientSampleViewModel = class(TViewModelFactory,
    IRestClientSampleViewModel, IViewModelAs<IRestClientSampleViewModel>)
  private
    function GetDeltas(Banco, Tabela: String;
      MemTable: TFDMemTable): TFDJSONDeltas;
  public
    function ViewModelAs: IRestClientSampleViewModel;
    class function new(): IRestClientSampleViewModel; overload;
    class function new(const AController: IController)
      : IRestClientSampleViewModel; overload;
    procedure AfterInit; override;
  end;

implementation

function TRestClientSampleViewModel.ViewModelAs: IRestClientSampleViewModel;
begin
  result := self;
end;

class function TRestClientSampleViewModel.new(): IRestClientSampleViewModel;
begin
  result := new(nil);
end;

/// <summary>
/// New cria uma nova instância para o ViewModel
/// </summary>
/// <param name="AController">
/// AController é o controller ao qual o ViewModel esta
/// ligado
/// </param>
class function TRestClientSampleViewModel.new(const AController: IController)
  : IRestClientSampleViewModel;
begin
  result := TRestClientSampleViewModel.create;
  result.controller(AController);
end;

procedure TRestClientSampleViewModel.AfterInit;
begin
  // evento disparado apos a definicao do Controller;
end;


function TRestClientSampleViewModel.GetDeltas(Banco, Tabela : String; MemTable : TFDMemTable) : TFDJSONDeltas;
begin
  if MemTable.State in [dsInsert, dsEdit] then
    MemTable.Post;
  result := TFDJSONDeltas.Create;
  TFDJSONDeltasWriter.ListAdd(result, MemTable);
end;

end.
