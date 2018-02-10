import { NgModule } from '@angular/core';
import { TreeModule } from 'angular-tree-component';
import { CommonModule } from '@angular/common';
//import { InternalServicesComponent } from './services/services.component';
import { InternalMetadataComponent } from './metadata/metadata.component';
import { InternalDescribeComponent } from './describe/describe.component';
import { ServicesModule } from '../services/services.module'
import { InternalRoutesModule } from './internal.router';
import { MaterialModule } from '../material/material.module';

@NgModule({
  imports: [
    CommonModule,
    ServicesModule,
    InternalRoutesModule,
    MaterialModule,
    TreeModule
  ],
  declarations: [ 
    InternalMetadataComponent,
    InternalDescribeComponent],
  exports:[
    InternalMetadataComponent,
    InternalDescribeComponent
  ]  
})
export class InternalModule { }
