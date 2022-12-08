IF  p_qtd_parc=1 THEN
  SET w_valor=p_valor;
ELSE
  IF months(p_data_requ,'2019-04-30')+1>= p_qtd_parc  THEN
      SET w_valor=p_valor*0.8;   
  ELSEIF  months(p_data_requ,'2019-08-28')+1>= p_qtd_parc THEN
      SET w_valor=p_valor*0.6;  
  ELSEIF  months(p_data_requ,'2019-12-30')+1>= p_qtd_parc THEN
     SET w_valor=p_valor*0.40; 
  END IF ;
       
END IF;   
  
  
IF  p_qtd_parc=1 THEN
  SET w_valor=p_valor;
ELSE
  IF months(p_data_requ,'2019-04-30')+1>= p_qtd_parc  THEN
      SET w_valor=p_valor*0.8;   
  ELSEIF  months(p_data_requ,'2019-08-28')+1>= p_qtd_parc THEN
      SET w_valor=p_valor*0.6;  
  ELSEIF  months(p_data_requ,'2019-12-30')+1>= p_qtd_parc THEN
     SET w_valor=p_valor*0.40; 
  END IF ;
       
END IF;     