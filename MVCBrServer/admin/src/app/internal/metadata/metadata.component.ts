import { Component, OnInit } from '@angular/core';
import { ODataBrAdminService } from '../../services/odatabr-admin.service';
import { MatTableDataSource } from '@angular/material';

@Component({
  selector: 'app-internal-metadata',
  templateUrl: './metadata.component.html',
  styleUrls: ['./metadata.component.css']
})
export class InternalMetadataComponent implements OnInit {
  nodes = [ ];
  context:string="";
  comment:string="";
  supports:any={
    '$filter':'yes',
    '$format':'yes',
    '$inlinecount':'yes',
    '$orderby':'yes',
    '$select':'yes',
    '$skip':'yes',
    '$top':'yes',
    '$groupby':'yes',
  }

  displayedColumns = ['resource', 'method', 'keyID', 'fields'];
  dataSource = new MatTableDataSource ([{resource:""}]);


  constructor(private rest: ODataBrAdminService) {

  }

  getLink(resource){
    return this.rest.gerResourceLink(resource)+'&$top=10';
 }


  ngOnInit() {
    this.rest.init(x => {
      this.rest.odata_metadata().subscribe(
        rsp => {
          for (let it in rsp) {
            switch (it) {
              case 'OData.Services': {
                this.dataSource =  new MatTableDataSource ( rsp[it] );
                break;
              }
              case '__comment':{
                this.comment = rsp[it];
              }
            }

          }
          //this.nodes = rsp;
          console.log(rsp);
          console.log(this.nodes);
        }
      )
    }
  )
  }
  getItem(item){
    return JSON.stringify(item);
  } 
}
