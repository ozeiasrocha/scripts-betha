 /* -- Fórmula de Lançamento para receita de  200-Imposto sobre Serviços de Qualquer Natureza referente Exercício de 2009*/
%%	w_codigo        ---> Código de referência que está sendo calculado (Imóvel / Econômico / Pedido / Melhoria / etc)
%%	w_imovel        ---> Código do imóvel no caso de Contribuição de Melhoria
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
%%  w_reparc        ---> Se é reparcelamento de débitos ou não

DECLARE tipo_economico                CHAR(1);
DECLARE ativ_principal                INTEGER;
DECLARE classif_atividade             INTEGER;
DECLARE valor_iss_fixo                DECIMAL(15,4);
DECLARE eh_isento                     INTEGER;
DECLARE eh_optante_simples            CHAR(1);
DECLARE w_pessoa                      INTEGER;
DECLARE isencao                       INTEGER;
DECLARE formacao                      INTEGER;
DECLARE w_data_inicio                 DATE;
DECLARE ano_inicial                   INTEGER;
DECLARE mes_inicial                   INTEGER;
DECLARE w_configuracao                INTEGER;

%% Verificando o Tipo do Cadastro de Economico ('F'-Fixo, 'H'-Homologado e 'O'-Outros)

SELECT tipo INTO tipo_economico FROM economicos WHERE i_economicos = w_codigo;                
                        
%% Encontrando o valor do ISS

IF (tipo_economico = 'F') THEN  
  
%% Buscando a Atividade Principal
SET ativ_principal = dbf_fc_ret_ativ_principal(w_codigo);

%% Buscando a Classificacao da Atividade, conforme ART. 198 E ART. 202
SET classif_atividade = isnull(dbf_fc_ret_opc_atividade(ativ_principal, 2200,dbf_ano_base(ativ_principal, w_ano, 2200, 'opcoes_bca')),0);

IF (classif_atividade = 2203) THEN % Se a atividade DO economico estiver classificada como Autonomo
  
%% Buscando a formacao do profissional autonomo
SET formacao = isnull((dbf_fc_ret_opc_economico(w_codigo,1200,dbf_ano_base(w_codigo,w_ano,1200,'opcoes_bce'))),0);
  
  IF (formacao = 1201) THEN % Nivel Superior 
    SET valor_iss_fixo = 500;
  ELSE IF (formacao = 1202) THEN % Nivel Medio
    SET valor_iss_fixo = 150;
  ELSE IF (formacao = 1203) THEN % Demais niveis
    SET valor_iss_fixo = 50;
  ELSE
    CALL dbp_raiserror('','Cálculo NÃO realizado para este cadastro. É necessário informar a formação do Profissional Autônomo.');
   END IF;
  END IF;
 END IF;
    
  ELSE % Se ele nao FOR Autonomo, calcula o ISS Fixo normalmente pelo Valor da Atividade
  SET valor_iss_fixo = dbf_fc_retbcae_valor(w_codigo,2199,dbf_fc_ret_ativ_principal(w_codigo),w_ano);
END IF;


ELSE IF (tipo_economico = 'H')  THEN

%% Verificando se a pessoa eh Optante do Simples Nacional
SELECT i_pessoas INTO w_pessoa FROM bethadba.economicos WHERE i_economicos = w_codigo;
SET eh_optante_simples = dbf_eh_optantesimplesnac(w_pessoa, today());

IF (eh_optante_simples = 'S') THEN
  CALL dbp_raiserror('','Calculo nao Realizado para este cadastro. Motivo: Optante do Simples Nacional.');
END IF;

%% Verificando a data de Inicio do Cadastro

SELECT data_inicio INTO w_data_inicio FROM bethadba.movi_eco
WHERE tipo = 'I' AND i_economicos = w_codigo;

SET ano_inicial = year(w_data_inicio);    
SET mes_inicial = month(w_data_inicio);

%% Verificando a Configuração de Parcelas a ser Utilizada

IF(ano_inicial = w_ano) THEN
 IF (mes_inicial = 2) THEN     
     SET w_configuracao = 2;
  ELSEIF(mes_inicial = 3) THEN
        SET w_configuracao = 3;
  ELSEIF(mes_inicial = 4) THEN
        SET w_configuracao = 4;
  ELSEIF(mes_inicial = 5) THEN
        SET w_configuracao = 5;
  ELSEIF(mes_inicial = 6) THEN
        SET w_configuracao = 6;
  ELSEIF(mes_inicial = 7) THEN
        SET w_configuracao = 7;
  ELSEIF(mes_inicial = 8) THEN
        SET w_configuracao = 8;
  ELSEIF(mes_inicial = 9) THEN
        SET w_configuracao = 9;
  ELSEIF(mes_inicial = 10) THEN
        SET w_configuracao = 10;
  ELSEIF(mes_inicial = 11) THEN
        SET w_configuracao = 11;
  ELSEIF(mes_inicial = 12) THEN
        SET w_configuracao = 12;

ELSE
  SET w_configuracao = 1;   
  END IF; 
    END IF;
  
ELSE IF (tipo_economico = 'O')  THEN
  CALL dbp_raiserror('','Economico do tipo Outros. ISS nao foi calculado.');
    END IF;
  END IF;
END IF;   
 
%% Verificando a Isencao do ISS

SET eh_isento = dbf_fc_ret_opc_economico(w_codigo, 100, w_ano);

IF (eh_isento = 101) THEN
  SET isencao = 2;
END IF;

%% Criando as receitas  

IF (tipo_economico = 'F') THEN
  SET ret = (dbf_fc_cria_rec(202,valor_iss_fixo, 13,isencao)); % Configuracao 13 é ISS Fixo
ELSE IF ((dbf_fc_cria_rec_aliq(1,201,w_configuracao,isencao, 1)) = 0) THEN
    CALL dbp_raiserror('','Problema com aliquota da Atividade ou Isencao do tipo Imune ');
   END IF;
 END IF; 

