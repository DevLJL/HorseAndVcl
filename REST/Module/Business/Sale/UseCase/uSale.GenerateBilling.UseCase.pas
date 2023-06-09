﻿unit uSale.GenerateBilling.UseCase;

interface

uses
  uSale.Repository.Interfaces,
  uProduct.Repository.Interfaces,
  uZLConnection.Interfaces,
  uBillPayReceive.Repository.Interfaces,
  uCashFlow.Repository.Interfaces,
  uSale.Types,
  uSale.Input.DTO,
  uSale,
  uSale.Show.DTO,
  uProduct.Types,
  uCashFlowTransaction.Types,
  uRepository.Factory;

type
  ISaleGenerateBillingUseCase = Interface
    ['{FD249E36-4A4C-4580-9502-CC79F9171E9F}']
    function Execute(AReturnShowDTO: Boolean = true): TSaleShowDTO;
  end;

  TSaleGenerateBillingUseCase = class(TInterfacedObject, ISaleGenerateBillingUseCase)
  private
    FSharedConn: IZLConnection;
    FSaleRepository: ISaleRepository;
    FProductRepository: IProductRepository;
    FBillPayReceiveRepository: IBillPayReceiveRepository;
    FCashFlowRepository: ICashFlowRepository;
    FSaleId: Int64;
    FStationId: Int64;
    FOperation: TSaleGenerateBillingOperation;
    FSale: TSale;
    FInput: TSaleInputDTO;
    FSaleStatus: TSaleStatus;
    FTypeMov: TProductMovStock;
    FFlgGenerateBillReceives: Boolean;
    FTypeTransaction: TCashFlowTransactionType;
    constructor Create(ARepositoryFactory: IRepositoryFactory; ASaleId: Int64; AStationId: Int64; AOperation: TSaleGenerateBillingOperation; AInput: TSaleInputDTO);
    destructor Destroy; override;
    function Validate: ISaleGenerateBillingUseCase;
    function HandleChangeSaleStatus: ISaleGenerateBillingUseCase;
    function HandleMovStock: ISaleGenerateBillingUseCase;
    function HandleBillReceive: ISaleGenerateBillingUseCase;
    function HandleCashFlow: ISaleGenerateBillingUseCase;
  public
    /// <summary>
    ///   Informar ID da Venda que já está salva e Faturar
    /// </summary>
    class function Make(ARepositoryFactory: IRepositoryFactory; ASaleId: Int64; AStationId: Int64; AOperation: TSaleGenerateBillingOperation): ISaleGenerateBillingUseCase; overload;
    /// <summary>
    ///   Informar Input da Venda para Incluir e Faturar
    /// </summary>
    class function Make(ARepositoryFactory: IRepositoryFactory; AInput: TSaleInputDTO; AStationId: Int64): ISaleGenerateBillingUseCase; overload;
    function Execute(AReturnShowDTO: Boolean = true): TSaleShowDTO;
  end;

implementation

{ TSaleGenerateBillingUseCase }

uses
  uSmartPointer,
  uSaleItem,
  System.Generics.Collections,
  uBillPayReceive,
  System.SysUtils,
  uAppRest.Types,
  uSalePayment,
  uTrans,
  uSale.GenerateBillReceivesBySale,
  uSale.Mapper,
  uEntityValidation.Exception,
  uCashFlowTransaction,
  uSale.GenerateCashFlowTransactionsBySale,
  uCache;

constructor TSaleGenerateBillingUseCase.Create(ARepositoryFactory: IRepositoryFactory; ASaleId: Int64; AStationId: Int64; AOperation: TSaleGenerateBillingOperation; AInput: TSaleInputDTO);
begin
  inherited Create;

  // Repositórios
  FSharedConn               := ARepositoryFactory.Conn;
  FSaleRepository           := ARepositoryFactory.Sale;
  FProductRepository        := ARepositoryFactory.Product;
  FBillPayReceiveRepository := ARepositoryFactory.BillPayReceive;
  FCashFlowRepository       := ARepositoryFactory.CashFlow;

  // Desligar Gerenciamento de Transação interna dos Repositórios
  // Transação será gerenciada por FSharedConn
  FSaleRepository.SetManageTransaction(False);
  FProductRepository.SetManageTransaction(False);
  FBillPayReceiveRepository.SetManageTransaction(False);
  FCashFlowRepository.SetManageTransaction(False);

  FSaleId                   := ASaleId;
  FStationId                := AStationId;
  FOperation                := AOperation;
  FInput                    := AInput;

  case FOperation of
    TSaleGenerateBillingOperation.Revert: Begin
      FSaleStatus              := TSaleStatus.Pending;
      FTypeMov                 := TProductMovStock.Increment;
      FFlgGenerateBillReceives := False;
      FTypeTransaction         := TCashFlowTransactionType.Debit;
    End;
    TSaleGenerateBillingOperation.Approve: Begin
      FSaleStatus              := TSaleStatus.Approved;
      FTypeMov                 := TProductMovStock.Decrement;
      FFlgGenerateBillReceives := True;
      FTypeTransaction         := TCashFlowTransactionType.Credit;
    End;
    TSaleGenerateBillingOperation.Cancel: Begin
      FSaleStatus              := TSaleStatus.Canceled;
      FTypeMov                 := TProductMovStock.Increment;
      FFlgGenerateBillReceives := False;
      FTypeTransaction         := TCashFlowTransactionType.Debit;
    End;
  end;
end;

destructor TSaleGenerateBillingUseCase.Destroy;
begin
  if Assigned(FSale)  then FreeAndNil(FSale);
  inherited;
end;

class function TSaleGenerateBillingUseCase.Make(ARepositoryFactory: IRepositoryFactory; ASaleId: Int64; AStationId: Int64; AOperation: TSaleGenerateBillingOperation): ISaleGenerateBillingUseCase;
begin
  Result := Self.Create(ARepositoryFactory, ASaleId, AStationId, AOperation, nil);
end;

class function TSaleGenerateBillingUseCase.Make(ARepositoryFactory: IRepositoryFactory; AInput: TSaleInputDTO; AStationId: Int64): ISaleGenerateBillingUseCase;
const
  LSALE_ID_NOT_INFORMED = 0;
begin
  Result := Self.Create(ARepositoryFactory, LSALE_ID_NOT_INFORMED, AStationId, TSaleGenerateBillingOperation.Approve, AInput);
end;

function TSaleGenerateBillingUseCase.Execute(AReturnShowDTO: Boolean): TSaleShowDTO;
begin
  try
    FSharedConn.StartTransaction;

    case (FSaleId > 0) of
      // Localizar Venda quando ID informado
      True: Begin
        FSale := FSaleRepository.Show(FSaleId);
        if not Assigned(FSale) then
          raise Exception.Create(Trans.RecordNotFound + ': ' + FSaleId.ToString);
      End;
      // Inserir Venda quando o INPUT informado ao invés do ID
      False: Begin
        const LEntity: SH<TSale> = TSaleMapper.InputToEntity(FInput);
        const LErrors = LEntity.Value.BeforeSaveAndValidate(TEntityState.Store);
        if not LErrors.Trim.IsEmpty then
          raise TEntityValidationException.Create(LErrors);
        FSale := FSaleRepository.Show(FSaleRepository.Store(LEntity));
      End;
    end;

    Validate;               {Validar dados antes de prosseguir}
    HandleChangeSaleStatus; {Alterar Status da Venda}
    HandleMovStock;         {Movimentar Estoque}
    HandleBillReceive;      {Gerar/Estornar Contas a Receber}
    HandleCashFlow;         {Gerar Fluxo de Caixa}

    FSharedConn.CommitTransaction;
  except on E: Exception do
    Begin
      FSharedConn.RollBackTransaction;
      raise;
    End;
  end;

  // Retornar Venda C/ Alterações
  if AReturnShowDTO then
  begin
    const LEntity: SH<TSale> = FSaleRepository.Show(FSale.id);
    Result := TSaleMapper.EntityToShow(LEntity.Value);
  end;

  // Remover Cache de Produtos p/ evitar erros
  Cache.RemoveValue(CACHE_PRODUCT_REQ_BODY_KEY);
end;

function TSaleGenerateBillingUseCase.Validate: ISaleGenerateBillingUseCase;
begin
  Result := Self;

  // Se venda estiver cancelada, aborta qualquer processo
  if FSale.status = TSaleStatus.Canceled then
    raise TEntityValidationException.Create(Trans.Sale.SaleIsAlreadyInStatus(TSaleStatus.Canceled.ToString));

  // Impedir aprovação de venda já aprovada anteriormente
  if (FOperation = TSaleGenerateBillingOperation.Approve) and (FSale.status = TSaleStatus.Approved) then
    raise TEntityValidationException.Create(Trans.Sale.SaleIsAlreadyInStatus(TSaleStatus.Approved.ToString));

  // Impedir estorno de venda pendente
  if (FOperation = TSaleGenerateBillingOperation.Revert) and (FSale.status = TSaleStatus.Pending) then
    raise TEntityValidationException.Create(Trans.Sale.SaleIsAlreadyInStatus(TSaleStatus.Pending.ToString));

  // Impedir cancelamento de venda pendente
  if (FOperation = TSaleGenerateBillingOperation.Cancel) and (FSale.status = TSaleStatus.Pending)  then
      raise TEntityValidationException.Create(Trans.Sale.SaleIsAlreadyInStatus(TSaleStatus.Pending.ToString));
end;

function TSaleGenerateBillingUseCase.HandleChangeSaleStatus: ISaleGenerateBillingUseCase;
begin
  Result := Self;
  FSaleRepository.ChangeStatus(FSale.id, FSaleStatus);
end;

function TSaleGenerateBillingUseCase.HandleMovStock: ISaleGenerateBillingUseCase;
begin
  Result := Self;
  for var LSaleItem in FSale.sale_items do
    FProductRepository.MoveProduct(LSaleItem.product_id, LSaleItem.quantity, FTypeMov);
end;

function TSaleGenerateBillingUseCase.HandleBillReceive: ISaleGenerateBillingUseCase;
begin
  Result := Self;

  case FFlgGenerateBillReceives of
    // Gerar Contas a Receber
    True: Begin
      const LBillReceives: SH<TObjectList<TBillPayReceive>> = TSaleGenerateBillReceivesBySale.Make.Execute(FSale);
      for var LBillReceive in LBillReceives.Value do
        FBillPayReceiveRepository.Store(lBillReceive);
    End;
    // Estornar Contas a Receber
    False: FBillPayReceiveRepository.DeleteBySaleId(FSale.id);
  end;
end;

function TSaleGenerateBillingUseCase.HandleCashFlow: ISaleGenerateBillingUseCase;
begin
  Result := Self;

  // Obter ID de Fluxo de Caixa Ativo por Estação
  const LCashFlowIdInUse = FCashFlowRepository.GetIdByStationInUse(FStationId);
  if not (LCashFlowIdInUse > 0) then
    Exit;

  // Gerar Fluxo de Caixa
  const LCashFlowTransactions: SH<TObjectList<TCashFlowTransaction>> = TSaleGenerateCashFlowTransactionsBySale.Make.Execute(FSale, LCashFlowIdInUse, FTypeTransaction);
  for var LCashFlowTransaction in LCashFlowTransactions.Value do
    FCashFlowRepository.StoreTransaction(LCashFlowTransaction);
end;

end.

