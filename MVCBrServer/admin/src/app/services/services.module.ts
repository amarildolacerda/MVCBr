///
/// modulos de serviços
/// amarildo lacerda - tireideletra.com.br
///
import { NgModule,APP_INITIALIZER } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule, HttpClientJsonpModule } from '@angular/common/http';
import {SessionService,StorageService } from './storage.service';
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
    SessionService,StorageService
    
  ],
  exports:[
  ]
})
export class ServicesModule { }
