# SIManagerDB — Laboratório SQL Server

Base de dados **inteiramente fictícia** para a série Hands-On SQL Server do PontoTec.

## Instalação

1. Abrir o SQL Server Management Studio (SSMS) e ligar a uma instância SQL Server 2019 ou posterior.
2. Abrir `SIManagerDB_Instalacao.sql`.
3. Executar o script completo (F5). **Atenção:** o script recusa executar se já existir uma base `SIManagerDB`, para proteger dados existentes.
4. Abrir `SIManagerDB_Validacao.sql` e executar para consultar contagens e exemplos.

## Volume previsto

- 12 departamentos, 10 equipas, 600 utilizadores e 120 técnicos.
- 25 aplicações, 75 módulos e 100 versões.
- 30 fornecedores, 60 contratos e 120 licenças.
- 50 000 incidentes, 12 000 pedidos de serviço, 25 000 intervenções e 8 000 alterações.

Todos os nomes, emails, fornecedores e eventos são simulados. Emails utilizam `example.com`.

## Conteúdo

- `SIManagerDB_Instalacao.sql`: criação da base, modelo relacional, constraints, dados e índices de suporte à integridade.
- `SIManagerDB_Validacao.sql`: verificações de volume, integridade e consultas de demonstração.

## Nota didática

Não são criados índices adicionais para acelerar consultas analíticas: essa será a matéria do Hands-On #07. As PK e UNIQUE criam os seus índices necessários. A base não contém dados pessoais reais.

## Compatibilidade

SQL Server 2019+; execução recomendada numa instância de desenvolvimento, não em produção. A criação de 95 mil+ registos pode demorar alguns minutos dependendo do computador.
