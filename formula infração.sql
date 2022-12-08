/* -- Fórmula de Lançamento para receita de  2600-Auto de Infração referente Exercício de 2015*/
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


DECLARE w_valor1    DECIMAL(15,4);
DECLARE w_valor2    DECIMAL(15,4);
DECLARE w_valor3    DECIMAL(15,4);
DECLARE w_valor4    DECIMAL(15,4);
DECLARE w_desc1     DECIMAL(15,4);
DECLARE w_desc2     DECIMAL(15,4);
DECLARE w_desc3     DECIMAL(15,4);
DECLARE w_desc4     DECIMAL(15,4);
DECLARE w_ufm       DECIMAL(15,4);
DECLARE w_data_aux  CHAR(10);
DECLARE w_receitas  INTEGER;  
DECLARE rec1        INTEGER;
DECLARE rec2        INTEGER;
DECLARE rec3        INTEGER;
DECLARE rec4        INTEGER;

SELECT ("bethadba"."dbf_fc_conv_valor"(i_moedas,today(),valor))INTO w_valor1 
FROM bethadba.autos KEY JOIN bethadba.autos_infracoes KEY JOIN bethadba.infracoes 
WHERE autos.i_autos = w_codigo  AND autos.ano = w_ano AND autos_infracoes.i_infracoes=1; 

SELECT ("bethadba"."dbf_fc_conv_valor"(i_moedas,today(),valor))INTO w_valor2  
FROM bethadba.autos KEY JOIN bethadba.autos_infracoes KEY JOIN bethadba.infracoes 
WHERE autos.i_autos = w_codigo  AND autos.ano = w_ano AND autos_infracoes.i_infracoes=2; 

SELECT ("bethadba"."dbf_fc_conv_valor"(i_moedas,today(),valor))INTO w_valor3 
FROM bethadba.autos KEY JOIN bethadba.autos_infracoes KEY JOIN bethadba.infracoes 
WHERE autos.i_autos = w_codigo  AND autos.ano = w_ano AND autos_infracoes.i_infracoes=3; 

SET w_valor1=isnull(w_valor1,0);
SET w_valor2=isnull(w_valor2,0);
SET w_valor3=isnull(w_valor3,0);

%%MESSAGE 'valor_auto: '||w_valor1 type warning TO client; 


%Seleção para pegar o percentual de desconto para AS infrações.
SET w_desc1 = (SELECT desc_multa FROM 
             bethadba.autos_infracoes KEY JOIN bethadba.infracoes  
             WHERE i_autos = w_codigo AND bethadba.autos_infracoes.ano = w_ano AND autos_infracoes.i_infracoes=1);   

SET w_desc2 = (SELECT desc_multa FROM 
             bethadba.autos_infracoes KEY JOIN bethadba.infracoes  
             WHERE i_autos = w_codigo AND bethadba.autos_infracoes.ano = w_ano AND autos_infracoes.i_infracoes=2);   
SET w_desc3 = (SELECT desc_multa FROM 
             bethadba.autos_infracoes KEY JOIN bethadba.infracoes  
             WHERE i_autos = w_codigo AND bethadba.autos_infracoes.ano = w_ano AND autos_infracoes.i_infracoes=3);   
             
SET w_desc4 = (SELECT desc_multa FROM 
             bethadba.autos_infracoes KEY JOIN bethadba.infracoes  
             WHERE i_autos = w_codigo AND bethadba.autos_infracoes.ano = w_ano AND autos_infracoes.i_infracoes=4);    
SET w_desc1=isnull(w_desc1,0);
SET w_desc2=isnull(w_desc2,0);
SET w_desc3=isnull(w_desc3,0);
SET w_desc4=isnull(w_desc4,0);
            
 
%%MESSAGE 'valor_desc: '||w_desc4 type warning TO client;   

%%SET w_desc = (w_perc_desc * w_valor_auto) / 100;       
%%MESSAGE 'w_desc: '||w_desc type warning TO client; 
%%MESSAGE 'w_perc: '||w_perc_desc type warning TO client;    
                                                              

SET ret = dbf_fc_cria_rec(2604, w_valor1); 
SET ret = dbf_fc_cria_rec(2603, w_valor2);
SET ret = dbf_fc_cria_rec(2601, w_valor3);
%%IF rec4<>0 THEN SET ret = dbf_fc_cria_rec(rec4, w_valor4); END IF;
 
%Altera o vencimeno para 20 dias  
SET w_data_aux = STRING( dateformat(today() + 20,'YYYYMMDD') );
CALL dbf_fc_upd_calc('w_venc_ini', ''''+ w_data_aux +'''');   
 
                                                           

 SET ret  = dbf_fc_gera_desc(2604,50); 
 SET ret  = dbf_fc_gera_desc(2603,50);  
 SET ret  = dbf_fc_gera_desc(2601,50); 


  
