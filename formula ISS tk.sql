/* -- Fórmula de Lançamento para receita de  200-Imposto Sobre Serviço de Qualquer Natureza referente Exercício de 2013*/
%%	w_codigo        ---> Código de referência que está sendo calculado (Imóvel / Econômico / Pedido / Melhoria / etc)
%%	w_refer         ---> Código do imóvel no caso de Contribuição de Melhoriar ou Código da Publicidade
%%	w_parc_ini      ---> Nº da parcela Inicial 
%%	w_parc_fin      ---> Nº da parcela Final 
%%	w_receita       ---> Passa a Receita Principal
%%	w_ano           ---> Passa o ano que será Calculado
%%	w_config        ---> Configuração informada na Janela de Calculo
%%	w_npar          ---> Passa o Número de Parcela a serem geradas, caso não tenha Parâmetros das Parcelas
%%	w_moeda         ---> Passa o Código da moeda
%%  w_venc_ini      ---> Vcto Inicial
%%  w_dias          ---> dias vcto
%%  w_antecip       ---> Antecipa
%%  w_simula        ---> Simulado
%%  w_notifica      ---> Será notificado após a geração
%%  w_complementa   ---> Complementar
%%  w_unidade       ---> Unidade
%%  w_atos          ---> Passa o código do Lei/Ato 

DECLARE tipo_eco            CHAR(1);
DECLARE pessoa              INTEGER;
DECLARE ativ_principal      INTEGER;
DECLARE iss_fixo            DECIMAL(15,4);
DECLARE ufm                 DECIMAL(15,4);
DECLARE eh_optante_simples  CHAR(1);  
DECLARE w_porte_emp     INTEGER;    
DECLARE w_isento        INTEGER;

%%***********************************************************************************************************************************************
%%                                                                                                                                             **
%% ISS FIXO SERÁ CALCULADO COM BASE NA LISA DE SERVIÇOS ANEXA AO CÓDIGO TRIBUTÁRIO                                                             **
%% ONDE O VALOR DE CADA ATIVIDADE DEVERÁ ESTAR INFORMADO NO CAMPO 299 NO CADASTRO DE ATIVIDADES, O VALOR NA ATIVIDADE É EM UFM                 **
%% O ISS HOMOLOGADO SERÁ CALCULADO GERANDO AS 12 PARCELAS ZERADAS, DEVENDO SER FEITO O LANÇAMENTO POR PARCELA DE ACORDO COM AS COMPETÊNCIAS    **
%%                                                                                                                                             **
%%*********************************************************************************************************************************************


%%Seleciona o tipo do economico, H - Homologado ou F- fixo.
SELECT i_pessoas,tipo INTO pessoa,tipo_eco FROM bethadba.economicos WHERE i_economicos=w_codigo;

%%Busca o valor da UFM
SET ufm=dbf_fc_valor_idx(2,today(*)); 

%% busca porte da empresa
SELECT porte_empresa INTO w_porte_emp FROM bethadba.pessoas_juridicas, bethadba.economicos
WHERE pessoas_juridicas.i_pessoas = economicos.i_pessoas AND economicos.i_economicos = w_codigo;

IF w_porte_emp = 5 THEN
   SET w_isento = 4;
END IF;   

IF tipo_eco='F' THEN
  
  %%Busca a atividade principal. 
  SET ativ_principal=dbf_fc_ret_ativ_principal(w_codigo); 
  
  %%Busca o valor no cadastro da atividade
  SET iss_fixo=dbf_fc_retbca_valor(ativ_principal,299,dbf_ano_base(ativ_principal, w_ano, 299, 'opcoes_bca'));
  SET iss_fixo=iss_fixo*ufm;
   
%%Criando a receita do iss fixo  
SET ret=dbf_fc_cria_rec(202,iss_fixo, 2,NULL);
%%****************************************************************************************************************

ELSEIF tipo_eco='H'THEN 
  
  %%Verifica se é optante pelo simples e não calcula o imposto.
  SET eh_optante_simples = dbf_eh_optantesimplesnac(pessoa, today(*));
  
  IF (eh_optante_simples = 'S') THEN
     RAISERROR 17000 'Optante pelo Simples Nacional, não Calculado!'
  END IF; 

%%Cria as parcelas zeradas  
SET ret=dbf_fc_cria_rec_aliq(1,201,1,NULL, 1);  

%%*****************************************************************************************************************

%%Econômicos enquadados como outros, não geram calculo   
ELSEIF tipo_eco='O' THEN
   RAISERROR 17000 'Economico do tipo "Outros", não calculado.' 

END IF;                    
