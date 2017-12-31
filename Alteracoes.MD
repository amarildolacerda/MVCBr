30/12/2017 - AL - Alterações para o ODataBr
   + incluido geração automatica de view que se inciam com 'ODATA_' dispensando inclui-las no metadata; (testado firebird) - para consulta passou a devolver um "new" com novo servicemodel gerado na mesma pasta do server;
   + incluido no OData.ServiceModel.json a possibilidade de importar um json externo:
       .. ,import: [ 'x.json','y.json' ], ...
   + altera o rowstate para aceitar  'updateORinsert' -> quando o update não encontrar registro executar um insert;
   = a clausula   $filter é utilizada no POST,PATCH,PUT para formar a where que deseja usar para atualização;
   = no POST,PUT,PATCH... caso não seja indicado um $filter é utilizado a chave primaria.
   + alguns browser não estão aceitando enviar PATCH.. em substuição enviar como PUT, marcando o "rowstate";
   + melhoria na configuração de busca no banco para reduzir tempo de resposta, desligando alguns recursos do firedac;

19/10/2017 - AL
   * Lock/Unlock para VCL.PageView
   
15/10/2017 - AL
   * correção de access violation ao sair no TLayoutManager
   
14/10/2017 - AL
   * alteração na  MVCBr.BPL para forçar a gravação do pas quando criar, antes dependida do usuário mandar salvar e deixava gravar na pasta errada.
   
08/10/2017 - AL
   = Suporte ao DMVC RC8
   +- alteração BPL para retirar dependencias
   
27/09/2017 - AL
   + adicionado parametro  no MVCBr.MongoModel
   + adicionado mapeamente de objetos para carga interna do MVCBr.MongoModel
   
26/09/2017 - AL
   + adicionado (inicial) Model para mongo   MVCBr.MongoModel - Nao esta completo.
    
24/09/2017 - AL
   * correção FMX PageView - estava com access vilation ao sair.
   + adicionado opção de escolher a pasta de destino com os assistentes.
   
27/08/2017 - AL
   + criado a pasta Templates e adicionado templates para ela;
   + MVCBr.Patterns.Memento.pas

22/08/2017 - AL
   = renomeado MVCBr.Patterns.Factory para MVCBr.Factory (para se utilizando somente interno no MVCBr)
   + MVCBr.Patterns.Factory - para uso geral
   
21/08/2017 - AL
   + MVCBr.Patterns.Singleton
   
01/08/2017 - AL
   + MVCBr.FrameView - Herda TFrame para implementar IView
   + MVCBr.MiddlewareFactory - usado para interceptar a entrada e saida da VIEW
                               
19/07/2017 - AL
   * correação BUG AttachContoller no MVCBr.FormView   (_addref)

16/07/2017 - AL
   + adicionado Builder Expert ( and all)

14/07/2017 - AL
   + adicionado Lazy Builder
   + adicionado exemplo para UniGUI
   + alterado instalador para incluir PATH completos para os fontes.
   
06/07/2017 - AL
   + acrescentado dois nova assistentes     7-Facade Factory   8-Facade Sub-Class
   
03/07/2017 - AL
   + acrescentado  MVCBr.Patterns.Builder
   -+ Alterado MVCBr.Patters.Facade para herdar de Builder
   * alterado Lista de Controller para acertar memory leaks *ainda*
   * alterado observer com bugs de vazamento de memoria.
   + adicionado tests para Builder 
   
28/06/2017 - AL
   + MVCBr.Patterns.Adapter
   * memory leak no TMVCBrComponentFactory
   = alterado a lista de models para ser threadsafe
   = trocado a lista de controlles para threadsafe
   + MVCBr.Patterns.Facade
   + adicionado tests para Facade
26/06/2017 - AL
   + adicionado parametro  OwnedFree no AttachController do FormFactory, para controlar se
     o controller pode fazer um FREE no formulário (default=true, o controller nao pode fazer FREE na view )
26/06/2017 - AL
   + adicionado procedure release as interface para liberar referencia cruzada
   * corrigido memory leaks nas classes com referencia cruzada
   * corrigido servidor mermory leaks
   
16/06/2017 - AL
   + adicionado ISAPI para OData
   + adicionado pasta \bin  para os binários
   * alterado o path de configuração para compatibilidade com o ISAPI (para usar "Arquivos de programas\mvcbr")

15/06/2017 - AL
   + atualizado o DMVC para RC5 versao 3.0
   + ataulizado o LoggerPro
   * correção para subir com GetIt
   + adicionado o instalado na raiz
   
24/05/2017 - AL
   * correção de bug quando execute ResolveController para o MainForm
23/05/2017 - AL
   * convertido o extrator de metadata para MVCBr   
21/05/2017 - AL
   - retirado dependencia do IdHttp
   + substituido o TIdHTTP pelo  THTTPClient  (System.net);
   - retirado alguns metodos do FormFactory substituido por Eventos
   + adicionado eventos para os forms (Views)
   + adicionado eventos para o TModuleFactory
   
16/05/2017 - AL
   - retirado varios warnnings
   + adicionado suporte a Oracle no OData
   * alterado $top $skip para o PostgreSQL, como novo metodo para tratar final SELECT
   = renomeado update para updateview
   + iniciado TDbObjectListModel - suporte a configuração em BD
   = alterado class base para TObjectListModel Custom
   * atualizado a pasta DOCS (alterado de doc para docs)

05/05/2017 - AL
   + implementado ShowView com parametro BeforeOpen e OnClose Proc para controller e View;
   * correção do evento OnClose do FORM que faltava um inherited
   + adicionado exemplo na pasta VCL como pegar parametros digitados no segundo formulario usando o evento OnClose;

03/05/2017 - AL
   - retirado a interface do oData.JSON
   + acrescido as assinatura IJsonObject e movido para o System.Json.Helper
   + correção configuração  VendorLib para atender PostgreSQL (por: Elisângela)
      
   
29/04/2017 - AL
   - Incluido suporte a PostgreSQL (contribuição:  Elisângela)
   - Alterado o MVCBrServer.config para incluir  "VendorLib"  (atenção para a barra do caminho... precisa ser dobrada  \\\\  )
   - alterado o MVCBrServer, para ler as configurações de conexão direto do arquivo.. assim permite incluir novas propriedades sem precisar recompilar.
   - retirado alguns [unsafe] que estavam em conflito no WIN64
