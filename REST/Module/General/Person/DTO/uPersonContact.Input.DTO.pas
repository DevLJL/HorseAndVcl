unit uPersonContact.Input.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  uBase.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections;

type
  TPersonContactInputDTO = class(TBaseDTO)
  private
    Fname: string;
    Femail: string;
    Fphone: string;
    Fnote: string;
    Flegal_entity_number: String;
    Ftype: string;
  public
    [SwagString(100)]
    [SwagProp('name', 'Nome do Contato', false)]
    property name: string read Fname write Fname;

    [SwagString(20)]
    [SwagProp('legal_entity_number', 'CPF/CNPJ', false)]
    property legal_entity_number: String read Flegal_entity_number write Flegal_entity_number;

    [SwagString(100)]
    [SwagProp('type', 'Tipo de Contato', false)]
    property &type: string read Ftype write Ftype;

    [SwagString]
    [SwagProp('note', 'Observação', false)]
    property note: string read Fnote write Fnote;

    [SwagString(14)]
    [SwagProp('phone', 'Telefone', false)]
    property phone: string read Fphone write Fphone;

    [SwagString(255)]
    [SwagProp('email', 'E-mail', false)]
    property email: string read Femail write Femail;
  end;

implementation

end.


