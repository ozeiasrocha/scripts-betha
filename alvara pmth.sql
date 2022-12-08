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


DECLARE reinicio  INTEGER;       %% Busca a data de reinicio
DECLARE data_ini  DATE;          %% Data de inicio da atividade
DECLARE dia       INTEGER;       %% Dia do inicio da atividade
DECLARE mes       INTEGER;       %% Mês do inicio da atividade
DECLARE ano       INTEGER;       %% Ano do inicio da atividade
DECLARE area      DECIMAL(15,4); %% Área da atividade
DECLARE valor_tll DECIMAL(15,4); %% Valor da Taxa de tll
DECLARE valor_tff DECIMAL(15,4); %% Valor da taxa de tff
DECLARE valor_aux DECIMAL(15,4); %% Valor auxiliar de calculo  
DECLARE vlr_int   INTEGER;  
DECLARE ufm       DECIMAL(15,4); %% Valor da ufm   
DECLARE tempo     INTEGER;
DECLARE w_ativ    INTEGER;       %%utilização
DECLARE w_lixo    INTEGER;       %%lixo
DECLARE w_func    DECIMAL(15,4);        %%No. funcionários


%%Verifica a data de inicio da atividade
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

%%MESSAGE string('ufm -> ', ufm) TYPE WARNING TO CLIENT;

    
%% Busca área do estabelecimento;
SET area=dbf_fc_retbce_valor(w_codigo, 199, dbf_ano_base(w_codigo,w_ano,199,'opcoes_bce')); 
%%MESSAGE string('area ',area) TYPE WARNING TO CLIENT; 

%% Busca qtd  funcionários;
SET w_func=dbf_fc_retbce_valor(w_codigo, 498, dbf_ano_base(w_codigo,w_ano,498,'opcoes_bce'));   
%% MESSAGE 'QTD_FUNC '|| w_func TYPE WARNING TO CLIENT;  
    
%% Busca Classificação de atividade
SET w_ativ=dbf_fc_ret_opc_economico(w_codigo, 300, dbf_ano_base(w_codigo,w_ano,300,'opcoes_bce'));
   
 
%Busca taxa de serviços urbanos (lixo)
SET w_lixo=dbf_fc_ret_opc_economico(w_codigo, 200, dbf_ano_base(w_codigo,w_ano,200,'opcoes_bce'));

              
%define valor da TLL

IF w_ativ IN (301,303,304,305,308) THEN
  SET valor_tll = 1;
ELSE
  SET valor_tll = 0.8;
END IF;  
   
           

%define valor da TFF
 
IF w_ativ IN (301,303, 304) THEN   %% industria, comercio, serviços
  IF w_func <= 5 THEN
    SET valor_tff = 2;
  ELSEIF w_func > 5 AND w_func <= 10 THEN
    SET valor_tff = 4;
  ELSE             %% 2 para cada grupo de 10 ou fração          
    SET vlr_int   = w_func / 10; 
    SET valor_aux   = w_func / 10; 
    
    IF valor_aux > vlr_int THEN
      SET valor_tff = (vlr_int + 1) * 2 ;
    ELSE
      SET valor_tff = vlr_int * 2;
    END IF;  
    
  END IF;  
ELSEIF w_ativ = 305 THEN  %% diversoes publicas
  SET valor_tff = 8;

ELSEIF w_ativ = 308 THEN   %% credito, financeiras
   IF w_func <= 10 THEN
    SET valor_tff = 5;
   ELSEIF w_func > 10 AND w_func <= 30 THEN
    SET valor_tff = 15;
   ELSE                %% 10 para cada grupo de 20 ou fração

    SET vlr_int   = w_func / 20;
    SET valor_aux   = w_func / 20; 
    
    IF valor_aux > vlr_int THEN
      SET valor_tff = (vlr_int + 1) * 10 ;
    ELSE
      SET valor_tff = vlr_int * 10;
    END IF; 
    

   END IF;  
ELSE   %% 302 - AGRO, 306 - AUTONOMO, 307 - FEIRANTES, 310 - ESPORADICOS
   SET valor_tff = 0.5;
     
  
END IF;  

%converte UFMMHT em reais     
SET valor_tll = valor_tll * ufm;
SET valor_tff = valor_tff * ufm;            
%%MESSAGE 'valor_tll '|| valor_tll TYPE WARNING TO CLIENT;              
%%MESSAGE 'valor_tff '|| valor_tff TYPE WARNING TO CLIENT;              

%%Define o valor da taxa de acordo com a metragem do estabelecimento  



%% Taxa de Licença para Localização

   
    
%%Taxa de Licença e fiscalização


%%Calcula proporcional
%SET valor_tll=valor_tll/12*tempo;

%%Criando AS receitas  

IF ano=w_ano THEN
 SET ret = (dbf_fc_cria_rec(301,valor_tll,1));     
 %%MESSAGE 'rec301  '||ret TYPE WARNING TO CLIENT; 
 SET ret = (dbf_fc_cria_rec(302,valor_tff ,1));    
 %%MESSAGE 'rec302  '||ret TYPE WARNING TO CLIENT; 
ELSE  
 SET ret = (dbf_fc_cria_rec(302,valor_tff ,1));    
 %%MESSAGE 'rec302  '||ret TYPE WARNING TO CLIENT; 
END IF;
    