unit uGlobalConfig.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter;

type
  IGlobalConfigSQLBuilder = interface(IBaseSQLBuilder)
    ['{C9E66F63-E133-4243-9ECC-38D038B41D2B}']

    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.

