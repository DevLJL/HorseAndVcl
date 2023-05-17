unit uQueueEmail.Persistence.UseCase.Interfaces;

interface

uses
  uQueueEmail.Filter.DTO,
  uIndexResult,
  uQueueEmail.Show.DTO,
  uQueueEmail.Input.DTO,
  uFilter,
  uEither;

type
  IQueueEmailPersistenceUseCase = Interface
    ['{05187FB2-4FF7-4D56-BF9F-D3DD8B3AF6AF}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TQueueEmailFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TQueueEmailShowDTO;
    function StoreAndShow(AInput: TQueueEmailInputDTO): Either<String, TQueueEmailShowDTO>;
    function Store(AInput: TQueueEmailInputDTO): Int64;
    function Update(APK: Int64; AInput: TQueueEmailInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TQueueEmailInputDTO): Either<String, TQueueEmailShowDTO>;
  end;

implementation

end.
