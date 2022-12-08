// Script utilizado para a conversão de eventos
//1 - Executar o seguinte comando no banco de dados: "select DISTINCT i_eventos  from bethadba.movimentos m where i_competencias >= '2020-01-01'"
//2 - Lembrar de ajustar o filtro de competência para que pegue os últimos 2 anos
//3 - Pegar o resultado do comando SQL e colocar no array "usadosDesk"
//4 - Exemplo de preenchimento no array usadosDesk = [1,2,3,4,5]

usadosDesk = []
naoPadraoCloud = []
eventosFazer = []

filtroConfiguracaoEvento = "descricao like '%NAO_PADRAO%'"

dadosConfiguracaoEvento = Dados.folha.v2.configuracaoEvento.busca(criterio: filtroConfiguracaoEvento,campos: "codigo")

percorrer (dadosConfiguracaoEvento) { i ->
	naoPadraoCloud << i.codigo
}

imprimir "Eventos não padrões " + naoPadraoCloud

naoPadraoCloud.each { j ->
  if(usadosDesk.contains(j.toInteger())) {
    eventosFazer << j
  }
}

imprimir "Eventos a serem feitos " + eventosFazer


// Geração do Arquivo CSV
//-- Nome do Arquivo
nomeArquivo = [Datas.formatar(Datas.hoje(),'ddMMyyyy_hhmmss'),'EVENTOS_CONVERSAO.CSV'].join('_')
//-- Define parametros do Arquivo 
arquivoCsv = Arquivo.novo(nomeArquivo, 'csv', [encoding: 'iso-8859-1', entreAspas: 'N', delimitador:';'])
//-- Cabeçalho
cabecalhoArquivo = ['CODIGO']
arquivoCsv.escrever(cabecalhoArquivo.join(';'))
arquivoCsv.novaLinha()  
//-- Escrever o arquivo
eventosFazer.each { i->
  linhaDoArquivo = []
  linhaDoArquivo.add(i)
  imprimir "linha do arquivo " + linhaDoArquivo
  arquivoCsv.escrever(linhaDoArquivo.join())
  arquivoCsv.novaLinha()
}

Resultado.arquivo(arquivoCsv, nomeArquivo)