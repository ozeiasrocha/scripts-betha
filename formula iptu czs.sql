/* -- Fórmula de Lançamento para receita de  100-Imposto Predial e Territorial Urbano referente Exercício de 2009*/
%%	w_codigo        ---> Código de referência que está sendo calculado (Imóvel / Econômico / Pedido / Melhoria / etc)
%%	w_imovel        ---> Código do imóvel no caso de Contribuição de Melhoria
%%	w_parc_ini      ---> Nº da parcela Inicial 
%%	w_parc_fin      ---> Nº da parcela Final 
%%	w_receita       ---> Passa a Receita Principal
%%	w_ano           ---> Passa o ano que será Calculado
%%	w_config        ---> Configuração informada na Janela de Calculo
%%	w_npar          ---> Passa o Número de Parcela a serem geradas, caso não tenha Parâmetros das Parcelas
%%	w_moeda         ---> Passa o Código da moeda
%%  w_venc_ini      ---> Vcto Inicial
%%  w_dias          ---> dias vcto
%%  w_antecip       ---> Antecipa
%%  w_simula        ---> Simulado
%%  w_notifica      ---> Será notificado após a geração
%%  w_complementa   ---> Complementar
%%  w_unidade       ---> Unidade
%%  w_reparc        ---> Se é reparcelamento de débitos ou não  

%% @autor         Tiago Giusti <tgiusti@gmail.com>
%% @descricao     Formula de Calculo de IPTU, COSIP e Taxa de Coleta de Lixo
%% @versao        1.2
%% @atualizacoes  17/02/2010: incluida verificacao do Valor Minimo para criar parcela (Art. 50)
%% @atualizacoes  17/02/2010: incluida verificacao de Isencao para IPTU de imovel Edificado menor ou igual a 30 UNIFP (Art. 52)
%% @atualizacoes  17/02/2010: incluida verificacao da Progressividade do imposto para terrenos baldios (Art. 48)
%% @atualizacoes  03/03/2010: incluida alteracoes para gerar os valores em R$, tanto nas caracteristicas do Imovel quanto Lancto.
%% @atualização   29/04/2010: incluido verificacao de campo nulo ou despadronizado na inscr. imob. (campo Setor)
%% @atualização   29/04/2010: incluido verificação item 2100 ocupação
%% @atualização   29/04/2010: incluido tratamento da verificação de valor da unifp da isenção para o valor do valor do dia
                                       
DECLARE valor_unifp      DECIMAL(15,4);  % Valor da UNIFP
DECLARE area_terreno     DECIMAL(15,4);  % Area DO Terreno
DECLARE area_construida  DECIMAL(15,4);  % Area construida da Unidade (Edificada)
DECLARE setor            CHAR(4);
DECLARE padrao           INTEGER;
DECLARE ocupacao         INTEGER; 
DECLARE vm2t             DECIMAL(15,4);  % Valor DO m2 DO terreno
DECLARE vm2c             DECIMAL(15,4);  % Valor DO m2 da construcao
DECLARE vvt              DECIMAL(15,4);  % Valor Venal DO Terreno
DECLARE vvc              DECIMAL(15,4);  % Valor Venal da Construcao
DECLARE aliquota         DECIMAL(15,4);   
DECLARE vvi              DECIMAL(15,4);  % Valor Venal DO Imovel
DECLARE iptu             DECIMAL(15,4);  % Imposto Predial e Territorial
DECLARE eh_isento        INTEGER;
DECLARE isencao          INTEGER;
DECLARE config           INTEGER;
DECLARE testada          DECIMAL(15,4);
DECLARE cosip            DECIMAL(15,4);  
DECLARE tipo_coleta      INTEGER; 
DECLARE taxa_lixo        DECIMAL(15,4); 
DECLARE eh_devedor       CHAR(2);
DECLARE prog_ano         INTEGER;
DECLARE iluminacao       INTEGER;  
DECLARE isencao_lixo     INTEGER; 
DECLARE valor_tes        DECIMAL(15,4);


%% VERIFICANDO VALOR DA UNIFP NA DATA DO CALCULO

SET valor_unifp = dbf_fc_valor_idx(2,today());


%% INICIALIZANDO VARIAVEIS

SET vm2t = 0;
SET vm2c = 0;
 
%% BUSCANDO O SETOR DO IMOVEL

SELECT isnull((campo1),'0') INTO setor FROM bethadba.imoveis WHERE i_imoveis = w_codigo;

%% BUSCANDO O PADRÃO DA CONSTRUCAO

SET padrao = isnull((dbf_fc_existe_opc_bci(w_codigo,900,dbf_ano_base(w_codigo,w_ano,900,'opcoes_bci'))),0);

%% BUSCANDO A OCUPACAO

SET ocupacao = isnull((dbf_fc_existe_opc_bci(w_codigo,2100,dbf_ano_base(w_codigo,w_ano,2100,'opcoes_bci'))),0);

%% BUSCANDO A AREA DO TERRENO

SET area_terreno = isnull((dbf_fc_retbci_valor(w_codigo,799,dbf_ano_base(w_codigo,w_ano,799,'opcoes_bci'))),0);

%% BUSCANDO A AREA CONSTRUIDA

SET area_construida = isnull((dbf_fc_retbci_valor(w_codigo,899,dbf_ano_base(w_codigo,w_ano,899,'opcoes_bci'))),0);

%% BUSCANDO A ILUMINACAO PUBLICA

SET iluminacao = isnull((dbf_fc_existe_opc_bci(w_codigo,1800,dbf_ano_base(w_codigo,w_ano,1800,'opcoes_bci'))),0);

%% BUSCANDO VALOR DO M2 DO TERRENO E DO VALOR DO M2 DA CONSTRUCAO, CASO EXISTA


IF ((setor = '1A') OR (setor = '2A')) THEN
  SET vm2t = 9; % Valor DO Metro Quadrado da Construcao em UNIFP
  % Na condicao abaixo, verifica se eh Imovel Edificado, encontra o Padrao e define o Valor DO M2 da Construcao
  IF (ocupacao = 2101 OR ocupacao = 2102 OR ocupacao = 2103 OR ocupacao = 2104) THEN 
     IF (padrao = 901) THEN
      SET vm2c = 180;
    ELSE IF padrao = 902 THEN
        SET vm2c = 120;
      ELSE
        SET vm2c = 60;
       END IF;
    END IF;
  END IF;
      ELSE IF ((setor = '3A') OR (setor = '4A')) THEN 
        SET vm2t = 6; % Valor DO Metro Quadrado da Construcao em UNIFP
        % Na condicao abaixo, verifica se eh Imovel Edificado, encontra o Padrao e define o Valor DO M2 da Construcao
          IF (ocupacao = 2101 OR ocupacao = 2102 OR ocupacao = 2103 OR ocupacao = 2104) THEN 
            IF (padrao = 901) THEN
              SET vm2c = 150;
            ELSE IF padrao = 902 THEN
              SET vm2c = 105;
                ELSE
              SET vm2c = 45;
            END IF;
          END IF;
        END IF;
            ELSE IF ((setor = '1B') OR (setor = '2B')) THEN 
            SET vm2t = 4.50; % Valor DO Metro Quadrado da Construcao em UNIFP
            % Na condicao abaixo, verifica se eh Imovel Edificado, encontra o Padrao e define o Valor DO M2 da Construcao
              IF (ocupacao = 2101 OR ocupacao = 2102 OR ocupacao = 2103 OR ocupacao = 2104) THEN
            IF (padrao = 901) THEN
              SET vm2c = 135;
            ELSE IF padrao = 902 THEN
              SET vm2c = 75;
                ELSE
              SET vm2c = 45;
            END IF;
          END IF;
        END IF;
               ELSE IF ((setor = '3B') OR (setor = '4B')) THEN 
            SET vm2t = 3; % Valor DO Metro Quadrado da Construcao em UNIFP
            % Na condicao abaixo, verifica se eh Imovel Edificado, encontra o Padrao e define o Valor DO M2 da Construcao
              IF (ocupacao = 2101 OR ocupacao = 2102 OR ocupacao = 2103 OR ocupacao = 2104) THEN 
            IF (padrao = 901) THEN
              SET vm2c = 90;
            ELSE IF padrao = 902 THEN
              SET vm2c = 75;
                ELSE
              SET vm2c = 30;
            END IF;
          END IF;
        END IF;
                ELSE IF ((setor <> '1A') OR (setor <> '2A') OR (setor <> '3A') OR (setor <> '4A') OR (setor <> '1B') OR (setor <> '2B') OR (setor <> '3B') OR (setor <> '4B')) THEN  % Tratamento caso nao tenha sido informado o setor DO imovel (nulo)
                  PRINT 'entrou aqui';
               CALL dbp_raiserror('','Cálculo NÃO realizado para este cadastro. É necessário informar ou corrigir o campo Setor do Imóvel.');
              END IF;
       END IF;
      END IF;
    END IF;
   END IF; 

%% ARMAZENANDO NO CADASTRO DE IMOVEIS VALOR DO M2 DO TERRENO E DA CONSTRUCAO
   
   SET ret = dbf_fc_cria_bci_valor(w_codigo,4099,vm2t * valor_unifp,w_ano);
   SET ret = dbf_fc_cria_bci_valor(w_codigo,4199,vm2c * valor_unifp,w_ano);
   
   
%% CALCULANDO A COSIP (Iluminacao Publica) conf. Art 163 

% Buscando a testada, que sera usada como base de calculo para a Cosip, caso contrario, 
%% utiliza-se o valor Testada = 10, ou seja, 10 m2 * .50 = 5 UNIFP
%% Somente cobra COSIP se o Imovel for Nao Edificado

IF (ocupacao = 2105) AND (iluminacao = 1801) THEN % Verificando se eh "Nao Edificado" e se eh "Sim" na Iluminacao Pub.
  SET testada = isnull((dbf_fc_retbci_valor(w_codigo,3799,dbf_ano_base(w_codigo,w_ano,3799,'opcoes_bci'))),0);

  IF (testada > 0) THEN
    SET cosip = testada * .50;
  ELSE
    SET cosip = 5;
  END IF;
 END IF;
  
 

%% CALCULANDO O VALOR DO TERENO 


SET vvt = area_terreno * vm2t;
SET ret = dbf_fc_cria_bci_valor(w_codigo,1199,vvt * valor_unifp,w_ano);

%% CALCULANDO O VALOR DA CONSTRUCAO

SET vvc = area_construida * vm2c;
SET ret = dbf_fc_cria_bci_valor(w_codigo,1299,vvc * valor_unifp,w_ano);

%% CALCULANDO O VALOR VENAL DO IMOVEL

SET vvi = vvt + vvc;
SET ret = dbf_fc_cria_bci_valor(w_codigo,1399,vvi * valor_unifp,w_ano); 


%% ENCONTRANDO A ALIQUOTA PARA CALCULAR O IPTU

IF area_construida > 0 THEN 
  IF padrao = 901 THEN
     SET aliquota = .007;
  ELSE IF padrao = 902 THEN
     SET aliquota = .005
    ELSE
     SET aliquota = .004;
   END IF;
  END IF;
    ELSE
      SET aliquota = .02;
 END IF; 
  
%%MESSAGE string('padrão', padrao)   TYPE WARNING TO CLIENT;   
%%MESSAGE string('aliquota', aliquota)   TYPE WARNING TO CLIENT;     
 
 
%% ARMAZENANDO NO CADASTRO DE IMOVEIS VALOR DA ALIQUOTA
   
SET ret = dbf_fc_cria_bci_valor(w_codigo,4299,aliquota * 100,w_ano);

%% CALCULANDO O IMPOSTO PREDIAL E TERRITORIAL 


SET iptu = vvi * aliquota; 

%%MESSAGE string('iptu -> ', iptu)   TYPE WARNING TO CLIENT;


% VERIFICANDO A ISENCAO DO IPTU NO CADASTRO DE IMOVEIS

SET eh_isento = dbf_fc_existe_opc_bci(w_codigo,100,dbf_ano_base(w_codigo,w_ano,100,'opcoes_bci'));

IF (eh_isento = 101) THEN % ISENTO/IMUNE
  SET isencao = 1;
END IF;

%%  (ALTERADA PELA LEI 768/2017)
%% VERIFICANDO A ISENCAO DO IPTU IMPOSTO MENOR OU IGUAL A 30 UNIFP (Art. 52)
%% validade somente para imoveis com Ocupacao = "Edificado" (2101)

%%IF (iptu <=50) AND (ocupacao = 2101) THEN
%%  SET isencao = 2;
%% END IF;            
 

% VERIFICANDO A PROGRESSIVIDADE PARA TERRENOS BALDIOS (Art. 48)
% A cada ano sem Edificacao, é acrescido 10% no valor DO imposto
% A verificacao eh realizada por meio DO Ano Base DO Item 2100   

SELECT isnull((max(ano)),0) AS ano_encontrado INTO prog_ano FROM bethadba.opcoes_bci WHERE i_item = 2105 AND i_imoveis = w_codigo
AND NOT EXISTS(SELECT 1 FROM bethadba.opcoes_bci WHERE i_item IN (2101,2102) AND i_imoveis = w_codigo
AND ano > (SELECT isnull((max(ano)),0) FROM bethadba.opcoes_bci WHERE i_item = 2105 AND i_imoveis = w_codigo)); 

IF (prog_ano > 0) THEN 
  SET iptu = iptu + (iptu * ((w_ano-prog_ano) / 10.));
 END IF;  
 
%% MESSAGE string('prog ano ', prog_ano)   TYPE WARNING TO CLIENT;
 

% VERIFICANDO SE EH DEVEDOR DE EXERCICIOS ANTERIORES E DEFININDO O DESCONTO (Art. 50)
% Se o retorno FOR "02", referem-se a Dividas em Aberto vencidas, que sao verificadas a
% sua situacao no ultimo dia DO exercicio anterior ao DO calculo. 

SELECT dbf_devedor(1,w_codigo, string(w_ano-1)+'-12-31') INTO eh_devedor;

%%MESSAGE string('devedor ', eh_devedor)   TYPE WARNING TO CLIENT;

% DEFININDO A CONFIGURACAO DE PARCELAS CONFORME VALOR DO IMPOSTO COM MINIMO DE 15 UNIFP (Art.50 III)
% Para cada faixa de valor, eh utilizada uma configuracao que (1) concede 20% de desconto para a cota
% unica  caso nao existam dividas ativas no ultimo dia DO exercicio anterior (Art. 50 I) e (2) concede 10% 
% de desconto para a cota unica caso existam dividas (Art. 50 II).


 IF eh_devedor='00' THEN
IF iptu <= 30 THEN
     SET config=15;
   ELSEIF iptu >30 AND iptu <=45 THEN 
     SET config=13; 
   ELSEIF iptu > 45 AND iptu <=60 THEN 
     SET config=11;      
   ELSEIF iptu > 60 AND iptu <=74 THEN 
     SET config=9;      
   ELSEIF iptu > 74 AND iptu <=90 THEN 
     SET config=7; 
   ELSEIF iptu > 90 AND iptu <=105 THEN 
     SET config=5;
   ELSEIF iptu > 105 AND iptu <=120 THEN 
     SET config=3;     
   ELSE 
     SET config=1;
   END IF;
ELSE     
   IF iptu <= 30 THEN
     SET config=16;
   ELSEIF iptu > 30 AND iptu <=45 THEN 
     SET config=14; 
   ELSEIF iptu > 45 AND iptu <=60 THEN 
     SET config=12;      
   ELSEIF iptu > 60 AND iptu <=74 THEN 
     SET config=10;      
   ELSEIF iptu > 74 AND iptu <=90 THEN 
     SET config=8;
   ELSEIF iptu > 90 AND iptu <=105 THEN 
     SET config=6;
   ELSEIF iptu> 105 AND iptu <=120 THEN 
     SET config=4;   
   ELSE 
     SET config=2;
   END IF    
END IF;     
    

 
%%MESSAGE string('configuração -> ', config)   TYPE WARNING TO CLIENT; 
 
%%  (REVOGADA PELA LEI 769/2017)  
%%VERIRICA A ISENCAO DA TAXA DE LIXO
%%IF tipo_coleta = 1713 THEN 
%%  SET isencao_lixo = 1;  
%%ELSE  
%% SET isencao_lixo = 3;  
%%END IF;   

%%SET valor_tes = iptu * valor_unifp;

%%MESSAGE string('iptu -> ', iptu)   TYPE WARNING TO CLIENT;
%%MESSAGE string('valor_tes -> ', valor_tes)   TYPE WARNING TO CLIENT;    

%% CRIANDO AS RECEITAS

SET ret = (dbf_fc_cria_rec(101,iptu * valor_unifp,config, isencao));   

%%  (REVOGADA PELA LEI 769/2017)
%%IF isencao_lixo = 1 THEN
%%  SET ret = (dbf_fc_cria_rec(102,taxa_lixo * valor_unifp,config, isencao_lixo));
%%ELSE                                                              
%%  SET ret = (dbf_fc_cria_rec(102,taxa_lixo * valor_unifp,config));
%%END IF;

%%SET ret = (dbf_fc_cria_rec(102,taxa_lixo * valor_unifp,config, isencao));
SET ret = (dbf_fc_cria_rec(103,cosip * valor_unifp,config));
SET ret = dbf_fc_cria_desc_imo(*); 