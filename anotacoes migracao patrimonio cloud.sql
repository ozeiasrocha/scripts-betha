select * from bethadba.responsaveis where i_respons in (6800, 6520)
update bethadba.custos set i_respons=6800 where i_respons=6520;
call bethadba.pg_habilitartriggers('off');
update bethadba.bens set i_respons=6800 where i_respons=6520;
delete bethadba.responsaveis where i_respons=6520;
call bethadba.pg_habilitartriggers('on');
commit;



update bethadba.bens set i_fornec=7009 where i_fornec=7025;
delete bethadba.fornecedores where i_fornec=7025;
commit

--MASCARA DE CLASSES E MATERIAIS
-- AJUSTAR PARA NIVEIS: #.##, 100 SINTETICO, 1.01 ANALITICO
-- Classes: incluir mascara sintética