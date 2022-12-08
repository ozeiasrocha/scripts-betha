--subreceitas diferentes da reecita principal (nao existe fiorilli)
delete bethadba.rec_debitos from bethadba.rec_debitos inner join bethadba.debitos on debitos.i_debitos=rec_debitos.i_debitos
inner join bethadba.lanctos on lanctos.i_lanctos=debitos.i_lanctos
where cast(rec_debitos.i_receitas-right(rec_debitos.i_receitas,2) as integer)<>lanctos.i_receitas;

 commit;
 
 
-- debitos no tributos que nao estao na fiorilli
select lanctos.i_lanctos,cast(rec_debitos.i_receitas-right(rec_debitos.i_receitas,2) as integer) as receita, 
lanctos.i_lanctos,fi_receitas.i_receitas,rec_debitos.i_receitas, round((select sum(lvalor_frc) from desbth.fi_receitas fr where fr.cod_div_frc=fi_receitas.cod_div_frc),2) as vlr_div, (select sum(valor_gerado) from bethadba.rec_debitos rd where rd.i_debitos=debitos.i_debitos) as vlr_deb, lvalor_frc,
* from bethadba.rec_debitos inner join bethadba.debitos on debitos.i_debitos=rec_debitos.i_debitos
inner join bethadba.lanctos on lanctos.i_lanctos=debitos.i_lanctos
left join desbth.fi_receitas on fi_receitas.cod_div_frc=lanctos.i_lanctos and fi_receitas.i_receitas=rec_debitos.i_receitas
where  cod_div_frc is null and rec_debitos.i_debitos in (select i_debitos from bethadba.debitos where flag in ('A', 'T')) --and lanctos.i_lanctos=21
and lanctos.i_lanctos<=(select max(cod_div) from desbth.fi_divida)
order by lanctos.i_lanctos


delete bethadba.rec_debitos from bethadba.rec_debitos inner join bethadba.debitos on debitos.i_debitos=rec_debitos.i_debitos
inner join bethadba.lanctos on lanctos.i_lanctos=debitos.i_lanctos
left join desbth.fi_receitas on fi_receitas.cod_div_frc=lanctos.i_lanctos and fi_receitas.i_receitas=rec_debitos.i_receitas
where  cod_div_frc is null and rec_debitos.i_debitos in (select i_debitos from bethadba.debitos where flag in ('A', 'T')) --and lanctos.i_lanctos=21
and lanctos.i_lanctos<=(select max(cod_div) from desbth.fi_divida);
commit;

-- valor divergente debitos / fi_parcela (usar segundo comando)
select lanctos.i_lanctos,cast(rec_debitos.i_receitas-right(rec_debitos.i_receitas,2) as integer) as receita, 
lanctos.i_lanctos,fi_receitas.i_receitas,rec_debitos.i_receitas, round((select sum(lvalor_frc) from desbth.fi_receitas fr where fr.cod_div_frc=fi_receitas.cod_div_frc),2) as vlr_div, (select sum(valor_gerado) from bethadba.rec_debitos rd where rd.i_debitos=debitos.i_debitos) as vlr_deb, lvalor_frc,
* from bethadba.rec_debitos inner join bethadba.debitos on debitos.i_debitos=rec_debitos.i_debitos
inner join bethadba.lanctos on lanctos.i_lanctos=debitos.i_lanctos
left join desbth.fi_receitas on fi_receitas.cod_div_frc=lanctos.i_lanctos and fi_receitas.i_receitas=rec_debitos.i_receitas
where rec_debitos.i_debitos in (select i_debitos from bethadba.debitos where flag in ('A', 'T')) --and lanctos.i_lanctos=21
and lanctos.i_lanctos<=(select max(cod_div) from desbth.fi_divida)
and vlr_div<>vlr_deb and lvalor_frc<>valor_gerado
order by lanctos.i_lanctos

update bethadba.rec_debitos inner join bethadba.debitos on debitos.i_debitos=rec_debitos.i_debitos
inner join bethadba.lanctos on lanctos.i_lanctos=debitos.i_lanctos
left join desbth.fi_receitas on fi_receitas.cod_div_frc=lanctos.i_lanctos and fi_receitas.i_receitas=rec_debitos.i_receitas
set valor_gerado=lvalor_frc
where rec_debitos.i_debitos in (select i_debitos from bethadba.debitos where flag in ('A', 'T')) --and lanctos.i_lanctos=21
and lanctos.i_lanctos<=(select max(cod_div) from desbth.fi_divida)
and round((select sum(lvalor_frc) from desbth.fi_receitas fr where fr.cod_div_frc=fi_receitas.cod_div_frc),2)<>(select sum(valor_gerado) from bethadba.rec_debitos rd where rd.i_debitos=debitos.i_debitos) 
 and lvalor_frc<>valor_gerado;
commit;

select i_lanctos, rec_debitos.i_debitos, lvalor_frc, valor_gerado,* 
from desbth.fi_receitas inner join  bethadba.rec_debitos  on rec_debitos.i_debitos=fi_receitas.i_debitos and rec_debitos.i_receitas=fi_receitas.i_receitas 
where lvalor_frc<>valor_gerado and i_lanctos<=(select max(cod_div) from desbth.fi_divida) --and cod_div_frc=235712

update desbth.fi_receitas inner join  bethadba.rec_debitos  on rec_debitos.i_debitos=fi_receitas.i_debitos and rec_debitos.i_receitas=fi_receitas.i_receitas 
set valor_gerado=lvalor_frc
where lvalor_frc<>valor_gerado and i_lanctos<=(select max(cod_div) from desbth.fi_divida) --and cod_div_frc=235712
; commit;

--cacelar pagtos 2019
call bethadba.dbp_conn_gera(1,2021,301);
call bethadba.pg_habilitartriggers('off');
update bethadba.pagtos set data_est='2020-01-01' where data_pgto<'2020-01-01' and data_pgto>'2018-12-31' and data_est is null and valor_dif<>0; commit;

--correçoes migração sena
alter table desbth.gr_receita add(i_receitas integer);

select * from bethadba.lanctos key join bethadba.rec_lanctos where rec_lanctos.i_receitas-right(rec_lanctos.i_receitas,2)<>lanctos.i_receitas and lanctos.situacao<>'C'
and i_notas=511999

select * from bethadba.lanctos key join bethadba.rec_lanctos where lanctos.i_lanctos=238672
select * from bethadba.debitos where i_lanctos=238672
select * from bethadba.rec_debitos where i_debitos=494390

select * from desbth.fi_divida where cod_div=238672
select * from desbth.li_notafiscal where cod_nfs=511999

select * from desbth.gr_receita order by 2

update desbth.gr_receita set i_receitas=100 where cod_rec between 100 and 199;
update desbth.gr_receita set i_receitas=200 where cod_rec between 200 and 299;
update desbth.gr_receita set i_receitas=300 where cod_rec between 300 and 399;
update desbth.gr_receita set i_receitas=400 where cod_rec between 400 and 499;
update desbth.gr_receita set i_receitas=500 where cod_rec between 500 and 599;
update desbth.gr_receita set i_receitas=600 where cod_rec between 600 and 699;
update desbth.gr_receita set i_receitas=700 where cod_rec between 700 and 799;
update desbth.gr_receita set i_receitas=800 where cod_rec between 800 and 899;
update desbth.gr_receita set i_receitas=100 where cod_rec between 100 and 199;
update desbth.gr_receita set i_receitas=300 where cod_rec between 900 and 999;
update desbth.gr_receita set i_receitas=1000 where cod_rec between 1000 and 1099;
update desbth.gr_receita set i_receitas=1100 where cod_rec between 1100 and 1199;
update desbth.gr_receita set i_receitas=1200 where cod_rec between 1200 and 1299;
update desbth.gr_receita set i_receitas=400 where cod_rec between 1300 and 1399; -- receita 1300 nao existe na betha  -> 420
update desbth.gr_receita set i_receitas=400 where cod_rec between 1400 and 1499; -- receita 1400 nao existe na betha  -> 422
update desbth.gr_receita set i_receitas=400 where cod_rec between 1500 and 1599; -- receita 1500 ta uma bagunça
-- setar as subreceitas 15??
update desbth.gr_receita set i_receitas=1600 where cod_rec between 1600 and 1699;
--setar subreceitas 
update desbth.gr_receita set i_receitas=1700 where cod_rec between 1700 and 1799;
--setar as subreceitas 1705 e 1706
update desbth.gr_receita set i_receitas=400 where cod_rec between 1800 and 1899;
--setar subreceitas 


-- fi_recprincipal
-- cnv_receitas_aux

begin
declare l_i_lanctos integer; declare l_i_receitas integer; declare l_i_refer integer; declare l_situacao  char(1); 
declare rl_i_receitas integer; declare rl_valor_lanc decimal(15,4);
declare d_i_debitos integer; declare d_flag char(1);
declare rd_i_receitas integer;  declare rd_valor_gerado decimal(15,4);  
declare w_curdeb dynamic scroll cursor for 

select l.i_lanctos, l.i_receitas, coalesce(i_imoveis, i_economicos, i_pedidos, i_itbis, i_projetos, i_notas) as i_refer, situacao, 
rl.i_receitas as rl_i_receitas, rl.valor_lanc, 
d.i_debitos, d.flag,
rd.i_receitas, rd.valor_gerado
from bethadba.lanctos l inner join bethadba.rec_lanctos rl on rl.i_lanctos=l.i_lanctos and rl.i_receitas-right(rl.i_receitas,2)<>l.i_receitas 
inner join  bethadba.debitos d on d.i_lanctos=l.i_lanctos left join bethadba.rec_debitos rd on rd.i_debitos=d.i_debitos  and rd.i_receitas-right(rd.i_receitas,2)<>l.i_receitas 
where  l.i_lanctos=y_i_lanctos;

llLoop: for ll as lc_debitos dynamic scroll cursor for
 select lanctos.i_lanctos as y_i_lanctos from bethadba.lanctos key join bethadba.rec_lanctos where rec_lanctos.i_receitas-right(rec_lanctos.i_receitas,2)<>lanctos.i_receitas
 and lanctos.ano<2020 and lanctos.i_lanctos in (select i_lanctos from bethadba.numeros_baixas where i_num_baixas in (10046, 10048, 162658, 10051))
do
	 open w_curdeb;
       l_curdeb: loop
           fetch next w_curdeb into  l_i_lanctos, l_i_receitas, l_i_refer, l_situacao, rl_i_receitas, rl_valor_lanc, d_i_debitos, d_flag, rd_i_receitas, rd_valor_gerado;
           if sqlstate = '02000' then
              leave l_curdeb
           end if;		 

     --set w_i_acordos=i_acordos;     
    message 'lancto= '||l_i_lanctos||' debito: '||d_i_debitos||' l_receita: '||l_i_receitas||' rl_receita: '||rl_i_receitas||' rl_valor_lanc: '||rl_valor_lanc||' rd_valor_gerado: '||rd_valor_gerado to client;
   delete bethadba.rec_debitos where i_debitos=d_i_debitos and i_receitas=rd_i_receitas and valor_gerado=rd_valor_gerado;
  delete bethadba.rec_lanctos where i_lanctos=l_i_lanctos and i_receitas=l_i_receitas and valor_lanc=rl_valor_lanc;
     end loop l_curdeb;
      close w_curdeb;	
end for;
end;
commit;




















