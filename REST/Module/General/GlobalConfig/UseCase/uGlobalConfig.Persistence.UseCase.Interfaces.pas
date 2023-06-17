unit uGlobalConfig.Persistence.UseCase.Interfaces;

interface

uses
  uGlobalConfig.Filter.DTO,
  uIndexResult,
  uGlobalConfig.Show.DTO,
  uGlobalConfig.Input.DTO,
  uFilter,
  uEither;

type
  IGlobalConfigPersistenceUseCase = Interface
    ['{F09F7940-D637-432C-9547-05A373A80514}']
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AIds: String): Boolean;
    function Index(AFilterDTO: TGlobalConfigFilterDTO): IIndexResult overload;
    function Index(AFilterEntity: IFilter): IIndexResult; overload;
    function Show(APK: Int64): TGlobalConfigShowDTO;
    function StoreAndShow(AInput: TGlobalConfigInputDTO): Either<String, TGlobalConfigShowDTO>;
    function Store(AInput: TGlobalConfigInputDTO): Int64;
    function Update(APK: Int64; AInput: TGlobalConfigInputDTO): Int64;
    function UpdateAndShow(AId: Int64; AInput: TGlobalConfigInputDTO): Either<String, TGlobalConfigShowDTO>;
  end;

implementation

end.
