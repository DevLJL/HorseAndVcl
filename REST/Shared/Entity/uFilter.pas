unit uFilter;

interface

uses
  uFilter.Types;

type
  IFilter = Interface
    ['{71C7A4F4-8601-48BD-9A88-3D0BD1F9F4B5}']
    function CurrentPage: Integer; overload;
    function CurrentPage(AValue: Integer): IFilter; overload;

    function LimitPerPage: Integer; overload;
    function LimitPerPage(AValue: Integer): IFilter; overload;

    function Columns: String; overload;
    function Columns(AValue: String): IFilter; overload;

    function OrderBy: String; overload;
    function OrderBy(AValue: String): IFilter; overload;

    function WherePkIn: String; overload;
    function WherePkIn(AValue: String): IFilter; overload;

    function Where(AParentheses: TParentheses; AFieldName: String; ACondition: TCondition; AValue: String = ''): IFilter;
    function &And(AParentheses: TParentheses; AFieldName: String; ACondition: TCondition; AValue: String = ''): IFilter;
    function &Or(AParentheses: TParentheses; AFieldName: String; ACondition: TCondition; AValue: String = ''): IFilter;
    function ClearExpression: IFilter;
    function GetExpression: String;
  End;

  TFilter = class(TInterfacedObject, IFilter)
  private
    FOrderBy: string;
    FLimitPerPage: integer;
    FColumns: string;
    FCurrentPage: integer;
    FExpression: String;
    FWherePkIn: String;
    function Condition(ACondition: TCondition; AValue: String = ''): IFilter;
  public
    function CurrentPage: Integer; overload;
    function CurrentPage(AValue: Integer): IFilter; overload;

    function LimitPerPage: Integer; overload;
    function LimitPerPage(AValue: Integer): IFilter; overload;

    function Columns: String; overload;
    function Columns(AValue: String): IFilter; overload;

    function OrderBy: String; overload;
    function OrderBy(AValue: String): IFilter; overload;

    function WherePkIn: String; overload;
    function WherePkIn(AValue: String): IFilter; overload;

    function Where(AParentheses: TParentheses; AFieldName: String; ACondition: TCondition; AValue: String = ''): IFilter;
    function &And(AParentheses: TParentheses; AFieldName: String; ACondition: TCondition; AValue: String = ''): IFilter;
    function &Or(AParentheses: TParentheses; AFieldName: String; ACondition: TCondition; AValue: String = ''): IFilter;
    function ClearExpression: IFilter;
    function GetExpression: String;
  end;

implementation

uses
  System.SysUtils;

{ TFilter }
function TFilter.Where(AParentheses: TParentheses; AFieldName: String; ACondition: TCondition; AValue: String): IFilter;
var
  lWhere: String;
begin
  Result := Self;

  lWhere := ' AND ';
  if (AParentheses in [TParentheses.Open, TParentheses.OpenAndClose]) then
    lWhere := lWhere + ' (';

  FExpression := FExpression + lWhere + AFieldName + ' ';
  Condition(ACondition, AValue);

  if (AParentheses in [TParentheses.Close, TParentheses.OpenAndClose]) then
    FExpression := FExpression + ') ';
end;

function TFilter.WherePkIn(AValue: String): IFilter;
begin
  Result := Self;
  FWherePkIn := AValue;
end;

function TFilter.WherePkIn: String;
begin
  Result := FWherePkIn;
end;

function TFilter.&And(AParentheses: TParentheses; AFieldName: String; ACondition: TCondition; AValue: String): IFilter;
var
  lAnd: String;
begin
  Result := Self;

  lAnd := ' AND ';
  if (AParentheses in [TParentheses.Open, TParentheses.OpenAndClose]) then
    lAnd := lAnd + ' (';

  FExpression := FExpression + lAnd + AFieldName + ' ';
  Condition(ACondition, AValue);

  if (AParentheses in [TParentheses.Close, TParentheses.OpenAndClose]) then
    FExpression := FExpression + ') ';
end;

function TFilter.&Or(AParentheses: TParentheses; AFieldName: String; ACondition: TCondition; AValue: String): IFilter;
var
  lOr: String;
begin
  Result := Self;

  lOr := ' OR ';
  if FExpression.Trim.IsEmpty then {Evitar erros}
    lOr := ' AND ';
  if (AParentheses in [TParentheses.Open, TParentheses.OpenAndClose]) then
    lOr := lOr + ' (';

  FExpression := FExpression + lOr + AFieldName + ' ';
  Condition(ACondition, AValue);

  if (AParentheses in [TParentheses.Close, TParentheses.OpenAndClose]) then
    FExpression := FExpression + ') ';
end;

function TFilter.OrderBy(AValue: String): IFilter;
begin
  Result := Self;
  FOrderBy := AValue;
end;

function TFilter.OrderBy: String;
begin
  Result := FOrderBy;
end;

function TFilter.ClearExpression: IFilter;
begin
  Result := Self;
  FExpression := EmptyStr;
end;

function TFilter.Columns(AValue: String): IFilter;
begin
  Result := Self;
  FColumns := AValue;
end;

function TFilter.Columns: String;
begin
  Result := FColumns;
end;

function TFilter.Condition(ACondition: TCondition; AValue: String): IFilter;
begin
  Result := Self;
  case ACondition of
    TCondition.Equal:          FExpression := FExpression + ' = '    + QuotedStr(AValue);
    TCondition.Greater:        FExpression := FExpression + ' > '    + QuotedStr(AValue);
    TCondition.Less:           FExpression := FExpression + ' < '    + QuotedStr(AValue);
    TCondition.GreaterOrEqual: FExpression := FExpression + ' >= '   + QuotedStr(AValue);
    TCondition.LessOrEqual:    FExpression := FExpression + ' <= '   + QuotedStr(AValue);
    TCondition.Different:      FExpression := FExpression + ' <> '   + QuotedStr(AValue);
    TCondition.LikeInitial:    FExpression := FExpression + ' like ' + QuotedStr(AValue+'%');
    TCondition.LikeFinal:      FExpression := FExpression + ' like ' + QuotedStr('%'+AValue);
    TCondition.LikeAnywhere:   FExpression := FExpression + ' like ' + QuotedStr('%'+AValue+'%');
    TCondition.Like:           FExpression := FExpression + ' like ' + QuotedStr(AValue);
    TCondition.IsNull:         FExpression := FExpression + ' is null ';
    TCondition.IsNotNull:      FExpression := FExpression + ' is not null ';
  end;

  FExpression := FExpression + ' ';
end;

function TFilter.CurrentPage(AValue: Integer): IFilter;
begin
  Result := Self;
  FCurrentPage := AValue;
end;

function TFilter.GetExpression: String;
begin
  Result := FExpression;
end;

function TFilter.CurrentPage: Integer;
begin
  Result := FCurrentPage;
end;

function TFilter.LimitPerPage(AValue: Integer): IFilter;
begin
  Result := Self;
  FLimitPerPage := AValue;
end;

function TFilter.LimitPerPage: Integer;
begin
  Result := FLimitPerPage;
end;

end.
