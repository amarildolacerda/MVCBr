import { Component, OnInit } from '@angular/core';
import { ODataBrAdminService } from '../../services/odatabr-admin.service';

@Component({
  selector: 'app-users',
  templateUrl: './users.component.html',
  styleUrls: ['./users.component.css']
})
export class UsersComponent implements OnInit {
  
  token:string=''; 

  constructor(private admin:ODataBrAdminService) {
   }

  ngOnInit() {
  }

  public get_token_new(){
    
    this.admin.get_token_new().subscribe(
       r=> {
         this.token = r[0].token;
         return this.token;
       }
    );
    
  }


}
