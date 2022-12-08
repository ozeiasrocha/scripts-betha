/* -- Fórmula de Lançamento para receita de  400-Taxa de Licença p/ Localização e Funcionamento referente Exercício de 2009*/
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

DECLARE area_ocupada         DECIMAL(15,4);  % Area Ocupada
DECLARE ativ_principal       INTEGER;        % Atividade Principal DO Economico 
DECLARE classif_atividade    INTEGER;        % Classificacao da Atividade: Industria, Comercio, etc 
DECLARE estab_fixo           INTEGER;        % Profissional Autonomo - Com Estabelecimento Fixo ou Nao 
DECLARE complexidade         INTEGER;        % Nivel de Complexidade
DECLARE taxa_localizacao     DECIMAL(15,4);  % Valor da Taxa De Localizacao
DECLARE taxa_funcionamento   DECIMAL(15,4);  % Valor da Taxa De Funcionamento
DECLARE taxa_sanitario       DECIMAL(15,4);  % Valor da Taxa de Alvara Sanitario 
DECLARE taxa_expediente      DECIMAL(15,4);  % Valor da Taxa de Expediente
DECLARE w_isento             INTEGER;
DECLARE w_porte_emp          INTEGER;

%% DEFININDO A TAXA DE EXPEDIENTE

SET taxa_expediente = 10;

%%MESSAGE string('taxa expediente -->', taxa_expediente) type warning TO client;

%% BUSCANDO AREA OCUPADA     

SET area_ocupada =
isnull(dbf_fc_retbce_valor(w_codigo, 1099, dbf_ano_base(w_codigo, w_ano, 1099, 'opcoes_bce')),0);

%%MESSAGE string('area -->', area_ocupada) type warning TO client;

%% BUSCANDO A ATIVIDADE PRINCIPAL

SET ativ_principal = dbf_fc_ret_ativ_principal(w_codigo);

%%MESSAGE string('atividade-->', ativ_principal) type warning TO client;

%% BUSCANDO A CLASSIFICACAO DA ATIVIDADE, CONF. ART. 198 E ART. 202

SET classif_atividade = isnull(dbf_fc_ret_opc_atividade(ativ_principal, 2200,dbf_ano_base(ativ_principal, w_ano, 2200, 'opcoes_bca')),0); 

%%MESSAGE string('atividade-->',classif_atividade) type warning TO client;

%% VERIFICANDO SE PROFISSIONAL AUTONOMO POSSUI ESTABELECIMENTO FIXO

SET estab_fixo = isnull((dbf_fc_ret_opc_economico(w_codigo,1100,dbf_ano_base(w_codigo,w_ano,1100,'opcoes_bce'))),0);

%%MESSAGE string('estabelecimento fixo->',estab_fixo) type warning TO client;

%%PRINT 'retorno estab fixo: '+string(estab_fixo); 

%%VERIFICANDO SE A EMPRESA É MEI  

SELECT porte_empresa INTO w_porte_emp FROM bethadba.pessoas_juridicas, bethadba.economicos
WHERE pessoas_juridicas.i_pessoas = economicos.i_pessoas AND economicos.i_economicos = w_codigo;

IF w_porte_emp = 5 THEN
   SET w_isento = 4;
END IF;   

%%MESSAGE string('porte empresa->',w_porte_emp) type warning TO client; 


% ENCONTRANDO OS VALORES DA TAXA DE LOCALIZACAO E FUNCIONAMENTO

IF (classif_atividade = 2201) THEN
  SET taxa_localizacao = 83;
  IF (area_ocupada <= 10) THEN 
    SET taxa_funcionamento = 23;
  ELSE IF
    (area_ocupada > 10) AND (area_ocupada <= 60) THEN
    SET taxa_funcionamento = 42;
  ELSE IF
    (area_ocupada > 60) AND (area_ocupada <= 100) THEN
    SET taxa_funcionamento = 83;
  ELSE IF
    (area_ocupada > 100) AND (area_ocupada <= 350) THEN
    SET taxa_funcionamento = 125;
  ELSE IF
    (area_ocupada > 350) AND (area_ocupada <= 700) THEN
    SET taxa_funcionamento = 435;
  ELSE IF
    (area_ocupada > 700) THEN
    SET taxa_funcionamento = 830;
     END IF;
    END IF;
   END IF;
  END IF;
 END IF;
END IF;
ELSE IF (classif_atividade = 2202) THEN
  SET taxa_localizacao = 42;
    IF (area_ocupada <= 10) THEN 
    SET taxa_funcionamento = 22;
  ELSE IF
    (area_ocupada > 10) AND (area_ocupada <= 150) THEN
    SET taxa_funcionamento = 83;
  ELSE IF
    (area_ocupada > 150) AND (area_ocupada <= 350) THEN
    SET taxa_funcionamento = 125;
  ELSE IF
    (area_ocupada > 350) AND (area_ocupada <= 750) THEN
    SET taxa_funcionamento = 350;
  ELSE IF
    (area_ocupada > 750) THEN
    SET taxa_funcionamento = 830;
     END IF;
    END IF;
   END IF;
  END IF;
 END IF;
ELSE IF (classif_atividade = 2203) THEN
  SET taxa_localizacao = 21;
  IF (estab_fixo = 1101) THEN
    SET taxa_funcionamento = 125;
  ELSE IF
    (estab_fixo = 1102) THEN    
    SET taxa_funcionamento = 62;
  ELSE
    CALL dbp_raiserror('','Profissional Autônomo: É necessário informar se possui ou não Estalecimento Fixo. Art 202');
   END IF;
  END IF; 
ELSE IF (classif_atividade = 2204) THEN
    SET taxa_localizacao = 21;
     IF (area_ocupada <= 150) THEN 
    SET taxa_funcionamento = 83;
  ELSE IF
    (area_ocupada > 150) AND (area_ocupada <= 400) THEN
    SET taxa_funcionamento = 167;
  ELSE IF
    (area_ocupada > 400) AND (area_ocupada <= 800) THEN
    SET taxa_funcionamento = 333;
  ELSE IF
    (area_ocupada > 800) THEN
    SET taxa_funcionamento = 625;
    END IF;
  END IF; 
 END IF; 
END IF;
ELSE IF (classif_atividade = 2205) THEN
    SET taxa_localizacao = 21;
    SET taxa_funcionamento = 125;
ELSE IF (classif_atividade = 0) THEN
  CALL dbp_raiserror('','A atividade do econômico NÃO foi classificada como Indústria, Comércio, Autônomo, etc.'); 
     END IF;
    END IF; 
   END IF; 
  END IF;
 END IF; 
END IF; 

% CALCULANDO ALVARÁ SANITÁRIO, CONF. TABELA IX DO ART 241  

% Verificando o Nivel de Complexidade
SET complexidade = isnull((dbf_fc_ret_opc_economico(w_codigo,1300,dbf_ano_base(w_codigo,w_ano,1300,'opcoes_bce'))),0);

IF (complexidade > 0 ) THEN

IF (area_ocupada <= 50) THEN
    CASE complexidade
      WHEN 1301 THEN
      SET taxa_sanitario = 21;
      WHEN 1302 THEN
      SET taxa_sanitario = 42;
      WHEN 1303 THEN
      SET taxa_sanitario = 83;
      END CASE;
  ELSE IF
    (area_ocupada > 50) AND (area_ocupada <= 100) THEN
     CASE complexidade
          WHEN 1301 THEN
          SET taxa_sanitario = 50;
          WHEN 1302 THEN
          SET taxa_sanitario = 62;
          WHEN 1303 THEN
          SET taxa_sanitario = 104;
          END CASE;
   ELSE IF
    (area_ocupada > 100) AND (area_ocupada <= 200) THEN
      CASE complexidade
          WHEN 1301 THEN
          SET taxa_sanitario = 62;
          WHEN 1302 THEN
          SET taxa_sanitario = 66;
          WHEN 1303 THEN
          SET taxa_sanitario = 125;
          END CASE;
    ELSE IF
    (area_ocupada > 200) AND (area_ocupada <= 500) THEN
      CASE complexidade
          WHEN 1301 THEN
          SET taxa_sanitario = 58;
          WHEN 1302 THEN
          SET taxa_sanitario = 87;
          WHEN 1303 THEN
          SET taxa_sanitario = 145;
          END CASE;
    ELSE IF
    (area_ocupada > 500) AND (area_ocupada <= 1000) THEN
      CASE complexidade
          WHEN 1301 THEN
          SET taxa_sanitario = 66;
          WHEN 1302 THEN
          SET taxa_sanitario = 99;
          WHEN 1303 THEN
          SET taxa_sanitario = 166;
          END CASE;
     ELSE IF
      (area_ocupada > 1000) THEN
        CASE complexidade
          WHEN 1301 THEN
          SET taxa_sanitario = 66;
          WHEN 1302 THEN
          SET taxa_sanitario = 99;
          WHEN 1303 THEN
          SET taxa_sanitario = 166;
          END CASE;
        END IF;
      END IF;
    END IF;
   END IF;
  END IF;
 END IF; 
END IF;
         
             
% CRIANDO AS RECEITAS
%% TAXA DE LOCALIZACAO SERA COBRADA VIA RECEITAS DIVERSAS (Solicitacao do Sr. Erico, Chefe do Dep. de Trib.)
%%SET ret = dbf_fc_cria_rec(401, taxa_localizacao); )
SET ret = dbf_fc_cria_rec(402, taxa_funcionamento,w_config,w_isento);    
SET ret = dbf_fc_cria_rec(403, taxa_sanitario,w_config,w_isento);    
SET ret = dbf_fc_cria_rec(404, taxa_expediente,w_config,w_isento);    