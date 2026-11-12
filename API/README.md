# API de Tarefas

Serviço REST em Delphi para gerenciar tarefas (Parte 1 do teste prático de Desenvolvedor Delphi). Aplicação console construída com **Horse**, documentada com **Swagger**, protegida por **JWT** e persistindo em **SQL Server** via FireDAC.

## Tecnologias

| Item | Uso |
| --- | --- |
| Delphi 13 (Win32/Win64) | Linguagem e compilador |
| [Horse](https://github.com/HashLoad/horse) | Framework HTTP |
| [Jhonson](https://github.com/HashLoad/jhonson) | Middleware de JSON |
| [Horse-CORS](https://github.com/HashLoad/horse-cors) | Middleware de CORS |
| [Horse-JWT](https://github.com/HashLoad/horse-jwt) | Middleware de autenticação JWT |
| [GBSwagger](https://github.com/gabrielbaltazar/gbswagger) | Rotas por atributos + documentação Swagger + validação |
| FireDAC (MSSQL) | Acesso ao SQL Server com pool de conexões |
| [Boss](https://github.com/HashLoad/boss) | Gerenciador de dependências |

## Pré-requisitos

- Delphi 13 com FireDAC
- Boss instalado
- SQL Server (qualquer edição, inclusive Express/LocalDB)
- Driver ODBC do SQL Server instalado na máquina que executa a API

## Como executar

1. **Dependências** – na pasta do projeto:

   ```bash
   boss install
   ```

2. **Banco de dados** – execute `Database/01_create_database.sql` no SQL Server. O script é idempotente e cria o banco `TarefasBDMG`, as tabelas `Tarefa` e `Usuario` e o usuário padrão da API.

3. **Compilação** – abra `AplicacaoBDMG_api.dproj` no RAD Studio e compile, ou pela linha de comando:

   ```bash
   msbuild AplicacaoBDMG_api.dproj /t:Build /p:Config=Debug /p:Platform=Win32
   ```

4. **Configuração** – na primeira execução a API cria o arquivo `AplicacaoBDMG_apiResources.json` ao lado do executável. Ajuste a conexão se necessário e execute novamente.

   | Chave | Padrão | Descrição |
   | --- | --- | --- |
   | `API_SECRETKEY` | gerada aleatoriamente (256 bits) | Segredo de assinatura do JWT |
   | `API_TOKEN_EXPIRACAO` | `3600` | Validade do token em segundos |
   | `DATABASE_HOST` | `localhost` | Servidor/instância (ex.: `localhost\SQLEXPRESS`) |
   | `DATABASE_NAME` | `TarefasBDMG` | Nome do banco |
   | `DATABASE_OSAUTHENT` | `true` | `true` = autenticação integrada do Windows |
   | `DATABASE_USERNAME` | `sa` | Usado quando `DATABASE_OSAUTHENT` é `false` |
   | `DATABASE_PASSWORD` | vazio | Usado quando `DATABASE_OSAUTHENT` é `false` |

   Esse arquivo não é versionado, pois guarda a senha do banco e o segredo do JWT.

5. **Execução** – rode `AplicacaoBDMG_api.exe`. A API sobe na porta **9090** (constante `API_PORT` em `Source/View/AplicacaoBDMG.View.API.pas`). Pressione ENTER no console para encerrar.

6. **Swagger** – http://localhost:9090/v1/swagger/doc/html

## Autenticação

A comunicação entre a aplicação cliente e o serviço é protegida por JWT (HS256).

- Usuário padrão criado pelo script: **`admin`** / **`admin123`**
- `POST /v1/auth/login` devolve o token; as demais rotas de tarefas exigem o header `Authorization: Bearer <token>`
- O token carrega as claims `sub` (login), `iat`, `exp` e `idUsuario` e expira em 1 hora por padrão
- A senha nunca é gravada em texto puro: a tabela guarda o SHA-256 de `salt + senha`
- O login responde sempre a mesma mensagem para usuário inexistente, inativo ou senha incorreta
- No Swagger, clique em **Authorize** e informe `Bearer <token>`

## Endpoints

Prefixo de todas as rotas: `/v1`

| Método | Rota | Descrição | Sucesso | Erros |
| --- | --- | --- | --- | --- |
| GET | `/ping` | Verificação do serviço (pública). Com `?connect` testa também o banco | 200 | 500 |
| POST | `/auth/login` | Autentica e devolve o JWT (pública) | 200 | 400, 401, 500 |
| GET | `/tarefas` | Lista todas as tarefas | 200 | 401, 500 |
| POST | `/tarefas` | Adiciona uma tarefa | 201 | 400, 401, 500 |
| PATCH | `/tarefas/{id}/status` | Atualiza o status de uma tarefa | 200 | 400, 401, 404, 500 |
| DELETE | `/tarefas/{id}` | Remove uma tarefa | 204 | 400, 401, 404, 500 |
| GET | `/tarefas/estatisticas` | Estatísticas do desafio SQL | 200 | 401, 500 |

### Exemplos

Login:

```bash
curl -X POST http://localhost:9090/v1/auth/login -H "Content-Type: application/json" -d "{\"login\":\"admin\",\"senha\":\"admin123\"}"
```

```json
{ "token": "eyJhbGciOi...", "expiraEm": 3600 }
```

Adicionar tarefa:

```bash
curl -X POST http://localhost:9090/v1/tarefas -H "Authorization: Bearer <token>" -H "Content-Type: application/json" -d "{\"titulo\":\"Revisar contrato\",\"descricao\":\"Cliente X\",\"prioridade\":3}"
```

```json
{
  "id": 1,
  "titulo": "Revisar contrato",
  "descricao": "Cliente X",
  "status": "Pendente",
  "prioridade": 3,
  "dataCriacao": "2026-11-11T22:30:00.000-03:00",
  "dataConclusao": null
}
```

Atualizar status:

```bash
curl -X PATCH http://localhost:9090/v1/tarefas/1/status -H "Authorization: Bearer <token>" -H "Content-Type: application/json" -d "{\"status\":\"Concluida\"}"
```

Estatísticas:

```bash
curl http://localhost:9090/v1/tarefas/estatisticas -H "Authorization: Bearer <token>"
```

```json
{ "totalTarefas": 10, "mediaPrioridadePendentes": 2.75, "concluidasUltimos7Dias": 4 }
```

### Formato de erro

Todos os erros tratados pela API seguem o mesmo formato:

```json
{ "erro": "Tarefa 99 não encontrada.", "codigo": "TAREFA_NAO_ENCONTRADA" }
```

| Código | Status | Quando ocorre |
| --- | --- | --- |
| `REQUISICAO_INVALIDA` | 400 | Corpo ausente, tipo incorreto, campo obrigatório faltando, valor fora da faixa |
| `ID_INVALIDO` | 400 | `id` da rota não é um inteiro positivo |
| `NAO_AUTORIZADO` | 401 | Token ausente, inválido ou expirado |
| `CREDENCIAIS_INVALIDAS` | 401 | Login ou senha incorretos |
| `TAREFA_NAO_ENCONTRADA` | 404 | Tarefa inexistente no PATCH ou DELETE |
| `ERRO_BANCO_DADOS` | 500 | Falha de acesso ao banco (detalhe apenas no log do console) |
| `ERRO_INTERNO` | 500 | Erro inesperado (detalhe apenas no log do console) |

Um corpo que não seja JSON válido é recusado pelo middleware Jhonson com status 400 e o texto `Invalid JSON`.

## Estrutura de dados

### Tabela `dbo.Tarefa`

| Coluna | Tipo | Regra |
| --- | --- | --- |
| `Id` | `INT IDENTITY` | Chave primária |
| `Titulo` | `NVARCHAR(150)` | Obrigatório |
| `Descricao` | `NVARCHAR(500)` | Opcional |
| `Status` | `VARCHAR(20)` | `Pendente`, `EmAndamento` ou `Concluida` (CHECK); padrão `Pendente` |
| `Prioridade` | `TINYINT` | De 1 (menor) a 5 (maior) (CHECK) |
| `DataCriacao` | `DATETIME2(0)` | Padrão `SYSDATETIME()` |
| `DataConclusao` | `DATETIME2(0)` | Nula enquanto a tarefa não está concluída |

Índice `IX_Tarefa_Status_DataConclusao (Status, DataConclusao) INCLUDE (Prioridade)` para atender os filtros das estatísticas.

### Tabela `dbo.Usuario`

| Coluna | Tipo | Regra |
| --- | --- | --- |
| `Id` | `INT IDENTITY` | Chave primária |
| `Login` | `VARCHAR(50)` | Único |
| `SenhaHash` | `VARCHAR(64)` | SHA-256 hexadecimal de `Salt + senha` |
| `Salt` | `VARCHAR(64)` | Valor aleatório por usuário |
| `Ativo` | `BIT` | Padrão 1 |

### Regras e premissas

- **Pendente** significa exatamente `Status = 'Pendente'`; tarefas `EmAndamento` não entram na média de prioridade.
- **Data de conclusão** é preenchida com a hora do servidor de banco quando o status passa a `Concluida`, é preservada se a tarefa já estava concluída e é limpa quando a tarefa é reaberta.
- **Últimos 7 dias** é uma janela móvel a partir do instante da consulta.
- **Média sem tarefas pendentes** retorna `0`.
- Uma tarefa nova sempre nasce como `Pendente`.

## Desafio SQL

As três estatísticas são calculadas em uma única ida ao banco (`Source/Model/DAO/AplicacaoBDMG.DAO.SQL.pas`):

```sql
SELECT (SELECT COUNT(*)
          FROM dbo.Tarefa) AS TotalTarefas,
       (SELECT ISNULL(AVG(CAST(Prioridade AS DECIMAL(5, 2))), 0)
          FROM dbo.Tarefa
         WHERE Status = 'Pendente') AS MediaPrioridadePendentes,
       (SELECT COUNT(*)
          FROM dbo.Tarefa
         WHERE Status = 'Concluida'
           AND DataConclusao >= DATEADD(DAY, -7, SYSDATETIME())) AS ConcluidasUltimos7Dias
```

O `CAST` para `DECIMAL` é necessário porque `AVG` sobre `TINYINT` faria divisão inteira; o `ISNULL` cobre o caso de não haver tarefas pendentes. Os valores de status entram por parâmetro, assim como todos os demais valores enviados ao banco (nenhum SQL é montado por concatenação).

## Arquitetura

Fluxo de uma requisição: **View** (endpoint) → **Controller** (conexão e fábricas) → **DAO** / **Service** → **Modelo**.

```
AplicacaoBDMG_api.dpr
Resources/            Configuração de runtime (AplicacaoBDMG_apiResources.json)
Swagger/              Configuração do Swagger
Database/             Script de criação do banco
Source/
  View/               Endpoints Horse declarados por atributos Swagger
  Controller/         Obtém a conexão do pool e expõe as fábricas de DAO e Service
  Middleware/         Tratamento global de exceções
  Utils/              Conversão Modelo <-> JSON
  Model/
    Modelo/           Classes de modelo, tipos e exceção de negócio
    DAO/              Acesso a dados (FireDAC / SQL Server)
    Service/          Regras de negócio (autenticação)
```

- **View** – cada classe herda de `TAPIAplicacaoBDMGViewBase<T>` e declara rota, parâmetros e respostas por atributos (`SwagPath`, `SwagGET`, `SwagResponse`...), que registram a rota no Horse e geram a documentação ao mesmo tempo.
- **Controller** – vive durante uma requisição; cria a conexão sob demanda e a devolve ao pool ao ser liberado.
- **Validação** – as regras de entrada ficam nos atributos do modelo (`SwagRequired`, `SwagString`, `SwagNumber`), aplicadas na entrada e refletidas no Swagger.
- **Tratamento de erros** – um middleware converte qualquer exceção no formato padrão de erro e registra no console os erros inesperados, sem expor detalhes internos ao cliente.

### Uso de Factory

| Padrão | Onde | Papel |
| --- | --- | --- |
| Abstract Factory | `IAPIAplicacaoBDMGDAOFactory` / `TAPIAplicacaoBDMGDAOFactory` | Entrega a família de DAOs (`Tarefa`, `Usuario`) sobre a mesma conexão; View e Service conhecem apenas interfaces |
| Abstract Factory | `IAPIAplicacaoBDMGServiceFactory` / `TAPIAplicacaoBDMGServiceFactory` | Entrega os serviços de regra de negócio já ligados às DAOs |
| Factory Method | `TAPIAplicacaoBDMGConnectionFactory.New` | Escolhe a implementação de `IAPIAplicacaoBDMGConnection` (hoje SQL Server); outro SGBD entra sem alterar Controller ou DAOs |
| Factory Method | `CreateController` e métodos `New` das classes | Criação sempre por interface, com liberação por contagem de referência |
