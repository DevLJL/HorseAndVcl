unit uPaymentTerm.Input.DTO;

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
  TPaymentTermInputDTO = class(TBaseDTO)
  private
    Finterval_between_installments: SmallInt;
    Fnumber_of_installments: SmallInt;
    Ffirst_in: SmallInt;
    Fdescription: string;
  public
    [SwagString(255)]
    [SwagProp('description', 'Descrição', false)]
    property description: string read Fdescription write Fdescription;

    [SwagNumber]
    [SwagProp('number_of_installments', 'Quantidade de Parcelas', false)]
    property number_of_installments: SmallInt read Fnumber_of_installments write Fnumber_of_installments;

    [SwagNumber]
    [SwagProp('interval_between_installments', 'Intervalo entre as Parcelas', false)]
    property interval_between_installments: SmallInt read Finterval_between_installments write Finterval_between_installments;

    [SwagNumber]
    [SwagProp('first_in', 'Primeira parcela em: ? (Dias)', false)]
    property first_in: SmallInt read Ffirst_in write Ffirst_in;

  end;

implementation

end.


