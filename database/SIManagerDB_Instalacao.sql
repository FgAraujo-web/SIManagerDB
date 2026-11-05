/* PontoTec | SIManagerDB | Dados totalmente fictícios
   SQL Server 2019+ | Executar numa instância de desenvolvimento.
   Segurança: nunca substitui uma base de dados existente. */
-- REQUER SSMS em SQLCMD Mode (Query > SQLCMD Mode), ou sqlcmd.
-- Interrompe os lotes seguintes quando ocorrer um erro.
:ON ERROR EXIT

USE master;
GO
IF DB_ID(N'SIManagerDB') IS NOT NULL
    THROW 50001, 'SIManagerDB ja existe. A instalacao foi interrompida para proteger os dados.', 1;
GO
CREATE DATABASE SIManagerDB;
GO
USE SIManagerDB;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
-- A transacao protege a criacao das tabelas e o povoamento.
-- CREATE DATABASE permanece fora da transacao (exigencia SQL Server).
BEGIN TRANSACTION;
GO

CREATE TABLE dbo.Departamento (
 DepartamentoId int IDENTITY(1,1) CONSTRAINT PK_Departamento PRIMARY KEY,
 Nome nvarchar(100) NOT NULL CONSTRAINT UQ_Departamento_Nome UNIQUE,
 Ativo bit NOT NULL CONSTRAINT DF_Departamento_Ativo DEFAULT (1)
);
CREATE TABLE dbo.Equipa (
 EquipaId int IDENTITY(1,1) CONSTRAINT PK_Equipa PRIMARY KEY,
 DepartamentoId int NOT NULL REFERENCES dbo.Departamento(DepartamentoId),
 Nome nvarchar(100) NOT NULL CONSTRAINT UQ_Equipa_Nome UNIQUE
);
CREATE TABLE dbo.Utilizador (
 UtilizadorId int IDENTITY(1,1) CONSTRAINT PK_Utilizador PRIMARY KEY,
 DepartamentoId int NOT NULL REFERENCES dbo.Departamento(DepartamentoId),
 Nome nvarchar(120) NOT NULL,
 Email varchar(150) NOT NULL CONSTRAINT UQ_Utilizador_Email UNIQUE,
 Ativo bit NOT NULL CONSTRAINT DF_Utilizador_Ativo DEFAULT (1)
);
CREATE TABLE dbo.Tecnico (
 TecnicoId int IDENTITY(1,1) CONSTRAINT PK_Tecnico PRIMARY KEY,
 UtilizadorId int NOT NULL CONSTRAINT UQ_Tecnico_Utilizador UNIQUE REFERENCES dbo.Utilizador(UtilizadorId),
 EquipaId int NOT NULL REFERENCES dbo.Equipa(EquipaId),
 NivelSuporte tinyint NOT NULL CONSTRAINT CK_Tecnico_Nivel CHECK (NivelSuporte BETWEEN 1 AND 3)
);
CREATE TABLE dbo.Aplicacao (
 AplicacaoId int IDENTITY(1,1) CONSTRAINT PK_Aplicacao PRIMARY KEY,
 Nome nvarchar(120) NOT NULL CONSTRAINT UQ_Aplicacao_Nome UNIQUE,
 Descricao nvarchar(300) NULL,
 DepartamentoResponsavelId int NOT NULL REFERENCES dbo.Departamento(DepartamentoId),
 Criticidade varchar(10) NOT NULL CONSTRAINT CK_Aplicacao_Criticidade CHECK (Criticidade IN ('Baixa','Media','Alta','Critica')),
 Estado varchar(12) NOT NULL CONSTRAINT CK_Aplicacao_Estado CHECK (Estado IN ('Ativa','Manutencao','Desativada'))
);
CREATE TABLE dbo.ModuloAplicacao (
 ModuloId int IDENTITY(1,1) CONSTRAINT PK_Modulo PRIMARY KEY,
 AplicacaoId int NOT NULL REFERENCES dbo.Aplicacao(AplicacaoId),
 Nome nvarchar(100) NOT NULL,
 CONSTRAINT UQ_Modulo_Aplicacao_Nome UNIQUE (AplicacaoId, Nome)
);
CREATE TABLE dbo.VersaoAplicacao (
 VersaoId int IDENTITY(1,1) CONSTRAINT PK_Versao PRIMARY KEY,
 AplicacaoId int NOT NULL REFERENCES dbo.Aplicacao(AplicacaoId),
 NumeroVersao varchar(20) NOT NULL,
 DataLancamento date NOT NULL,
 CONSTRAINT UQ_Versao_Aplicacao_Numero UNIQUE (AplicacaoId, NumeroVersao)
);
CREATE TABLE dbo.Fornecedor (
 FornecedorId int IDENTITY(1,1) CONSTRAINT PK_Fornecedor PRIMARY KEY,
 Nome nvarchar(120) NOT NULL CONSTRAINT UQ_Fornecedor_Nome UNIQUE,
 Email varchar(150) NOT NULL
);
CREATE TABLE dbo.Contrato (
 ContratoId int IDENTITY(1,1) CONSTRAINT PK_Contrato PRIMARY KEY,
 FornecedorId int NOT NULL REFERENCES dbo.Fornecedor(FornecedorId),
 AplicacaoId int NOT NULL REFERENCES dbo.Aplicacao(AplicacaoId),
 Referencia varchar(30) NOT NULL CONSTRAINT UQ_Contrato_Referencia UNIQUE,
 DataInicio date NOT NULL,
 DataFim date NOT NULL,
 ValorAnual decimal(12,2) NOT NULL CONSTRAINT CK_Contrato_Valor CHECK (ValorAnual >= 0),
 CONSTRAINT CK_Contrato_Datas CHECK (DataFim > DataInicio)
);
CREATE TABLE dbo.Licenca (
 LicencaId int IDENTITY(1,1) CONSTRAINT PK_Licenca PRIMARY KEY,
 ContratoId int NOT NULL REFERENCES dbo.Contrato(ContratoId),
 Codigo varchar(30) NOT NULL CONSTRAINT UQ_Licenca_Codigo UNIQUE,
 Quantidade int NOT NULL CONSTRAINT CK_Licenca_Quantidade CHECK (Quantidade > 0),
 DataExpiracao date NOT NULL
);
CREATE TABLE dbo.PoliticaSLA (
 SLAId int IDENTITY(1,1) CONSTRAINT PK_SLA PRIMARY KEY,
 Prioridade varchar(10) NOT NULL CONSTRAINT UQ_SLA_Prioridade UNIQUE,
 HorasResolucao int NOT NULL CONSTRAINT CK_SLA_Horas CHECK (HorasResolucao > 0)
);
CREATE TABLE dbo.Incidente (
 IncidenteId int IDENTITY(1,1) CONSTRAINT PK_Incidente PRIMARY KEY,
 AplicacaoId int NOT NULL REFERENCES dbo.Aplicacao(AplicacaoId),
 AbertoPorId int NOT NULL REFERENCES dbo.Utilizador(UtilizadorId),
 TecnicoId int NULL REFERENCES dbo.Tecnico(TecnicoId),
 SLAId int NOT NULL REFERENCES dbo.PoliticaSLA(SLAId),
 Titulo nvarchar(200) NOT NULL,
 Estado varchar(12) NOT NULL CONSTRAINT CK_Incidente_Estado CHECK (Estado IN ('Aberto','EmAnalise','Resolvido','Fechado')),
 DataAbertura datetime2(0) NOT NULL,
 DataResolucao datetime2(0) NULL,
 CONSTRAINT CK_Incidente_Datas CHECK (DataResolucao IS NULL OR DataResolucao >= DataAbertura),
 CONSTRAINT CK_Incidente_EstadoResolucao CHECK (
   (Estado IN ('Aberto','EmAnalise') AND DataResolucao IS NULL)
   OR (Estado IN ('Resolvido','Fechado') AND DataResolucao IS NOT NULL))
);
CREATE TABLE dbo.PedidoServico (
 PedidoId int IDENTITY(1,1) CONSTRAINT PK_Pedido PRIMARY KEY,
 AplicacaoId int NOT NULL REFERENCES dbo.Aplicacao(AplicacaoId),
 SolicitanteId int NOT NULL REFERENCES dbo.Utilizador(UtilizadorId),
 TecnicoId int NULL REFERENCES dbo.Tecnico(TecnicoId),
 Tipo varchar(20) NOT NULL CONSTRAINT CK_Pedido_Tipo CHECK (Tipo IN ('Acesso','Configuracao','Informacao','Instalacao')),
 Estado varchar(12) NOT NULL CONSTRAINT CK_Pedido_Estado CHECK (Estado IN ('Aberto','EmCurso','Concluido')),
 DataPedido datetime2(0) NOT NULL
);
CREATE TABLE dbo.Intervencao (
 IntervencaoId int IDENTITY(1,1) CONSTRAINT PK_Intervencao PRIMARY KEY,
 IncidenteId int NOT NULL REFERENCES dbo.Incidente(IncidenteId),
 TecnicoId int NOT NULL REFERENCES dbo.Tecnico(TecnicoId),
 DataIntervencao datetime2(0) NOT NULL,
 MinutosGastos int NOT NULL CONSTRAINT CK_Intervencao_Minutos CHECK (MinutosGastos BETWEEN 1 AND 1440),
 Descricao nvarchar(200) NOT NULL
);
CREATE TABLE dbo.Alteracao (
 AlteracaoId int IDENTITY(1,1) CONSTRAINT PK_Alteracao PRIMARY KEY,
 AplicacaoId int NOT NULL REFERENCES dbo.Aplicacao(AplicacaoId),
 TecnicoId int NOT NULL REFERENCES dbo.Tecnico(TecnicoId),
 Tipo varchar(15) NOT NULL CONSTRAINT CK_Alteracao_Tipo CHECK (Tipo IN ('Corretiva','Evolutiva','Preventiva')),
 Estado varchar(12) NOT NULL CONSTRAINT CK_Alteracao_Estado CHECK (Estado IN ('Planeada','Executada','Cancelada')),
 DataAlteracao datetime2(0) NOT NULL,
 Descricao nvarchar(200) NOT NULL
);
GO

INSERT dbo.Departamento (Nome) VALUES
(N'Sistemas de Informacao'),(N'Financeira'),(N'Recursos Humanos'),(N'Comercial'),
(N'Operacoes'),(N'Compras'),(N'Juridico'),(N'Qualidade'),
(N'Planeamento'),(N'Atendimento'),(N'Logistica'),(N'Direcao');
INSERT dbo.Equipa (DepartamentoId,Nome) VALUES
(1,N'Suporte Aplicacional'),(1,N'Engenharia de Dados'),(1,N'Infraestruturas'),
(1,N'Desenvolvimento'),(1,N'Seguranca'),(1,N'Integracoes'),
(5,N'Operacoes de Negocio'),(10,N'Suporte ao Utilizador'),
(1,N'Arquitetura'),(1,N'Gestao de Servicos');
INSERT dbo.PoliticaSLA(Prioridade,HorasResolucao) VALUES
('P1',4),('P2',8),('P3',24),('P4',72);

-- Sequencia de numeros reutilizavel em memoria para povoamento set-based.
CREATE TABLE #N (n int NOT NULL PRIMARY KEY);
;WITH D AS (SELECT 0 AS d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9),
N AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM D a CROSS JOIN D b CROSS JOIN D c CROSS JOIN D d CROSS JOIN D e)
INSERT #N(n) SELECT n FROM N WHERE n <= 50000;

INSERT dbo.Utilizador(DepartamentoId,Nome,Email)
SELECT (n%12)+1, CONCAT(N'Utilizador Ficticio ',RIGHT(CONCAT('0000',n),4)), CONCAT('utilizador',n,'@example.com')
FROM #N WHERE n<=600;
INSERT dbo.Tecnico(UtilizadorId,EquipaId,NivelSuporte)
SELECT n, (n%10)+1, (n%3)+1 FROM #N WHERE n<=120;
INSERT dbo.Aplicacao(Nome,Descricao,DepartamentoResponsavelId,Criticidade,Estado)
SELECT CONCAT(N'Aplicacao Empresarial ',RIGHT(CONCAT('00',n),2)),
 CONCAT(N'Sistema de informacao ficticio ',n), (n%12)+1,
 CASE n%4 WHEN 0 THEN 'Critica' WHEN 1 THEN 'Alta' WHEN 2 THEN 'Media' ELSE 'Baixa' END,
 CASE WHEN n%13=0 THEN 'Manutencao' ELSE 'Ativa' END
FROM #N WHERE n<=25;
INSERT dbo.ModuloAplicacao(AplicacaoId,Nome)
SELECT ((n-1)/3)+1, CONCAT(N'Modulo ',((n-1)%3)+1) FROM #N WHERE n<=75;
INSERT dbo.VersaoAplicacao(AplicacaoId,NumeroVersao,DataLancamento)
SELECT ((n-1)/4)+1, CONCAT('v',((n-1)%4)+1,'.0'),
 DATEADD(DAY, (n*23)%1100,CONVERT(date,'2022-01-01')) FROM #N WHERE n<=100;
INSERT dbo.Fornecedor(Nome,Email)
SELECT CONCAT(N'Fornecedor Ficticio ',n), CONCAT('fornecedor',n,'@example.com') FROM #N WHERE n<=30;
INSERT dbo.Contrato(FornecedorId,AplicacaoId,Referencia,DataInicio,DataFim,ValorAnual)
SELECT (n%30)+1,(n%25)+1,CONCAT('CT-',RIGHT(CONCAT('0000',n),4)),
 DATEADD(DAY,(n*19)%900,CONVERT(date,'2023-01-01')),
 DATEADD(DAY,365+(n%4)*180,DATEADD(DAY,(n*19)%900,CONVERT(date,'2023-01-01'))),
 CONVERT(decimal(12,2),2000+(n*137)%40000) FROM #N WHERE n<=60;
INSERT dbo.Licenca(ContratoId,Codigo,Quantidade,DataExpiracao)
SELECT ((n-1)%60)+1,CONCAT('LIC-',RIGHT(CONCAT('0000',n),4)),5+(n*7)%250,
 DATEADD(DAY,365+(n%4)*180,DATEADD(DAY,((((n-1)%60)+1)*19)%900,CONVERT(date,'2023-01-01')))
FROM #N WHERE n<=120;

-- Padrões deterministas: aproximadamente 20% abertos, 20% em analise,
-- 30% resolvidos e 30% fechados. SLA inclui casos cumpridos e excedidos.
INSERT dbo.Incidente(AplicacaoId,AbertoPorId,TecnicoId,SLAId,Titulo,Estado,DataAbertura,DataResolucao)
SELECT (n%25)+1,(n%600)+1,CASE WHEN n%11=0 THEN NULL ELSE (n%120)+1 END,
 (n%4)+1, CONCAT(N'Incidente simulado #',n,N' - falha aplicacional'),
 CASE WHEN n%10<2 THEN 'Aberto' WHEN n%10<4 THEN 'EmAnalise' WHEN n%10<7 THEN 'Resolvido' ELSE 'Fechado' END,
 DATEADD(MINUTE,(n*37)%1440,DATEADD(DAY,(n*13)%1000,CONVERT(datetime2(0),'2023-01-01'))),
 CASE WHEN n%10<4 THEN NULL ELSE
 DATEADD(HOUR,CASE WHEN n%6=0 THEN 96 WHEN n%6=1 THEN 48 WHEN n%6=2 THEN 18 ELSE 2+(n%5) END,
 DATEADD(MINUTE,(n*37)%1440,DATEADD(DAY,(n*13)%1000,CONVERT(datetime2(0),'2023-01-01')))) END
FROM #N;
INSERT dbo.PedidoServico(AplicacaoId,SolicitanteId,TecnicoId,Tipo,Estado,DataPedido)
SELECT (n%25)+1,(n%600)+1,CASE WHEN n%9=0 THEN NULL ELSE (n%120)+1 END,
 CASE n%4 WHEN 0 THEN 'Acesso' WHEN 1 THEN 'Configuracao' WHEN 2 THEN 'Informacao' ELSE 'Instalacao' END,
 CASE n%3 WHEN 0 THEN 'Aberto' WHEN 1 THEN 'EmCurso' ELSE 'Concluido' END,
 DATEADD(DAY,(n*17)%1000,CONVERT(datetime2(0),'2023-01-01'))
FROM #N WHERE n<=12000;
INSERT dbo.Intervencao(IncidenteId,TecnicoId,DataIntervencao,MinutosGastos,Descricao)
SELECT ((n*7)%50000)+1,(n%120)+1,
 DATEADD(HOUR,1,DATEADD(MINUTE,(((n*7)%50000)+1)*37%1440,
 DATEADD(DAY,(((n*7)%50000)+1)*13%1000,CONVERT(datetime2(0),'2023-01-01')))),
 10+(n*13)%240,CONCAT(N'Diagnostico e intervencao ficticia #',n)
FROM #N WHERE n<=25000;
INSERT dbo.Alteracao(AplicacaoId,TecnicoId,Tipo,Estado,DataAlteracao,Descricao)
SELECT (n%25)+1,(n%120)+1,
 CASE n%3 WHEN 0 THEN 'Corretiva' WHEN 1 THEN 'Evolutiva' ELSE 'Preventiva' END,
 CASE n%4 WHEN 0 THEN 'Planeada' WHEN 1 THEN 'Cancelada' ELSE 'Executada' END,
 DATEADD(DAY,(n*29)%1000,CONVERT(datetime2(0),'2023-01-01')),
 CONCAT(N'Alteracao aplicacional ficticia #',n)
FROM #N WHERE n<=8000;
DROP TABLE #N;
COMMIT TRANSACTION;
GO
PRINT 'SIManagerDB instalada com sucesso. Execute SIManagerDB_Validacao.sql.';
GO
