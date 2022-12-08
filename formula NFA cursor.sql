DECLARE w_iss    DECIMAL;
DECLARE div      DECIMAL(15,4);   
DECLARE base     DECIMAL(15,4);
SET base=0; SET w_iss=0;

llLoop: FOR ll AS lc_itens dynamic scroll CURSOR FOR 
SELECT i_itens AS w_item, i_atividades AS w_ativ, valor AS w_valor, aliquota AS w_aliq, quantidade AS w_qtd, valor_reducao AS w_red
FROM bethadba.itens_nota
WHERE i_notas=w_codigo
ORDER BY i_itens DO  
  IF w_ativ IN (2) THEN 
     SET base  = base  + (w_valor - w_red) * w_qtd * 0.4;
     SET w_iss = w_iss + (w_valor - w_red) * w_qtd * w_aliq / 100 * 0.4; 
     MESSAGE base type warning TO client;
  ELSE
     SET base  = base  + (w_valor - w_red) * w_qtd;
     SET w_iss = w_iss + (w_valor - w_red) * w_qtd * w_aliq / 100; 
     MESSAGE base type warning TO client;
  END IF;        
END FOR;
SET div=6.36;    
SET ret = dbf_fc_cria_rec(1501,w_iss);     
SET ret = dbf_fc_cria_rec(1502,div);  

