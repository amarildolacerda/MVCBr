import { NgModule } from '@angular/core';
import {Routes, RouterModule} from "@angular/router";
import { AppComponent } from "./app.component";
import { SobreComponent } from "./views/sobre/sobre.component";
import { PrincipalComponent } from './views/principal/principal.component';
import { InternalServicesComponent } from './internal/services/services.component';
import { InternalMetadataComponent } from './internal/metadata/metadata.component';
import { InternalDescribeComponent } from './internal/describe/describe.component';



const routes: Routes = [
    { path: '', component: PrincipalComponent },
    { path: 'sobre', component: SobreComponent },
    { path: 'internal.services', component: InternalServicesComponent},
    { path: 'internal.metadata', component: InternalMetadataComponent},
    { path: 'internal.describe', component: InternalDescribeComponent}

   ];

@NgModule({
    imports: [RouterModule.forRoot(routes)],
    exports: [RouterModule]
  })
  export class AppRoutingModule { }