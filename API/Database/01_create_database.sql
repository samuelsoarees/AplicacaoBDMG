IF DB_ID('TarefasBDMG') IS NULL
    CREATE DATABASE TarefasBDMG;
GO

USE TarefasBDMG;
GO

IF OBJECT_ID('dbo.Tarefa', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Tarefa (
        Id            INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Tarefa PRIMARY KEY,
        Titulo        NVARCHAR(150)     NOT NULL,
        Descricao     NVARCHAR(500)     NULL,
        Status        VARCHAR(20)       NOT NULL CONSTRAINT DF_Tarefa_Status DEFAULT 'Pendente',
        Prioridade    TINYINT           NOT NULL,
        DataCriacao   DATETIME2(0)      NOT NULL CONSTRAINT DF_Tarefa_DataCriacao DEFAULT SYSDATETIME(),
        DataConclusao DATETIME2(0)      NULL,
        CONSTRAINT CK_Tarefa_Status     CHECK (Status IN ('Pendente', 'EmAndamento', 'Concluida')),
        CONSTRAINT CK_Tarefa_Prioridade CHECK (Prioridade BETWEEN 1 AND 5)
    );

    CREATE INDEX IX_Tarefa_Status_DataConclusao ON dbo.Tarefa (Status, DataConclusao) INCLUDE (Prioridade);
END
GO

IF OBJECT_ID('dbo.Usuario', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Usuario (
        Id        INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Usuario PRIMARY KEY,
        Login     VARCHAR(50)       NOT NULL CONSTRAINT UQ_Usuario_Login UNIQUE,
        SenhaHash VARCHAR(64)       NOT NULL,
        Salt      VARCHAR(64)       NOT NULL,
        Ativo     BIT               NOT NULL CONSTRAINT DF_Usuario_Ativo DEFAULT 1
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Usuario WHERE Login = 'admin')
BEGIN
    DECLARE @Salt  VARCHAR(64) = LOWER(REPLACE(CONVERT(VARCHAR(36), NEWID()), '-', ''));
    DECLARE @Senha VARCHAR(50) = 'admin123';

    INSERT INTO dbo.Usuario (Login, SenhaHash, Salt, Ativo)
    VALUES ('admin',
            LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', @Salt + @Senha), 2)),
            @Salt,
            1);
END
GO

SELECT COUNT(*) AS TotalTarefas
  FROM dbo.Tarefa;

SELECT ISNULL(AVG(CAST(Prioridade AS DECIMAL(5, 2))), 0) AS MediaPrioridadePendentes
  FROM dbo.Tarefa
 WHERE Status = 'Pendente';

SELECT COUNT(*) AS ConcluidasUltimos7Dias
  FROM dbo.Tarefa
 WHERE Status = 'Concluida'
   AND DataConclusao >= DATEADD(DAY, -7, SYSDATETIME());
GO
