Situação da Dívida
A-Ativo, C-Cancelado, S-Suspença, P-Parcelada, Q-Quitada, N-Anistiada, E-Prescrita, R-Remida, 
J-Ajuizada,I-Parcelado no Refis, D-Quitada pelo Refis)


--verificando dividas
select l.i_lanctos, l.ano, l.situacao,d.i_debitos, d.parcela, d.flag, cod_div, origem_div, fi_divida.i_acordos, parcela_par, situacao_par,
dividas.i_dividas, dividas.situacao, dividas.parcela  from bethadba.lanctos l join bethadba.debitos d on d.i_lanctos=l.i_lanctos
join fi_divida on cod_cad_div=l.i_imoveis and ano_div=l.ano 
join fi_parcela  on  cod_div=cod_div_par and parcela_par=d.parcela and  situacao_par in (1,2)
join bethadba.dividas on i_refer=l.i_imoveis and dividas.ano=l.ano and dividas.parcela=d.parcela
where l.i_imoveis=5572 and l.ano=2018

select l.i_lanctos, l.ano, l.situacao,d.i_debitos, d.parcela, d.flag, cod_div, origem_div, fi_divida.i_acordos, parcela_par, situacao_par,
dividas.i_dividas, dividas.situacao, dividas.parcela  from bethadba.lanctos l join bethadba.debitos d on d.i_lanctos=l.i_lanctos
join fi_divida on cod_cad_div=l.i_imoveis and ano_div=l.ano 
join fi_parcela  on  cod_div=cod_div_par and parcela_par=d.parcela and  situacao_par in (1,2)
join bethadba.dividas on i_refer=l.i_imoveis and dividas.ano=l.ano and dividas.parcela=d.parcela
where --l.i_imoveis=5572 and 
l.ano=2018 and d.flag='T' and dividas.situacao='C'
order by 1,5

select * from bethadba.dividas d 
left join bethadba.lanctos l on
l.ano=d.ano and l.i_receitas=d.i_receitas
and i_refer in (string(l.i_economicos, l.i_melhorias, l.i_pedidos, l.i_itbis, l.i_projetos, l.i_notas, l.i_autos, l.i_imoveis))
inner join bethadba.debitos de on de.i_lanctos=l.i_lanctos
where d.situacao in ('P', 'Q')
and l.i_lanctos=232809


call bethadba.pg_setoption('fire_triggers','off');
update bethadba.dividas d 
left join bethadba.lanctos l on
l.ano=d.ano and l.i_receitas=d.i_receitas
and i_refer in (string(l.i_economicos, l.i_melhorias, l.i_pedidos, l.i_itbis, l.i_projetos, l.i_notas, l.i_autos, l.i_imoveis))
inner join bethadba.debitos de on de.i_lanctos=l.i_lanctos
set de.flag='T'
where d.situacao in ( 'Q','N', 'E', 'R')
--and l.i_lanctos=232809
commit;


update bethadba.dividas d 
left join bethadba.lanctos l on
l.ano=d.ano and l.i_receitas=d.i_receitas
and i_refer in (string(l.i_economicos, l.i_melhorias, l.i_pedidos, l.i_itbis, l.i_projetos, l.i_notas, l.i_autos, l.i_imoveis))
inner join bethadba.debitos de on de.i_lanctos=l.i_lanctos
left join bethadba.acordos_dividas ad on ad.i_dividas=d.i_dividas
left join bethadba.acordos a on a.i_acordos=ad.i_acordos
set de.flag='T'
where d.situacao in ( 'P') and sit_acordo<>'C' and de.flag<>'T'
-- and exists (select 1 from bethadba.acordos a inner join bethadba.acordos_dividas ad on ad.i_acordos=a.i_acordos and ad.i_dividas=d.i_dividas  where sit_acordo<>'C') 
--and l.i_lanctos=232809
;
commit;


update
bethadba.dividas d 
left join bethadba.lanctos l on l.ano=d.ano and l.i_receitas=d.i_receitas
and i_refer in (string(l.i_economicos, l.i_melhorias, l.i_pedidos, l.i_itbis, l.i_projetos, l.i_notas, l.i_autos, l.i_imoveis))
inner join bethadba.debitos de on de.i_lanctos=l.i_lanctos
set d.situacao='C'
where d.situacao in ( 'A') and de.flag in('C') --and sit_acordo<>'C' 
and l.i_lanctos< 100
;

update
bethadba.dividas d 
left join bethadba.lanctos l on l.ano=d.ano and l.i_receitas=d.i_receitas
and i_refer in (string(l.i_economicos, l.i_melhorias, l.i_pedidos, l.i_itbis, l.i_projetos, l.i_notas, l.i_autos, l.i_imoveis))
inner join bethadba.debitos de on de.i_lanctos=l.i_lanctos
set d.situacao='C'
where d.situacao in ( 'A') and de.flag in('A') --and sit_acordo<>'C' 
--and l.i_lanctos< 100
;
commit;
