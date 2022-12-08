/* -- Cálculo de IRRF*/
%%  p_nr_nota       ---> Código da Nota Avulsa para Cálculo do IRRF
%%  p_valor_INSS    ---> Valor do INSS Calculado para a Nota
%%  w_valor_calc	 ---> Valor do IRRF Calculado
DECLARE totalNota       DECIMAL(15,4);    
DECLARE w_inss          DECIMAL(15,4);

%%Busca o Valor Total da Nota
SELECT totalNota = sum(valor * quantidade) 
INTO totalNota FROM bethadba.notas_avulsas JOIN bethadba.itens_nota
WHERE notas_avulsas.i_notas = p_nr_nota; 


%%Calculando o Valor do INSS
%%====================         
SET w_inss=0;
IF(totalNota <= 1659.38) THEN
   SET w_inss =((totalNota) * 0.08);
ELSEIF((totalNota > 1659.38) AND (totalNota <= 2756.66)) THEN
   
   SET w_inss =((totalNota) * 0.09);       
   
ELSEIF((totalNota >2765.67) AND (totalNota <= 5531.31)) THEN
   SET w_inss = ((totalNota) * 0.11);
ELSE
   SET w_inss = 608.44;         %%teto do inss           
END IF;
   
%%deduzindo o inss da base de calculo
SET totalNota=totalNota-w_inss;

%%Calculando o Valor do IRRF
%%====================
IF(totalNota <= 1903.98) THEN
   SET w_valor_calc = 0.00;
ELSEIF((totalNota > 1903.98) AND (totalNota <= 2826.55)) THEN
   
   SET w_valor_calc = ((totalNota) * 0.075) - 142.80;       
   
ELSEIF((totalNota > 2826.55) AND (totalNota <= 3751.05)) THEN
   SET w_valor_calc = ((totalNota) * 0.15)- 354.80;
ELSEIF((totalNota > 3751.05) AND (totalNota <= 4664.68)) THEN
   SET w_valor_calc = ((totalNota) * 0.225)- 636.13;
ELSEIF(totalNota > 4664.68) THEN
   SET w_valor_calc = (totalNota * 0.275)- 869.36;                    
END IF;
