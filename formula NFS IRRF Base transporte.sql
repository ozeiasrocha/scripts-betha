/* -- Cálculo de IRRF
p_nr_nota       ---> Código da Nota Avulsa para Cálculo DO IRRF
p_valor_INSS    ---> Valor DO INSS Calculado para a Nota
w_valor_calc	 ---> Valor DO IRRF Calculado
Criado por: Ozeias Rocha */
 
 


DECLARE base     DECIMAL(15,4);
SET base=0;      

llLoop: FOR ll AS lc_itens dynamic scroll CURSOR FOR 
SELECT i_itens AS w_item, i_atividades AS w_ativ, valor AS w_valor, aliquota AS w_aliq, quantidade AS w_qtd, valor_reducao AS w_red
FROM bethadba.itens_nota
WHERE i_notas=p_nr_nota
ORDER BY i_itens DO  
  IF w_ativ IN (4924800, 10000009) THEN 
     SET base  = base  + (w_valor - w_red) * w_qtd * 0.6;
  ELSE
     SET base  = base  + (w_valor - w_red) * w_qtd;
  END IF;        
END FOR;  

%%Calculando o Valor do IRRF
IF(base <= 1903.98) THEN
   SET w_valor_calc = 0.00;
ELSEIF((base > 1903.98) AND (base <= 2826.55)) THEN   
   SET w_valor_calc = ((base) * 0.075) - 142.80;          
ELSEIF((base > 2826.55) AND (base <= 3751.05)) THEN
   SET w_valor_calc = ((base) * 0.15)- 354.80;
ELSEIF((base > 3751.05) AND (base <= 4664.68)) THEN
   SET w_valor_calc = ((base) * 0.225)- 636.13;
ELSEIF(base > 4664.68) THEN
   SET w_valor_calc = (base * 0.275)- 869.36;                    
END IF;