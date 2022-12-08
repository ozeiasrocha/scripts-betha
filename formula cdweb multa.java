//-------------------------------------------------------------------------------------------------------------------------
//Declarando variáveis
//-------------------------------------------------------------------------------------------------------------------------
idx_vcto  = 0.000000;
idx_pgto = 0.000000;
vlr_corr   = 0.000000;
vlr_corrigido   = 0.000000;
vlr_juros  = 0.000000;
vlr_multa = 0.000000;
qtdDias   = 0;
percentual = 0.000000;
//-------------------------------------------------------------------------------------------------------------------------
//Verifica se é feriado
//-------------------------------------------------------------------------------------------------------------------------
w_data  = dtVencto ; 
w_feriado  = Feriados.ehFeriado(w_data);

percorrer(enquanto: {w_feriado != 'N'}){
w_data = w_data + 1; 
w_feriado = Feriados.ehFeriado(w_data);
}
//-------------------------------------------------------------------------------------------------------------------------
//Fórmula de Multa
//-------------------------------------------------------------------------------------------------------------------------
ano_vcto = Datas.ano(w_data);

se (w_data < dtPagto) {
   qtdDias = Datas.diferencaDias(w_data, dtPagto); 
  percentual = 0.2;
  se (qtdDias<=30){
    percentual = 0.0033*qtdDias;
  }
 
    vlr_multa = Numeros.arredonda((vlDevido+vlCorrecaoCalc)*percentual, 2);
}  
  
 retornar valorMulta:vlr_multa;