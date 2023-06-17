unit uBase.SQLBuilder.Interfaces;

interface

uses
  uBase.Entity;

type
  IBaseSQLBuilder = interface
    ['{5E58A4CA-2060-4DF0-A7C0-C43E0DE4CF0A}']

    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
  end;

implementation

end.
