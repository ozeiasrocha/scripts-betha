DECLARE totalNota       DECIMAL(15,4);


%%Busca o Valor Total da Nota
SELECT totalNota = sum(valor * quantidade)

INTO totalNota FROM bethadba.notas_avulsas JOIN bethadba.itens_nota
WHERE notas_avulsas.i_notas = p_nr_nota; 


%%Calculando o Valor do IRRF
%%====================
IF(totalNota <= 1868.22) THEN
    SET w_valor_calc = 0.00;
ELSEIF((totalNota > 1868.22) AND (totalNota <= 2799.86)) THEN
    SET w_valor_calc = ((totalNota) * 0.075);  
ELSEIF((totalNota > 2799.86) AND (totalNota <= 3733.19)) THEN
    SET w_valor_calc = ((totalNota) * 0.15);
ELSEIF((totalNota > 3733.19) AND (totalNota <= 4664.68)) THEN
    SET w_valor_calc = ((totalNota) * 0.225);
ELSEIF(totalNota > 4664.68) THEN
    SET w_valor_calc = (totalNota * 0.275);                    
END IF;



