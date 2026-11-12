# Gerenciador de Tarefas – Aplicação cliente

Aplicação **VCL** em Delphi que consome a [API de Tarefas](../API/README.md) (Parte 2 do teste prático de Desenvolvedor Delphi). Todas as operações passam pelo serviço: a aplicação não tem banco nem arquivo de dados local.

## Funcionalidades

| Requisito | Onde |
| --- | --- |
| Login com JWT | Tela de login (`POST /auth/login`); o token fica **somente em memória** |
| Exibir a lista de tarefas | Tela principal, grid com status destacado por cor |
| Adicionar tarefa | Botão **Nova tarefa** (ou `Insert`), com validação antes do envio |
| Atualizar o status | Botão **Alterar status**, com os status aceitos pela API |
| Remover tarefa | Botão **Remover** (ou `Delete`), com confirmação |
| Estatísticas do desafio SQL | Três indicadores no topo da tela principal |

Atalhos da tela principal: `F5` atualiza, `Insert` nova tarefa, `Delete` remove a selecionada.

## Tecnologias

| Item | Uso |
| --- | --- |
| Delphi 13 (Win32/Win64) | Linguagem e compilador |
| VCL | Interface gráfica |
| [RESTRequest4Delphi](https://github.com/viniciussanchez/RESTRequest4Delphi) | Chamadas HTTP ao serviço |
| [Boss](https://github.com/HashLoad/boss) | Gerenciador de dependências |

## Como executar

1. **Serviço** – suba a API da pasta `../API` (veja o README dela). Por padrão ela responde em `http://localhost:9090/v1`.

2. **Dependências** – na pasta deste projeto:

   ```bash
   boss install
   ```

3. **Compilação** – abra `AplicacaoBDMG_app.dproj` no RAD Studio e compile, ou pela linha de comando:

   ```bash
   msbuild AplicacaoBDMG_app.dproj /t:Build /p:Config=Debug /p:Platform=Win32
   ```

4. **Execução** – rode `AplicacaoBDMG_app.exe` e entre com o usuário criado pelo script do banco (`admin` / `admin123`).

### Configuração (opcional)

Sem configuração nenhuma a aplicação usa `http://localhost:9090/v1`. Para apontar para outro endereço, copie `AplicacaoBDMG_appResources.json.example` para a pasta do executável com o nome `AplicacaoBDMG_appResources.json`:

| Chave | Padrão | Descrição |
| --- | --- | --- |
| `API_URL` | `http://localhost:9090/v1` | Endereço base do serviço, com a versão |
| `API_TIMEOUT` | `15000` | Tempo máximo de espera por requisição (ms) |

O arquivo é apenas lido. O endereço em uso aparece no rodapé da tela de login.

## Arquitetura

```
AplicacaoBDMG_app.dpr
Resources/            Configuração de runtime (endereço do serviço)
Source/
  View/               Telas VCL: Login, Principal e TarefaNova
  Utils/              Conversão JSON -> Modelo e execução assíncrona
  Model/
    Modelo/           Classes de modelo, tipos e exceções
    Service/          Acesso ao serviço (RESTRequest4Delphi), sessão e fábrica
```

- **View** – as telas conhecem apenas as interfaces de `AplicacaoBDMG.Service.Interfaces`; nenhuma tela monta URL, JSON ou cabeçalho.
- **Service** – `TAplicacaoBDMGServiceRequest` é o único ponto de saída HTTP: acrescenta endereço, timeout e o token Bearer e converte toda falha em exceção da aplicação.
- **Factory** – `IAplicacaoBDMGServiceFactory` (Abstract Factory) entrega os serviços `Auth` e `Tarefa` já ligados à mesma sessão; trocar o transporte ou usar um dublê em testes não altera as telas.
- **Sessão** – `IAplicacaoBDMGSession` guarda login e token em memória; é esvaziada no logout, na expiração e ao fechar a aplicação.
- **Interface responsiva** – as chamadas rodam em segundo plano (`TAplicacaoBDMGAsync`) e o resultado volta para a thread principal, então a janela não trava com o serviço lento ou fora do ar.

## Tratamento de erros

| Situação | Comportamento |
| --- | --- |
| Serviço fora do ar, endereço errado ou timeout | Mensagem orientando a verificar a API; a tela continua utilizável |
| Login ou senha incorretos | Mensagem na própria tela de login |
| Token expirado ou inválido (401) | Token descartado, tela limpa e retorno ao login com aviso |
| Dados recusados pela API (400) | Mensagem devolvida pelo serviço, exibida na tela de cadastro |
| Tarefa removida por outro usuário (404) | Mensagem do serviço e recarga automática da lista |
| Erro interno do serviço (500) | Mensagem do serviço, sem detalhes técnicos |

## Premissas

- Após cada inclusão, mudança de status ou remoção a tela recarrega lista e estatísticas a partir do serviço, de modo que os indicadores sempre refletem o cálculo feito no SQL Server.
- Os limites de título (150), descrição (500) e prioridade (1 a 5) são conferidos na tela para orientar o usuário, mas a validação que vale é a da API.
- Datas são exibidas no horário local da máquina.
