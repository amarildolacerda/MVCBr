import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UsersComponent } from './users/users.component';
import { MenuModule } from '../menu/menu.module'

@NgModule({
  imports: [
    CommonModule,
    MenuModule
  ],
  declarations: [UsersComponent],
  exports: [UsersComponent]
})
export class ViewsModule { }
