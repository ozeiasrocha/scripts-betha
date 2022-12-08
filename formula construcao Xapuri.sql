/* -- Fórmula de Lançamento para receita de  2100-Alvará de Construção referente Exercício de 2019*/
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
 
DECLARE w_ufm                  NUMERIC(15,4);
DECLARE w_tipo_obra            INTEGER;
DECLARE w_area                 NUMERIC(15,4);
DECLARE w_valor_faixa          NUMERIC(15,4);
DECLARE w_aprovacao_projeto    NUMERIC(15,4);
DECLARE w_alvara               NUMERIC(15,4);       
DECLARE w_ocupacao             INTEGER;


%%=======================================================================
%% BUSCANDO TIPO DE OBRA
SELECT i_tipos_obras INTO w_tipo_obra FROM bethadba.projetos WHERE i_projetos = w_codigo; 

%%=======================================================================
%% BUSCANDO UFM
SET w_ufm = dbf_fc_valor_idx(2,today());
   
%%=======================================================================
%% BUSCANDO VALORES PARA CADA TIPO DE OBRA 
 
 SET W_ocupacao  = dbf_fc_existe_opc_projeto(w_codigo, 60500, w_ano);
 
%%=======================================================================
IF w_tipo_obra = 1 THEN %%CONSTRUÇÃO 
  SET w_area = dbf_fc_retprojeto_valor(w_codigo, 60899, w_ano);
 IF isnull(w_area,0) = 0 THEN
  CALL dbp_raiserror('','CONSTRUÇÃO: Deve ser informado o Tamanho da Área Construída (Item 60899)!!!');  
   END IF;
     IF (W_ocupacao  = 60501) THEN %%Edifícios, Casas e Prédios Residenciais   
      SET w_alvara = 1 * w_ufm * w_area;
   ELSEIF W_ocupacao  = 60502 THEN %%Barracões e Galpões
      SET w_alvara = 1 * w_ufm * w_area;
   ELSEIF W_ocupacao  = 60503 THEN %%Reconstruções, Reforma e Demolições
      SET w_alvara = 1 * w_ufm * w_area;
   END IF; 
END IF;  
  
IF w_tipo_obra = 2 THEN %%AMPLIAÇÃO 
  SET w_area = dbf_fc_retprojeto_valor(w_codigo, 61099, w_ano); 
 IF isnull(w_area,0) = 0 THEN
  CALL dbp_raiserror('','AMPLIAÇÃO: Deve ser informado o Tamanho da Área Ampliada (Item 61099)!!!');  
   END IF;
     IF (W_ocupacao  = 60501) THEN %%Edifícios, Casas e Prédios Residenciais   
      SET w_alvara = 1 * w_ufm * w_area;
   ELSEIF W_ocupacao  = 60502 THEN %%Barracões e Galpões
      SET w_alvara = 1 * w_ufm * w_area;
   ELSEIF W_ocupacao  = 60503 THEN %%Reconstruções, Reforma e Demolições
      SET w_alvara = 1 * w_ufm * w_area;
   END IF; 
END IF;  
 
IF w_tipo_obra = 3 THEN %%DEMOLIÇÃO  
  SET w_area = dbf_fc_retprojeto_valor(w_codigo, 60999, w_ano); 
 IF isnull(w_area,0) = 0 THEN
  CALL dbp_raiserror('','DEMOLIÇÃO: Deve ser informado o Tamanho da Área Demolida (Item 60999)!!!');  
   END IF;
     IF (W_ocupacao  = 60501) THEN %%Edifícios, Casas e Prédios Residenciais   
      SET w_alvara = 1 * w_ufm * w_area;
   ELSEIF W_ocupacao  = 60502 THEN %%Barracões e Galpões
      SET w_alvara = 1 * w_ufm * w_area;
   ELSEIF W_ocupacao  = 60503 THEN %%Reconstruções, Reforma e Demolições
      SET w_alvara = 1 * w_ufm * w_area;
   END IF; 
END IF; 
 
IF w_tipo_obra = 4 THEN %%REFORMA   
  SET w_area = dbf_fc_retprojeto_valor(w_codigo, 61199, w_ano); 
 IF isnull(w_area,0) = 0 THEN
  CALL dbp_raiserror('','REFORMA: Deve ser informado o Tamanho da Área Demolida (Item 61999)!!!');  
   END IF;
     IF (W_ocupacao  = 60501) THEN %%Edifícios, Casas e Prédios Residenciais   
      SET w_alvara = 1 * w_ufm * w_area;
   ELSEIF W_ocupacao  = 60502 THEN %%Barracões e Galpões
      SET w_alvara = 1 * w_ufm * w_area;
   ELSEIF W_ocupacao  = 60503 THEN %%Reconstruções, Reforma e Demolições
      SET w_alvara = 1 * w_ufm * w_area;
   END IF; 
END IF;  
    
%%=======================================================================
%% GERANDO AS RECEITAS DO ALVARÁ E APROVAÇÃO DO PROJETO
SET ret = dbf_fc_cria_rec(2101,w_alvara); %% Taxa de Alvará de Construção; 


