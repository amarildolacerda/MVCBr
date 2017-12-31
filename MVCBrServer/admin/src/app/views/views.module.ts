import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UsersComponent } from './users/users.component';
import { MenuModule } from '../menu/menu.module';
import { ServicesModule } from '../services/services.module';
//import {ODataBrAdminService } from '../services/odatabr-admin.service';

@NgModule({
  imports: [
    CommonModule,
    MenuModule,
    ServicesModule,
    //ODataBrAdminService
  ],
  declarations: [
    //ODataBrAdminService,
    UsersComponent],
  exports: [
    //ODataBrAdminService,
    UsersComponent]
})
export class ViewsModule { }
