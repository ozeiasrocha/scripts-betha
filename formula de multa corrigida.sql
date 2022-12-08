 /* -- Fórmula de Multa de Lançamentos para receita de  [99999 - GERAL] referente Exercício de 2009*/
%%	p_valor       ---> Valor em Moeda Corrente
%%	p_vcto        ---> Data de Vencimento
%%	p_pgto        ---> Data de Pagamento
%%	p_valor_multa ---> Valor do Multa
%%	p_sub_rec    ---> Passa o Código da sub-receita
%%  p_codigo     ---> Código do débito
%%  p_moeda      ---> Código da Moeda do débito    

DECLARE w_meses INTEGER;
DECLARE w_dias INTEGER;
DECLARE w_prox_data DATE;  
DECLARE w_feriado INTEGER;  
DECLARE correcao DECIMAL(15,4);                       

DECLARE w_corr CHAR(1);
DECLARE w_idx_vcto DECIMAL(15,10);
DECLARE w_idx_pgto DECIMAL(15,10);
DECLARE w_correcao DECIMAL(15,10);
%% calcula correcao ----------------------------------------------
%% verifica se a moeda eh a corrente do pais
SELECT corrente INTO w_corr FROM moedas WHERE i_moedas=p_moeda;
  %% pega valor do indexador na da de vencimento, se for nulo fica zero
SET w_idx_vcto=dbf_fc_valor_idx(2,p_vcto);
%% pega valor do indexador na da de pagamento, se for nulo fica zero
SET w_idx_pgto=dbf_fc_valor_idx(2,p_pgto);
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
  
  IF (p_pgto > p_vcto) THEN   
  IF year(p_pgto) = year(p_vcto) THEN
    SET p_valor_multa = p_valor * 0.02;
  ELSE
  IF year(p_pgto) > year(p_vcto) THEN  
    SET p_valor_multa = (p_valor+w_correcao) * 0.1;
  END IF;
 END IF;
END IF;




/*
% Multa de 2% até ultimo dia DO ano de lançamento e 10% no ano posterior ao lançamento.
% Juros de 1% ao mês (0.0333 ao dia)


IF (p_pgto > p_vcto) THEN   
  IF year(p_pgto) = year(p_vcto) THEN
    SET p_valor_multa = p_valor * 0.02;
  ELSE
  IF year(p_pgto) > year(p_vcto) THEN  
    SET p_valor_multa = p_valor * 0.1;
  END IF;
 END IF;
END IF;

*/