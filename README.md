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

Os laboratórios foram desenvolvidos e validados com SQL Server 2019 Express.

## Mapa interativo da Série 2

Consulte o percurso técnico completo, os resultados dos cinco HANDS-ON e a próxima extensão em Power BI:

**[Abrir o mapa interativo — Série 2 SQL Server](https://fgaraujo-web.github.io/SIManagerDB/Serie_2_SQL_Server_Extras_PowerBI_Atualizado.html)**

## Próxima extensão — Power BI Analytics

Está prevista uma extensão prática para transformar os dados operacionais da SIManagerDB em relatórios analíticos, através de Power Query, modelação de dados e DAX.

Os quatro relatórios propostos são:

1. Gestão de Incidentes.
2. Portefólio Aplicacional.
3. Operação e Suporte Técnico.
4. Contratos e Licenciamento.

**Estado:** proposta por desenvolver.

---

**Ponto de Conhecimento Tecnológico**

*Explorar • Experimentar • Aprender • Partilhar*
