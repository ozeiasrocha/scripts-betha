
DECLARE w_meses INTEGER;
DECLARE w_dias INTEGER;
DECLARE w_prox_data DATE;  
DECLARE w_feriado INTEGER;  

DECLARE w_corr CHAR(1);
DECLARE w_idx_vcto DECIMAL(15,10);
DECLARE w_idx_pgto DECIMAL(15,10);
DECLARE w_correcao DECIMAL(15,10);
%%-- calcula correcao ----------------------------------------------
%%-- verifica se a moeda eh a corrente do pais
SELECT corrente INTO w_corr FROM moedas WHERE i_moedas=p_moeda;
  %%-- pega valor do indexador na da de vencimento, se for nulo fica zero
SET w_idx_vcto=dbf_fc_valor_idx(2,p_vcto);
%%-- pega valor do indexador na da de pagamento, se for nulo fica zero
SET w_idx_pgto=dbf_fc_valor_idx(2,p_pgto);
%%--calcula a correª-o caso a moeda seja a corrente

%%--SET w_corrECAO=(p_valor*w_idx_pgto)-(p_valor*w_idx_vcto);
SET w_correcao=(p_valor/w_idx_vcto)*w_idx_pgto-p_valor; 

%%-- calcula juros -------------------------------------------------                 
                        

%%-- SE NO VENCIMENTO FOR FERIADO ADICIONA 01 DIA AO P_VCTO:
                 
  SET w_feriado = dbf_eh_feriado(p_vcto);
    WHILE w_feriado > 0 LOOP
       SET p_vcto = days(p_vcto,1);
       SET w_feriado = dbf_eh_feriado(p_vcto);
    END LOOP;
  
 
  SET w_meses=months(p_vcto,p_pgto)+1;
  SET w_dias=days(p_vcto,p_pgto);   
 %%-- message w_correcao type warning to client;
 
  IF(w_dias >= 1) THEN
   SET p_valor_juro=((isnull(w_meses,0)))*(.01)*(p_valor+w_correcao) ;  
   %%--set p_valor_juro =w_correcao; 
   %%--SET P_VALOR_JURO=W_CORRECAO;
  END IF; 
