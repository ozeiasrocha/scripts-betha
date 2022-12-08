//FORMULA TESTE DO SERVICE DESK
//inicio
multa = 0.00;
juro=0.00;
qtdDias=0;
qtdMes=0;
corre=0.00;
idx_vcto=0;
idx_pgto=0;
datavcto = dataVencimento;

//Guias Unificadas
se (situacao.equivalente ('U') && situacao.equivalente == 'A'){
datavcto = dataVencimentoUnificadora
}

//Verifica Proximo dia Util
percorrer (enquanto:{DataUtil.isFeriado(datavcto) == true || DataUtil.isSabado(datavcto) == true || DataUtil.isDomingo(datavcto) == true}){
  datavcto = datavcto + 1; 
}



//Busca Valores da UFM
idx_vcto = 1//IndexadoresUtil.valorIndexador('UFM',datavcto)
idx_pgto = 2//IndexadoresUtil.valorIndexador('UFM',dataAtual)

//Calcula Correção, Juros e Multa
se((situacao.equivalente('A') || situacao.equivalente('T') || situacao.equivalente('U')) && datavcto < dataAtual){
//Correção  
corre = ((valorGuia / idx_vcto) *  idx_pgto) -  valorGuia

//Multa
	qtdDias = Datas.diferencaDias(datavcto, dataAtual) 
  	se(qtdDias <= 30){  
    	multa = (valorGuia + corre) * 0.02;
    }senao{
          se (qtdDias <= 60){
      			multa = (valorGuia + corre) * 0.04
          }senao{
                  	multa = (valorGuia + corre) * 0.06}}
//Juros  
    qtdMes = Datas.diferencaMeses(datavcto, dataAtual) +1;
    juro = ((valorGuia + corre) * 0.01) * qtdMes;
}

retornar valorJuro:Numeros.arredonda(juro,2) ,valorMulta:Numeros.arredonda(multa,2)
