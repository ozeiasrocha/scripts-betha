                                         
                                            
 /* -- Fórmula de conversão de valor */
%%	p_moeda       ---> Código da moeda em que o valor esta expresso
%%	p_data        ---> Data para buscar o indexador para converter o valor
%%	p_valor       ---> Valor na moeda p_moeda
%%	p_tipo        ---> Indica o que esta sendo convertido
%%	L             ---> Lançamento do exercício
%%	D             ---> Dívida Ativa
%%	p_codigo      ---> Código do que esta sendo convertido
%%	p_sub_rec     ---> Código da subreceita
%%	w_valor_corr  ---> Valor que será retornado


IF(w_corr = 'S') THEN 
   SET w_valor_corr=p_valor 
ELSE 
   SET w_valor_idx = dbf_fc_valor_idx(p_moeda,p_data); 
   SET w_valor_corr = p_valor * w_valor_idx                     
END IF
