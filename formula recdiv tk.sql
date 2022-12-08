-- Fórmula de Lançamento para receita de  400-Receitas Diversas referente Exercício de 2013*/
%%  w_codigo        ---> Código de referência que está sendo calculado (Imóvel / Econômico / Pedido / Melhoria / etc)
%%  w_refer         ---> Código do imóvel no caso de Contribuição de Melhoriar ou Código da Publicidade
%%  w_parc_ini      ---> Nº da parcela Inicial 
%%  w_parc_fin      ---> Nº da parcela Final 
%%  w_receita       ---> Passa a Receita Principal
%%  w_ano           ---> Passa o ano que será Calculado
%%  w_config        ---> Configuração informada na Janela de Calculo
%%  w_npar          ---> Passa o Número de Parcela a serem geradas, caso não tenha Parâmetros das Parcelas
%%  w_moeda         ---> Passa o Código da moeda
%%  w_venc_ini      ---> Vcto Inicial
%%  w_dias          ---> dias vcto
%%  w_antecip       ---> Antecipa
%%  w_simula        ---> Simulado
%%  w_notifica      ---> Será notificado após a geração
%%  w_complementa   ---> Complementar
%%  w_unidade       ---> Unidade
%%  w_atos          ---> Passa o código do Lei/Ato
 
DECLARE base1 DECIMAL(15,4); 
DECLARE base2 DECIMAL(15,4); 
DECLARE base3 DECIMAL(15,4); 
DECLARE base4 DECIMAL(15,4); 
DECLARE base5 DECIMAL(15,4); 
DECLARE base6 DECIMAL(15,4); 
DECLARE base7 DECIMAL(15,4); 
DECLARE base8 DECIMAL(15,4); 
DECLARE base9 DECIMAL(15,4); 
DECLARE base10 DECIMAL(15,4); 
DECLARE base11 DECIMAL(15,4); 
DECLARE base12 DECIMAL(15,4); 
DECLARE base13 DECIMAL(15,4);
DECLARE base14 DECIMAL(15,4);
DECLARE base15 DECIMAL(15,4);
DECLARE base16 DECIMAL(15,4);
DECLARE base17 DECIMAL(15,4);
DECLARE base18 DECIMAL(15,4);
DECLARE base19 DECIMAL(15,4);
DECLARE base20 DECIMAL(15,4);
DECLARE base21 DECIMAL(15,4);
DECLARE base22 DECIMAL(15,4); 
 
DECLARE asfaltada DECIMAL(15,4);
DECLARE tijolada DECIMAL(15,4);


DECLARE idx DECIMAL(15,4);
DECLARE tipo_serv INTEGER;

SELECT i_tipo_serv INTO tipo_serv FROM bethadba.pedidos_processos WHERE i_pedidos = w_codigo;

SET idx=dbf_fc_valor_idx(2,today(*));

IF tipo_serv= 2 THEN  %%Receitas Diversas
 
 
SET base1=dbf_fc_valor_base(w_codigo,1);
SET base2=dbf_fc_valor_base(w_codigo,2);
SET base3=dbf_fc_valor_base(w_codigo,3);
SET base4=dbf_fc_valor_base(w_codigo,4);
SET base5=dbf_fc_valor_base(w_codigo,5);
SET base6=dbf_fc_valor_base(w_codigo,6);
SET base7=dbf_fc_valor_base(w_codigo,7);
SET base8=dbf_fc_valor_base(w_codigo,8);
SET base9=dbf_fc_valor_base(w_codigo,9);
SET base10=dbf_fc_valor_base(w_codigo,10);
SET base11=dbf_fc_valor_base(w_codigo,11);
SET base12=dbf_fc_valor_base(w_codigo,12);
SET base13=dbf_fc_valor_base(w_codigo,13);
SET base14=dbf_fc_valor_base(w_codigo,14);

SET ret = dbf_fc_cria_rec(401,base1,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(402,base2,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(403,base3,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(404,base4,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(405,base5,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(406,base6,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(407,base7,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(408,base8,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(409,base9,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(410,base10,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(411,base11,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(412,base12,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(413,base13,NULL,NULL,'N'); 
SET ret = dbf_fc_cria_rec(414,base14,NULL,NULL,'N');

ELSEIF tipo_serv=3 THEN %%Escavação de Rua Por Metro

SET base1=dbf_fc_valor_base(w_codigo,1);
SET base2=dbf_fc_valor_base(w_codigo,2);  
SET base3=dbf_fc_valor_base(w_codigo,3); 

SET ret = dbf_fc_cria_rec(414,base1,NULL,NULL,'N'); 
SET ret = dbf_fc_cria_rec(415,base2,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(426,base3,NULL,NULL,'N');

ELSEIF tipo_serv=4 THEN %%Aluguéis de box

SET base17=dbf_fc_valor_base(w_codigo,1);
SET base18=dbf_fc_valor_base(w_codigo,2);
SET base19=dbf_fc_valor_base(w_codigo,3);
SET base20=dbf_fc_valor_base(w_codigo,4);
SET base21=dbf_fc_valor_base(w_codigo,5);

SET ret = dbf_fc_cria_rec(416,base17,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(417,base18,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(418,base19,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(419,base20,NULL,NULL,'N');
SET ret = dbf_fc_cria_rec(420,base21,NULL,NULL,'N');   

ELSEIF tipo_serv=5 THEN %%alvará    
SET base22=dbf_fc_valor_base(w_codigo,1)*idx;  

SET ret = dbf_fc_cria_rec(421,base22,NULL,NULL,'N');

END IF;

