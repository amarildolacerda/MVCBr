import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ODataProviderService,ODataFactory }  from './odata-provider.service';
import { GlobalsService } from './globals.service';

@NgModule({
  imports: [
    CommonModule
  ],
  declarations: [],
  providers:[
    ODataProviderService,
    GlobalsService
  ],
  exports:[
    GlobalsService,
    ODataProviderService,ODataFactory
  ]
})
export class ServicesModule { }
