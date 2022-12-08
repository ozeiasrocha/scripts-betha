
DECLARE tx_expediente     DECIMAL(15,4);
DECLARE itbi_final        DECIMAL(15,4);
 
% Buscando dados DO ITBI

SELECT sum(itbi.itbi_final) INTO itbi_final FROM bethadba.itbi
       WHERE bethadba.itbi.i_itbis = w_codigo AND bethadba.itbi.ano=w_ano;

% Criando AS receitas

SET ret = dbf_fc_cria_rec(301, itbi_final, w_config);
