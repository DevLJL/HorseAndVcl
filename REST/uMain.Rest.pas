unit uMain.Rest;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  uResponse.DTO,
  uConnMigration,
  uSmartPointer,
  Horse,
  Horse.JWT,
  Horse.Compression,
  Horse.Jhonson,
  Horse.Cors,
  Horse.Logger,
  Horse.Logger.Provider.Console,
  Horse.Logger.Provider.LogFile,
  Horse.Logger.Manager,
  Horse.Etag,
  Horse.GBSwagger,
  Horse.OctetStream,
  Horse.Upload,
  DataSet.Serialize,
  uExceptionHandler,
  uAppRest.Types,
  uMyClaims,
  uRouteApi.Auth,
  uRouteApi.Business,
  uRouteApi.Financial,
  uRouteApi.General,
  uRouteApi.Stock,
  uTaskScheduler;

type
  TMainRest = class
  private
    class procedure InitializeSwagger;
    class procedure SetMiddlewares;
    class procedure RunMigrationsAndSeeds;
    class procedure SetRoutes;
    class procedure ClearTempFolder;
    class procedure StartTasks;
    class procedure RunServer;
  public
    class function Start: TMainRest;
  end;

implementation

uses uEnv.Rest;

const
  SKIP_ROUTES_ON_AUTHENTICATION: TArray<String> = [
    'api/v1/Ping',
    'api/v1/AclUsers/Login',
    '/swagger/doc/html',
    '/swagger/doc/json'
  ];

{ TMain }

class function TMainRest.Start: TMainRest;
begin
  ReportMemoryLeaksOnShutdown := True;//(DebugHook <> 0);
  IsConsole                   := False;

  InitializeSwagger;
  SetMiddlewares;
  RunMigrationsAndSeeds;
  SetRoutes;
  ClearTempFolder;
  StartTasks;
  RunServer;
end;

class procedure TMainRest.InitializeSwagger;
begin
  Swagger
    .BasePath('api/v1')
    .Info
      .Title('xxxxx')
      .Description('API AB2xx3HCxxxxxxxxxx')
    .&End
    .Register
      .SchemaOnError(TResponseDTO)
    .&End
    .AddProtocol(TGBSwaggerProtocol.gbHttp)
    .AddProtocol(TGBSwaggerProtocol.gbHttps)
    .AddBearerSecurity;
end;

class procedure TMainRest.SetMiddlewares;
begin
  // Configuração DataSetSerialize
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition    := TCaseNameDefinition.cndLower;
  TDataSetSerializeConfig.GetInstance.DateTimeIsISO8601     := False;
  TDataSetSerializeConfig.GetInstance.Export.FormatDateTime := 'yyyy-mm-dd"T"hh":"mm":"ss.000';
  //TDataSetSerializeConfig.GetInstance.Export.FormatDate     := 'yyyy-mm-dd';

  // Configurações Logger
  THorseLoggerManager
    .RegisterProvider(THorseLoggerProviderConsole.New())
    .RegisterProvider(THorseLoggerProviderLogFile.New());

  // Configuração do CORS
  HorseCORS
    .AllowedOrigin('*')
    .AllowedCredentials(true)
    .AllowedHeaders('*')
    .AllowedMethods('*')
    .ExposedHeaders('*');

  THorse
    .Use(Jhonson)
    .Use(ExceptionHandler)
    .Use(THorseLoggerManager.HorseCallback)
    .Use(HorseJWT(
      JWT_KEY,
      THorseJWTConfig.New
        .SessionClass(TMyClaims)
        .SkipRoutes(SKIP_ROUTES_ON_AUTHENTICATION)
    ))
    .Use(Compression(0))
    .Use(HorseSwagger)
    .Use(eTag)
    .Use(Cors)
    .Use(HorseSwagger)
    .Use(OctetStream)
    .Use(Upload);
end;

class procedure TMainRest.RunMigrationsAndSeeds;
begin
  try
    Writeln('Running migrations and seeders...');
    ConnMigration.RunPendingMigrationsAndSeeders;
  except on E: Exception do
    Begin
      // Exibir mensagem para o usuário
      Writeln('Falha na execução das migrações.');
      Writeln(E.Message + ' - ' + E.ClassName);

      // Encerrar Aplicação
      System.Halt;
      Exit;
    end;
  end;
end;

class procedure TMainRest.ClearTempFolder;
begin
  const lTempPath = ExtractFilePath(ParamStr(0)) + 'Temp\';
  if TDirectory.Exists(lTempPath) then
    TDirectory.Delete(lTempPath, True);
end;

class procedure TMainRest.StartTasks;
begin
  TaskScheduler.Start;
end;

class procedure TMainRest.RunServer;
begin
  // Executar Servidor
  THorse.Listen(ENV_REST.ApiPort,
    procedure
    begin
      Writeln(Format('Swagger Documentation on %s:%d%s', [THorse.Host, THorse.Port, '/swagger/doc/html']));
      Writeln(Format('Server is runing on %s:%d - [%s]', [THorse.Host, THorse.Port, DateTimeToStr(Now)]));
      Readln;
    end);
end;

class procedure TMainRest.SetRoutes;
begin
  // Método de Teste - PING
  THorse.Get(
    'api/v1/Ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('Pong');
    end
  );

  // Registro de Rotas
  TRouteApiAuth.Registry;
  TRouteApiStock.Registry;
  TRouteApiGeneral.Registry;
  TRouteApiFinancial.Registry;
  TRouteApiBusiness.Registry;
end;

end.
