unit uNcm.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  INcmSQLBuilder = interface(IBaseSQLBuilder)
    ['{AAD879E3-63D2-4A50-998E-7F062B6104A8}']

    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function RegisteredFields(AColumName, AColumnValue: String; AId: Int64): String;
  end;

implementation

end.

