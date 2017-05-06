{$define en-us}
{.$define pt-br}

{$ifdef en-us}
 {$I .\translate\en-us.inc}
{$else}
 {$I .\translate\pt-br.inc}
{$endif}