unit uFilter.Types;

interface

{$SCOPEDENUMS ON}
type
  TParentheses = (None, Open, Close, OpenAndClose);

  // Condition
  TCondition = (None, Equal, Greater, Less, GreaterOrEqual, LessOrEqual, Different, LikeInitial, LikeFinal, LikeAnywhere, Like, IsNull, IsNotNull);
  TConditionHelper = record Helper for TCondition
    function ToString : string;
    class function FromString(const AOper: string): TCondition; static;
  end;

implementation

uses
  System.SysUtils,
  System.TypInfo;

{ TConditionHelper }
class function TConditionHelper.FromString(const AOper: string): TCondition;
begin
  Result := TCondition(GetEnumValue(TypeInfo(TCondition), AOper));
end;

function TConditionHelper.ToString: string;
begin
  Result := GetEnumName(TypeInfo(TCondition), Integer(Self)).Trim;
end;

end.
