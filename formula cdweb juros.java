//Inicio
juro=0.00;
qtdDias=0;
qtdMes=0;
datavcto=dtVencto;

//Verifica se no Vencimento não é dia Útil
percorrer (enquanto:{ Feriados.ehFeriado(datavcto) == 'S' }){ 
  datavcto = datavcto + 1;
}


//Calcula Juros
se(datavcto < dtPagto){  
    qtdMes = Datas.diferencaMeses(datavcto, dtPagto) +1;
    juro =  ((vlDevido+vlCorrecaoCalc) * 0.01) *qtdMes;
}


retornar valorJuros:Numeros.arredonda(juro,2)