
DECLARE valor_iss DECIMAL(15,2);

SELECT sum((valor * quantidade) * aliquota / 100) 
INTO valor_iss 
FROM bethadba.itens_nota
WHERE i_notas = w_codigo;

SET ret = dbf_fc_cria_rec(2001,valor_iss);
