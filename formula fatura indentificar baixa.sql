%%************************************************************
%% Identificar o numero de baixa
%%************************************************************
DECLARE chave INTEGER;

SET chave = BYTE_SUBSTR( p_codBarra,29,2);

IF BYTE_SUBSTR( p_codBarra,1,2 ) = '82' THEN 
  IF chave = '17' OR chave = '16' OR chave = '15' THEN
	  SET wNumBaixa = BYTE_SUBSTR( p_codBarra,31,9);
  ELSE
    SET wNumBaixa = BYTE_SUBSTR( p_codBarra,29,9);
	END IF;
%%ELSEIF BYTE_SUBSTR( p_codBarra,1,3 ) = '033' THEN    
%%	SET wNumBaixa = BYTE_SUBSTR( p_codBarra,28,12);
END IF 
;