///
/// modulos de serviços
/// amarildo lacerda - tireideletra.com.br
///
import { NgModule,APP_INITIALIZER } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule, HttpClientJsonpModule } from '@angular/common/http';

import { ODataProviderService }  from './odata-provider.service';
import { ODataBrAdminService} from './odatabr-admin.service';

@NgModule({
  imports: [
    CommonModule,
    HttpClientModule, HttpClientJsonpModule
  ],
  declarations: [],
  providers:[
    ODataProviderService,
    ODataBrAdminService,
    
  ],
  exports:[
  ]
})
export class ServicesModule { }
