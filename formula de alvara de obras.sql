admin	adm@vance
DECLARE tipo_servico INTEGER;  
DECLARE parecer      CHAR;
DECLARE tipo_obra    INTEGER;
DECLARE ufm          DECIMAL(15,4);
DECLARE area_obra    DECIMAL(15,4);  
DECLARE vlr_alvara   DECIMAL(15,4);

%%Busca o valor da ufm
SET ufm=dbf_fc_valor_idx(2,today(*));     

SET area_obra=dbf_fc_retbci_valor(w_codigo,6699,dbf_ano_base(w_codigo,w_ano,6699,'opcoes_bci'));
PRINT string('area_construcao: ',area_construcao);

SET tipo_obra=dbf_fc_existe_opc_projeto(w_codigo,500,dbf_ano_base(w_codigo,w_ano,500,'opcoes_bci'));  
 PRINT string('tipo_obra: ',tipo_obra);


SELECT i_tipos_obras,parecer INTO tipo_servico, parecer FROM bethadba.projetos WHERE i_projetos=w_codigo;
MESSAGE string ('tipo_servico ',tipo_servico) TYPE WARNING TO CLIENT;  



%%Criando as receitas
%%SET ret = dbf_fc_cria_rec(2701, vlr_alvara,NULL, NULL);    
