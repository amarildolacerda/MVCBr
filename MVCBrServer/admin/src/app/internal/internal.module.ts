import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { InternalServicesComponent } from './services/services.component';
import { InternalMetadataComponent } from './metadata/metadata.component';
import { InternalDescribeComponent } from './describe/describe.component';
//import { ODataBrAdminService } from '../services/odatabr-admin.service';
import { ServicesModule } from '../services/services.module'

@NgModule({
  imports: [
    CommonModule,
    ServicesModule
  ],
  declarations: [InternalServicesComponent, InternalMetadataComponent, InternalDescribeComponent]
})
export class InternalModule { }
