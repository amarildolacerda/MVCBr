///
/// acesso ao serviço de admin
/// amarildo lacerda - tireideletra.com.br
///

import { Injectable } from '@angular/core';
import { ODataProviderService } from './odata-provider.service';
import { GlobalsService } from './globals.service';
import { Observable } from 'rxjs/Observable';


@Injectable()
export class ODataBrAdminService {
  observable:ODataProviderService;

constructor(private rest:ODataProviderService, private globals:GlobalsService) {

  globals.subscribe(r=>{
    rest.createUrlBase(globals.server.url,globals.server.port ); 
  });

   }
 public subscribe(proc:any){
   this.observable.subscribe(r=>{ proc(r); });
 }  
 public get_token_new():ODataBrAdminService{
   this.observable =  this.rest.getOData('/OData/admin/token/new') ;
   return this;   
  } 
}
