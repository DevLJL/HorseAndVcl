unit uPerson.BeforeSave;

interface

uses
  uPerson,
  uAppRest.Types;

type
  IPersonBeforeSave = Interface
    ['{1B262FC5-418D-4CC4-A3CD-9CD7C63F64D9}']
    function Execute: IPersonBeforeSave;
  end;

  TPersonBeforeSave = class(TInterfacedObject, IPersonBeforeSave)
  private
    FEntity: TPerson;
    FState: TEntityState;
    constructor Create(AEntity: TPerson; AStateEnum: TEntityState);
    function HandlePerson: IPersonBeforeSave;
  public
    class function Make(AEntity: TPerson; AStateEnum: TEntityState): IPersonBeforeSave;
    function Execute: IPersonBeforeSave;
  end;

implementation

uses
  uHlp,
  System.SysUtils,
  uPerson.Types;

{ TPersonBeforeSave }

constructor TPersonBeforeSave.Create(AEntity: TPerson; AStateEnum: TEntityState);
begin
  inherited Create;
  FEntity := AEntity;
  FState  := AStateEnum;
end;

function TPersonBeforeSave.Execute: IPersonBeforeSave;
begin
  Result := Self;
  HandlePerson;
end;

function TPersonBeforeSave.HandlePerson: IPersonBeforeSave;
begin
  if FEntity.alias_name.Trim.IsEmpty then
    FEntity.alias_name := FEntity.name;

  FEntity.legal_entity_number := OnlyNumbers(FEntity.legal_entity_number);
  FEntity.zipcode             := OnlyNumbers(FEntity.zipcode);
  FEntity.phone_1             := OnlyNumbers(FEntity.phone_1);
  FEntity.phone_2             := OnlyNumbers(FEntity.phone_2);
  FEntity.phone_3             := OnlyNumbers(FEntity.phone_3);

  // Apenas na inclusão, verificar se é Pessoa Jurídica e definir Contribuinte de ICMS
  if (FState = TEntityState.Store) and (FEntity.legal_entity_number.Length = 14) then
  begin
    case (FEntity.state_registration.Trim > EmptyStr) of
      True:  FEntity.icms_taxpayer := TPersonIcmsTaxPayer.Yes;
      False: FEntity.icms_taxpayer := TPersonIcmsTaxPayer.Free;
    end;
  end;
end;

class function TPersonBeforeSave.Make(AEntity: TPerson; AStateEnum: TEntityState): IPersonBeforeSave;
begin
  Result := Self.Create(AEntity, AStateEnum);
end;

end.


