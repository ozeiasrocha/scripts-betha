/* -- Cálculo de INSS*/
%%  p_nr_nota       ---> Código da Nota Avulsa para Cálculo do INSS
%%  w_valor_calc	 ---> Valor do INSS Calculado

DECLARE totalNota       DECIMAL(15,4);

%%Busca o Valor Total da Nota
SELECT totalNota = sum(valor * quantidade)

INTO totalNota FROM bethadba.notas_avulsas JOIN bethadba.itens_nota
WHERE notas_avulsas.i_notas = p_nr_nota; 

%%Calculando o Valor do INSS
%%====================
IF(totalNota <= 1659.38) THEN
   SET w_valor_calc =((totalNota) * 0.08);
ELSEIF((totalNota > 1659.38) AND (totalNota <= 2756.66)) THEN
   
   SET w_valor_calc =((totalNota) * 0.09);       
   
ELSEIF((totalNota >2765.67) AND (totalNota <= 5531.31)) THEN
   SET w_valor_calc = ((totalNota) * 0.11);
ELSE
   SET w_valor_calc = 608.44;         %%teto do inss           
END IF;

