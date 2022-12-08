
--limpar codigo da lista duplicado nas atividades
call bethadba.dbp_conn_gera(1,2022,301);
update bethadba.economicos_atividades a key join bethadba.ramos_atividades set i_lista_servicos=null
where  i_lista_servicos in (select i_lista_servicos from bethadba.economicos_atividades a2 key join bethadba.ramos_atividades r2 group by i_economicos, i_lista_servicos having count(*)>1 and a2.i_economicos=a.i_economicos);
commit;

--remove caracteres da inscricao estadual
update bethadba.pessoas_juridicas set inscricao_estadual=desbth.dbf_retira_caracteres(inscricao_estadual) where inscricao_estadual is not null; commit;

--codigo ibge inexistente
update bethadba.ruas set i_cidades=null where i_ruas in(811, 886, 1079, 1316, 1322, 1323);
update bethadba.pessoas_enderecos pe key join bethadba.cidades set pe.i_cidades=null, pe.nome_cidade_conv=nome where i_pessoas in (8336, 7676, 8197, 8196, 6340, 8117, 6932, 3907, 5255, 8399, 8251, 6998);
commit;

--porte 0 - nao classificado caso for null
update bethadba.pessoas_juridicas set porte_empresa=0 where porte_empresa is null; commit;

--i_ruas=null  and nome_ruas=null
update bethadba.pessoas_enderecos set nome_rua='NAO INFORMADO' where i_ruas is null and nome_rua is null; commit;





1. Solicitar e avaliar Código tributário(CTM) da entidade e legislações vigentes

Buscar informações, no CTM da entidade, sobre formas de cálculo
2. Solicitar informações sobre acréscimos moratórios, notificações e infrações

Identificar qual o índice e a forma de atualização
3. Processo Fiscal

Quais são os fiscais que atuarão na fiscalização?
Que documentos serão fiscalizados?
Quais são as fontes de divulgação da fiscalização?
Qual tipo de infrações e valores aplicados?
4. Financeiro

Quais são os bancos, agências e convênios utilizados?
Identificar os indexadores
5. Emissão de Guias

Quais documentos de cobrança são utilizados na entidade
Identificar os modelos de cobrança (Registrado, FEBRABAN, etc)
6. Documentos

Levantamento de documentos oficiais, e seus padrões, emitidos pela entidade, conforme códigos vigentes
Identificar quais documentos legais são solicitados nas notificações
7. Será obrigatório vincular o CNAE com o serviço no cadastro da pessoa?

8. Qual lei contempla a lista de serviços utilizada pela entidade?

9. Inteligência fiscal

9.1 Inteligência fiscal para administradoras de cartão

Qual a porcentagem de divergência que deverá aparecer quando o valor do serviço declarado for menor que o valor em cartão?
Considerar como divergência valor de serviço declarado maior que o valor em cartão?
Considerar como divergência valor de serviço declarado igual ao valor em cartão?
9.2 Inteligência fiscal para cartórios

Qual a porcentagem para ser apresentada como divergência quando o valor do serviço declarado for menor que o valor do CNJ?
Considerar como divergência o valor de serviço declarado maior que o valor do CNJ
Considerar como divergência o valor de serviço declarado igual ao valor do CNJ
10. Processo fiscal

10.1 Entenda os prazos para o contribuinte se manifestar em ações fiscais, contencioso tributário, notificação da estimativa fiscal e arbitramentos

Prazo em dias úteis ou corridos para optantes, ou não do simples nacional
Número de dias úteis ou corridos para início do prazo para manifestação após edital e quando data for omitida.
10.2 Contencioso tributário - Atenção: ainda há entregas a serem feitas pelo equipe do produto quanto a esta rotina, por isso não está 100% funcional.

Irá controlar a suspensão do lançamento da impugnação recebida intempestivamente?
É cobrado o valor do litígio para enviar 2.ª. instância? Quanto?
11. Fiscalização orientadora

Prazo em dias úteis ou corridos para optantes, ou não do simples nacional
12. Haverá integração das guias de pagamento?

Guia de ISS
Auto de infração
Estimativa fiscal
Arbitramento


HOMOLOGAÇÃO
1. Cadastro de Pessoas

2. Verificar cadastros gerais

Lista de serviços
Motivos
3. Verificar cadastros de endereços

Bairros, Estados, Logradouros e Municípios
Distritos, Localidades, Loteamentos e condomínios
4. Cadastro financeiro

Bancos, agências e convênios
Competências e indexadores
5. Processos Fiscais

Cadastro de fiscais
Documentos a serem fiscalizados
Ações Fiscais
Infrações e notificações

CONFIGURAR
1. Realizar o cadastramento dos fiscais

2. Informações financeiras, sendo:

Configurar fórmula de cálculo de acréscimos moratórios, notificações e infrações
Configurar fórmula de cálculo do ISS devido
Indexadores
Bancos, agências e convênios
Competências
3. Processo fiscal

Cadastrar/atualizar os documentos a serem fiscalizados
Cadastrar fiscais responsáveis - vincular o cadastro do fiscal ao cadastro de pessoa.
Cadastrar Infrações e notificações
4. Emissão de Guias

Vinculação do convênio às guias de ISS, auto de infração, estimativa fiscal e arbitramento
6. Atualizar obrigatoriedade ou não de vincular o CNAE com o serviço no cadastro da pessoa

6. Selecionar a lei da lista de serviços utilizada pela entidade

7. Configurar parâmetros de Inteligência fiscal para administradoras de cartão

8. Configurar parâmetros de Inteligência fiscal para cartórios

8. Configurar prazos de Processo fiscal para manifestação em ações fiscais, contencioso tributário, notificação da estimativa fiscal e arbitramentos

9. Configurar parâmetros para o contencioso tributário

10. Configurar parâmeros sobre fiscalização orientadora


Ao final do treinamento os usuários precisarão ter conhecimento das seguintes rotinas do sistema:

1 Cadastros

1.1 Cadastramento e manutenção de pessoas

1.2 Realizar manutenção à Lista de serviços

1.3 Cadastramento e manutenção de motivos

1.4 Endereços

Bairros, distritos, estados, localidades, logradouros e municípios
1.5 Financeiro

Bancos, agências e convênios
Competências
Indexadores
1.6 Processo fiscal

Fiscais
Documentos a serem fiscalizados
Fontes de divulgação
Infrações
Entidades
2. Inteligência fiscal

Importação do arquivo PGDAS-D
Análise de resultado fiscal e cadastral do simples nacional
Importação do arquivo de operadoras de cartão
Análise gráfica das informações recebidas.
3. Fiscalização Orientadora

Domicílio tributário - gestão de comunicação
4. Processo fiscal

Adicionar um processo fiscal
Utilizar os instrumentos fiscais - emitir termo de início, emitir intimação, iniciar apuração fiscal, lavrar auto de infração e encerrar ação fiscal)
Controle de instrumentos fiscais - Envio, entrega do documento
Apuração fiscal
Auto de infração
. Emissão de Guias

Guia de ISS
Guia de auto de infração
Guia para estimativa fiscal
Guia para arbitramento


1. Após o treinamento com os servidores, acompanhar os testes com os setores e:

Homologar Cadastros

Pessoas
Lista de serviços
Motivos
Endereços (bairros, distritos, estados, localidades, logradouros e municípios)
Bancos, agências e convênios
Competências
Indexadores
Fiscais
Documentos a serem fiscalizados
Fontes de divulgação
Infrações
Entidades
2. Homologar Inteligência fiscal

Importação do arquivo de movimentação do Simles Nacional
Importação do arquivo de operadoras de cartão
Cruzamento da Receita Bruta do PGDAS-D
Cruzamento da movimentação do Simples Nacional
Análise gráfica das informações recebidas.
3. Homologar Fiscalização Orientadora

4. Homologar Processo fiscal

Abertura de novo processo fiscal
Utilização dos instrumentos fiscais - emitir termo de início, emitir intimação, iniciar apuração fiscal, lavrar auto de infração e encerrar ação fiscal)
Utilização do controle de instrumentos fiscais - Envio, entrega do documento
Notificação Fiscal
Apuração fiscal
Auto de infração
. Emissão de Guias

Guia de ISS
Guia de auto de infração
Guia para estimativa fiscal
Guia para arbitramento

1. Garantir que o sistema esteja com as configurações idênticas as utilizadas na homologação, sendo:

Garantir que os usuários tenham realizado seu primeiro acesso e configurados com seus respectivos direitos de acesso
Garantir que as configurações financeiras estejam adequadamente configuradas
Garantir que os documentos oficiais estejam disponibilizados
Garantir emissão das guias
Garantir o resultado das fórmulas estejam de acordo
2. Garantir que o sistema seja integrado com

A fase de integração só deverá ser iniciada após as validações dos cálculos das fórmulas
Configurar integração com e-Nota / Livro eletrônico
Configurar integração com Tributos Cloud
Configurar Cadastro Único
3 . Disponibilizar relatórios customizados, se necessário.





