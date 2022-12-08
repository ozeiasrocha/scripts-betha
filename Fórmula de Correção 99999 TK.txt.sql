/* -- Fórmula de Correção*/
%%	p_valor_cnv  ---> Valor na moeda Original
%%	w_valor_corr ---> Valor da Correção
%%	p_data_vcto  ---> Data de Vencimento
%%	p_data_pgto  ---> Data de Pagamento
%%	p_moeda      ---> Passa o Código da moeda
%%	p_ano        ---> Passa o ano do débito/divida
%%	p_sub_rec    ---> Código da subreceita
%%  w_atos       ---> Passa o código do Lei/Ato
/**** Para as receitas (eventos) do sistema Betha Faturas é retornado o
código DO evento + 50000 ex: para o evento 1 é retornado o código 50001. ****/
%%  p_classe     ---> Passa o código da classe de consumo
%%  p_tipo_eve   ---> Passa o tipo de evento 
/**** p_classe e p_tipo_eve somente devem ser utilizadas se o
sistema estiver configurado para a integração com o Betha Fatura. ****/
%%	p_ind_tipo   ---> Indica o que esta sendo corrigido 
%%                    ('L-Lancto','D-Divida','A-Acordo')
%%  p_valor_tribP ---> Valor total das receitas parceladas no acordo
%%  p_valor_corrP ---> Valor total da correção parcelada no acordo
%%  p_valor_JuroP ---> Valor total do juro parcelado no acordo
%%  p_valor_MultP ---> Valor total da multa parcelada no acordo
%%  w_atos        ---> Passa o código do Lei/Ato


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
  