DECLARE w_meses INTEGER;
DECLARE w_dias INTEGER;
DECLARE w_prox_data DATE;  
DECLARE w_feriado INTEGER;                         
 
                 
% SE NO VENCIMENTO FOR FERIADO ADICIONA 01 DIA AO P_VCTO:
                 
  SET w_feriado = dbf_eh_feriado(p_vcto);
    WHILE w_feriado > 0 LOOP
       SET p_vcto = days(p_vcto,1);
       SET w_feriado = dbf_eh_feriado(p_vcto);
    END LOOP;
  
 
  SET w_meses=months(p_vcto,p_pgto)+1;
  SET w_dias=days(p_vcto,p_pgto);
 
  IF(w_dias >= 1) THEN
   SET p_valor_juro=((isnull(w_meses,0)))*(.01)*(p_valor)
  END IF; 

