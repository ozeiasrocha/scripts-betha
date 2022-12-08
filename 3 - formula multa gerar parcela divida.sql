DECLARE w_meses INTEGER;
DECLARE w_dias INTEGER;
DECLARE w_prox_data DATE;  
DECLARE w_feriado INTEGER; 

  SET w_feriado = dbf_eh_feriado(p_data_vcto);
    WHILE w_feriado > 0 LOOP
       SET p_data_vcto = days(p_data_vcto,1);
       SET w_feriado = dbf_eh_feriado(p_data_vcto);
    END LOOP;
  
IF (p_data_pgto > p_data_vcto) THEN   
  IF year(p_data_pgto) = year(p_data_vcto) THEN
    SET p_valor_jm = p_valor * 0.02;
  ELSE
  IF year(p_data_pgto) > year(p_data_vcto) THEN  
    SET p_valor_jm = p_valor * 0.1;
  END IF;
 END IF;
END IF;
