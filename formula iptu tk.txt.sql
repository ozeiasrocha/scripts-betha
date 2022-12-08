/* -- Fórmula de Lançamento para receita de  100-Imposto Predial Territorial Urbano referente Exercício de 2013*/
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


DECLARE area_terreno    DECIMAL(15,4); %% Área do terreno
DECLARE are_construida  DECIMAL(15,4); %% Área da construção
DECLARE area_total_cons DECIMAL(15,4); %% Área total construida
DECLARE fracao_ideal    DECIMAL(15,4); %%Fração ideal  
DECLARE zona            CHAR(10);      %% Campo 1 da inscrição imobiliária 
DECLARE situacao        INTEGER;       %%situacao
DECLARE topogafia       INTEGER;       %%topogafia
DECLARE pedologia       INTEGER;       %% pedologia
DECLARE vvt             DECIMAL(15,4); %%Valor Venal do terreno
DECLARE vve             DECIMAL(15,4); %%Valor venal da edificação
DECLARE vvi             DECIMAL(15,4); %%Valor venal do imóvel
DECLARE m2_terreno      DECIMAL(15,4); %%Valor do M² de terreno 
DECLARE m2_construcao   DECIMAL(15,4); %%Valor M² de construção
DECLARE aliq            DECIMAL(15,4); %%Aliquota 
DECLARE utilizacao      INTEGER;       %%Utilização do imovel
DECLARE isencao_imposto INTEGER;      %% Verifica isenção de imposto
DECLARE isencao_tsu     INTEGER;       %%Verifica taxa de serviços urbanos
DECLARE devedor         INTEGER;       %% Verifica se o contribuinte é devedor
DECLARE ufm             DECIMAL(15,4); %%Valor da UFM
DECLARE vlr_lixo        DECIMAL(15,4); %%Valor da taxa de lixo
DECLARE testada         DECIMAL(15,4); %%Testada do imóvel
DECLARE tipo            INTEGER;       %%Tipo de imóvel
DECLARE cobertura       INTEGER;
DECLARE parede          INTEGER;
DECLARE forro           INTEGER;
DECLARE revestimento    INTEGER;
DECLARE inst_sanitaria  INTEGER;
DECLARE inst_eletrica   INTEGER;
DECLARE piso            INTEGER;
DECLARE estrutura       INTEGER;
DECLARE pontos          DECIMAL(15,4);
DECLARE iptu            DECIMAL(15,2);
DECLARE config          INTEGER;
DECLARE total_iptu      DECIMAL(15,4);
DECLARE w_ip   DECIMAL(15,4);
DECLARE w_isento_i DECIMAL(15,4); 


%%Busca o valor da UFM
SET ufm = dbf_fc_valor_idx(2,''+string(w_ano)+''+'-01-01'); 

%%Busca o campo1 da inscrição e insere na variável zona
SELECT campo1 INTO zona FROM bethadba.imoveis WHERE i_imoveis=w_codigo;

%% Busca a área do terreno
SET area_terreno=dbf_fc_retbci_valor(w_codigo,199,dbf_ano_base(w_codigo,w_ano,199,'opcoes_bci'));

%%Busca a área da construção
SET are_construida=dbf_fc_retbci_valor(w_codigo,499,dbf_ano_base(w_codigo,w_ano,499,'opcoes_bci'));    

%%Busca área total construida da unidade
SET area_total_cons=isnull(dbf_fc_retbci_valor(w_codigo,599,dbf_ano_base(w_codigo,w_ano,599,'opcoes_bci')),0); 

%%Busca a testada do terreno
SET testada=isnull(dbf_fc_retbci_valor(w_codigo,399,dbf_ano_base(w_codigo,w_ano,399,'opcoes_bci')),0); 
   PRINT 'testada==>' + string(testada); 
  
                          
 IF w_unidade>0 THEN          
   SET fracao_ideal= (area_terreno*are_construida)/area_total_cons;
 ELSE
   SET fracao_ideal= area_terreno;
 END IF;
 
%% Busca o valor do M² de terreno

IF zona=1 THEN
   SET m2_terreno= 46;
ELSEIF zona=2 THEN
   SET m2_terreno=38;
ELSEIF zona=3 THEN
   SET m2_terreno=31;
ELSEIF zona=4 THEN
   SET m2_terreno=29;
ELSEIF zona=5 THEN
   SET m2_terreno=27;
END IF;
            

%%Busca valores de depreciação/valorização na tabela_i 
SET situacao =  dbf_fc_valor_tab('1', w_codigo, 1, '1', w_ano); 
SET topogafia = dbf_fc_valor_tab('1', w_codigo, 2, '1', w_ano); 
SET pedologia = dbf_fc_valor_tab('1', w_codigo, 3, '1', w_ano);

%%Calcula o valor venal do terreno
SET vvt= fracao_ideal*m2_terreno*situacao*topogafia*pedologia;  

%%Pontos por categoria

SET cobertura=     isnull(dbf_fc_valor_tab('2', w_codigo, 1, '1', w_ano),1); 
SET parede=        isnull(dbf_fc_valor_tab('2', w_codigo, 2, '1', w_ano),1); 
SET forro=         isnull(dbf_fc_valor_tab('2', w_codigo, 3, '1', w_ano),1); 
SET revestimento=  isnull(dbf_fc_valor_tab('2', w_codigo, 4, '1', w_ano),1); 
SET inst_sanitaria=isnull(dbf_fc_valor_tab('2', w_codigo, 5, '1', w_ano),1); 
SET inst_eletrica= isnull(dbf_fc_valor_tab('2', w_codigo, 6, '1', w_ano),1); 
SET piso=          isnull(dbf_fc_valor_tab('2', w_codigo, 7, '1', w_ano),1); 
SET estrutura=     isnull(dbf_fc_valor_tab('2', w_codigo, 8, '1', w_ano),1);
 
%%Somatória dos pontos 
SET pontos=cobertura+parede+forro+revestimento+inst_sanitaria+inst_eletrica+piso+estrutura;

%%Busca o valor do M² de construção
IF zona=1 THEN
  SET m2_construcao=150;
ELSEIF zona=2 THEN
  SET m2_construcao=120;
ELSEIF zona=3 THEN
  SET m2_construcao=100;
ELSEIF zona=4 THEN
  SET m2_construcao=0;
ELSEIF zona=5 THEN
  SET m2_construcao=0;
END IF;

%%Calcula valor venal da edificação 
SET vve=are_construida*m2_construcao/**(pontos/100); */;

%%Calcula o valor venal do imóvel, somando o vvt+vve
SET vvi=isnull(vvt,0)+isnull(vve,0);

%Busca utilização do imóvel 
SET utilizacao=dbf_fc_existe_opc_bci(w_codigo,2200,dbf_ano_base(w_codigo,w_ano,2200,'opcoes_bci')); 

%%Encontra a aliquota
IF w_unidade=0 THEN
  SET aliq=0.04;
ELSE
  IF utilizacao=2201 THEN
    SET aliq=0.005;
  ELSE
    SET aliq=0.01;
  END IF;
END IF;

%%Calculando o valor do iptu
%%*************************
SET iptu=vvi*aliq;

  
%%Calcula a taxa de lixo

SET tipo=dbf_fc_existe_opc_bci(w_codigo,1700,dbf_ano_base(w_codigo,w_ano,1700,'opcoes_bci'));
 PRINT 'tipo==>' + string(tipo);   
 
IF tipo IN(1701,1702) THEN  %%Residencial
   SET vlr_lixo=0;
ELSEIF tipo=1704 THEN   %%Sala
    IF testada<=500 THEN
       SET vlr_lixo=50*ufm;
    ELSEIF testada>100 AND testda<=200 THEN
       SET vlr_lixo=60*ufm;
    ELSEIF testada>200 AND testada<=400 THEN
       SET vlr_lixo=96*ufm;
    ELSEIF testada>400 THEN
       SET vlr_lixo= 120*ufm;
    END IF;
ELSEIF tipo=1704 THEN %%Comércio
    IF testada <=10 THEN
       SET vlr_lixo=50*ufm;
    ELSEIF testada>10 THEN
       SET vlr_lixo=60*ufm;
    END IF;
ELSEIF tipo=1712 THEN %%Industrial
    IF testada<=20 THEN
       SET vlr_lixo=60*ufm;
    ELSEIF testada>20 AND testada <=41 THEN
       SET vlr_lixo=80*ufm;
    ELSEIF testada>41 AND testada<=60 THEN
       SET vlr_lixo=100*ufm;        
    ELSEIF testada>60 AND testada <=100 THEN
        SET vlr_lixo=150*ufm;
    ELSEIF testada>100 AND testada<=200 THEN
        SET vlr_lixo=200*ufm;
    ELSEIF testada>200 AND testada<=400 THEN
        SET vlr_lixo=300*ufm;
    ELSEIF testada>400 THEN
        SET vlr_lixo=400*ufm;
    END IF;
ELSEIF tipo IN (1711,1713)   THEN %%Garagem, galpão
    IF testada <=20 THEN
       SET vlr_lixo=30*ufm;
    ELSEIF testada>20 AND testada <=40 THEN
       SET vlr_lixo=40*ufm;
    ELSEIF testada>41 AND testada<=60 THEN
       SET vlr_lixo=60*ufm;        
    ELSEIF testada>60 AND testada <=100 THEN
        SET vlr_lixo=80*ufm;
    ELSEIF testada>100 AND testada<=200 THEN
        SET vlr_lixo=100*ufm;
    ELSEIF testada>200 THEN
        SET vlr_lixo=200*ufm;
    END IF;
ELSEIF tipo=1715 THEN %%Especial
    IF testada<=10 THEN
        SET vlr_lixo= 50*ufm;
    ELSEIF testada>10 AND testada<=20 THEN
        SET vlr_lixo=100*ufm;
    ELSEIF testada>20 AND testada<=40 THEN
        SET vlr_lixo=200*ufm;
    ELSEIF testada>40 AND testada<=60 THEN
        SET vlr_lixo=300*ufm;
    ELSEIF testada>60 AND testada<=100 THEN
        SET vlr_lixo=400*ufm;
    ELSEIF testada>100 AND testada<=200 THEN
        SET vlr_lixo=500*ufm;
    ELSEIF testada>200 THEN
        SET vlr_lixo=600*ufm;
    END IF;
ELSEIF tipo= 1714 THEN %%Telheiro
    IF testada<=20 THEN
        SET vlr_lixo=30*ufm;
    ELSEIF testada>20 AND testada<=40 THEN
        SET vlr_lixo=50*ufm;
    ELSEIF testada>40 AND testada<=60 THEN
        SET vlr_lixo=70*ufm;
    ELSEIF testada>60 AND testada<=100 THEN
        SET vlr_lixo=100*ufm;
    ELSEIF testada>100 AND testada<=200 THEN
        SET vlr_lixo=150*ufm;
    ELSEIF testada>200 THEN
        SET vlr_lixo=200*ufm;
    END IF;
                       
END IF;
  PRINT 'vlr_lixo==>' + string(vlr_lixo);  
                 
%%Varifica isenções

IF dbf_fc_existe_opc_bci(w_codigo,3300,dbf_ano_base(w_codigo,w_ano,3300,'opcoes_bci'))=3302 THEN
  SET isencao_imposto=1;
END IF;

IF dbf_fc_existe_opc_bci(w_codigo,3500,dbf_ano_base(w_codigo,w_ano,3500,'opcoes_bci'))=3502 THEN
   SET isencao_tsu=2
END IF;
   
%%Verifica se o contribuinte possui algum debito no ano anterior  


 SELECT dbf_devedor(1,w_codigo, string(w_ano-1)+'-12-31') INTO devedor;
 IF devedor='00' THEN
   SET config=4;
 ELSE
   SET config=2;
END IF;

IF iptu >= 250.01 THEN
SET w_config = 1    

ELSEIF iptu BETWEEN 100.01 AND 250.00 THEN
SET w_config = 2

ELSEIF iptu BETWEEN 01.00 AND 100.00 THEN
SET w_config = 3   

 


END IF;

%%Criando as receitas  



SET ret = dbf_fc_cria_rec(101, iptu,w_config, w_isento_i);
%%SET ret = dbf_fc_cria_rec(102, vlr_lixo,w_config, w_isento_i); 


SET ret = dbf_fc_cria_desc_imo(); 


SET ret = dbf_fc_cria_bci_valor(w_codigo,5099,vvt,w_ano);
SET ret = dbf_fc_cria_bci_valor(w_codigo,5199,vve,w_ano);
SET ret = dbf_fc_cria_bci_valor(w_codigo,5299,vvi,w_ano);
SET ret = dbf_fc_cria_bci_valor(w_codigo,5399,m2_terreno,w_ano);
SET ret = dbf_fc_cria_bci_valor(w_codigo,5499,m2_construcao,w_ano);
SET ret = dbf_fc_cria_bci_valor(w_codigo,5599,aliq*100,w_ano);
SET ret = dbf_fc_cria_bci_valor(w_codigo,5699,fracao_ideal,w_ano);
