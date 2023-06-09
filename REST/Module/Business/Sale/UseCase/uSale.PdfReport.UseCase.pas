﻿unit uSale.PdfReport.UseCase;

interface

uses
  uSale.Repository.Interfaces,
  uOutPutFileStream;

type
  ISalePdfReportUseCase = Interface
    ['{761E2080-9E8A-4801-8ABB-E8CB2140F062}']
    function Execute(AId: Int64): IOutPutFileStream;
  End;

  TSalePdfReportUseCase = class(TInterfacedObject, ISalePdfReportUseCase)
  private
    FRepository: ISaleRepository;
    constructor Create(ARepository: ISaleRepository);
  public
    class function Make(ARepository: ISaleRepository): ISalePdfReportUseCase;
    function Execute(AId: Int64): IOutPutFileStream;
  end;

implementation

{ TSalePdfReportUseCase }

uses
  uSale.Report;

constructor TSalePdfReportUseCase.Create(ARepository: ISaleRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TSalePdfReportUseCase.Execute(AId: Int64): IOutPutFileStream;
begin
  // Gerar PDF e retornar IOutPutFileStream
  Result := TSaleReport.Execute(FRepository.DataForReport(AId));
end;

class function TSalePdfReportUseCase.Make(ARepository: ISaleRepository): ISalePdfReportUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
