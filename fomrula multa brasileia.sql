DECLARE w_meses INTEGER;
DECLARE w_dias INTEGER;
DECLARE w_prox_data DATE;  
DECLARE w_feriado INTEGER;                         
DECLARE w_corr CHAR(1);
DECLARE w_idx_vcto DECIMAL(15,10);
DECLARE w_idx_pgto DECIMAL(15,10);
DECLARE w_correcao DECIMAL(15,10);
%% calcula correcao ----------------------------------------------
%% verifica se a moeda eh a corrente do pais
SELECT corrente INTO w_corr FROM moedas WHERE i_moedas=p_moeda;
  %% pega valor do indexador na da de vencimento, se for nulo fica zero
SET w_idx_vcto=dbf_fc_valor_idx(4,p_vcto);
%% pega valor do indexador na da de pagamento, se for nulo fica zero
SET w_idx_pgto=dbf_fc_valor_idx(4,p_pgto);
%%calcula a correª-o caso a moeda seja a corrente

SET w_correcao=(p_valor/w_idx_vcto)*w_idx_pgto-p_valor; 

                 
% SE NO VENCIMENTO FOR FERIADO ADICIONA 01 DIA AO P_VCTO:
                 
  SET w_feriado = dbf_eh_feriado(p_vcto);
    WHILE w_feriado > 0 LOOP
       SET p_vcto = days(p_vcto,1);
       SET w_feriado = dbf_eh_feriado(p_vcto);
    END LOOP;
  
 
  SET w_meses=months(p_vcto,p_pgto);
  SET w_dias=days(p_vcto,p_pgto);  
 %% MESSAGE w_correcao type warning TO client;

  IF (w_dias * 0.33)<20 THEN
   SET p_valor_multa =(p_valor+w_correcao)*(w_dias * 0.33)/100;
  ELSEIF w_dias > 30 THEN
   SET p_valor_multa =( p_valor+w_correcao) * 0.20;  
  END IF;