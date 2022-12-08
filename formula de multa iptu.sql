/* -- F�rmula de Multa de Lan�amentos para receita de  [99999 - GERAL] referente Exerc�cio de 2013*/
%%	p_valor       ---> Valor em Moeda Corrente
%%	p_vcto        ---> Data de Vencimento
%%	p_pgto        ---> Data de Pagamento
%%	p_valor_multa ---> Valor do Multa
%%	p_sub_rec     ---> Passa o C�digo da sub-receita
%%  p_codigo      ---> C�digo do d�bito
%%  p_moeda       ---> C�digo da Moeda do d�bito
%%  w_atos        ---> Passa o c�digo do Lei/Ato


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
  
 
  SET w_meses=months(p_vcto,p_pgto);
  SET w_dias=days(p_vcto,p_pgto);  
  

  IF(w_dias >= 1 AND w_dias <= 30) THEN
   SET p_valor_multa =p_valor*(w_dias * 0.0033);
  ELSEIF w_dias > 30 THEN
   SET p_valor_multa = p_valor * 0.20;  
  END IF;  