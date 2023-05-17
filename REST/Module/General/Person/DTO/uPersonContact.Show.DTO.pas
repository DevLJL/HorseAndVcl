unit uPersonContact.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  XSuperObject,
  uAppRest.Types,
  {$ENDIF}
  uSmartPointer,
  System.Generics.Collections,
  uPersonContact.Input.DTO;

type
  TPersonContactShowDTO = class(TPersonContactInputDTO)
  private
    Fperson_id: Int64;
    Fid: Int64;
  public
    [SwagNumber]
    [SwagProp('id', 'ID', true)]
    property id: Int64 read Fid write Fid;

    [SwagNumber]
    [SwagProp('person_id', 'Pessoa (ID)', true)]
    property person_id: Int64 read Fperson_id write Fperson_id;
  end;

implementation

end.


