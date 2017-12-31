import { TestBed, inject } from '@angular/core/testing';

import { OdataProviderService } from './odata-provider.service';

describe('OdataProviderService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [OdataProviderService]
    });
  });

  it('should be created', inject([OdataProviderService], (service: OdataProviderService) => {
    expect(service).toBeTruthy();
  }));
});
