import { Component, OnInit } from '@angular/core';
import { ODataBrAdminService } from '../../services/odatabr-admin.service';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-users',
  templateUrl: './users.component.html',
  styleUrls: ['./users.component.css']
})
export class UsersComponent implements OnInit {

  token: string = '';
  userName: string = '';
  secret: string = '';
  group: string = '';

  formUsers: FormGroup;

  constructor(private admin: ODataBrAdminService, private fb: FormBuilder) {
  }

  ngOnInit() {
    this.formUsers = this.fb.group({
      userName: [null, Validators.compose(
        [Validators.required,
        Validators.minLength(5),
        Validators.maxLength(20)
        ])],
      group: [null, Validators.compose([Validators.required,
      Validators.minLength(3)])],
      secret: [null, Validators.required],
      
    })
  }

  public get_token_new() {

    this.admin.get_token_new().subscribe(
      r => {
        this.token = r[0].token;
        return this.token;
      }
    );

  }

  addUser(post) {
    this.admin.addUser(this.token, post.userName, post.secret, post.group)
      .subscribe(r => {
        console.log(r);
      })
  }
}
