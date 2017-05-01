Unit Main.ViewModel;

interface

{ .$I ..\inc\mvcbr.inc }
uses MVCBr.Interf, MVCBr.ViewModel, Main.ViewModel.Interf;

Type
  TMainViewModel = class(TViewModelFactory, IMainViewModel,
    IViewModelAs<IMainViewModel>)
  public
    function ViewModelAs: IMainViewModel;
    class function new(): IMainViewModel; overload;
    class function new(const AController: IController): IMainViewModel;
      overload;
  end;

implementation

function TMainViewModel.ViewModelAs: IMainViewModel;
begin
  result := self;
end;

class function TMainViewModel.new(): IMainViewModel;
begin
  result := new(nil);
end;

class function TMainViewModel.new(const AController: IController)
  : IMainViewModel;
begin
  result := TMainViewModel.create;
  result.controller(AController);
end;

end.
