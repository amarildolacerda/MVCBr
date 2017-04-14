$expand param -> gerar detail para um master
     http://localhost:8080/OData/OData.svc/nfe(1)?$expand=nfeitem,nfecliente,nferodape,nfeimpostos
     retorno:
     <pre>
     {
            value: [ numero:1, data="2017-04-14",....,
                     nfeitem: [
                              ],
                     nfecliente: [
                              ],
                     nferodape: [
                          ],
                     nfeimpostos: [
                     
                     
                     ]
                     
                   ]
           } 
  </pre>
