unit uCashFlow.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uCashFlow,
  uCashFlowTransaction;

type
  ICashFlowRepository = interface(IBaseRepository)
    ['{585D2335-994B-40F0-ABEB-C0360DBFF283}']
    function Show(AId: Int64): TCashFlow;
    /// <summary> Verificar se stacao esta em uso </summary>
    /// <param name="AStationId"> ID da Estacao </param>
    /// <param name="ADiffCashFlowId"> Diferente de ID da Estacao </param>
    /// <returns> CashFlowId </returns>
    function GetIdByStationInUse(AStationId: Int64; ADiffCashFlowId: Int64 = 0): Int64;
    function StoreTransaction(ACashFlowTransaction: TCashFlowTransaction): ICashFlowRepository;
  end;

implementation

end.



