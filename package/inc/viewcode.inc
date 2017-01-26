ViewHead = 'unit %ModelIdent;                                ' + #10#13 +
  '                                                          ' + #10#13 +
  '// Código gerado pelo assistente     MVCBr OTA            ' + #10#13 +
  '// www.tireideletra.com.br                                ' + #10#13 +
  '                                                          ' + #10#13 +
  'interface                                                 ' + #10#13 +
  'uses                                                      ' + #10#13 +
  '  Windows, Messages, SysUtils,  Classes,Graphics,         ' + #10#13 +
  '  Controls,StdCtrls,ComCtrls,ExtCtrls,Forms,MVCBr.Interf, ' + #10#13 +
  '  MVCBr.Controller;                                       ' + #10#13 +
  '                                                          ' + #10#13;
ViewDef = 'type                                              ' + #10#13 +
  '  I%FormIdent = interface(IView)                      ' + #10#13 +
  '    [''%guid'']                                           ' + #10#13 +
  '    // incluir especializacoes aqui                       ' + #10#13 +
  '  end;                                                    ' + #10#13 +
  '                                                          ' + #10#13 +
  '  T%FormIdent = class(T%AncestorIdent,IView,IThisAs<T%FormIdent>,' + #10#13 +
  '                      I%FormIdent,IViewAs<I%FormIdent>)' + #10#13 +
  '                                                          ' + #10#13 +
  '  private                                                 ' + #10#13 +
  '    FViewModel : IViewModel;                              ' + #10#13 +
  '    FController : IController;                            ' + #10#13 +
  '  protected                                               ' + #10#13 +
  '    function Controller(const aController: IController): IView;' + #10#13 +
  '  public                                                    ' + #10#13 +
  '   { Public declarations }                                ' + #10#13 +
  '    class function New(AController:IController):IView;    ' + #10#13 +
  '    function ViewModel(const AViewModel:IViewModel):IView;' + #10#13 +
  '    function This: TObject;                               ' + #10#13 +
  '    function ThisAs:T%FormIdent;                          ' + #10#13 +
  '    function ViewAs:I%FormIdent;                      ' + #10#13 +
  '    function ShowView(const AProc: TProc<IView>): integer;' + #10#13 +
  '    function Update: IView;                               ' + #10#13 +
  '  end;                                                    ' + #10#13 +
  '                                                          ' + #10#13;

ViewImpl = 'function T%FormIdent.Update:IView;             ' + #10#13 +
  'begin                                                     ' + #10#13 +
  '  result := self;                                         ' + #10#13 +
  '  if assigned(FViewModel) then FViewModel.update(self as IView);' + #10#13 +
  '  {codigo para atualizar a View vai aqui...}              ' + #10#13 +
  'end;                                                      ' + #10#13 +
  '                                                          ' + #10#13 +
  'function T%FormIdent.ViewAs:I%FormIdent;              ' + #10#13 +
  'begin                                                     ' + #10#13 +
  '  result := self;                                         ' + #10#13 +
  'end;                                                      ' + #10#13 +
  '                                                          ' + #10#13 +
  'class function T%FormIdent.new(AController:IController):IView;    ' + #10#13
  + 'begin                                                     ' + #10#13 +
  '   result := T%FormIdent.create(nil);                     ' + #10#13 +
  '   result.controller(AController);                        ' + #10#13 +
  'end;                                                      ' + #10#13 +
  '                                                          ' + #10#13 +
  'function T%FormIdent.Controller(const AController:IController):IView; ' +
  #10#13 + 'begin                                              ' + #10#13 +
  '  result := self;                                         ' + #10#13 +
  '  FController := AController;                             ' + #10#13 +
  'end;                                                      ' + #10#13 +
  '                                                          ' + #10#13 +
  'function T%FormIdent.ViewModel(const AViewModel:IViewModel):IView;' + #10#13
  + 'begin                                                     ' + #10#13 +
  '   result := self;                                        ' + #10#13 +
  '  if assigned(AViewModel) then                          ' + #10#13 +
  '   FViewModel := AViewModel;                          ' + #10#13 +
  'end;                                                      ' + #10#13 +
  '                                                          ' + #10#13 +
  'function T%FormIdent.This:TObject;                        ' + #10#13 +
  'begin                                                     ' + #10#13 +
  '   result := self;                                        ' + #10#13 +
  'end;                                                      ' + #10#13 +
  '                                                          ' + #10#13 +
  'function T%FormIdent.ThisAs:T%FormIdent;                  ' + #10#13 +
  'begin                                                     ' + #10#13 +
  '   result := self;                                        ' + #10#13 +
  'end;                                                      ' + #10#13 +
  '                                                          ' + #10#13 +
  'function T%FormIdent.ShowView(const AProc:TProc<IView>):integer;' + #10#13 +
  'var                                                 ' + #10#13 +
  '  vm: IModel;                                       ' + #10#13 +
  'begin                                               ' + #10#13 +
  '  if assigned(FController) then                     ' + #10#13 +
  '  begin                                             ' + #10#13 +
  '    vm := FController.GetModelByType(mtViewModel);  ' + #10#13 +
  '    if assigned(vm) then                            ' + #10#13 +
  '      supports(vm.This,IViewModel,FViewModel);      ' + #10#13 +
  '  end;                                              ' + #10#13 +
  '  ShowModal;                                              ' + #10#13 +
  '  result := ord(ModalResult);                             ' + #10#13 +
  '  if assigned(AProc) then AProc(self);                    ' + #10#13 +
  'end;                                                      ' + #10#13 +
  '                                                          ' + #10#13;

ViewCode = ViewHead + ViewDef +
  '                                                          ' + #10#13 +
  'implementation                                            ' + #10#13 +
  '                                                          ' + #10#13 +
  '{$R *.dfm}                                                ' + #10#13 +
  '                                                          ' + #10#13 +
  ViewImpl +
  'end.                                                      ' + #10#13;

ViewCodeFMX = ViewHead + ViewDef +
  '                                                          ' + #10#13 +
  'implementation                                            ' + #10#13 +
  '                                                          ' + #10#13 +
  '{$R *.fmx}                                                ' + #10#13 +
  '                                                          ' + #10#13 +
  ViewImpl +
  'end.                                                      ' + #10#13;


ViewCode2 = ViewHead + ViewDef +
  '                                                          ' + #10#13 +
  'implementation                                            ' + #10#13 +
  '                                                          ' + #10#13 +
  ViewImpl +
  'end.                                                      ' + #10#13;
