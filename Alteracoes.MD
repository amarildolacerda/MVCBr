
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
