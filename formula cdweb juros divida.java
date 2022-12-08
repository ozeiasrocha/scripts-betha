w_perc = 0
w_data = dtVencto

se(dtPagto > w_data) {
   w_data = Datas.adicionaDias(w_data,1)
   se(Datas.dia(dtPagto) > Datas.dia(w_data)) {
      w_perc = 1

   }
se(Datas.diferencaMeses(w_data, dtPagto) > 0) {
   w_perc = w_perc + Datas.diferencaMeses(w_data, dtPagto)+ 1;
  imprimir Datas.diferencaMeses(w_data, dtPagto)+1;

   }

}
p_valor_juro = (vlDevido + vlCorrecaoCalc) * w_perc / 100;
retornar valorJuros:Numeros.arredonda(p_valor_juro,2)