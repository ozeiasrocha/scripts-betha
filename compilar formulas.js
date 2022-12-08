pAuthorization  = parametros.authorization.valor
pUserAccess     = parametros.userAccess.valor

//----------------Testes----------------
//pAuthorization  = "c31af885-005d-4bcd-b7fc-167493a345ab"
//pUserAccess     = "PMSm_HLi1wCH6ru0j8rJaw==" 
//--------------------------------------

eventos = []

//Paginação com limit e offset
hasNext = true
limit   = 20
pagina  = 0

while (hasNext) {
	offset = pagina * limit
  	
    consulta = Http.servico('https://folha.betha.cloud/folha/api/configuracao-evento/').cabecalho(['Authorization': "Bearer ${pAuthorization}", 'User-Access': pUserAccess])
      
    consulta = consulta.parametro(['limit': limit, 'offset': offset]).GET()
    
    if (!consulta.sucesso()) {
      	imprimir "Token expirado!"
      	hasNext = false
    } else {
    	responseEventos = consulta.json()
      
      	responseEventos.content.each { i -> 
      		eventos << i
      	}
      
      	hasNext = responseEventos.hasNext
    }
    
	pagina += 1
}

eventos.each { i -> 
  	consulta = Http.servico("https://folha.betha.cloud/folha/api/configuracao-evento/${i.id}").cabecalho(['Authorization': "Bearer ${pAuthorization}", 'user-access': pUserAccess]).GET()
  	consulta = consulta.json()	
  	
  	tetoRemuneratorio = false
    if (consulta.enviaEsocial == true){
      	tetoRemuneratorio = true
    }
  
  	dados = [
    	configuracaoEvento: [ 
            "id": i.id,
            "inicioVigencia": consulta.inicioVigencia,
          	"tetoRemuneratorio": tetoRemuneratorio
         ]
    ]
  
  	update = Http.servico("https://folha.betha.cloud/folha/api/configuracao-evento/${i.id}").cabecalho(['Authorization': "Bearer ${pAuthorization}", 'user-access': pUserAccess])
  
  	update = update.PUT(JSON.escrever(dados), Http.JSON)
    	
  	if (!update.sucesso()) {
  		imprimir "Erro ao compilar o evento ${i.codigo} - ${i.descricao}" 
    } else {
    	imprimir "O evento ${i.codigo} - ${i.descricao} foi compilado com sucesso!" 
    }  	     
}