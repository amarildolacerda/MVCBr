unit MVCBr.Patterns.Prototype;

{
  Auth: Base: https://delphihaven.wordpress.com/2011/06/09/object-cloning-using-rtti/
}

interface

uses System.Classes;

Type

  IMVCBrPrototype = interface
    ['{C381557F-C320-487C-8BBF-0F29EADB1E80}']
  end;

  TMVCBrPrototype = Class(TInterfacedObject, IMVCBrPrototype)
  public
    class procedure Copy<T: Class>(ASource: T; ATarget: T); static;
    class function Clone<T: Class>(ASource: T): T; static;
    class function New<T: Class>: T; static;
  end;

implementation

uses System.TypInfo, System.SysUtils, System.RTTI {, System.RTTI.Helper,
    System.Classes.Helper};

class procedure TMVCBrPrototype.Copy<T>(ASource, ATarget: T);
var
  Context: TRttiContext;
  IsComponent, LookOutForNameProp: Boolean;
  RttiType: TRttiType;
  Method: TRttiMethod;
  MinVisibility: TMemberVisibility;
  Params: TArray<TRttiParameter>;
  Prop: TRttiProperty;
  Fld: TRttiField;
  SourceAsPointer, ResultAsPointer: Pointer;
begin
  RttiType := Context.GetType(ASource.ClassType);
  // find a suitable constructor, though treat components specially
  IsComponent := (ASource is TComponent);
  try
    // loop through the props, copying values across for ones that are read/write
    Move(ASource, SourceAsPointer, SizeOf(Pointer));
    Move(ATarget, ResultAsPointer, SizeOf(Pointer));

    if ASource is TComponent then
    begin
      Fld := RttiType.GetField('Parent');
      if assigned(Fld) then
      begin
        Fld.SetValue(ResultAsPointer, Fld.GetValue(SourceAsPointer));
      end
      else
        IsComponent := false;
    end;

    LookOutForNameProp := IsComponent and (TComponent(ASource).Owner <> nil);
    if IsComponent then
      MinVisibility := mvPublished
      // an alternative is to build an exception list
    else
      MinVisibility := mvPublic;

    for Fld in RttiType.GetFields do
    begin
      if Fld.Visibility >= MinVisibility then
        Fld.SetValue(ResultAsPointer, Fld.GetValue(SourceAsPointer));
    end;

    for Prop in RttiType.GetProperties do
      if (Prop.Visibility >= MinVisibility) and Prop.IsReadable and Prop.IsWritable
      then
        if LookOutForNameProp and (Prop.Name = 'Name') and
          (Prop.PropertyType is TRttiStringType) then
          LookOutForNameProp := false
        else
          Prop.SetValue(ResultAsPointer, Prop.GetValue(SourceAsPointer));
  except
    raise;
  end;
end;

// MVCBr.Interf;
class function TMVCBrPrototype.New<T>: T;
var
  Context: TRttiContext;
  Method: TRttiMethod;
  AType: TRttiType;
begin
  AType := Context.GetType(TClass(T));
  for Method in AType.GetMethods do
    if Method.IsConstructor then
    begin
      if Length(Method.GetParameters) = 0 then
      begin
        result := Method.invoke(TClass(T), []).AsType<T>
      end;
    end;
end;

class function TMVCBrPrototype.Clone<T>(ASource: T): T;
var
  Context: TRttiContext;
  IsComponent, LookOutForNameProp: Boolean;
  RttiType: TRttiType;
  Method: TRttiMethod;
  MinVisibility: TMemberVisibility;
  Params: TArray<TRttiParameter>;
  Prop: TRttiProperty;
  SourceAsPointer, ResultAsPointer: Pointer;
begin
  RttiType := Context.GetType(ASource.ClassType);
  // find a suitable constructor, though treat components specially
  IsComponent := (ASource is TComponent);
  for Method in RttiType.GetMethods do
    if Method.IsConstructor then
    begin
      Params := Method.GetParameters;
      if Params = nil then
        Break;
      if (Length(Params) = 1) and IsComponent and
        (Params[0].ParamType is TRttiInstanceType) and
        SameText(Method.Name, 'Create') then
        Break;
    end;
  if Params = nil then
    result := Method.invoke(ASource.ClassType, []).AsType<T>
  else
    result := Method.invoke(ASource.ClassType, [TComponent(ASource).Owner])
      .AsType<T>;
  TMVCBrPrototype.Copy(ASource, result);

end;

end.
