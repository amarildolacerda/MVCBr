import { Injectable } from '@angular/core';
import { ODataProviderService } from './odata-provider.service';
import { GlobalsService } from './globals.service';

@Injectable()
export class ODataBrAdminService {

  constructor(private rest:ODataProviderService, private globals:GlobalsService) {

    rest.createUrlBase('',0); 

   }
   
  get_token_new():ODataProviderService{
   return this.rest.getValue({"resource":'/OData/admin/token/new'});
  } 

}
