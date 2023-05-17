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
    ['{75F11084-E074-42AC-82EA-D011545133C6}']
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
