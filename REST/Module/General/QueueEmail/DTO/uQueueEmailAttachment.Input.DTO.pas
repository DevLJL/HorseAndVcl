unit uQueueEmailAttachment.Input.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  uBase.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections;

type
  TQueueEmailAttachmentInputDTO = class(TBaseDTO)
  private
    Fbase64: String;
    Ffile_name: string;
  public
    [SwagString(255)]
    [SwagProp('file_name', 'Nome do Arquivo com Extensão. Exemplo: NomeDoArquivo.png', true)]
    property file_name: string read Ffile_name write Ffile_name;

    [SwagString]
    [SwagProp('base64', 'Anexo codificado em Base64', true)]
    property base64: String read Fbase64 write Fbase64;
  end;

implementation

end.


