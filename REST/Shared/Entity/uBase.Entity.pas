unit uBase.Entity;

interface

uses
  uValidation.Interfaces;

type
  TBaseEntity = class abstract(TInterfacedObject, IValidation)
  public
    function Validate: String; virtual; abstract;
  end;

implementation

end.
