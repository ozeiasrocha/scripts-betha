--- migração CM Rodrigues
restos? empenho parcialmente pago?
colocar arqjob de diaria pra executar na sequencia de exercicio
sapo - relacao de empenhos (empenhos a pagar)



homologacao status: dd656122-7fe7-4aa6-b4fc-c6fca892d850 ]
homologacao fundo : f02fbfcd-b8ab-410b-ad1d-0deb3cce23d0 

HOMOLOGAÇÃO JORDÃO
entidade: 9290
database: 8356
token prefeitura:  c9475b69-0885-499e-8f64-9eb650b5d626
token fundo:     

--para consulta concorrente na base durante a migração no sybase: 
SET TEMPORARY OPTION isolation_level = 0;
call bethadba.dbp_conn_gera(1,2022,1);

apaga registros da tabela de controle antes de reenviar o arqjob
delete bethadba.controle_migracao_registro_ocor where situacao<>3;

update  bethadba.pessoas_fisicas set cpf=null where cpf like'999%';
select * from bethadba.pessoas key join bethadba.pessoas_fisicas where tipo_pessoa<>'O' and cpf is null;
select * from bethadba.pessoas key join bethadba.pessoas_juridicas where tipo_pessoa<>'O' and cnpj is null;

*** migrar credores de anos anteriores ***
*** migrar o planejamento em ordem crescente e sancionar todas as LOAs ***

tabela controle_migracao_registro_ocor: (1 - resolvido, 2- nao resolvido) está na descricao dos campos da tabela
empenhos: chave_dsk6


-- ConfiguracaoMigracao
/* modelo Acre */
vetor("tipo",     1,2);
vetor("descricao",1,"Grupo");
vetor("digitos",  1,1);

vetor("tipo",     2,5);
vetor("descricao",2,"Especificação TCE");
vetor("digitos",  2,2);

vetor("tipo",     3,6);
vetor("descricao",3,"Detalhamento do Recurso");
vetor("digitos",  3,2);

@gaEnumRecSuperavit = 'true';
@giDuplicidadeCredor = 2;

@gaDescricaoPrincipalRecurso = 'especificacao_tce.descricao';


call bethadba.pg_habilitartriggers('off');
select (select top 1 i_tipo_deducao from sapo.tipo_deducao t where t.tipo_stn=9 and t.ano_exerc=r.ano_exerc and t.i_entidades=r.i_entidades) tipo_ded,* from sapo.receitas r key join sapo.tipo_deducao d  where left(i_rubricas,1)=9;
update sapo.receitas r key join sapo.tipo_deducao d set r.i_tipo_deducao=(select top 1 i_tipo_deducao from sapo.tipo_deducao t where t.tipo_stn=9 and t.ano_exerc=r.ano_exerc and t.i_entidades=r.i_entidades) where left(i_rubricas,1)=9;


update bethadba.hist_rec_loa set i_tipos_deducoes_rec=95 where i_tipos_deducoes_rec=0;
select * from bethadba.tipos_deducoes_rec
update bethadba.rec_loa set i_tipos_deducoes_rec=95 where i_tipos_deducoes_rec=0;


--Planejamento, LOA, utilitarios, cloud: organogramas, alimenta parametros cloud,  atualiza tipos de dedução (somente prefeitura)


--SAPO, Financeiro, utilitarios, cloud: organogramas, bloqueios/desbloqueios



--verificar inconsistencias 
select * from bethadba.controle_migracao_registro_ocor where id_gerado is null
--conversor -> limpa ocorrencias (tipo_registro)

--Rodar configurações
--Rodar ParametrosOrçamentários
--Rodar ParamentrosEscrituração

--Colocar configurações EM USO (receita, despesa, funcional, organogramas, recurso, plano de contas
--Rodar PPA, LDO, LOA

--RECURSOS 
--Sapo/Utilitarios, sincronização.*/


(SAPO) -> (Contabil cloud)

--*** credores - verificar se subiram todos!

--*** sancionar a LOA antes de começar ***
--*** se tiver restos sancionar a LOA do exercicio anterior ***
--*** Retenções? pode travar a migração
--*** Tem que ter naturezas no primeiro exercício do PPA


--contasContabeis
-- [A conta contábil 4.6.2.9.0.00.00.00.00.000000 deve registrar qual sua conta de nível inferior]
-- criar as contas de nivel superior no plano de contas de acordo com o TCE
-- http://sistemas.tce.ac.gov.br/portaldogestor/referencias/contaContabil.xhtml


--dataSaldoInicial
--[Não é permitido mais de uma data de lançamento de abertura por ano e plano de contas]
--rodar novamente o arqjob


--ConfigContaCorrenteBUSCA
-- solicitar a betha orquestracao: cadastros necessários e padrões do sistema (Replicação, eventos, regras, conta corrente, componentes)
--  Eventos Contábeis, Regras de Documentos, Contas Correntes, Componentes, Equivalências e Itens de Equivalência

--eventosDocumentos (sem ID) -  situacao: 4 - Pendente de retorno
--rodar betha conversor
--criei o evento 999927 - Evento padrão migração D Sequencial 27


