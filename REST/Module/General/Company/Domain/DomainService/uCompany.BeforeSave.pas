unit uCompany.BeforeSave;

interface

uses
  uCompany,
  uAppRest.Types;

type
  ICompanyBeforeSave = Interface
    ['{FA3A45C9-3DF0-4841-B86B-0AC161C9F579}']
    function Execute: ICompanyBeforeSave;
  end;

  TCompanyBeforeSave = class(TInterfacedObject, ICompanyBeforeSave)
  private
    FEntity: TCompany;
    FState: TEntityState;
    constructor Create(AEntity: TCompany; AStateEnum: TEntityState);
    function HandleCompany: ICompanyBeforeSave;
  public
    class function Make(AEntity: TCompany; AStateEnum: TEntityState): ICompanyBeforeSave;
    function Execute: ICompanyBeforeSave;
  end;

implementation

uses
  uHlp,
  System.SysUtils;

{ TCompanyBeforeSave }

constructor TCompanyBeforeSave.Create(AEntity: TCompany; AStateEnum: TEntityState);
begin
  inherited Create;
  FEntity := AEntity;
  FState  := AStateEnum;
end;

function TCompanyBeforeSave.Execute: ICompanyBeforeSave;
begin
  Result := Self;
  HandleCompany;
end;

function TCompanyBeforeSave.HandleCompany: ICompanyBeforeSave;
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

class function TCompanyBeforeSave.Make(AEntity: TCompany; AStateEnum: TEntityState): ICompanyBeforeSave;
begin
  Result := Self.Create(AEntity, AStateEnum);
end;

end.


