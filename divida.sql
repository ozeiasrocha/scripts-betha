ISNULL((SELECT count(*) FROM bethadba.dividas KEY JOIN bethadba.RECEITAS WHERE dividas.i_pessoas = NEGPOS.i_pessoas AND
			   dividas.i_refer = imoveis.i_imoveis AND receitas.tipo_receita IN('1','3') AND situacao NOT IN ( 'C', 'P','Q','D', 'S', 'E','I','R') AND 
             NOT EXISTS(SELECT 1 FROM bethadba.ajuizamentos_movtos WHERE i_movtos = 'P' AND 
			 ajuizamentos_movtos.I_AJUIZAMENTOS = bethadba.dbf_ret_num_exec(dividas.i_dividas))),0) 