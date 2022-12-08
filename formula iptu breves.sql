
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
DECLARE tff2    DECIMAL(15,4);
DECLARE tff3    DECIMAL(15,4);
DECLARE tff4    DECIMAL(15,4);
DECLARE area    INTEGER;
DECLARE fixo    INTEGER;
DECLARE ufm     DECIMAL(15,4);
DECLARE isencao INTEGER;  
DECLARE classif2 INTEGER;
DECLARE ATIV1   INTEGER;
DECLARE ATIV2   INTEGER;
DECLARE ATIV3   INTEGER;
DECLARE ATIV4   INTEGER;
DECLARE AREA2 INTEGER;
DECLARE AREA3 INTEGER;
DECLARE AREA4 INTEGER;
DECLARE formacao INTEGER;
DECLARE qtd INTEGER;  
DECLARE qtd2 INTEGER;
DECLARE qtd3 INTEGER;
DECLARE qtd4 INTEGER;


%%Verifica a data de iniciio da atividade
SELECT max(i_movi_eco) INTO reinicio 
    FROM bethadba.movi_eco
    WHERE movi_eco.i_economicos = w_codigo AND movi_eco.tipo = 'R'; 
       
    IF(reinicio > 0) THEN
      SET data_ini = dbf_fc_ret_data_reinicio_ativ(w_codigo); 
    ELSE
      SET data_ini = dbf_fc_ret_data_inicio_ativ(w_codigo);
    END IF;
    %%MESSAGE string ('data_ini: ',data_ini) TYPE WARNING TO CLIENT;  
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

%%Verifica isenção
IF dbf_fc_ret_opc_economico(w_codigo,1200,dbf_ano_base(w_codigo,w_ano,1200,'opcoes_bce'))=1202 THEN
  SET isencao=1;  
  SET tff=0;     
END IF;

%%Busca a atividade principal   
SET ATIV1=isnull((dbf_fc_ret_opc_economico(w_codigo,1500,dbf_ano_base(w_codigo,w_ano,1500,'opcoes_bce'))),0);
%%MESSAGE string ('ativ1 ', ativ1) type warning TO client;
IF ATIV1 = '' AND isencao<>1 THEN
   CALL dbp_raiserror('','NÃO GERA LANÇAMENTO DE ALVARÁ, FAVOR INFORMAR A ATIVIDADE PRINCIPAL. (15/00)');  
END IF;     
  
%%Busca area da atividade principal   
SET area=isnull((dbf_fc_ret_opc_economico(w_codigo,1600,dbf_ano_base(w_codigo,w_ano,1600,'opcoes_bce'))),0);
%%Busca qtd salas, funcionarios, cadeiras, grades, etc   - tabela 4
SET QTD=isnull((dbf_fc_ret_opc_economico(w_codigo,1800,dbf_ano_base(w_codigo,w_ano,1800,'opcoes_bce'))),0);
%%Busca FORMACAO AUTONOMO   
SET formacao=isnull((dbf_fc_ret_opc_economico(w_codigo,1700,dbf_ano_base(w_codigo,w_ano,1700,'opcoes_bce'))),0);

IF ativ1 IN (1506, 1509, 1521, 1522, 1523, 1524, 1525, 1526, 1527, 1528, 1529, 1531, 1534, 1537, 1539, 1541, 1542, 1543, 1547 ) THEN  
   IF  area = ''   THEN
      CALL dbp_raiserror('','NÃO GERA LANÇAMENTO DE ALVARÁ, FAVOR INFORMAR AREA DA ATIVIDADE PRINCIPAL. (16/00)');
   ELSE
      SET tff=dbf_fc_valor_tab('1', w_codigo,2, '3',w_ano); 
      IF tff=0 THEN  
        CALL dbp_raiserror('','Verificar o valor do ítem '+ string(area) + ' em Boletins >> Tabelas I ( referente BCE, Tabela 2)', );
      END IF;  
    END IF;  
ELSEIF ativ1 IN (1507, 1508, 1514, 1515, 1530, 1540, 1544, 1546 ) THEN      
   IF QTD = ''  THEN
      CALL dbp_raiserror('','NÃO GERA LANÇAMENTO DE ALVARÁ, FAVOR INFORMAR A QUANTIDADE DE SALAS/DORM/FUNCIONARIOS/CADEIRAS. (18/00)');
   ELSE
      SET tff=dbf_fc_valor_tab('1', w_codigo,4, '3',w_ano);  
       IF tff=0 THEN  
        CALL dbp_raiserror('','Verificar o valor do ítem '+ string(qtd) + ' em Boletins >> Tabelas I ( referente BCE, Tabela 4)', );
      END IF; 
   END IF;     
ELSEIF  ativ1 IN (1519 ) THEN
   IF formacao = ''  THEN
      CALL dbp_raiserror('','NÃO GERA LANÇAMENTO DE ALVARÁ, FAVOR INFORMAR A FORMAÇÃO PROFISSIONAL (17/00)');
   ELSE
    SET tff=dbf_fc_valor_tab('1', w_codigo,3, '3',w_ano); 
       IF tff=0 THEN  
        CALL dbp_raiserror('','Verificar o valor do ítem '+ string(formacao) + ' em Boletins >> Tabelas I ( referente BCE, Tabela 3)', );
      END IF; 
   END IF;
ELSEIF  ativ1 IN (1532 ) THEN
    SET tff=0; %% não cobra para açaí
ELSE
   SET tff=dbf_fc_valor_tab('1', w_codigo,1, '3',w_ano);  
      IF tff=0 AND isencao<>1 THEN  
        CALL dbp_raiserror('','Verificar o valor do ítem '+ string(ativ1) + ' em Boletins >> Tabelas I ( referente BCE, Tabela 1)', );
      END IF; 
END IF;  

%% atividades secundarias

%%Busca a atividades
SET ATIV2=isnull((dbf_fc_ret_opc_economico(w_codigo,2000,dbf_ano_base(w_codigo,w_ano,2000,'opcoes_bce'))),0);
SET ATIV3=isnull((dbf_fc_ret_opc_economico(w_codigo,2300,dbf_ano_base(w_codigo,w_ano,2300,'opcoes_bce'))),0);
SET ATIV4=isnull((dbf_fc_ret_opc_economico(w_codigo,2600,dbf_ano_base(w_codigo,w_ano,2600,'opcoes_bce'))),0);
  
%%Busca areas
SET area2=isnull((dbf_fc_ret_opc_economico(w_codigo,2100,dbf_ano_base(w_codigo,w_ano,2100,'opcoes_bce'))),0);
SET area3=isnull((dbf_fc_ret_opc_economico(w_codigo,2400,dbf_ano_base(w_codigo,w_ano,2400,'opcoes_bce'))),0);
SET area4=isnull((dbf_fc_ret_opc_economico(w_codigo,2700,dbf_ano_base(w_codigo,w_ano,2700,'opcoes_bce'))),0);

%%Busca qtd's
SET QTD2=isnull((dbf_fc_ret_opc_economico(w_codigo,2200,dbf_ano_base(w_codigo,w_ano,2200,'opcoes_bce'))),0);
SET QTD3=isnull((dbf_fc_ret_opc_economico(w_codigo,2500,dbf_ano_base(w_codigo,w_ano,2500,'opcoes_bce'))),0);
SET QTD4=isnull((dbf_fc_ret_opc_economico(w_codigo,2800,dbf_ano_base(w_codigo,w_ano,2800,'opcoes_bce'))),0);
  
%% calculo atividade 2
IF ativ2 IN (2006, 2009, 2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2031, 2034, 2037, 2039, 2041, 2042, 2043, 2047 ) THEN  
   IF  area2 = ''   THEN
      CALL dbp_raiserror('','NÃO GERA LANÇAMENTO DE ALVARÁ, FAVOR INFORMAR AREA DA ATIVIDADE 2. (21/00)');
   ELSE
      %%SET tff2=dbf_fc_valor_tab('1', w_codigo,2, '3',w_ano); 
      SELECT VALOR INTO tff2 FROM BETHADBA.tabelas_i WHERE ANO=W_ANO AND  REFER=3 AND I_ITEM=AREA2-500;
      IF isnull(tff2,0)=0 THEN  
        CALL dbp_raiserror('','Verificar o valor do ítem '+ string(area2-500) + ' em Boletins >> Tabelas I ( referente BCE, Tabela 2)', );
      END IF;  
    END IF;  
ELSEIF ativ2 IN (2007, 2008, 2014, 2015, 2030, 2040, 2044, 2046 ) THEN      
   IF QTD2 = ''  THEN
      CALL dbp_raiserror('','FAVOR INFORMAR A QUANTIDADE DE SALAS/DORM/FUNCIONARIOS/CADEIRAS DA ATIVIDADE 2. (22/00)');
   ELSE
      %%SET tff2=dbf_fc_valor_tab('1', w_codigo,4, '3',w_ano);  
           SELECT VALOR INTO tff2 FROM BETHADBA.tabelas_i WHERE ANO=W_ANO AND  REFER=3 AND I_ITEM=qtd2-400;
      IF isnull(tff2,0)=0 THEN  
        CALL dbp_raiserror('','Verificar o valor do ítem '+ string(qtd2-400) + ' em Boletins >> Tabelas I ( referente BCE, Tabela 4)', );
      END IF; 
   END IF;     
ELSEIF  ativ2 IN (2019 ) THEN
      CALL dbp_raiserror('','NÃO GERA LANÇAMENTO DE ALVARÁ. AUTONOMO SOMENTE ATIVIDADE PRINCIPAL');
ELSEIF Ativ2=2054 THEN
  SET tFF2=0;      
ELSEIF isnull(ativ2,0)<>0 THEN
   %%SET tff2=dbf_fc_valor_tab('1', w_codigo,1, '3',w_ano);  
    SELECT VALOR INTO tff2 FROM BETHADBA.tabelas_i WHERE ANO=W_ANO AND  REFER=3 AND I_ITEM=ativ2-500;
      IF isnull(tff2,0)=0 THEN  
        CALL dbp_raiserror('','Verificar o valor do ítem '+ string(ativ2-500) + ' em Boletins >> Tabelas I ( referente BCE, Tabela 1)', );
      END IF; 
END IF;  

%% calculo atividade 3
IF ativ3 IN (2306, 2309, 2321, 2322, 2323, 2324, 2325, 2326, 2327, 2328, 2329, 2331, 2334, 2337, 2339, 2341, 2342, 2343, 2347 ) THEN  
   IF  area3 = ''   THEN
      CALL dbp_raiserror('','NÃO GERA LANÇAMENTO DE ALVARÁ, FAVOR INFORMAR AREA DA ATIVIDADE 3. (24/00)');
   ELSE
     %% SET tff3=dbf_fc_valor_tab('1', w_codigo,2, '3',w_ano); 
     SELECT VALOR INTO tff3 FROM BETHADBA.tabelas_i WHERE ANO=W_ANO AND  REFER=3 AND I_ITEM=AREA3-800;
     IF isnull(tff3,0)=0 THEN  
        CALL dbp_raiserror('','Verificar o valor do ítem '+ string(area3-800) + ' em Boletins >> Tabelas I ( referente BCE, Tabela 2)', );
     END IF;  
   END IF;  
ELSEIF ativ3 IN (2307, 2308, 2314, 2315, 2330, 2340, 2344, 2346 ) THEN      
   IF QTD3 = ''  THEN
      CALL dbp_raiserror('','FAVOR INFORMAR A QUANTIDADE DE SALAS/DORM/FUNCIONARIOS/CADEIRAS DA ATIVIDADE 3. (25/00)');
   ELSE
     %% SET tff3=dbf_fc_valor_tab('1', w_codigo,4, '3',w_ano);  
     SELECT VALOR INTO tff3 FROM BETHADBA.tabelas_i WHERE ANO=W_ANO AND  REFER=3 AND I_ITEM=qtd3-700;
       IF isnull(tff3,0)=0 THEN  
        CALL dbp_raiserror('','Verificar o valor do ítem '+ string(qtd3-700) + ' em Boletins >> Tabelas I ( referente BCE, Tabela 4)', );
      END IF; 
   END IF;     
ELSEIF  ativ3 IN (2319 ) THEN
      CALL dbp_raiserror('','NÃO GERA LANÇAMENTO DE ALVARÁ. AUTONOMO SOMENTE ATIVIDADE PRINCIPAL');
ELSEIF Ativ3=2354 THEN
  SET tFF3=0;   
ELSEIF isnull(ativ3,0)<>0 THEN
  %% SET tff3=dbf_fc_valor_tab('1', w_codigo,1, '3',w_ano);  
      SELECT VALOR INTO tff3 FROM BETHADBA.tabelas_i WHERE ANO=W_ANO AND  REFER=3 AND I_ITEM=ativ3-800;
      IF isnull(tff3,0)=0 THEN  
        CALL dbp_raiserror('','Verificar o valor do ítem '+ string(ativ3-800) + ' em Boletins >> Tabelas I ( referente BCE, Tabela 1)', );
      END IF; 
END IF;  

%% calculo atividade 4
IF ativ4 IN (2606, 2609, 2621, 2622, 2623, 2624, 2625, 2626, 2627, 2628, 2629, 2631, 2634, 2637, 2639, 2641, 2642, 2643, 2647 ) THEN  
   IF  area4 = ''   THEN
      CALL dbp_raiserror('','NÃO GERA LANÇAMENTO DE ALVARÁ, FAVOR INFORMAR AREA DA ATIVIDADE 4. (27/00)');
   ELSE
      %%SET tff4=dbf_fc_valor_tab('1', w_codigo,2, '3',w_ano); 
     SELECT VALOR INTO tff4 FROM BETHADBA.tabelas_i WHERE ANO=W_ANO AND  REFER=3 AND I_ITEM=AREA4-1100;
     IF isnull(tff4,0)=0 THEN  
        CALL dbp_raiserror('','Verificar o valor do ítem '+ string(area4-1100) + ' em Boletins >> Tabelas I ( referente BCE, Tabela 2)', );
      END IF;  
    END IF;  
ELSEIF ativ4 IN (2607, 2608, 2614, 2615, 2630, 2640, 2644, 2646 ) THEN      
   IF QTD4 = ''  THEN
      CALL dbp_raiserror('','FAVOR INFORMAR A QUANTIDADE DE SALAS/DORM/FUNCIONARIOS/CADEIRAS DA ATIVIDADE 4. (28/00)');
   ELSE
     %% SET tff4=dbf_fc_valor_tab('1', w_codigo,4, '3',w_ano);  
       SELECT VALOR INTO tff4 FROM BETHADBA.tabelas_i WHERE ANO=W_ANO AND  REFER=3 AND I_ITEM=qtd4-1000;
       IF isnull(tff4,0)=0 THEN    
        CALL dbp_raiserror('','Verificar o valor do ítem '+ string(qtd4-1000) + ' em Boletins >> Tabelas I ( referente BCE, Tabela 4)', );
      END IF; 
   END IF;     
ELSEIF  ativ4 IN (2619 ) THEN
      CALL dbp_raiserror('','NÃO GERA LANÇAMENTO DE ALVARÁ. AUTONOMO SOMENTE ATIVIDADE PRINCIPAL');
ELSEIF Ativ4=2654 THEN
  SET tFF4=0;   
ELSEIF isnull(ativ4,0)<>0 THEN
  %% SET tff4=dbf_fc_valor_tab('1', w_codigo,1, '3',w_ano);  
      SELECT VALOR INTO tff4 FROM BETHADBA.tabelas_i WHERE ANO=W_ANO AND  REFER=3 AND I_ITEM=ativ4-1100;
      IF isnull(tff4,0)=0 THEN  
        CALL dbp_raiserror('','Verificar o valor do ítem '+ string(ativ4-1100) + ' em Boletins >> Tabelas I ( referente BCE, Tabela 1)', );
      END IF; 
END IF;  

SET tff=(tff+isnull(tff2,0)+isnull(tff3,0)+isnull(tff4,0))/12*tempo;


%%Criando as receitas   


   SET ret = dbf_fc_cria_rec(401, tff,  NULL, NULL);    
   SET ret = dbf_fc_cria_rec(402, 78.34, NULL,NULL); 
  SET ret = dbf_fc_cria_rec(403, 5.90,  NULL,NULL); 