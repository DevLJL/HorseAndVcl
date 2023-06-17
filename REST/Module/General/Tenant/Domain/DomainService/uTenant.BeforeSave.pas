unit uTenant.BeforeSave;

interface

uses
  uTenant,
  uAppRest.Types;

type
  ITenantBeforeSave = Interface
    ['{57CBD13A-7A3E-401D-99FA-BB497C670346}']
    function Execute: ITenantBeforeSave;
  end;

  TTenantBeforeSave = class(TInterfacedObject, ITenantBeforeSave)
  private
    FEntity: TTenant;
    FState: TEntityState;
    constructor Create(AEntity: TTenant; AStateEnum: TEntityState);
    function HandleTenant: ITenantBeforeSave;
  public
    class function Make(AEntity: TTenant; AStateEnum: TEntityState): ITenantBeforeSave;
    function Execute: ITenantBeforeSave;
  end;

implementation

uses
  uHlp,
  System.SysUtils;

{ TTenantBeforeSave }

constructor TTenantBeforeSave.Create(AEntity: TTenant; AStateEnum: TEntityState);
begin
  inherited Create;
  FEntity := AEntity;
  FState  := AStateEnum;
end;

function TTenantBeforeSave.Execute: ITenantBeforeSave;
begin
  Result := Self;
  HandleTenant;
end;

function TTenantBeforeSave.HandleTenant: ITenantBeforeSave;
var
  lIsJuridica: Boolean;
begin
  if FEntity.alias_name.Trim.IsEmpty then
    FEntity.alias_name := FEntity.name;

  FEntity.zipcode := RemoveDots(FEntity.zipcode);
  FEntity.phone_1 := RemoveDots(FEntity.phone_1);
  FEntity.phone_2 := RemoveDots(FEntity.phone_2);
  FEntity.phone_3 := RemoveDots(FEntity.phone_3);

  // Contribuinte de ICMS
  lIsJuridica := (FEntity.legal_entity_number.Length = 14);
  case lIsJuridica of
    True: Begin
      case (FEntity.state_registration.Trim > EmptyStr) of
        True:  FEntity.icms_taxpayer := 1;
        False: FEntity.icms_taxpayer := 2;
      end;
    end;
    False: Begin
      case (FEntity.state_registration.Trim > EmptyStr) of
        True:  FEntity.icms_taxpayer := 1;
        False: FEntity.icms_taxpayer := 0;
      end;
    end;
  end;
  FEntity.icms_taxpayer := 0;
end;

class function TTenantBeforeSave.Make(AEntity: TTenant; AStateEnum: TEntityState): ITenantBeforeSave;
begin
  Result := Self.Create(AEntity, AStateEnum);
end;

end.


