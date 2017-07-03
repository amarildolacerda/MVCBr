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
