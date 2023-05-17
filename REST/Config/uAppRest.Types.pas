unit uAppRest.Types;

interface

{$SCOPEDENUMS ON}
type
  TEntityState = (None, Store, Update);

const
  // Nunca alterar essas chaves a menos que seja muito necess�rio.
  // Se for alterar, precisa gerar novamente todos os campos que s�o criptografados no banco de dados com a nova chave.
  {TODO -oOwner -cGeneral :Mover essas chaves para arquivo privado.}
  ENCRYPTATION_KEY       = '{A676CF7D-4755-400D-8E83-0753D4CEA08F}';
  LOGIN_PASSWORD_DEFAULT = '123Mudar@';
  JWT_KEY                = '{D2011AB9-7D15-4068-B7CB-014954657F9E}';

  HTTP_OK = 200; // Sucesso e retorna conteudo
  HTTP_CREATED = 201; // Incluiu Novo Registro
  HTTP_NO_CONTENT = 204; // Sucesso e n�o retorna conte�do
  HTTP_BAD_REQUEST = 400; // Erro rastre�vel
  HTTP_NOT_FOUND = 404; // N�o encontrado HTTP_NOT_FOUND
  HTTP_INTERNAL_SERVER_ERROR = 500; // Erro n�o rastre�vel
  DELIMITED_CHAR = ';';
  SELECT_LAST_INSERT_ID_MYSQL = 'SELECT last_insert_id() as id';
  DATETIME_DISPLAY_FORMAT = 'YYYY-MM-DDTHH:MM:SS.sTZ';
  DATE_DISPLAY_FORMAT = 'YYYY-MM-DD';
  CREATED_AT_DISPLAY = 'Data e hora de criação';
  CREATED_BY_ACL_USER_ID = 'Criado por usuário (id)';
  CREATED_BY_ACL_USER_NAME = 'Criado por usuário (nome)';
  UPDATED_AT_DISPLAY = 'Data e hora de alteração';
  UPDATED_BY_ACL_USER_ID = 'Alterado por usuário (id)';
  UPDATED_BY_ACL_USER_NAME = 'Alterado por usuário (nome)';

  // CACHE DE PRODUTOS
  CACHE_PRODUCT_MS_TO_EXPIRE     = 900000; {Expira em 15 minutos}
  CACHE_PRODUCT_REQ_BODY_KEY     = 'TProductController.Index.LastReqBody';
  CACHE_PRODUCT_INDEX_RESULT_KEY = 'TProductController.Index.LastIndexResult';

implementation

end.

