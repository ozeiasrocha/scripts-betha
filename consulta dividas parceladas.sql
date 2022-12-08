select i_pessoas, ano, i_receitas, parcela, i_receitas, i_refer, count(*) from bethadba.dividas a where situacao <> 'C' 
and exists (select 1 from bethadba.acordos_dividas b where a.i_dividas = b.i_dividas and i_acordos = 3218)
group by i_pessoas, ano, i_receitas, parcela, i_receitas, i_refer;

/* verifica na auditoria de as dividas sao de migracao. */
select * from bethadba.audit_dividas  where i_dividas = xxxx;