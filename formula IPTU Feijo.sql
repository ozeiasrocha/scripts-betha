/* -- F?rmula de Lan?amento para receita de  100-IPTU - Imposto Predial e Territorial Urbano referente Exerc?cio de 2019*/
%%	w_codigo        ---> C?digo de refer?ncia que est? sendo calculado (Im?vel / Econ?mico / Pedido / Melhoria / etc)
%%	w_refer         ---> C?digo do im?vel no caso de Contribui??o de Melhoriar ou C?digo da Publicidade
%%	w_parc_ini      ---> N? da parcela Inicial 
%%	w_parc_fin      ---> N? da parcela Final 
%%	w_receita       ---> Passa a Receita Principal
%%	w_ano           ---> Passa o ano que ser? Calculado
%%	w_config        ---> Configura??o informada na Janela de Calculo
%%	w_npar          ---> Passa o N?mero de Parcela a serem geradas, caso n?o tenha Par?metros das Parcelas
%%	w_moeda         ---> Passa o C?digo da moeda
%%  w_venc_ini      ---> Vcto Inicial
%%  w_dias          ---> dias vcto
%%  w_antecip       ---> Antecipa
%%  w_simula        ---> Simulado
%%  w_notifica      ---> Ser? notificado ap?s a gera??o
%%  w_complementa   ---> Complementar
%%  w_unidade       ---> Unidade
%%  w_atos          ---> Passa o c?digo do Lei/Ato

DECLARE v_ufm             DECIMAL(15,4);
DECLARE v_rua             INTEGER;
DECLARE v_secao           INTEGER;  
DECLARE v_lado            CHAR(01);
DECLARE v_rural           CHAR(01);
DECLARE v_distrito        INTEGER;  
DECLARE v_setor           INTEGER;
DECLARE v_quadra          CHAR(04);
DECLARE v_lote            CHAR(04);
DECLARE v_engloba_com     INTEGER;
DECLARE v_vm2t            DECIMAL(15,4);
DECLARE v_area_lote       DECIMAL(15,4); 
DECLARE v_vm2c            DECIMAL(15,4);
DECLARE v_areaconst_unid  DECIMAL(15,4);
DECLARE v_areatotal_const DECIMAL(15,4); 
DECLARE v_unidade         INTEGER;
DECLARE v_vvt             DECIMAL(15,4);
DECLARE v_vvp             DECIMAL(15,4);
DECLARE v_vvi             DECIMAL(15,4);
DECLARE v_vlrimp_terr     DECIMAL(15,4);
DECLARE v_vlrimp_pred     DECIMAL(15,4);
DECLARE v_aliquota        DECIMAL(15,4);
DECLARE v_utilizacao      INTEGER;
DECLARE v_nivel_coleta    INTEGER;
DECLARE v_tx_coletalixo   DECIMAL(15,4);
DECLARE v_fracaoideal     DECIMAL(15,4);
DECLARE v_estrutura       INTEGER;
DECLARE v_somaarea_unidad DECIMAL(15,4);  
DECLARE v_testada         DECIMAL(15,2);
DECLARE v_isencao_imune   INTEGER;
DECLARE v_isencao_it      INTEGER;
DECLARE v_isencao_ip      INTEGER;
DECLARE v_isencao_cl      INTEGER;   
DECLARE v_ano_cadastro    INTEGER;
DECLARE v_asfalto         INTEGER;
DECLARE v_calcada         INTEGER;
DECLARE v_muro         INTEGER;

%%MESSAGE string('unidades-> ', w_unidade) TYPE WARNING TO CLIENT;

%%============================================================
%% VERIFICA SE O IMOVEL ? URBANO OU RURAL
%%============================================================

SELECT rural INTO v_rural FROM bethadba.imoveis WHERE i_imoveis = w_codigo;

IF(v_rural = 'S') THEN
   CALL dbp_raiserror('N?o ser? gerado o Lan?amento para Im?vel do Tipo Rural.');
   RETURN;
   ROLLBACK;
END IF;              
  
%%============================================================
%% VERIFICA O VALOR DA UFM
%%============================================================  

SET v_ufm  = dbf_fc_valor_idx(2,w_ano||'-01-01');

%%============================================================  
%% VERIFICA O VALOR DO M2 DO TERRENO (v_vm2t)
%%============================================================  
SELECT isnull(engloba_com,0) INTO v_engloba_com FROM bethadba.imoveis  WHERE i_imoveis = w_codigo;  %% Verifica os im?veis englobados    

SELECT unidade,i_ruas, secao, lado, campo1, campo2, campo3, campo4 
INTO v_unidade, v_rua, v_secao, v_lado, v_distrito, v_setor, v_quadra, v_lote 
FROM bethadba.imoveis WHERE desativado = 'N' AND i_imoveis = w_codigo;


SET v_vm2t = (SELECT isnull(max(valor_m2),0) FROM bethadba.boletins WHERE boletins.i_ruas = v_rua AND boletins.secao = v_secao AND boletins.lado = v_lado AND boletins.campo1 = v_distrito AND boletins.campo2 = v_setor AND
              boletins.ano = (SELECT max(b.ano) FROM bethadba.boletins b WHERE b.i_ruas = boletins.i_ruas AND b.secao = boletins.secao AND b.lado = boletins.lado AND b.campo1 = boletins.campo1 AND b.campo2 = boletins.campo2));
MESSAGE string('vm2t ', v_vm2t) type warning TO client;

IF v_vm2t = 0 THEN
   CALL dbp_raiserror('N?O FOI ENCONTRADO O VALOR DO M? TERRITORIAL PARA ESTE IM?VEL.');
END IF;

SET v_area_lote  = (dbf_fc_retbci_valor(w_codigo,50599,w_ano));
MESSAGE string('area_lote ', v_area_lote) type warning TO client;

IF v_area_lote = 0 THEN
   CALL dbp_raiserror('N?O FOI ENCONTRADO A ?REA DO LOTE. VERIFIQUE O BCI 505/99-AREA DO TERRENO.');
END IF;

%%============================================================  
%% VERIFICA O VALOR DO M2 DA CONSTRU??O (v_vm2c)
%%============================================================  

IF v_unidade > 0 THEN
   SET v_areaconst_unid  = dbf_fc_retbci_valor(w_codigo,50699,w_ano);
   SET v_estrutura = isnull(dbf_fc_existe_opc_bci(w_codigo, 500, w_ano),0);
   IF v_estrutura = 0 THEN
      CALL dbp_raiserror('VERIFIQUE O BCI 5/00-EDIFICA??O/ESTRUTURA.'); 
      RETURN;
      ROLLBACK;
   END IF;

   SET v_vm2c = dbf_fc_valor_tab('1',w_codigo,1,'1',dbf_ano_base(w_codigo,w_ano,500,'tabelas_i'));  
   %%MESSAGE string('vm2c ', v_vm2c) type warning TO client;
   IF v_vm2c = 0 THEN
      CALL dbp_raiserror('N?O FOI ENCONTRADO O VALOR DO M? DA CONSTRU??O. VERIFIQUE A TABELA I (BCI 5/00-EDIFICA??O/ESTRUTURA).');
      RETURN;
      ROLLBACK;
   END IF;
   %%===========================================================%%  
   %% CALCULA O VALOR VENAL PREDIAL                             %% 
   %%===========================================================%%  
   SET v_vvp = v_areaconst_unid * v_vm2c;

   SET v_utilizacao = dbf_fc_existe_opc_bci(w_codigo, 200, w_ano);
   IF v_utilizacao IN (201) THEN
      SET v_aliquota = 0.01; %% Aliquota de 1% para im?vel predial residencial;    
   ELSE 
      SET v_aliquota = 0.015; %% Aliquota de 1.5% para im?vel predial comercial;    
  
    IF  v_aliquota=0 THEN
      CALL dbp_raiserror('PREENCHER O BCI 2/00-UTILIZA??O');
      RETURN;
      ROLLBACK; 
    END IF;  
   END IF;
ELSE 
   SET v_vvp = 0;
   SET v_aliquota = 3.5; %% Aliquota de 3% para terrenos baldios;    
END IF;

%%============================================================  
%% CALCULA O VALOR VENAL TERRITORIAL
%%============================================================  
IF v_unidade > 0 THEN
   SET v_area_lote = isnull(bethadba.dbf_fc_retbci_valor(w_codigo,50599,w_ano),0);
   SELECT sum(isnull(bethadba.dbf_fc_retbci_valor(i_imoveis,50699,w_ano),0)) INTO v_somaarea_unidad
   FROM bethadba.imoveis WHERE desativado = 'N' AND campo1 = v_distrito AND campo2 = v_setor  AND campo3 = v_quadra AND campo4 = v_lote;
   SET v_fracaoideal = (v_area_lote/v_somaarea_unidad) * v_areaconst_unid; 
ELSE
   SET v_fracaoideal = v_area_lote; 
END IF;  
SET v_vvt = v_area_lote * v_vm2t; 

SET v_vvi = v_vvt + v_vvp; 

%% verifica o ano de cadastro do imovel
SELECT min(ano) INTO v_ano_cadastro FROM bethadba.opcoes_bci WHERE i_imoveis=w_codigo; 

%% verifica se h? cal?amento da rua, muro e cal?ada
SET v_asfalto = isnull(dbf_fc_existe_opc_bci(w_codigo, 2100, w_ano),0);  
SET v_calcada = isnull(dbf_fc_existe_opc_bci(w_codigo, 1900, w_ano),0); 
SET v_muro    = isnull(dbf_fc_existe_opc_bci(w_codigo, 61900, w_ano),0); 

%% multa de 100%, mais 50% ao ano progressivamente
IF (v_asfalto=2101) AND (v_calcada = 1902 OR v_muro = 61902) THEN
  IF v_ano_cadastro < w_ano THEN   
    MESSAGE string('anos: ',(w_ano-v_ano_cadastro)) type warning TO client;
    SET v_aliquota =  v_aliquota *2;    %% 100% no primeiro ano
    IF w_ano-v_ano_cadastro-1>0 THEN
      SET v_aliquota = v_aliquota + (0.005 * (w_ano-v_ano_cadastro-1));  %% 50% progressivo a cada ano  
    END IF;  
  END IF; 
END IF;                                                        
MESSAGE 'aliquota: '||v_aliquota type warning TO client;  
SET v_vlrimp_terr = (v_vvt * v_aliquota / 100);
SET v_vlrimp_pred = (v_vvp * v_aliquota / 100);  
%%MESSAGE 'VVT - > '||V_VVT type warning TO client;
%%MESSAGE 'VVP - > '||V_VVP type warning TO client;
%%MESSAGE 'VVI - > '||V_VVT+v_vvp type warning TO client;
%%MESSAGE 'ALIQ - > '||V_aliquota type warning TO client;  


%%============================================================  
%% CALCULO COLETA DE LIXO
%%============================================================     
SET v_testada =  (dbf_fc_retbci_valor(w_codigo,50099,w_ano));   
IF v_area_lote = 0 THEN
   CALL dbp_raiserror('N?O FOI ENCONTRADO A TESTADA DO LOTE. VERIFIQUE O BCI 500/99-TESTADA.');
END IF;
SET v_tx_coletalixo = 0.03 * v_ufm * V_testada;
 

%%============================================================  
%% VERIFICA ISEN??O/IMUNIDADE
%%============================================================  
SET v_isencao_imune = isnull(dbf_fc_existe_opc_bci(w_codigo, 51300, w_ano),0);
   
IF v_isencao_imune = 51301 THEN    %% Imune de Imposto
   SET v_isencao_it = 4;
   SET v_isencao_ip = 4;
   SET v_isencao_cl = NULL;
ELSE IF v_isencao_imune = 51302 THEN %% Imune de Taxa
        SET v_isencao_it = NULL;
        SET v_isencao_ip = NULL;
        SET v_isencao_cl = 4;
     ELSE IF v_isencao_imune = 51303 THEN %% Imune de Ambos
             SET v_isencao_it = 4;
             SET v_isencao_ip = 4;
             SET v_isencao_cl = 4;
          ELSE IF v_isencao_imune = 51304 THEN %% Isento de Imposto
                  SET v_isencao_it = 5;
                  SET v_isencao_ip = 5;
                  SET v_isencao_cl = NULL;
               ELSE IF v_isencao_imune = 51305 THEN %% Isento de Taxa
                       SET v_isencao_it = NULL;
                       SET v_isencao_ip = NULL;
                       SET v_isencao_cl = 5;
                    ELSE IF v_isencao_imune = 51306 THEN %% Isento de Ambos
                            SET v_isencao_it = 5;
                            SET v_isencao_ip = 5;
                            SET v_isencao_cl = 5;
                         ELSE
                            SET v_isencao_it = NULL;
                            SET v_isencao_ip = NULL;
                            SET v_isencao_cl = NULL;
                         END IF;
                    END IF;
               END IF;
          END IF;   
     END IF;
END IF;   

%%============================================================  
%% GRAVAR OS BCI'S
%%============================================================  

SET ret = (dbf_fc_cria_bci_valor(w_codigo,51799,v_vvt)); %% Valor Venal Territorial       
SET ret = (dbf_fc_cria_bci_valor(w_codigo,51699,v_vvt)); %% Valor Venal Territorial
SET ret = (dbf_fc_cria_bci_valor(w_codigo,52099,v_vm2t)); %% Valor do Metro? Terreno
SET ret = (dbf_fc_cria_bci_valor(w_codigo,50899,v_fracaoideal)); %% Fra??o Ideal Territorial
%%SET ret = (dbf_fc_cria_bci_valor(w_codigo,52099,v_area_lote)); %% ?rea do Lote
SET ret = (dbf_fc_cria_bci_valor(w_codigo,51599,(v_aliquota*100))); %% Aliquota
SET ret = (dbf_fc_cria_bci_valor(w_codigo,52599,v_vlrimp_terr)); %% Imposto Territorial
%%SET ret = (dbf_fc_cria_bci_valor(w_codigo,53499,v_tx_coletalixo)); %% Taxa Coleta Lixo
IF v_unidade > 0 THEN
 %% SET ret = (dbf_fc_cria_bci_valor(w_codigo,52799,v_areaconst_unid)); %% ?rea Construida Unidade
  SET ret = (dbf_fc_cria_bci_valor(w_codigo,52199,v_fracaoideal)); %% Fra??o Ideal Predial 
  SET ret = (dbf_fc_cria_bci_valor(w_codigo,52199,(v_vm2c*v_ufm))); %% Valor do Metro? Constru??o 
  SET ret = (dbf_fc_cria_bci_valor(w_codigo,51899,v_vvp)); %% Valor Venal Predial   
  SET ret = (dbf_fc_cria_bci_valor(w_codigo,51699,V_VVT+v_vvp)); %% Valor Venal Predial
  SET ret = (dbf_fc_cria_bci_valor(w_codigo,53199,(v_aliquota*100))); %% Aliquota
  SET ret = (dbf_fc_cria_bci_valor(w_codigo,53299,v_vlrimp_pred)); %% Imposto Predial 
END IF;

%%============================================================  
%% CRIA??O DAS RECEITAS
%%============================================================

SET ret=(dbf_fc_cria_rec(101,v_vlrimp_terr+v_vlrimp_pred,w_config,v_isencao_it,NULL));
SET ret=(dbf_fc_cria_rec(105,0.03*v_ufm,w_config,v_isencao_ip,NULL));
SET ret=(dbf_fc_cria_rec(102,v_tx_coletalixo,w_config,v_isencao_cl,NULL));
%%SET ret=dbf_fc_cria_desc_imo(*);