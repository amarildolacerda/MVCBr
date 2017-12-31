import { TestBed, inject } from '@angular/core/testing';

import { OdatabrAdminService } from './odatabr-admin.service';

describe('OdatabrAdminService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [OdatabrAdminService]
    });
  });

  it('should be created', inject([OdatabrAdminService], (service: OdatabrAdminService) => {
    expect(service).toBeTruthy();
  }));
});
