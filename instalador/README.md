

Após instalar o serviço:
1. configurar firebird3 para apontar para o banco de dados-
   editar o arquivo databases.conf e adicionar:
          MVCBr = c:\pasta\mvcbr.fdb
2. nesta fase o usuario padão é o mesmo padrão que vem no FIREBIRD (aquele de sempre);
3. a configuração de porta do servidor e também de banco de dados, vai em  MVCBrServer.config 


Problemas conhecidos:
1. o instalador não inicializa o serviço automático, precisa fazer manual;
2. não consegue instalar se o serviço já existir.
3. a implementação funciona com driver FB; Há uma implementação iniciada para MySQL - ainda sem testes - precisando de voluntários.

