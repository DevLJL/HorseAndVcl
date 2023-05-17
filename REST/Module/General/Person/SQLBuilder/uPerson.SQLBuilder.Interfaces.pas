unit uPerson.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uPersonContact;

type
  IPersonSQLBuilder = interface(IBaseSQLBuilder)
    ['{9CABC513-B48F-4F05-B7E6-E29D3D983878}']

    // Person
    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function RegisteredFields(AColumName, AColumnValue: String; AId: Int64): String;

    // PersonContact
    function ScriptCreatePersonContactTable: String;
    function SelectPersonContactsByPersonId(APersonId: Int64): String;
    function DeletePersonContactsByPersonId(APersonId: Int64): String;
    function InsertPersonContact(APersonContact: TPersonContact): String;
  end;

implementation

end.


