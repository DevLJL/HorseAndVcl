unit uPerson.Repository.SQL;

interface

uses
  uBase.Repository,
  uPerson.Repository.Interfaces,
  uPerson.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uPerson,
  uPersonContact;

type
  TPersonRepositorySQL = class(TBaseRepository, IPersonRepository)
  private
    FPersonSQLBuilder: IPersonSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IPersonSQLBuilder);
    function DataSetToEntity(ADtsPerson: TDataSet): TBaseEntity; override;
    function DataSetToPersonContact(ADtsPersonContact: TDataSet): TPersonContact;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
    function FieldExists(AColumName, AColumnValue: String; AId: Int64): Boolean;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IPersonSQLBuilder): IPersonRepository;
    function Show(AId: Int64): TPerson;
    function Update(AId: Int64; AEntity: TBaseEntity): Int64; override;
    function Store(AEntity: TBaseEntity): Int64; override;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils,
  uZLQry.Interfaces,
  Vcl.Forms,
  uTrans,
  uApplication.Exception;

{ TPersonRepositorySQL }

class function TPersonRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IPersonSQLBuilder): IPersonRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TPersonRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IPersonSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FPersonSQLBuilder  := ASQLBuilder;
  FManageTransaction := True;
end;

function TPersonRepositorySQL.DataSetToEntity(ADtsPerson: TDataSet): TBaseEntity;
begin
  const LPerson = TPerson.FromJSON(ADtsPerson.ToJSONObjectString);

  // Tratar especificidades
  LPerson.city.id                  := ADtsPerson.FieldByName('city_id').AsLargeInt;
  LPerson.city.name                := ADtsPerson.FieldByName('city_name').AsString;
  LPerson.city.state               := ADtsPerson.FieldByName('city_state').AsString;
  LPerson.city.country             := ADtsPerson.FieldByName('city_country').AsString;
  LPerson.city.ibge_code           := ADtsPerson.FieldByName('city_ibge_code').AsString;
  LPerson.city.country_ibge_code   := ADtsPerson.FieldByName('city_country_ibge_code').AsString;
  LPerson.created_by_acl_user.id   := ADtsPerson.FieldByName('created_by_acl_user_id').AsLargeInt;
  LPerson.created_by_acl_user.name := ADtsPerson.FieldByName('created_by_acl_user_name').AsString;
  LPerson.updated_by_acl_user.id   := ADtsPerson.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LPerson.updated_by_acl_user.name := ADtsPerson.FieldByName('updated_by_acl_user_name').AsString;

  Result := LPerson;
end;

function TPersonRepositorySQL.DataSetToPersonContact(ADtsPersonContact: TDataSet): TPersonContact;
begin
  Result := TPersonContact.FromJSON(ADtsPersonContact.ToJSONObjectString);
end;

function TPersonRepositorySQL.FieldExists(AColumName, AColumnValue: String; AId: Int64): Boolean;
begin
  Result := not FConn.MakeQry.Open(
    FPersonSQLBuilder.RegisteredFields(AColumName, AColumnValue, AId)
  ).DataSet.IsEmpty;
end;

function TPersonRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FPersonSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TPersonRepositorySQL.Show(AId: Int64): TPerson;
begin
  Result := nil;
  const LQry = FConn.MakeQry;

  // Person
  const LPerson = inherited ShowById(AId) as TPerson;
  if not assigned(LPerson) then
    Exit;

  // PersonContact
  LQry.Open(FPersonSQLBuilder.SelectPersonContactsByPersonId(AId));
  LQry.First;
  while not LQry.Eof do
  begin
    LPerson.person_contacts.Add(DataSetToPersonContact(LQry.DataSet));
    LQry.Next;
  end;

  Result := LPerson;
end;

function TPersonRepositorySQL.Store(AEntity: TBaseEntity): Int64;
var
  LStoredId: Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // Person
    LStoredId := inherited Store(AEntity);
    const LPerson = AEntity as TPerson;

    // PersonContacts
    for var LPersonContact in LPerson.person_contacts do
    begin
      LPersonContact.person_id := LStoredId;
      LQry.ExecSQL(FPersonSQLBuilder.InsertPersonContact(LPersonContact))
    end;

    if FManageTransaction then
      FConn.CommitTransaction;
  except on E: Exception do
    Begin
      if FManageTransaction then
        FConn.RollBackTransaction;
      raise;
    End;
  end;

  Result := LStoredId;
end;

function TPersonRepositorySQL.Update(AId: Int64; AEntity: TBaseEntity): Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // Person
    inherited Update(AId, AEntity);
    const LPerson = AEntity as TPerson;

    // PersonContacts
    LQry.ExecSQL(FPersonSQLBuilder.DeletePersonContactsByPersonId(AId));
    for var LPersonContact in LPerson.person_contacts do
    begin
      LPersonContact.person_id := AId;
      LQry.ExecSQL(FPersonSQLBuilder.InsertPersonContact(LPersonContact))
    end;

    if FManageTransaction then
      FConn.CommitTransaction;
  except on E: Exception do
    Begin
      if FManageTransaction then
        FConn.RollBackTransaction;
      raise;
    End;
  end;

  Result := AId;
end;

procedure TPersonRepositorySQL.Validate(AEntity: TBaseEntity);
begin
  var LErrors := EmptyStr;
  const LPerson = (AEntity as TPerson);

  // CPF/CNPJ deve ser um campo único
  if not LPerson.legal_entity_number.Trim.IsEmpty then
  begin
    if FieldExists('person.legal_entity_number', LPerson.legal_entity_number, LPerson.id) then
      lErrors := lErrors + Trans.FieldWithValueIsInUse('CPF/CNPJ', LPerson.legal_entity_number) + #13;
  end;

  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);
end;

end.



