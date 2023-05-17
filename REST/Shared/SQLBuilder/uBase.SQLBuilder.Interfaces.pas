unit uBase.SQLBuilder.Interfaces;

interface

uses
  uBase.Entity;

type
  IBaseSQLBuilder = interface
    ['{A1ED4673-7815-4273-82A6-7579CF30E55A}']

    function ScriptCreateTable: String;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
  end;

implementation

end.
