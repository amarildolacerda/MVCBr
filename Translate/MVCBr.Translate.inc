{$define pt_br}
{.$define en_us}

{$ifdef pt_br}
  {$I translate/pt_br.inc}
{$else}
  {$ifdef en_us}
    {$I en_us.inc}
  {$endif}
{$endif}