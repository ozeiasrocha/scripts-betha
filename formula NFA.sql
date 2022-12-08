DECLARE w_iss      DECIMAL;  
DECLARE ativ_nfa   INTEGER; 
DECLARE lista_serv INTEGER;
 
        
SELECT count(i_notas) INTO ativ_nfa FROM bethadba.itens_nota 
WHERE i_notas =w_codigo AND isnull(i_atividades,0)=0;      

IF ativ_nfa>0 THEN
  CALL dbp_raiserror('','NECESSÁRIO INFORMAR ATIVIDADE.');    
  
END IF; 
SELECT count(itens_nota.i_atividades) INTO lista_serv FROM bethadba.itens_nota  JOIN bethadba.ramos_atividades
ON ramos_atividades.i_atividades=itens_nota.i_atividades
WHERE itens_nota.i_notas =w_codigo AND isnull(ramos_atividades.i_lista_servicos,0)=0; 
IF lista_serv>0 THEN
  CALL dbp_raiserror('','NECESSÁRIO INFORMAR O CAMPO LISTA DE SERVIÇO NO CADASTRO DA ATIVIDADE INFORMADA NA NOTA.');    
  
END IF;   


%% RETORNA O VALOR FINAL DO ISS DA NOTA

SELECT sum((valor - isnull((valor_reducao),0)) * quantidade * aliquota / 100) INTO w_iss FROM bethadba.itens_nota
WHERE i_notas = w_codigo; 
 
SET ret = dbf_fc_cria_rec(1101,w_iss);     
%%SET ret = dbf_fc_cria_rec(1102,tarifa,NULL);  
%%SET ret = dbf_fc_cria_rec(1103,expediente,NULL);