/* -- Fórmula de Correção */ 
  DECLARE w_corr CHAR(1);  
  DECLARE w_idx_vcto DECIMAL(15,10); 
  DECLARE w_idx_pgto DECIMAL(15,10); 
 %% verifica se a moeda eh a corrente do pais  
  SELECT corrente INTO w_corr FROM moedas WHERE i_moedas=p_moeda; 
  %% pega valor do indexador na da de vencimento, se for nulo fica zero 
  SET w_idx_vcto=dbf_fc_valor_idx(p_moeda,p_data_vcto); 
  %% pega valor do indexador na da de pagamento, se for nulo fica zero 
  SET w_idx_pgto=dbf_fc_valor_idx(p_moeda,p_data_pgto); 
  %%calcula a correª-o caso a moeda seja a corrente 
  IF(w_corr='S') THEN 
  	IF(w_idx_vcto>0) AND(w_idx_pgto>0) THEN  
  		SET w_valor_corr=(p_valor_cnv/w_idx_vcto)*w_idx_pgto-p_valor_cnv  
  	END IF 
  	ELSE  
   	%%calcula a correª-o para indexar 
  	SET w_valor_corr=(p_valor_cnv*w_idx_pgto)-(p_valor_cnv*w_idx_vcto) 
  END IF; 
  

