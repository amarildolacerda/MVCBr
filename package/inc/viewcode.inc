ViewHead = '/// <summary>                                                     '
  + #10#13 +
  '///    Uma View representa a camada de apresentação ao usuário    ' + #10#13
  + '///    deve esta associado a um controller onde ocorrerá          ' +
  #10#13 + '///    a troca de informações e comunicação com os Models         '
  + #10#13 +
  '/// </summary>                                                    ' + #10#13
  + 'unit %UnitIdent;                                ' + #10#13 +
  '                                                          ' + #10#13 +
  'interface                                                 ' + #10#13 +
  'uses                                                      ' + #10#13 +
  '{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}           ' + #10#13 +
  '  System.SysUtils, System.Classes,MVCBr.Interf,           ' + #10#13 +
  '  MVCBr.View,MVCBr.FormView, %MdlInterf ,MVCBr.Controller; ' + #10#13 +
  '                                                     ' + #10#13;
ViewDef = '                                   '#10#13 +
  'type                                                 ' + #10#13 +
  '/// Interface para a VIEW                                         ' + #10#13
  + '  I%FormIdent = interface(IView)                      ' + #10#13 +
  '    [''%guid'']                                           ' + #10#13 +
  '    // incluir especializacoes aqui                       ' + #10#13 +
  '  end;                                                    ' + #10#13 +
  '                                                          ' + #10#13 +
  '/// Object Factory que implementa a interface da VIEW             ' + #10#13
  + '  T%FormIdent = class(TFormFactory {T%AncestorIdent} ,IView,IThisAs<T%FormIdent>,'
  + #10#13 + '                      I%FormIdent,IViewAs<I%FormIdent>)' + #10#13
  + '                                                          ' + #10#13 +
  '  private                                                 ' + #10#13 +
  '    FViewModel : I%FormIdentModel;                    ' + #10#13 +
  '  protected                                               ' + #10#13 +
  '    function Controller(const aController: IController): IView;override;' +
  #10#13 + '  public                                                    ' +
  #10#13 + '   { Public declarations }                                ' + #10#13
  + '    class function New(AController:IController):IView;    ' + #10#13 +
  '    function ViewModel(const AViewModel:I%FormIdentModel):IView;' + #10#13 +
  '    function This: TObject;override;                  ' + #10#13 +
  '    function ThisAs:T%FormIdent;                      ' + #10#13 +
  '    function ViewAs:I%FormIdent;                      ' + #10#13 +
  '    function ShowView(const AProc: TProc<IView>): integer;override;' + #10#13
  + '    function Update: IView;override;                      ' + #10#13 +
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
  '  result := inherited Controller(AController);              ' + #10#13 +
  '  if not assigned(FViewModel) then                          ' + #10#13 +
  '    FViewModel := getViewModel as I%FormIdentModel;         ' + #10#13 +
  'end;                                                        ' + #10#13 +
  '                                                          ' + #10#13 +
  'function T%FormIdent.ViewModel(const AViewModel:I%FormIdentModel):IView;' +
  #10#13 + 'begin                                                     ' + #10#13
  + '   result := self;                                        ' + #10#13 +
  '  if assigned(AViewModel) then                          ' + #10#13 +
  '   FViewModel := AViewModel;                          ' + #10#13 +
  'end;                                                      ' + #10#13 +
  '                                                          ' + #10#13 +
  'function T%FormIdent.This:TObject;                        ' + #10#13 +
  'begin                                                     ' + #10#13 +
  '   result := inherited This;                         ' + #10#13 +
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
  '      supports(vm.This,I%FormIdentModel,FViewModel);      ' + #10#13 +
  '  end;                                              ' + #10#13 +
  '  inherited;                                              ' + #10#13 +
  'end;                                                      ' + #10#13 +
  '                                                          ' + #10#13;

ViewCode = ViewHead + ViewDef +
  '                                                          ' + #10#13 +
  'implementation                                            ' + #10#13 +
  '                                                          ' + #10#13 +
  '{$R *.DFM}                                                ' + #10#13 +
  '                                                          ' + #10#13 +
  ViewImpl +
  'end.                                                      ' + #10#13;

ViewCodeFMX = ViewHead + ViewDef +
  '                                                          ' + #10#13 +
  'implementation                                            ' + #10#13 +
  '                                                          ' + #10#13 +
  '{$R *.FMX}                                                ' + #10#13 +
  '                                                          ' + #10#13 +
  ViewImpl +
  'end.                                                      ' + #10#13;

ViewCode2 = ViewHead + ViewDef +
  '                                                          ' + #10#13 +
  'implementation                                            ' + #10#13 +
  '                                                          ' + #10#13 +
  ViewImpl +
  'end.                                                      ' + #10#13;

// ---------------------------------------------------------------//
ViewCodeNoViewModel =
  '/// <summary>                                                     ' + #10#13
  + '///    Uma View representa a camada de apresentação ao usuário    ' +
  #10#13 + '///    deve esta associado a um controller onde ocorrerá          '
  + #10#13 +
  '///    a troca de informações e comunicação com os Models         ' + #10#13
  + '/// </summary>                                                    ' +
  #10#13 + 'unit %ModelIdent;                                ' + #10#13 +
  '                                                          ' + #10#13 +
  'interface                                                 ' + #10#13 +
  'uses                                                      ' + #10#13 +
  '{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}           ' + #10#13 +
  '  System.SysUtils, System.Classes,MVCBr.Interf,           ' + #10#13 +
  '  MVCBr.View,MVCBr.FormView,MVCBr.Controller; ' + #10#13 +
  '                                                     ' + #10#13 +
  '                                   '#10#13 +
  'type                                                 ' + #10#13 +
  '/// Interface para a VIEW                                      ' + #10#13 +
  '  I%FormIdent = interface(IView)                      ' + #10#13 +
  '    [''%guid'']                                           ' + #10#13 +
  '    // incluir especializacoes aqui                       ' + #10#13 +
  '  end;                                                    ' + #10#13 +
  '                                                          ' + #10#13 +
  '/// Object Factory que implementa a interface da VIEW             ' + #10#13
  + '  T%FormIdent = class(TFormFactory {T%AncestorIdent} ,IView,IThisAs<T%FormIdent>,'
  + #10#13 + '  I%FormIdent,IViewAs<I%FormIdent>)' + #10#13 +
  '  private                                                 ' + #10#13 +
  '  protected                                               ' + #10#13 +
  '    function Controller(const aController: IController): IView;override;' +
  #10#13 + '  public                                         ' + #10#13 +
  '   { Public declarations }                                ' + #10#13 +
  '    class function New(AController:IController):IView;    ' + #10#13 +
  '    function This: TObject;override;                  ' + #10#13 +
  '    function ThisAs:T%FormIdent;                      ' + #10#13 +
  '    function ViewAs:I%FormIdent;                      ' + #10#13 +
  '    function ShowView(const AProc: TProc<IView>): integer;override;' + #10#13
  + '    function Update: IView;override;                      ' + #10#13 +
  '  end;                                                    ' + #10#13 +
  '                                                          ' + #10#13 +
  'Implementation ' + #10#13 +
  '{$R *.DFM}                                                ' + #10#13 +
  '                                                          ' + #10#13 +
  'function T%FormIdent.Update:IView;             ' + #10#13 +
  'begin                                                     ' + #10#13 +
  '  result := self;                                         ' + #10#13 +
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
  '  result := inherited Controller(AController);              ' + #10#13 +
  'end;                                                        ' + #10#13 +
  '                                                          ' + #10#13 +
  'function T%FormIdent.This:TObject;                        ' + #10#13 +
  'begin                                                     ' + #10#13 +
  '   result := inherited This;                         ' + #10#13 +
  'end;                                                      ' + #10#13 +
  '                                                          ' + #10#13 +
  'function T%FormIdent.ThisAs:T%FormIdent;                  ' + #10#13 +
  'begin                                                     ' + #10#13 +
  '   result := self;                                        ' + #10#13 +
  'end;                                                      ' + #10#13 +
  '                                                          ' + #10#13 +
  'function T%FormIdent.ShowView(const AProc:TProc<IView>):integer;' + #10#13 +
  'begin                                               ' + #10#13 +
  '  inherited;                                              ' + #10#13 +
  'end;                                                      ' + #10#13 +
  'end.                                                      ' + #10#13;
