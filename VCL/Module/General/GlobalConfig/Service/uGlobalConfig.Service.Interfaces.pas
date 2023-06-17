unit uGlobalConfig.Service.Interfaces;

interface

uses
  uBase.Service,
  uGlobalConfig.Filter.DTO,
  uIndexResult,
  uGlobalConfig.Show.DTO,
  uGlobalConfig.Input.DTO,
  uEither;

type
  IGlobalConfigService = Interface(IBaseService)
    ['{42CDFCF0-189E-4575-8525-7C1F704FDFC0}']
    function Index(AFilter: TGlobalConfigFilterDTO = nil): Either<String, IIndexResult>;
    function Show(AId: Int64 = 1): TGlobalConfigShowDTO;
    function UpdateAndShow(AId: Int64 = 1; AInput: TGlobalConfigInputDTO = nil): Either<String, TGlobalConfigShowDTO>;
  End;

implementation

end.
