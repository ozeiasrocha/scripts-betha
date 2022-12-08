/* -- Fórmula de Lançamento*/
%%	w_codigo        ---> Código de referência que está sendo calculado (Imóvel / Econômico / Pedido / Melhoria / etc)
%%	w_refer         ---> Código do imóvel no caso de Contribuição de Melhoria ou Código da Publicidade
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
%%  ********************  OBSERVAÇÃO   ********************
%%  Não pode ser utilizado o comando RETURN nas fórmulas deverá ser utilizado a procedure bethadba.dbp_raiserror 
%%  da seguinte forma para banco na versão 5 call bethadba.dbp_raiserror('1 parâmetro mensagem desejada', '2 parâmetro nulo')   
%%  da seguinte forma para banco na versão 7 call bethadba.dbp_raiserror('1 parâmetro nulo', '2 parâmetro mensagem desejada')  

DECLARE reinicio  INTEGER;       %%Buscca a data de reinicio
DECLARE data_ini  DATE;          %% Data de inicio da atividade
DECLARE dia       INTEGER;       %% Dia do inicio da atividade
DECLARE mes       INTEGER;       %% Mês do inicio da atividade
DECLARE ano       INTEGER; 
DECLARE tempo     INTEGER;  
DECLARE classif INTEGER;
DECLARE tll     DECIMAL(15,1);
DECLARE tff     DECIMAL(15,4);
DECLARE area    DECIMAL(15,4);
DECLARE fixo    INTEGER;
DECLARE ufm     DECIMAL(15,4);
DECLARE isencao INTEGER;  
DECLARE item_solo INTEGER;
DECLARE valor_solo DECIMAL(15,4);
DECLARE area_solo DECIMAL(15,4);  
DECLARE rec_div DECIMAL(15,4);
DECLARE expe    DECIMAL(15,4);
DECLARE tarifa  DECIMAL(15,4);  
DECLARE classif2 INTEGER;
DECLARE item_hor INTEGER;
DECLARE valor_hor DECIMAL(15,4);


%%Verifica a data de iniciio da atividade
SELECT max(i_movi_eco) INTO reinicio 
    FROM bethadba.movi_eco
    WHERE movi_eco.i_economicos = w_codigo AND movi_eco.tipo = 'R'; 
       
    IF(reinicio > 0) THEN
      SET data_ini = dbf_fc_ret_data_reinicio_ativ(w_codigo); 
    ELSE
      SET data_ini = dbf_fc_ret_data_inicio_ativ(w_codigo);
    END IF;
    MESSAGE string ('data_ini: ',data_ini) TYPE WARNING TO CLIENT;  
    SET dia=day(data_ini);
    SET mes=month(data_ini);
    SET ano=year(data_ini);
    
    IF(ano<w_ano) THEN
      SET tempo=12
    ELSE
      SET tempo=13-mes
    END IF;


%%Busca o valor da ufm
SET ufm=dbf_fc_valor_idx(2,today(*)); 

%%Busca area da atividade
SET area=isnull(dbf_fc_retbce_valor(w_codigo, 199, dbf_ano_base(w_codigo, w_ano, 199, 'opcoes_bce')),0);
IF area = '' THEN
   CALL dbp_raiserror('','NÃO GERA LANÇAMENTO DE ALVARÁ, FAVOR INFORMAR AREA DO ESTAB.');
END IF;  
MESSAGE string ('area ',area) TYPE WARNING TO CLIENT;      

%%Busca opção de estabelcimento fixo para autonomos
SET fixo=isnull((dbf_fc_ret_opc_economico(w_codigo,300,dbf_ano_base(w_codigo,w_ano,300,'opcoes_bce'))),0);

%%Busca classificação da atividade
SET classif=isnull((dbf_fc_ret_opc_economico(w_codigo,400,dbf_ano_base(w_codigo,w_ano,400,'opcoes_bce'))),0);
IF (classif=0) THEN
 CALL dbp_raiserror('FAVOR INFORMAR A CLASSIFICAÇÃO DA ATIVIDADE - LOCAL (4/00)');
END IF; 

MESSAGE string ('classif ',classif) TYPE WARNING TO CLIENT;  
IF (classif = 401) THEN
  SET tll = 2;
ELSEIF (classif = 402) THEN
    SET tll = 1;
         
ELSEIF (classif = 403) THEN 
    SET tll=.5;     
              
ELSEIF (classif = 404) THEN 
    SET tll=1.5;
         

END IF;      
   
%%Clasificação para calculo da tff

SET classif2=isnull((dbf_fc_ret_opc_economico(w_codigo,900,dbf_ano_base(w_codigo,w_ano,900,'opcoes_bce'))),0);   
IF (classif2=0) THEN
 CALL dbp_raiserror('FAVOR INFORMAR A CLASSIFICAÇÃO DA ATIVIDADE - FUNC. (9/00)');
END IF; 
IF (classif2 = 901) THEN
      IF (area <= 100) THEN 
         SET tff = 2;
      ELSEIF
        (area > 100) AND (area <= 250) THEN
         SET tff = 3.5;
       ELSEIF
         (area > 250) AND (area <= 500) THEN
          SET tff = 5;
       ELSEIF
          (area > 500) THEN
          SET tff = 8;
      END IF;

ELSEIF (classif2 = 902) THEN
      IF (area <= 30) THEN 
         SET tff = 1;
      ELSEIF
        (area > 30) AND (area <= 100) THEN
         SET tff = 2; 
      ELSEIF
        (area > 100) AND (area <= 250) THEN
         SET tff = 3;
       ELSEIF
         (area > 250)THEN
          SET tff = 5;
      END IF;   
    
ELSEIF (classif2 = 903) THEN 
    
      IF fixo=301 THEN
         SET tff=2;
      ELSEIF fixo=302 THEN
         SET tff=1;
      ELSEIF fixo IS NULL OR fixo=0 THEN
          RAISERROR 17000 'Profissional Autônomo: É necessário informar se possui ou não Estalecimento Fixo' ;
      END IF;
          
ELSEIF (classif2 = 904) THEN 

      IF (area <= 150) THEN 
         SET tff = 1;
      ELSEIF
        (area > 150) AND (area <= 400) THEN
         SET tff = 2;
       ELSEIF
         (area > 400) AND (area <= 800) THEN
         SET tff = 4;
       ELSEIF
          (area > 800) THEN
          SET tff = 7;
      END IF;
 ELSEIF (classif2 = 905) THEN        
  SET tff=3;
END IF;
      
 
 %%Busca informações para calculo da taxa de solo  
SET item_solo=isnull((dbf_fc_ret_opc_economico(w_codigo,800,dbf_ano_base(w_codigo,w_ano,800,'opcoes_bce'))),0);  
SET area_solo=isnull(dbf_fc_retbce_valor(w_codigo, 799, dbf_ano_base(w_codigo, w_ano, 799, 'opcoes_bce')),0);
 
 IF item_solo IN(802,803) THEN
    SET valor_solo=0.75
  ELSEIF item_solo=804 THEN
    SET valor_solo=0.9
  ELSEIF item_solo=805 THEN
    SET valor_solo=1.5
  ELSEIF item_solo=806 THEN
    SET valor_solo=2
  ELSEIF item_solo=807 THEN
    SET valor_solo=0.25*area_solo
  ELSEIF item_solo=809 THEN
    SET valor_solo=0.4  
   ELSEIF item_solo=810 THEN
    SET valor_solo=0.4*area_solo   
  ELSEIF item_solo=811 THEN
    SET valor_solo=5
  ELSEIF item_solo=812 THEN
    SET valor_solo=0.10
  ELSEIF item_solo=813 THEN
    SET valor_solo=0.5
  ELSEIF item_solo=814 THEN
    SET valor_solo=0.75
  ELSEIF item_solo=815 THEN
    SET valor_solo=0.04
  ELSEIF item_solo=816 THEN
    SET valor_solo=0.9
  END IF;
  
%%calcula taxa de horario especial
SET item_hor=dbf_fc_ret_opc_economico(w_codigo,1000,dbf_ano_base(w_codigo,w_ano,1000,'opcoes_bce')) ;
   
 IF item_hor=1001 THEN
  SET valor_hor=0.5;
 ELSEIF item_hor=1002 THEN
  SET valor_hor=2; 
 ELSEIF item_hor=1003 THEN
  SET valor_hor=1.5;
 ELSEIF item_hor=1004 THEN
  SET valor_hor=2;
  END IF;
  
SET valor_hor=valor_hor*ufm;   
    
  
SET rec_div=30.41;
 
MESSAGE string ('tff ',tff) TYPE WARNING TO CLIENT; 
SET tll=tll*ufm;      
SET tll=tll/12*tempo;

SET tff=tff*ufm;
MESSAGE string ('tff ',tff) TYPE WARNING TO CLIENT;   
SET tff=tff/12*tempo;
MESSAGE string ('tff ',tff) TYPE WARNING TO CLIENT;     
SET valor_solo=valor_solo*ufm;

SET valor_solo=valor_solo/12*tempo;  


%%Verifica isenção
IF dbf_fc_ret_opc_economico(w_codigo,500,dbf_ano_base(w_codigo,w_ano,500,'opcoes_bce'))=501 THEN
  SET isencao=1;       
  MESSAGE string ('ISENCAO ',isencao) TYPE WARNING TO CLIENT;  
END IF;
  

%%Criando as receitas    
MESSAGE string ('ano ',ano) TYPE WARNING TO CLIENT;  
MESSAGE string ('w_ano ',w_ano) TYPE WARNING TO CLIENT;  
IF ano=w_ano THEN
   SET ret = dbf_fc_cria_rec(301, tll,NULL, isencao);    
   SET ret = dbf_fc_cria_rec(302, tff,NULL,isencao); 
   SET ret = dbf_fc_cria_rec(303, valor_solo,NULL,isencao);
   SET ret = dbf_fc_cria_rec(304, rec_div,NULL,isencao);
   SET ret = dbf_fc_cria_rec(305, expe,NULL,isencao);
   %%SET ret = dbf_fc_cria_rec(306, tarifa,NULL,isencao);
   SET ret = dbf_fc_cria_rec(307, valor_hor,NULL,isencao);
ELSE
  SET ret = dbf_fc_cria_rec(302, tff,NULL,isencao); 
  SET ret = dbf_fc_cria_rec(303, valor_solo,NULL,isencao); 
  SET ret = dbf_fc_cria_rec(304, rec_div,NULL,isencao);
  SET ret = dbf_fc_cria_rec(305, expe,NULL,isencao);
  %%SET ret = dbf_fc_cria_rec(306, tarifa,NULL,isencao);
  SET ret = dbf_fc_cria_rec(307, valor_hor,NULL,isencao);
END IF;