unit uPerson.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uPersonContact;

type
  IPersonSQLBuilder = interface(IBaseSQLBuilder)
    ['{6CA1CE46-F560-4C59-8FD3-2B37EA68809B}']

    // Person
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function RegisteredFields(AColumName, AColumnValue: String; AId: Int64): String;

    // PersonContact
    function SelectPersonContactsByPersonId(APersonId: Int64): String;
    function DeletePersonContactsByPersonId(APersonId: Int64): String;
    function InsertPersonContact(APersonContact: TPersonContact): String;
  end;

implementation

end.


