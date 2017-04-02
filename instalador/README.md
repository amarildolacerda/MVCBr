

Após instalar o serviço:
1. configurar firebird3 para apontar para o banco de dados-
   editar o arquivo databases.conf e adicionar:
          MVCBr = c:\pasta\mvcbr.fdb
2. nesta fase o usuario padão é o mesmo padrão que vem no FIREBIRD (aquele de sempre);


Problema conhecidos:
1. o instalador não iniciliza o serviço automático, precisa fazer manual;
2. não consegue instalar se o serviço já existir.

3. não tem uma janela para configurar o banco de dados.... pode usar o alias   MVCBr no databases.conf para apontar para outro BD;
