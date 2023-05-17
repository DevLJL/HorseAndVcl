unit uQueueEmailContact.Input.DTO;

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
  System.Generics.Collections,
  uQueueEmail.Types;

type
  TQueueEmailContactInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Femail: string;
    Ftype: TQueueEmailContactType;
  public
    [SwagString(255)]
    [SwagProp('email', 'E-mail', true)]
    property email: string read Femail write Femail;

    [SwagString(255)]
    [SwagProp('name', 'Nome do Contato', true)]
    property name: String read Fname write Fname;

    [SwagNumber(0,3)]
    [SwagProp('type', 'Tipo [0..3] 0-Recipients, 1-ReceiptRecipients, 2-CarbonCopies, 3-BlindCarbonCopies]', true)]
    property &type: TQueueEmailContactType read Ftype write Ftype;
  end;

implementation

end.


