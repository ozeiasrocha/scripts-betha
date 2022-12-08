%% F�rmula desenvolvido pelo analista Tiago Silvano atrav�s do chamado VANCE-977 - 08/09/2015
/* -- F�rmula de Lan�amento para receita de  100-IMPOSTO PREDIAL E TERRITORIAL URBANO referente Exerc�cio de 2014*/
%%	w_codigo        ---> C�digo de refer�ncia que est� sendo calculado (Im�vel / Econ�mico / Pedido / Melhoria / etc)
%%	w_refer         ---> C�digo do im�vel no caso de Contribui��o de Melhoriar ou C�digo da Publicidade
%%	w_parc_ini      ---> N� da parcela Inicial 
%%	w_parc_fin      ---> N� da parcela Final 
%%	w_receita       ---> Passa a Receita Principal
%%	w_ano           ---> Passa o ano que ser� Calculado
%%	w_config        ---> Configura��o informada na Janela de Calculo
%%	w_npar          ---> Passa o N�mero de Parcela a serem geradas, caso n�o tenha Par�metros das Parcelas
%%	w_moeda         ---> Passa o C�digo da moeda
%%  w_venc_ini      ---> Vcto Inicial
%%  w_dias          ---> dias vcto
%%  w_antecip       ---> Antecipa
%%  w_simula        ---> Simulado
%%  w_notifica      ---> Ser� notificado ap�s a gera��o
%%  w_complementa   ---> Complementar
%%  w_unidade       ---> Unidade
%%  w_atos          ---> Passa o c�digo do Lei/Ato

DECLARE areacons          NUMERIC(15,4);      % �rea construida da unidade
DECLARE areaterr          NUMERIC(15,4);      % �rea construida da unidade
DECLARE vvt               NUMERIC(15,4);      % valor venal do terreno
DECLARE vvc               NUMERIC(15,4);      % valor venal da construcao
DECLARE vvi               NUMERIC(15,4);      % valor venal do imovel   
DECLARE w_taxa_lixo       NUMERIC(15,4);      % valor coleta de lixo 
DECLARE aliquota          NUMERIC(15,4);      % valor aliquota  
DECLARE w_taxa            NUMERIC(15,4);      % valor da taxa
DECLARE testada           NUMERIC(15,4);      % Valor da testada do Im�vel 
DECLARE ufme              NUMERIC(15,4);      % Unidade Padr�o Municipal  
DECLARE construido        INTEGER;            % existe constru��o [1]-sim [2]-n�o   
DECLARE valor_iptu        NUMERIC(15,4);      % valor do imposto 
DECLARE total_iptu        NUMERIC(15,4);      % valor total do imposto      
DECLARE aliq_lixo         NUMERIC(15,4);      % aliquota do lixo  
DECLARE aliq_taxa         NUMERIC(15,4);      % aliquota taxa expediente
DECLARE w_configuracao    INTEGER;
DECLARE w_engloba         INTEGER;            % flag isen��o
DECLARE w_isencao         INTEGER;            % flag isen��o
DECLARE w_isencao_iptu    INTEGER;            % flag isen��o iptu
DECLARE w_isencao_tsu     INTEGER;            % flag isen��o tsu
DECLARE data_isencao      DATE;
DECLARE ano_isencao       INTEGER;      
DECLARE unidade           INTEGER; 
DECLARE rural             CHAR;  
DECLARE w_tipo            INTEGER; 
DECLARE w_tipo_categoria  INTEGER;
DECLARE w_tipo_construcao INTEGER;    
DECLARE w_tipo_lixeiro    INTEGER;  
DECLARE w_tributacao      INTEGER;
%-------------------------------------------------------------------------------------------------
% VERIFICANDO SE EXISTE IMOVEIS ENGLOBADOS
%-------------------------------------------------------------------------------------------------

SELECT engloba_com INTO w_engloba FROM
bethadba.imoveis WHERE i_imoveis=w_codigo;  

%Verifica se o im�vel � rural n�o gera o IPTU
SET rural = (SELECT rural FROM bethadba.imoveis WHERE i_imoveis = w_codigo);
     IF rural = 'S' THEN
         CALL dbp_raiserror('','N�O GERA LAN�AMENTO DO IPTU, IMOVEL � RURAL.');
     END IF;

%-----------------------------------------------------------------------------------------------------------
% Unidade Fiscal no Municipio (UFM)
SET ufme = dbf_fc_valor_idx(2,today());
 %SET ufme = 101.12;
%-----------------------------------------------------------------------------------------------------------
% ATRIBUINDO VALORES AS VARI�VEIS  
SET unidade = (SELECT unidade FROM bethadba.imoveis WHERE i_imoveis = w_codigo);
   
SET areaterr = isnull((dbf_fc_retbci_valor(w_codigo,9999,w_ano)),0); 
     IF areaterr = '' THEN
         CALL dbp_raiserror('','N�O GERA LAN�AMENTO DO IPTU, FAVOR INFORMAR O VALOR NO BCI 9999.');
     END IF;  
SET areacons = isnull((dbf_fc_retbci_valor(w_codigo,10299,w_ano)),0);     
IF unidade > 0  AND areacons = '' THEN
       CALL dbp_raiserror('','N�O GERA LAN�AMENTO DO IPTU, FAVOR INFORMAR O VALOR NO BCI 10299.');
     END IF;
   
%----------------------------------------------------------------------------------------------------------
%--------------------- BCI's Obrigados para gera��o do c�lculo do imposto ---------------------------------
SET w_tipo =(SELECT i_item FROM bethadba.opcoes_bci WHERE i_item BETWEEN 100 AND 199  
              AND i_imoveis  = w_codigo AND ano = dbf_ano_base(w_codigo,w_ano,100,'opcoes_bci',NULL));
IF(w_tipo IS NULL) THEN
 CALL dbp_raiserror('FAVOR INFORMAR O VALOR NO BCI 100 Tipo de Im�vel');
END IF;  
SET w_tipo_categoria =(SELECT i_item FROM bethadba.opcoes_bci WHERE i_item BETWEEN 200 AND 299  
              AND i_imoveis  = w_codigo AND ano = dbf_ano_base(w_codigo,w_ano,200,'opcoes_bci',NULL));
IF(w_tipo_categoria IS NULL) THEN
 CALL dbp_raiserror('FAVOR INFORMAR O VALOR NO BCI 200 Categoria/Localiza��o');
END IF; 
SET w_tipo_construcao =(SELECT i_item FROM bethadba.opcoes_bci WHERE i_item BETWEEN 4000 AND 4099  
              AND i_imoveis  = w_codigo AND ano = dbf_ano_base(w_codigo,w_ano,4000,'opcoes_bci',NULL)); 
IF (unidade > 0)  AND (w_tipo_construcao IS NULL) THEN   
 CALL dbp_raiserror('FAVOR INFORMAR O VALOR NO BCI 4000 Tipo de Constru��o');
END IF;  
SET w_tipo_lixeiro =(SELECT i_item FROM bethadba.opcoes_bci WHERE i_item BETWEEN 9200 AND 9299  
              AND i_imoveis  = w_codigo AND ano = dbf_ano_base(w_codigo,w_ano,9200,'opcoes_bci',NULL));     
IF(w_tipo_lixeiro IS NULL) THEN
 CALL dbp_raiserror('FAVOR INFORMAR O VALOR NO BCI 9200 Lixeiro');
END IF;         
SET w_tributacao =(SELECT i_item FROM bethadba.opcoes_bci WHERE i_item BETWEEN 3700 AND 3799  
              AND i_imoveis  = w_codigo AND ano = dbf_ano_base(w_codigo,w_ano,3700,'opcoes_bci',NULL));                               
IF(w_tributacao IS NULL) THEN
 CALL dbp_raiserror('FAVOR INFORMAR O VALOR NO BCI 3700 Tributa��o');
END IF;              
%-----------------------------------------------------------------------------------------------------------
% VERIFICANDO OCUPA��O DO TERRENO
IF (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 101 AND
   (dbf_fc_existe_opc_bci(w_codigo,200,w_ano)) = 201 THEN
   SET vvt = ufme*0.2*areaterr;   
ELSEIF 
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 101 AND
   (dbf_fc_existe_opc_bci(w_codigo,200,w_ano)) = 202 THEN
    SET vvt = ufme*1.5*areaterr;
ELSEIF
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 101 AND
   (dbf_fc_existe_opc_bci(w_codigo,200,w_ano)) = 203 THEN
   SET vvt = ufme*1*areaterr; 
ELSEIF     
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 102 AND
   (dbf_fc_existe_opc_bci(w_codigo,200,w_ano)) = 201 THEN
   SET vvt = ufme*2*areaterr; 
ELSEIF     
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 102 AND
   (dbf_fc_existe_opc_bci(w_codigo,200,w_ano)) = 202 THEN
   SET vvt = ufme*1.5*areaterr; 
ELSEIF     
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 102 AND
   (dbf_fc_existe_opc_bci(w_codigo,200,w_ano)) = 203 THEN
   SET vvt = ufme*1*areaterr; 
ELSEIF     
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 103 AND
   (dbf_fc_existe_opc_bci(w_codigo,200,w_ano)) = 204 THEN
   SET vvt = ufme*2*areaterr;
ELSEIF     
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 104 AND
   (dbf_fc_existe_opc_bci(w_codigo,200,w_ano)) = 204 THEN
   SET vvt = ((ufme*1.5)*areaterr);     
END IF;    

%MESSAGE string ('vvt ',vvt) TYPE WARNING TO CLIENT;  
% DEFININDO VALOR DA CONSTRU��O 
IF (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 101 AND
   (dbf_fc_existe_opc_bci(w_codigo,4000,w_ano)) = 4001 THEN
    SET vvc = 800*areacons;   
ELSEIF   
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 101 AND
   (dbf_fc_existe_opc_bci(w_codigo,4000,w_ano)) = 4002 THEN
    SET vvc = 400*areacons;  
ELSEIF   
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 101 AND
   (dbf_fc_existe_opc_bci(w_codigo,4000,w_ano)) = 4003 THEN
    SET vvc = 250*areacons;
ELSEIF   
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 102 AND
   (dbf_fc_existe_opc_bci(w_codigo,4000,w_ano)) = 4001 THEN
    SET vvc = 800*areacons;
ELSEIF   
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 102 AND
   (dbf_fc_existe_opc_bci(w_codigo,4000,w_ano)) = 4002 THEN
    SET vvc = 400*areacons; 
ELSEIF
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 102 AND     % comercial madeira
   (dbf_fc_existe_opc_bci(w_codigo,4000,w_ano)) = 4003 THEN
    SET vvc = 250*areacons;
ELSEIF   
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 104 AND      %galp�o misto
   (dbf_fc_existe_opc_bci(w_codigo,4000,w_ano)) = 4002 THEN
    SET vvc = 400*areacons;            
END IF;   
%MESSAGE string ('vvc ',vvc) TYPE WARNING TO CLIENT;       
 % DEFININDO VALOR VENAL DO IM�VEL
   SET vvi =isnull((vvc),0)+ isnull((vvt),0);
%MESSAGE string ('vvi ',vvi) TYPE WARNING TO CLIENT;

%--------------------------------------------------------------------------------------------------------

% DEFININDO VALOR DA ALIQUOTA
IF (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 101 THEN
       SET aliquota = 0.005;   
ELSEIF
  (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 102 THEN
       SET aliquota = 0.02;
ELSEIF
  (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 103 THEN
       SET aliquota = 0.02; 
ELSEIF   
 (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 104 THEN
       SET aliquota = 0.015;    
END IF;   


%MESSAGE string ('aliquota ',aliquota) TYPE WARNING TO CLIENT;              
%---------------------------------------------------------------------------------------------------------
   % CALCULANDO O VALOR DA TAXA DE LIXO
IF (dbf_fc_existe_opc_bci(w_codigo,9200,w_ano)) = 9201 AND 
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 101  THEN
      SET aliq_lixo = 0.3;               
      SET w_taxa_lixo = round(ufme*aliq_lixo,2)
ELSEIF   
   (dbf_fc_existe_opc_bci(w_codigo,9200,w_ano)) = 9201 AND 
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 102  THEN
      SET aliq_lixo = 0.5; 
      SET w_taxa_lixo = round(ufme*aliq_lixo,2); 
ELSEIF   
   (dbf_fc_existe_opc_bci(w_codigo,9200,w_ano)) = 9201 AND 
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 103  THEN 
      SET aliq_lixo = 0.5; 
      SET w_taxa_lixo = round(ufme*aliq_lixo,2); 
ELSEIF   
   (dbf_fc_existe_opc_bci(w_codigo,9200,w_ano)) = 9201 AND 
   (dbf_fc_existe_opc_bci(w_codigo,100,w_ano)) = 104  THEN 
      SET aliq_lixo = 0.5; 
      SET w_taxa_lixo = round(ufme*aliq_lixo,2);                                
END IF;
   % CALCULANDO O VALOR DA TAXA DE EXPEDIENTE
      SET aliq_taxa = 0.20;                          
      SET w_taxa = round(ufme*aliq_taxa,2);                                        
                   
%----------------------------------------------------------------------------------------------------------- 
% VERIFICANDO A DATA DA ISENCAO SE HOUVER   

SET data_isencao = dbf_fc_retbci_data(w_codigo,19097,w_ano);
SET ano_isencao = year(data_isencao);  
%MESSAGE string ('ano_isencao ',ano_isencao) TYPE WARNING TO CLIENT;

% VERIFICANDO ISEN��ES E IMUNIDADE
SET w_isencao = dbf_fc_existe_opc_bci(w_codigo,3700);
IF      (w_isencao = 3703) AND ano_isencao >= w_ano THEN 
        SET w_isencao_iptu = 1;
        SET w_isencao_tsu  = 1; 
ELSEIF  (w_isencao = 3702)  THEN
         SET w_isencao_iptu = 2;
         SET w_isencao_tsu  = 2; 
END IF;                       
%%PRINT(string(w_isencao));


%-----------------------------------------------------------------------------------------------------------
SET  w_config = w_configuracao;
 
%-----------------------------------------------------------------------------------------------------------
% GRAVANDO BCI's
SET ret  = dbf_fc_cria_bci_valor(w_codigo, 10499, vvc,w_ano);     % gravando Valor Venal da constru��o
SET ret  = dbf_fc_cria_bci_valor(w_codigo, 10199, vvt,w_ano);     % gravando Valor Venal DO terreno      
SET ret  = dbf_fc_cria_bci_valor(w_codigo, 10899, vvi,w_ano);     % gravando Valor Venal DO im�vel           
SET valor_iptu = isnull(vvt,0)+isnull(vvc,0);
SET valor_iptu = valor_iptu * aliquota; 
%MESSAGE string ('valor_iptu ',valor_iptu) TYPE WARNING TO CLIENT;
SET ret  = dbf_fc_cria_bci_valor(w_codigo, 11099,valor_iptu,w_ano);% gravando Valor Venal DO im�vel 
SET total_iptu = isnull(valor_iptu,0)+isnull(w_taxa,0)+isnull(w_taxa_lixo,0);   
SET ret  = dbf_fc_cria_bci_valor(w_codigo, 12499,total_iptu,w_ano);% gravando Valor total DO IPTU   
SET ret  = dbf_fc_cria_bci_valor(w_codigo, 11399,w_taxa_lixo,w_ano);% gravando Valor total DO IPTU
SET ret  = dbf_fc_cria_bci_valor(w_codigo, 11599,aliq_taxa,w_ano);% gravando Valor total DO IPTU        
SET ret  = dbf_fc_cria_bci_valor(w_codigo, 11299,aliq_lixo,w_ano);% gravando Valor total DO IPTU   
SET ret  = dbf_fc_cria_bci_valor(w_codigo, 11699,w_taxa,w_ano);% gravando Valor total DO IPTU        
SET ret = dbf_fc_cria_bci_data(w_codigo,9797,w_venc_ini,w_ano);
%------------------------------------------------------------------------------------------------------------     
% CRIANDO RECEITAS  
 
 SET ret = dbf_fc_cria_rec(110,isnull((vvt*aliquota),0),w_config,w_isencao_iptu);  
 SET ret = dbf_fc_cria_rec(111,isnull((vvc*aliquota),0),w_config,w_isencao_iptu/*w_isencao_iptu*/);              
 SET ret = dbf_fc_cria_rec(115,w_taxa,w_config,w_isencao_tsu/*w_isencao_iptu*/);
 SET ret = dbf_fc_cria_rec(120,w_taxa_lixo,w_config,w_isencao_tsu/*w_isencao_iptu*/); 
 
 
 
