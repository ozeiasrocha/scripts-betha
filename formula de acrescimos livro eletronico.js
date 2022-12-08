//Inicio
vlCorrecao= 0.00;
// Dados comuns ao c¿lculo de Corre¿¿o, Juro e Multa
dataVcto = dataVencimento;

// Verifica se ¿ dia ¿til


percorrer (enquanto:{ DataUtil.ehFeriado(dataVcto) == true || 
								DataUtil.ehSabado(dataVcto) == true || 
  								DataUtil.ehDomingo(dataVcto) == true}){
      dataVcto = dataVcto+1; 
}
//==============================================
// F¿rmula de c¿lculo da Corre¿¿o
//==============================================
idxVcto = IndexadoresUtil.valorIndexador("UFM", dataVcto);
idxPgto = IndexadoresUtil.valorIndexador("UFM", dataAtual);
se((situacao.equivalente('A') || situacao.equivalente('T') || situacao.equivalente('U')) && dataVcto < dataAtual){
      //imprimir dataVcto;   imprimir dataAtual;  imprimir idxVcto;  imprimir idxPgto;
      se (idxVcto>0 && idxPgto>0){
           vlCorrecao = Numeros.arredonda(((valorGuia / idxVcto) * idxPgto) - valorGuia, 2);
       } senao{
            imprimir 'valor da UFM não encontrado!';
            
       }
}
//imprimir vlCorrecao:vlCorrecao
valorAtualizado = valorGuia + vlCorrecao;
//==============================================
// F¿rmula de c¿lculo do Juro
//==============================================
qtdMeses  = 0;
vlJuro = 0.00;
qtdMeses = Datas.diferencaMeses(dataVcto, dataAtual);
adicional = 0;

se ((Datas.dia(dataAtual ) > Datas.dia(dataVcto))  ||  ( Datas.mes(dataAtual) > Datas.mes(dataVcto) )) {
      adicional = 1; 
}
qtdMeses = qtdMeses + adicional;
se (dataAtual > dataVcto){
  	vlJuro = Numeros.arredonda(((valorGuia) * qtdMeses *0.01) ,2);
}
//==============================================
// F¿rmula de c¿lculo da Multa
//==============================================
vlMulta = 0.00;
se (dataAtual > dataVcto){	
	qtdDias = Datas.diferencaDias(dataVcto, dataAtual)
    se (qtdDias >= 31){
    percentual =  0.10
  }senao{
    percentual = qtdDias * 0.0033
  }
 vlMulta = Numeros.arredonda((valorGuia * percentual),2)
}
//==============================================
retornar valorCorrecao:vlCorrecao, valorJuro:vlJuro, valorMulta:vlMulta;