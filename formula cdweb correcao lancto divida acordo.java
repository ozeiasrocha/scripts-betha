moeda ='RealC';
corrente = IndexadoresUtil.corrente(moeda);
idxVcto = 0.0000;
idxPgto = 0.0000;
correcao = 0.0000;
dataVcto = dtVencto; 

idxVcto = IndexadoresUtil.valorIndexador(moeda, dataVcto);
idxPgto = IndexadoresUtil.valorIndexador(moeda, dtPagto);

se(corrente == "S"){
  se ((idxVcto > 0) && (idxPgto > 0)){
    correcao = (vlDevido / idxVcto) * idxPgto - vlDevido;
  } senao {
    correcao = (vlDevido * idxPgto) - (vlDevido * idxVcto);
  }
} senao {
  correcao = 0.0000;
}
retornar valorCorrecao:Numeros.arredonda(correcao,2);



-------corrigida para UFM
moeda ='UFM';
corrente = IndexadoresUtil.corrente(moeda);
imprimir('moeda corrente: '+corrente);
idxVcto = 0.0000;
idxPgto = 0.0000;
correcao = 0.0000;
dataVcto = dtVencto; 

idxVcto = IndexadoresUtil.valorIndexador(moeda, dataVcto);
idxPgto = IndexadoresUtil.valorIndexador(moeda, dtPagto);
imprimir (moeda+' vcto: '+idxVcto);
imprimir (moeda+' pgto: '+idxPgto);


  se ((idxVcto > 0) && (idxPgto > 0)){
    correcao = (vlDevido / idxVcto) * idxPgto - vlDevido;
  } senao {
    correcao = (vlDevido * idxPgto) - (vlDevido * idxVcto);
  }

retornar valorCorrecao:Numeros.arredonda(correcao,2);