# SIManagerDB — Gestão de Serviços e Aplicações

**Ponto de Conhecimento Tecnológico | Série Hands-On #02 — SQL Server**

**Explorar • Experimentar • Aprender • Partilhar**

## Sobre o projeto

A **SIManagerDB** é uma base de dados relacional fictícia, desenvolvida em SQL Server, que simula o ecossistema de Sistemas de Informação de uma organização de média/grande dimensão.

O projeto foi criado para demonstrar, através de exercícios práticos, conceitos de modelação de dados, consultas SQL, otimização de desempenho, gestão de transações, concorrência e auditoria.

Os dados são fictícios e destinam-se exclusivamente a fins educativos e de experimentação técnica.

## Estrutura da base de dados

A SIManagerDB contempla cinco áreas funcionais:

- **Aplicações:** sistemas empresariais, módulos, versões e criticidade.
- **Organização:** departamentos, utilizadores e equipas técnicas.
- **Service Management:** incidentes, pedidos de serviço, prioridades e níveis de serviço.
- **Contratos:** fornecedores, contratos, licenças e renovações.
- **Operações:** intervenções, alterações e histórico.

O modelo inicial contém **15 tabelas e 21 relacionamentos**, incluindo dados de teste com aproximadamente 50 000 incidentes.

## Série Hands-On #02 — SQL Server

| Módulo | Tema | Estado |
|---|---|---|
| #05 | Modelação de Dados e Constraints | Concluído |
| #06 | Joins, CTEs e Window Functions | Concluído |
| #07 | Índices e Otimização de Consultas | Concluído |
| #08 | Transações, Concorrência e Deadlocks | Concluído |
| #09 | Auditoria de Dados com Triggers e Tabelas Temporais | Concluído |

### HANDS-ON #05 — Modelação de Dados e Constraints

Exploração do modelo relacional, chaves primárias e estrangeiras, restrições de integridade e validação de regras de consistência.

### HANDS-ON #06 — Joins, CTEs e Window Functions

Seis exercícios práticos com INNER JOIN, LEFT JOIN, CTEs, agregações e funções de janela, incluindo ROW_NUMBER, RANK, DENSE_RANK, SUM OVER, LAG e LEAD.

### HANDS-ON #07 — Índices e Otimização de Consultas

Análise de planos de execução, índices e estatísticas de desempenho.

Num dos testes, a utilização de um índice de cobertura permitiu reduzir as leituras lógicas de **928 para 35**, uma redução aproximada de **96,2%**.

### HANDS-ON #08 — Transações, Concorrência e Deadlocks

Oito exercícios sobre controlo transacional, tratamento de erros, níveis de isolamento, bloqueios, concorrência e deadlocks.

Inclui a reprodução de um deadlock (erro 1205) e a análise de esperas de bloqueio.

### HANDS-ON #09 — Auditoria de Dados com Triggers e Tabelas Temporais

Oito exercícios de auditoria e histórico temporal, incluindo:

- Triggers AFTER INSERT, UPDATE e DELETE.
- Registo de alterações com valores anteriores e novos em JSON.
- Auditoria de operações sobre múltiplos registos.
- Tabelas temporais com SYSTEM_VERSIONING.
- Consultas FOR SYSTEM_TIME AS OF, BETWEEN e ALL.

**Resultados:** 3 triggers, 12 registos de auditoria e 3 versões temporais de um incidente.

## Estrutura do repositório

```text
SIManagerDB/
├── database/
├── hands-on-05/
├── hands-on-06/
├── hands-on-07/
├── hands-on-08/
├── hands-on-09/
├── ReportPowerBI/
│   ├── SIManagerDB_Documentacao_Tecnica_PowerBI.pdf
│   ├── SIManagerDB_Relatorio01_GestaoIncidentes_final.pbix
│   └── SIManagerDB_Relatorio01_GestaoIncidentes_final.pdf
├── .gitignore
├── README.md
└── Serie_2_SQL_Server_Extras_PowerBI_Atualizado.html
```

Cada módulo reúne os respetivos materiais técnicos, incluindo scripts SQL e documentação.

## Como começar

1. Instalar o Microsoft SQL Server e o SQL Server Management Studio (SSMS).
2. Consultar a pasta `database/` para preparar a SIManagerDB.
3. Executar os scripts de instalação e validação pela ordem documentada.
4. Explorar os exercícios dos módulos #05 a #09.
5. Consultar `ReportPowerBI/` para aceder aos relatórios e à documentação Power BI.

Os laboratórios foram desenvolvidos e validados com SQL Server 2019 Express.

## Mapa interativo da Série 2

Consulte o percurso técnico completo e os resultados dos cinco HANDS-ON:

**[Abrir o mapa interativo — Série 2 SQL Server](https://fgaraujo-web.github.io/SIManagerDB/Serie_2_SQL_Server_Extras_PowerBI_Atualizado.html)**

## Extensão concluída — Relatórios Power BI

Como complemento à Série 2 — SQL Server, foi desenvolvido um relatório interativo em **Microsoft Power BI Desktop**, baseado nos dados fictícios da SIManagerDB. O ficheiro `.pbix` contém **quatro páginas analíticas**, com um modelo semântico composto por seis tabelas, cinco relações ativas e 20 medidas DAX documentadas.

### Páginas do relatório

| Página | Objetivo |
|---|---|
| **Incidentes** | Monitorizar volumes, estados, evolução mensal, tempos de resolução e cumprimento de SLA. |
| **Aplicações** | Analisar o portefólio, estados, criticidade e aplicações com mais incidentes. |
| **Equipas Técnicas** | Analisar incidentes atribuídos, técnicos e distribuição por equipa. |
| **Visão Executiva** | Consolidar os principais indicadores e tendências para consulta de gestão. |

### Tecnologias e funcionalidades

- **SQL Server:** origem dos dados operacionais fictícios.
- **Power BI Desktop:** construção e apresentação do relatório.
- **Modelo de dados:** tabelas de incidentes, aplicações, técnicos, equipas, políticas SLA e calendário.
- **DAX:** medidas para contagens, rankings, tempos médios e cumprimento de SLA.
- **Interatividade:** segmentadores de ano e estado e navegação entre páginas.

### Ficheiros disponíveis

- **[Relatório Power BI (.pbix)](ReportPowerBI/SIManagerDB_Relatorio01_GestaoIncidentes_final.pbix)** — ficheiro editável com as quatro páginas.
- **[Exportação do relatório (.pdf)](ReportPowerBI/SIManagerDB_Relatorio01_GestaoIncidentes_final.pdf)** — versão estática para consulta.
- **[Documentação técnica (.pdf)](ReportPowerBI/SIManagerDB_Documentacao_Tecnica_PowerBI.pdf)** — arquitetura, relações, medidas DAX, relatórios, testes e evolução futura.

### Como explorar

1. Preparar a base de dados fictícia com os materiais de `database/`.
2. Abrir o ficheiro `.pbix` no Power BI Desktop.
3. Se necessário, configurar a ligação à instância local do SQL Server e atualizar as credenciais da origem.
4. Atualizar os dados e explorar as quatro páginas e os respetivos filtros.
5. Consultar a documentação técnica para compreender o modelo e as regras de cálculo.

> **Nota:** os dados são simulados e destinam-se a fins educativos. A exportação PDF não conserva a interatividade do Power BI. A configuração da origem de dados pode necessitar de adaptação ao ambiente de cada utilizador.

**Estado:** extensão Power BI desenvolvida e disponibilizada no repositório.

---

**Ponto de Conhecimento Tecnológico**

*Explorar • Experimentar • Aprender • Partilhar*
