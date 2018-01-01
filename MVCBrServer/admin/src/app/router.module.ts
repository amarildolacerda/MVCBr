import { NgModule } from '@angular/core';
import {Routes, RouterModule} from "@angular/router";
import { AppComponent } from "./app.component";
import { SobreComponent } from "./views/sobre/sobre.component";
import { PrincipalComponent } from './views/principal/principal.component';



const routes: Routes = [
    { path: '', component: PrincipalComponent },
    { path: 'sobre', component: SobreComponent }
   ];

@NgModule({
    imports: [RouterModule.forRoot(routes)],
    exports: [RouterModule]
  })
  export class AppRoutingModule { }