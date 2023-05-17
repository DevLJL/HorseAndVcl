@echo off

set vendor_path=%cd%\Vendor

if not exist %vendor_path% (
  echo Criando a pasta Vendor em branco...
  mkdir %vendor_path%
)

echo Clonando o repositório do Git dentro da pasta Vendor...
git clone https://github.com/DevLJL/ZLConnection.git %vendor_path%\ZLConnection
git clone https://github.com/DevLJL/Either.git %vendor_path%\Either
git clone https://github.com/DevLJL/QuotedStr.git %vendor_path%\QuotedStr
git clone https://github.com/DevLJL/SmartPointer.git %vendor_path%\SmartPointer
git clone https://github.com/onryldz/x-superobject.git %vendor_path%\XSuperObject
git clone https://github.com/exilon/QuickLib.git %vendor_path%\QuickLib
git clone https://github.com/viniciussanchez/RESTRequest4Delphi.git %vendor_path%\RESTRequest4D
git clone https://github.com/DevLJL/Faker.git %vendor_path%\Faker
git clone https://github.com/HashLoad/horse.git %vendor_path%\Horse
git clone https://github.com/HashLoad/horse-jwt.git %vendor_path%\HorseJwt
git clone https://github.com/paolo-rossi/delphi-jose-jwt.git %vendor_path%\DelphiJoseJwt
git clone https://github.com/dliocode/horse-ratelimit.git %vendor_path%\HorseRateLimit
git clone https://github.com/dliocode/horse-utils-clientip.git %vendor_path%\HorseUtilsClientIp
git clone https://github.com/dliocode/store.git %vendor_path%\Store
git clone https://github.com/danieleteti/delphiredisclient.git %vendor_path%\DelphiRedisClient
git clone https://github.com/HashLoad/horse-compression.git %vendor_path%\HorseCompression
git clone https://github.com/HashLoad/jhonson.git %vendor_path%\Jhonson
git clone https://github.com/HashLoad/horse-cors.git %vendor_path%\HorseCors
git clone https://github.com/HashLoad/horse-octet-stream.git %vendor_path%\HorseOctetStream
git clone https://github.com/HashLoad/horse-jwt.git %vendor_path%\HorseJwt
git clone https://github.com/HashLoad/handle-exception.git %vendor_path%\HandleException
git clone https://github.com/HashLoad/horse-logger.git %vendor_path%\HorseLogger
git clone https://github.com/HashLoad/horse-logger-provider-console.git %vendor_path%\HorseLoggerProviderConsole
git clone https://github.com/HashLoad/horse-logger-provider-logfile.git %vendor_path%\HorseLoggerProviderFile
git clone https://github.com/academiadocodigo/Horse-ETag.git %vendor_path%\HorseETag
git clone https://github.com/gabrielbaltazar/gbswagger.git %vendor_path%\GbSwagger
git clone https://github.com/dliocode/datavalidator.git %vendor_path%\DataValidator
git clone https://github.com/giorgiobazzo/horse-upload.git %vendor_path%\HorseUpload
git clone https://github.com/dliocode/sendemail.git %vendor_path%\SendEmail

echo Procurando por arquivos git_clone.bat...

for /r %vendor_path% %%f in (git_clone.bat) do (
  echo Executando %%f...
  call %%f
)

echo Tudo pronto!
