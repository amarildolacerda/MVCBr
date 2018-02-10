import { Routes, RouterModule } from '@angular/router';
import { InternalMetadataComponent } from './metadata/metadata.component';
//import { InternalServicesComponent } from './services/services.component';
import { InternalDescribeComponent } from './describe/describe.component';

const internalRoutes: Routes = [
  { path: "internal.metadata", component: InternalMetadataComponent },
 // { path: "internal.services", component: InternalServicesComponent },
  { path: "internal.describe", component: InternalDescribeComponent }

];

export const InternalRoutesModule = RouterModule.forChild(internalRoutes);
