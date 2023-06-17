unit uNcm.Persistence.UseCase.Interfaces;

interface

uses
  uNcm.Filter.DTO,
  uIndexResult,
  uNcm.Show.DTO,
  uNcm.Input.DTO,
  uFilter,
  uEither;

type
  INcmPersistenceUseCase = Interface
    ['{C1014330-050B-4534-90D7-5FAC03B8ECA9}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TNcmFilterDTO): IIndexResult; overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TNcmShowDTO;
    function StoreAndShow(AInput: TNcmInputDTO): Either<String, TNcmShowDTO>;
    function Store(AInput: TNcmInputDTO): Int64;
    function Update(APK: Int64; AInput: TNcmInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TNcmInputDTO): Either<String, TNcmShowDTO>;
  end;


implementation

end.
