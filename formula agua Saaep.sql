%%************************************************************
%% Calculo do evento 1 - Água
%%************************************************************
%% p_fatura            ---> Código da fatura que esta sendo gerada
%% p_imovel          ---> Código do imóvel que esta sendo calculado
%% p_ligacao         ---> Código da ligação do imóvel que esta sendo calculado
%% p_pessoa          ---> Código do consumidor que esta sendo gerada a fatura
%% p_ocorrencia      ---> Código da ocorrencia que informada na ficha de leitura
%% p_dataFat         ---> Data de faturamento
%% p_dtLeitAtu       ---> Data que foi efetuada a leitura
%% p_vcto            ---> Data de vencimento da fatura
%% p_leitura         ---> Valor lido
%% p_codClasse       ---> Código da classe economico
%% p_qtdEcon         ---> Quantidade de economias na classe
%% p_qtdCons         ---> Quantidade total consumida
%% p_vlrFat          ---> Valor total faturado 
%% p_qtdConsClas     ---> Quantidade consumida pela classe
%% p_qtdConsEcon     ---> Quantidade consumida na economia da classe
%% p_vlrFatClas      ---> Valor faturado para a classe
%% p_vlrFatEcon      ---> Valor faturado na economia da classe
%% w_retorno_evento  ---> Valor calculado para o evento


DECLARE w_preco DECIMAL( 15,2);
DECLARE w_excede DECIMAL( 15,2);
DECLARE w_faixa_ini INTEGER;  
DECLARE w_faixa_fim INTEGER;
DECLARE w_data_preco DATE;
DECLARE w_valor_econ DECIMAL(15,2);            
DECLARE w_forma_calc CHAR(1);  
DECLARE w_classe INTEGER;
DECLARE w_leitura_ant DECIMAL(15,2); 
DECLARE vlr_eve DECIMAL(15,2);
DECLARE w_consest INTEGER;   
DECLARE w_media DECIMAL(15,2);
DECLARE w_minimo DECIMAL(15,2);   
DECLARE w_dia_vcto INTEGER; 
DECLARE w_ocorrencia_ant INTEGER;
DECLARE w_cons_ant DECIMAL(15,2);
%%MESSAGE 'Inicio... '        type warning TO client;  
IF (SELECT 1 FROM bethadba.imoveis_fatura WHERE situa_agua = 1 AND i_imoveis = p_imovel AND i_ligacoes = p_ligacao) <> 0  THEN
 
        
   SELECT  forma_calculo, i_classes, consumo_estimado, dia_vcto INTO w_forma_calc, w_classe, w_consest, w_dia_vcto 
         FROM bethadba.imoveis_fatura INNER JOIN bethadba.economias_fatura
         ON imoveis_fatura.i_ligacoes = economias_fatura.i_ligacoes 
         WHERE situacao='F' AND imoveis_fatura.i_imoveis = p_imovel AND imoveis_fatura.i_ligacoes = p_ligacao; 
   SET w_minimo=(SELECT cons_min_class FROM bethadba.classes WHERE i_classes=p_codClasse);   
   IF isnull(p_vlrFatEcon,0)=0 THEN
      SET p_vlrFatEcon = w_minimo;
   END IF;   
   
   IF isnull(w_dia_vcto,0)<>0 THEN
      SET p_vcto  = substring(p_dataFat,1,8)+string(w_dia_vcto);
   END IF;  
   
    
   SET w_leitura_ant = dbf_fc_retleitura_ant(p_imovel, p_ligacao, p_dataFat);
   SET w_media =(SELECT FIRST media FROM bethadba.faturas WHERE i_ligacoes=p_ligacao AND data_fat=p_dataFat ORDER BY data_fat); 
   SET w_ocorrencia_ant =(SELECT FIRST i_ocorrencias FROM bethadba.vw_faturas  WHERE i_ligacoes=p_ligacao AND data_fat<p_dataFat  AND situacao<>'C' AND tipo_eve='A' ORDER BY data_fat DESC);
   SET w_cons_ant =  (SELECT FIRST fatu_econ FROM bethadba.vw_faturas  WHERE i_ligacoes=p_ligacao AND data_fat<p_dataFat  AND situacao<>'C' AND tipo_eve='A' ORDER BY data_fat DESC);
   
   IF w_ocorrencia_ant = 6 THEN
      SET  p_qtdConsClas = p_qtdConsClas - w_cons_ant; 
      IF p_qtdConsClas<0 THEN
          SET p_qtdConsClas = 0;
      ELSE     
        SET p_qtdConsEcon = p_qtdConsClas/p_qtdEcon;
        SET p_vlrFatEcon = p_qtdConsClas/p_qtdEcon; 
        SET p_qtdCons =  p_qtdConsClas; 
      END IF;  
   END IF;  
   
   IF p_ocorrencia IN (4, 6, 7, 8, 10, 12, 14, 16, 18, 19, 20, 22, 23, 25, 27, 29, 39, 44, 47)  THEN 
      %% calculo pela média
      SET p_qtdConsClas = w_media;
      SET p_qtdConsEcon = p_qtdConsClas/p_qtdEcon;
      SET p_vlrFatEcon = p_qtdConsClas/p_qtdEcon; 
      SET p_qtdCons =  p_qtdConsClas; 
   ELSEIF p_ocorrencia = 13 THEN %%  COR CAM LIG SIST g
      SET p_qtdConsClas = 0;
      SET p_qtdCons = 0;  
   ELSEIF p_ocorrencia IN (3, 15, 26, 30) THEN
      SET p_qtdConsClas = w_minimo;
      SET p_qtdCons = p_qtdConsClas; 
   ELSEIF p_ocorrencia = 28 THEN    %%HIDROMETRO REINICIADO
      SET p_qtdConsClas = 10000 - w_leitura_ant+p_leitura; 
      SET p_qtdConsEcon = p_qtdConsClas/p_qtdEcon;
      SET p_vlrFatEcon = p_qtdConsClas/p_qtdEcon; 
      SET p_vlrFatClas = p_qtdConsClas/p_qtdEcon;
      SET p_vlrFat = p_qtdConsClas/p_qtdEcon;
      SET p_qtdCons = p_qtdConsClas; 
   ELSEIF p_ocorrencia = 31 THEN   %%HIDROMETRO NOVO/TROCADO   
      SET p_qtdConsClas = w_media;
      %%p_qtdConsClas +1+ isnull((SELECT FIRST leitura_final-leitura_inicial FROM bethadba.imoveis_hidrometros WHERE i_ligacoes=p_ligacao ORDER BY data_util DESC),0);
      SET p_qtdConsEcon = p_qtdConsClas/p_qtdEcon;
      SET p_vlrFatEcon = p_qtdConsClas/p_qtdEcon; 
      SET p_qtdCons =  p_qtdConsClas;                           
   END IF; 
 
   IF  p_qtdEcon> 1 THEN
        SELECT max(i_datas) INTO w_data_preco
        FROM bethadba.tabelas_precos
        WHERE i_classes = p_codClasse AND
             i_faixa_ini <= CEILING(p_qtdConsClas) AND    	
              faixa_fim + 1 > CEILING( p_qtdConsClas);
        
        SELECT valor_faixa,valor_exced,i_faixa_ini, faixa_fim
        INTO w_preco,  w_excede,  w_faixa_ini, w_faixa_fim
        FROM bethadba.tabelas_precos
        WHERE i_datas =  w_data_preco AND
              i_classes =  p_codClasse AND
              i_faixa_ini <= CEILING( p_qtdConsClas) AND               
              (faixa_fim+1) > CEILING( p_qtdConsClas);  
   ELSE
        SELECT max(i_datas) INTO w_data_preco
        FROM bethadba.tabelas_precos
        WHERE i_classes = p_codClasse AND
             i_faixa_ini <= CEILING(p_vlrFatEcon) AND    	
              faixa_fim + 1 > CEILING( p_vlrFatEcon);
        
        SELECT valor_faixa,valor_exced,i_faixa_ini, faixa_fim
        INTO w_preco,  w_excede,  w_faixa_ini, w_faixa_fim
        FROM bethadba.tabelas_precos
        WHERE i_datas =  w_data_preco AND
              i_classes =  p_codClasse AND
              i_faixa_ini <= CEILING( p_vlrFatEcon) AND               
              (faixa_fim+1) > CEILING( p_vlrFatEcon); 
  
   END IF;    
   %% MESSAGE 'w_forma_calc '|| w_forma_calc        type warning TO client;
        
   IF ( w_forma_calc<>'H')  THEN   
          SELECT max(i_datas) INTO w_data_preco FROM bethadba.tabelas_precos  WHERE i_classes = p_codClasse;      
          CASE w_classe
          WHEN 1 THEN  
             SELECT top 1 valor_faixa INTO w_preco FROM bethadba.tabelas_precos  WHERE  i_datas <=  w_data_preco AND i_classes = 9 ORDER BY i_datas DESC;
          WHEN 2 THEN             
             SELECT top 1 valor_faixa INTO w_preco FROM bethadba.tabelas_precos  WHERE  i_datas <=  w_data_preco AND i_classes = 11 ORDER BY i_datas DESC;
          WHEN 3 THEN             
             SELECT top 1 valor_faixa INTO w_preco FROM bethadba.tabelas_precos  WHERE  i_datas <=  w_data_preco AND i_classes = 15 ORDER BY i_datas DESC;
          WHEN 4 THEN             
             SELECT top 1 valor_faixa INTO w_preco FROM bethadba.tabelas_precos  WHERE  i_datas <=  w_data_preco AND i_classes = 13 ORDER BY i_datas DESC;             
          WHEN 5 THEN             
             SELECT top 1 valor_faixa INTO w_preco FROM bethadba.tabelas_precos  WHERE  i_datas <=  w_data_preco AND i_classes = 14 ORDER BY i_datas DESC;             
          WHEN 6 THEN             
             SELECT top 1 valor_faixa INTO w_preco FROM bethadba.tabelas_precos  WHERE  i_datas <=  w_data_preco AND i_classes = 10 ORDER BY i_datas DESC;           
          WHEN 7 THEN             
             SELECT top 1 valor_faixa INTO w_preco FROM bethadba.tabelas_precos  WHERE  i_datas <=  w_data_preco AND i_classes = 16 ORDER BY i_datas DESC;             
          WHEN 8 THEN             
             SELECT top 1 valor_faixa INTO w_preco FROM bethadba.tabelas_precos  WHERE  i_datas <=  w_data_preco AND i_classes = 12 ORDER BY i_datas DESC;                                                                                                       
          ELSE
             SELECT top 1 valor_faixa INTO w_preco FROM bethadba.tabelas_precos  WHERE  i_datas <=  w_data_preco AND i_classes = p_codClasse ORDER BY i_datas DESC;
               
            /* MESSAGE 'preco! '|| w_preco       type warning TO client;   
             MESSAGE 'w_data_preco! '|| w_data_preco       type warning TO client;   
             MESSAGE 'classe! '|| p_codClasse       type warning TO client;*/ 
               
          END CASE;  
          SET w_retorno_evento = w_preco * w_consest ; 
            
   ELSE  %%consumo medido (hidrometro) 

           IF p_ocorrencia>0 AND p_qtdCons=0 THEN  
             SET w_faixa_ini = 0;
           END IF;  
               
           IF p_codClasse IN (2,3,4,7,8) THEN  
              IF p_qtdConsClas<15 THEN
                 SET p_qtdConsClas=15; 
 
              END IF; 
           ELSE      
              IF p_qtdConsClas<10 THEN     
                  SET p_qtdConsClas=10;
              END IF;    
           END IF;   

      
         /* MESSAGE 'w_preco '      || w_preco       type warning TO client;  
          MESSAGE 'w_faixa_ini '  || w_faixa_ini   type warning TO client;  
          MESSAGE 'w_classe '     || w_classe      type warning TO client; 
          MESSAGE 'p_codClasse '  || p_codClasse   type warning TO client;  
          MESSAGE 'p_qtdEcon '    || p_qtdEcon     type warning TO client;   
          MESSAGE 'p_qtdCons '    || p_qtdCons     type warning TO client; 
          MESSAGE 'p_vlrFat '     || p_vlrFat      type warning TO client; 
          MESSAGE 'p_qtdConsClas '|| p_qtdConsClas type warning TO client;   
          MESSAGE 'p_qtdConsEcon '|| p_qtdConsEcon type warning TO client;   
          MESSAGE 'p_vlrFatClas ' || p_vlrFatClas  type warning TO client;   
          MESSAGE 'p_vlrFatEcon ' || p_vlrFatEcon  type warning TO client;  
          MESSAGE 'w_excede '     || w_excede      type warning TO client;      
          MESSAGE 'p_ocorrencia ' || p_ocorrencia  type warning TO client;*/  
      
        IF w_faixa_ini = 0 THEN       
            %% MESSAGE 'H0 '|| w_faixa_ini         type warning TO client;  
               
            /*  SELECT valor_faixa INTO w_preco FROM bethadba.tabelas_precos
              WHERE i_datas =  w_data_preco AND
              i_classes =  p_codClasse AND
              i_faixa_ini <= CEILING( p_vlrFatClas+1) AND
              (faixa_fim+1) > CEILING( p_vlrFatClas+1); */ 

              SELECT valor_faixa INTO w_preco FROM bethadba.tabelas_precos
              WHERE i_datas =  w_data_preco AND
              i_classes =  p_codClasse AND
              i_faixa_ini <= CEILING( p_qtdConsClas+1) AND
              (faixa_fim+1) > CEILING( p_qtdConsClas+1);
               
                %%MESSAGE 'w_preco2 '    || w_preco       type warning TO client; 
          SET w_valor_econ = w_preco ; /*+ ((p_qtdConsClas - w_faixa_ini) * w_excede) -0.01 ;*/ 
        ELSE 
           %%MESSAGE 'H>0 '|| w_faixa_ini         type warning TO client;  
          SET w_valor_econ = w_preco + ((p_qtdConsClas - (w_faixa_ini-1)) * w_excede)     ;
        END IF;
        %% SET w_retorno_evento = w_valor_econ * p_qtdEcon;  
        SET w_retorno_evento = w_valor_econ;  
       
   END IF;   
 ELSE  
     
      SET vlr_eve =(SELECT sum(valor_evento) FROM bethadba.eventos_manuais WHERE i_ligacoes=p_ligacao AND data_fat=p_dataFat AND situacao_eve='L' AND valor_evento>0);  
      IF vlr_eve>0 THEN
        %%MESSAGE vlr_eve type warning TO client;
       SET w_retorno_evento = 0.001; 
      END IF;
       
        %%MESSAGE 'CORTADO '         type warning TO client; 
  
  
  
END IF;   