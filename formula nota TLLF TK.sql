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


DECLARE reinicio  INTEGER;       %%Buscca a data de reinicio
DECLARE data_ini  DATE;          %% Data de inicio da atividade
DECLARE dia       INTEGER;       %% Dia do inicio da atividade
DECLARE mes       INTEGER;       %% Mês do inicio da atividade
DECLARE ano       INTEGER;       %% Ano do inicio da atividade
DECLARE area      DECIMAL(15,4); %% Área da atividade
DECLARE valor_tll DECIMAL(15,4); %% Valor da Taxa de tll
DECLARE valor_tff DECIMAL(15,4); %% Valor da taxa de tff
DECLARE valor_aux DECIMAL(15,4); %% Valor auxiliar de calculo
DECLARE ufm       DECIMAL(15,4); %% Valor da ufm   
DECLARE tempo     INTEGER;




%%Verifica a data de iniciio da atividade
SELECT max(i_movi_eco) INTO reinicio 
    FROM bethadba.movi_eco
    WHERE movi_eco.i_economicos = w_codigo AND movi_eco.tipo = 'R'; 
       
    IF(reinicio > 0) THEN
      SET data_ini = dbf_fc_ret_data_reinicio_ativ(w_codigo); 
    ELSE
      SET data_ini = dbf_fc_ret_data_inicio_ativ(w_codigo);
    END IF;
    
    SET dia=day(data_ini);
    SET mes=month(data_ini);
    SET ano=year(data_ini);
    
    IF(ano<w_ano) THEN
      SET tempo=12
    ELSE
      SET tempo=13-mes
    END IF; 

%% Retorna o valor da 
SET ufm = dbf_fc_valor_idx(2,today(*));

MESSAGE string('ufm -> ', ufm) TYPE WARNING TO CLIENT;

    
%% Busca área do estabelecimento;
SET area=dbf_fc_retbce_valor(w_codigo, 599, dbf_ano_base(w_codigo,w_ano,599,'opcoes_bce')); 

MESSAGE string('area ',area) TYPE WARNING TO CLIENT; 

%%Define o valor da taxa de acordo com a metragem do estabelecimento 
%% Taxa de Licença para Localização
   IF area <=20.99 THEN
      SET valor_tll= 60*ufm;
    ELSEIF area>=21 AND area<=50.99 THEN
      SET valor_tll= 71*ufm;
    ELSEIF area>=51 AND area<=100.99 THEN  
      SET valor_tll= 88*ufm; 
    ELSEIF area>=101 AND area<=150.99 THEN  
      SET valor_tll= 110*ufm;
    ELSEIF area>=151 AND area<=200.99 THEN  
      SET valor_tll= 132*ufm; 
    ELSEIF area>=201 AND area<=250.99 THEN  
      SET valor_tll= 154*ufm;  
    ELSEIF area>=251 THEN
      SET valor_tll= 550*ufm; 
    END IF;
    
    MESSAGE 'valor_tll>>>'||valor_tll TYPE WARNING TO CLIENT; 
   
    
%%Taxa de Licença e fiscalização
  IF area <=20 THEN
     SET  valor_tff=20*ufm;
  ELSEIF area>20 AND area <=2000 THEN
     SET valor_aux= area*0.4*ufm;
     SET valor_tff= 80*ufm;
     SET valor_tff=valor_tff+valor_aux;
  ELSEIF  area>2000 THEN  
     SET valor_aux= area*0.4*ufm;
     SET valor_tff= 300*ufm;
     SET valor_tff=valor_tff+valor_aux; 
  END IF; 

%%Calcula proporcional
%SET valor_tll=valor_tll/12*tempo;

%%Criando AS receitas  

IF ano=w_ano THEN
SET ret = (dbf_fc_cria_rec(301,valor_tll,1));     
 MESSAGE 'ret1'||ret TYPE WARNING TO CLIENT; 
ELSE  
SET ret = (dbf_fc_cria_rec(302,valor_tff,1));    
 MESSAGE 'ret2'||ret TYPE WARNING TO CLIENT; 
END IF;
    
           