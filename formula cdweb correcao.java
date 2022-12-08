idx_vcto =IndexadoresUtil.valorIndexador(2, dtVencto);
idx_pgto =IndexadoresUtil.valorIndexador(2, dtPagto);
correcao = (vlDevido / idx_vcto * idx_pgto-vlDevido);
//imprimir idx_vcto;imprimir idx_pgto;imprimir vlDevido;imprimir correcao;
retornar valorCorrecao:Numeros.arredonda(correcao,2);