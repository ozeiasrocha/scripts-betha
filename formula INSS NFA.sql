/* -- Cálculo de INSS
%%  p_nr_nota        ---> Código da Nota Avulsa para Cálculo do INSS
%%  w_valor_calc	 ---> Valor do INSS Calculado
Criado por: Ozeias Rocha */

DECLARE totalNota       DECIMAL(15,4);

%% -- Busca o Valor Total da Nota
SELECT totalNota = sum(valor * quantidade)

INTO totalNota FROM bethadba.notas_avulsas JOIN bethadba.itens_nota
WHERE notas_avulsas.i_notas = p_nr_nota; 

%% -- Calculando o Valor do INSS
IF(totalNota <= 1751.81) THEN
   SET w_valor_calc =((totalNota) * 0.08);
ELSEIF((totalNota > 1751.81) AND (totalNota <= 2919.72)) THEN   
   SET w_valor_calc =((totalNota) * 0.09);          
ELSEIF((totalNota >2919.72) AND (totalNota <= 5839.45)) THEN
   SET w_valor_calc = ((totalNota) * 0.11);
ELSE
   SET w_valor_calc = 642.34;         %%-- teto do inss           
END IF;
