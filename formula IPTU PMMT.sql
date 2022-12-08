IF     coleta_lixo = 1801 AND zona_lixo = 6001 THEN     %% residencial regular A
  SET tsu = 0.75;
ELSEIF coleta_lixo = 1801 AND zona_lixo = 6002 THEN     %% residencial regular B
  SET tsu = 0.50;
ELSEIF coleta_lixo = 1802 AND zona_lixo = 6001 THEN     %% residencial   medio A
  SET tsu = 1.25;
ELSEIF coleta_lixo = 1802 AND zona_lixo = 6002 THEN     %% residencial   medio B
  SET tsu = 1;
ELSEIF coleta_lixo = 1803 AND zona_lixo = 6001 THEN     %% residencial elevado A
  SET tsu = 2;
ELSEIF coleta_lixo = 1803 AND zona_lixo = 6002 THEN     %% residencial elevado B
  SET tsu = 1.5;
ELSEIF coleta_lixo = 1804 AND zona_lixo = 6001 THEN     %% residencial especial A
  SET tsu = 2.5;
ELSEIF coleta_lixo = 1804 AND zona_lixo = 6002 THEN     %% residencial especial B
  SET tsu = 2;
ELSEIF coleta_lixo = 1805 AND zona_lixo = 6001 THEN     %% residencial multifamiliar A
  SET tsu = 1;
ELSEIF coleta_lixo = 1805 AND zona_lixo = 6002 THEN     %% residencial multifamiliar B
  SET tsu = 0.75;                                                                     
  
ELSEIF coleta_lixo = 1806 AND zona_lixo = 6001 AND area_terreno <=  60 THEN  %%Comercial
  SET tsu = 2;
ELSEIF coleta_lixo = 1806 AND zona_lixo = 6002 AND area_terreno <=  60 THEN
  SET tsu = 1.5;
ELSEIF coleta_lixo = 1806 AND zona_lixo = 6001 AND area_terreno >  60 AND area_terreno <= 150 THEN     
  SET tsu = 3.5;                                                                                       
ELSEIF coleta_lixo = 1806 AND zona_lixo = 6002 AND area_terreno >  60 AND area_terreno <= 150 THEN
  SET tsu = 1.75;   
ELSEIF coleta_lixo = 1806 AND zona_lixo = 6001 AND area_terreno > 150 AND area_terreno <= 350 THEN
  SET tsu = 5;      
ELSEIF coleta_lixo = 1806 AND zona_lixo = 6002 AND area_terreno > 150 AND area_terreno <= 350 THEN
  SET tsu = 3;      
ELSEIF coleta_lixo = 1806 AND zona_lixo = 6001 AND area_terreno > 350 AND area_terreno <= 700 THEN
  SET tsu = 10;      
ELSEIF coleta_lixo = 1806 AND zona_lixo = 6002 AND area_terreno > 350 AND area_terreno <= 700 THEN
  SET tsu = 6;    
ELSEIF coleta_lixo = 1806 AND zona_lixo = 6001 AND area_terreno > 700 AND area_terreno <= 1200 THEN
  SET tsu = 15;      
ELSEIF coleta_lixo = 1806 AND zona_lixo = 6002 AND area_terreno > 7000 AND area_terreno <= 1200 THEN
  SET tsu = 7.5;          
ELSEIF coleta_lixo = 1806 AND zona_lixo = 6001 AND area_terreno > 12000 THEN
  SET tsu = 17.5;            
ELSEIF coleta_lixo = 1806 AND zona_lixo = 6002 AND area_terreno > 12000 THEN
  SET tsu = 8.75;  
            
ELSEIF coleta_lixo = 1807 AND zona_lixo = 6001 AND area_terreno <=  100 THEN    %% Industria
  SET tsu = 4;
ELSEIF coleta_lixo = 1807 AND zona_lixo = 6002 AND area_terreno <=  100 THEN
  SET tsu = 2;
ELSEIF coleta_lixo = 1807 AND zona_lixo = 6001 AND area_terreno > 100 AND area_terreno <= 350 THEN
  SET tsu = 8;      
ELSEIF coleta_lixo = 1807 AND zona_lixo = 6001 AND area_terreno > 100 AND area_terreno <= 350 THEN
  SET tsu = 3;                                                 
ELSEIF coleta_lixo = 1807 AND zona_lixo = 6001 AND area_terreno > 350 AND area_terreno <= 700 THEN
  SET tsu = 10;      
ELSEIF coleta_lixo = 1807 AND zona_lixo = 6001 AND area_terreno > 350 AND area_terreno <= 700 THEN
  SET tsu = 5;   
ELSEIF coleta_lixo = 1807 AND zona_lixo = 6001 AND area_terreno > 700 THEN
  SET tsu = 15;            
ELSEIF coleta_lixo = 1807 AND zona_lixo = 6002 AND area_terreno > 700 THEN
  SET tsu = 8;  

ELSEIF coleta_lixo = 1808 AND zona_lixo = 6001 AND area_terreno <=  100 THEN   %% Industria  nociva
  SET tsu = 16;
ELSEIF coleta_lixo = 1808 AND zona_lixo = 6002 AND area_terreno <=  100 THEN
  SET tsu = 8;
ELSEIF coleta_lixo = 1808 AND zona_lixo = 6001 AND area_terreno > 100 AND area_terreno <= 350 THEN
  SET tsu = 24;      
ELSEIF coleta_lixo = 1808 AND zona_lixo = 6001 AND area_terreno > 100 AND area_terreno <= 350 THEN
  SET tsu = 12;                                                 
ELSEIF coleta_lixo = 1808 AND zona_lixo = 6001 AND area_terreno > 350 AND area_terreno <= 700 THEN
  SET tsu = 32;      
ELSEIF coleta_lixo = 1808 AND zona_lixo = 6001 AND area_terreno > 350 AND area_terreno <= 700 THEN
  SET tsu = 16;   
ELSEIF coleta_lixo = 1808 AND zona_lixo = 6001 AND area_terreno > 700 THEN
  SET tsu = 40;            
ELSEIF coleta_lixo = 1808 AND zona_lixo = 6002 AND area_terreno > 700 THEN  
  SET tsu = 75;      
  
ELSEIF coleta_lixo = 1809 AND zona_lixo = 6001 AND area_terreno <=  60 THEN   %% Prestadores de serviço
  SET tsu = 3;
ELSEIF coleta_lixo = 1809 AND zona_lixo = 6002 AND area_terreno <=  60 THEN
  SET tsu = 1.5;
ELSEIF coleta_lixo = 1809 AND zona_lixo = 6001 AND area_terreno >  60 AND area_terreno <= 150 THEN    
  SET tsu = 5.5;                                                                                      
ELSEIF coleta_lixo = 1809 AND zona_lixo = 6002 AND area_terreno > 60 AND area_terreno  <= 150 THEN
  SET tsu = 2.75;     
ELSEIF coleta_lixo = 1809 AND zona_lixo = 6001 AND area_terreno > 150 AND area_terreno <= 350 THEN
  SET tsu = 10;      
ELSEIF coleta_lixo = 1809 AND zona_lixo = 6002 AND area_terreno > 150 AND area_terreno <= 350 THEN
  SET tsu = 5;      
ELSEIF coleta_lixo = 1809 AND zona_lixo = 6001 AND area_terreno > 350  THEN
  SET tsu = 12.5;      
ELSEIF coleta_lixo = 1809 AND zona_lixo = 6002 AND area_terreno > 350  THEN
  SET tsu = 6.25;    
  
ELSEIF coleta_lixo = 1810 AND zona_lixo = 6001 AND area_terreno <=  150 THEN    %%Entidades
  SET tsu = 1;
ELSEIF coleta_lixo = 1810 AND zona_lixo = 6002 AND area_terreno <=  150 THEN
  SET tsu = 0.5;
ELSEIF coleta_lixo = 1810 AND zona_lixo = 6001 AND area_terreno > 150 AND area_terreno <= 400 THEN
  SET tsu = 2.5;      
ELSEIF coleta_lixo = 1810 AND zona_lixo = 6001 AND area_terreno > 150 AND area_terreno <= 400 THEN
  SET tsu = 1.5;                                                 
ELSEIF coleta_lixo = 1810 AND zona_lixo = 6001 AND area_terreno > 400 AND area_terreno <= 800 THEN
  SET tsu = 4;      
ELSEIF coleta_lixo = 1810 AND zona_lixo = 6001 AND area_terreno > 400 AND area_terreno <= 800 THEN
  SET tsu = 2.75;   
ELSEIF coleta_lixo = 1810 AND zona_lixo = 6001 AND area_terreno > 800 THEN
  SET tsu = 6;            
ELSEIF coleta_lixo = 1810 AND zona_lixo = 6002 AND area_terreno > 800 THEN  
  SET tsu = 4;       
  
ELSEIF coleta_lixo = 1811 AND zona_lixo = 6001 AND area_terreno <=  150 THEN    %% Institucional
  SET tsu = 2;
ELSEIF coleta_lixo = 1811 AND zona_lixo = 6002 AND area_terreno <=  150 THEN
  SET tsu = 0.5;
ELSEIF coleta_lixo = 1811 AND zona_lixo = 6001 AND area_terreno > 150 AND area_terreno <= 500 THEN
  SET tsu = 4;      
ELSEIF coleta_lixo = 1811 AND zona_lixo = 6001 AND area_terreno > 150 AND area_terreno <= 500 THEN
  SET tsu = 2.25;                                                 
ELSEIF coleta_lixo = 1811 AND zona_lixo = 6001 AND area_terreno > 500 THEN
  SET tsu = 8;            
ELSEIF coleta_lixo = 1811 AND zona_lixo = 6002 AND area_terreno > 700 THEN  
  SET tsu = 4;                                                              
  
ELSEIF coleta_lixo = 1812 AND zona_lixo = 6001 THEN    %%Drogarias
  SET tsu = 5;  
ELSEIF coleta_lixo = 1812 AND zona_lixo = 6002 THEN
  SET tsu = 2.5;  
       
ELSEIF coleta_lixo = 1813 AND zona_lixo = 6001 THEN    %%Clinicas
  SET tsu = 7.5;  
ELSEIF coleta_lixo = 1813 AND zona_lixo = 6002 THEN
  SET tsu = 3.75;  
  
ELSEIF coleta_lixo = 1814 AND zona_lixo = 6001 THEN    %% Hospitais
  SET tsu = 10;  
ELSEIF coleta_lixo = 1814 AND zona_lixo = 6002 THEN
  SET tsu = 5;
  
ELSEIF coleta_lixo >= 1815 AND zona_lixo = 6001 THEN    %% Outros
  SET tsu = 5;  
ELSEIF coleta_lixo >= 1815 AND zona_lixo = 6002 THEN
  SET tsu = 2.5;  

END IF;  
MESSAGE string('tsu: ',tsu) type warning TO client; 
 
%%Verifica isenção
/*
IF dbf_fc_existe_opc_bci(w_codigo,4900,dbf_ano_base(w_codigo,w_ano,4900,'opcoes_bci'))=4901 THEN
  SET isencao_imposto=1;
  ELSEIF dbf_fc_existe_opc_bci(w_codigo,4900,dbf_ano_base(w_codigo,w_ano,4900,'opcoes_bci'))=4902 THEN
   SET isencao_taxas=2 ;
   ELSEIF dbf_fc_existe_opc_bci(w_codigo,4900,dbf_ano_base(w_codigo,w_ano,4900,'opcoes_bci'))=4903 THEN
    SET isencao_imposto=3 ;
    SET isencao_taxas=3 ;
  END IF;   */
    

%%Criando as receitas                  
SET ret=dbf_fc_cria_rec(101,iptu,1,isencao_imposto); 
SET ret=dbf_fc_cria_rec(102,tsu,1,isencao_taxas); 
%%SET ret=dbf_fc_cria_rec(103,tarifa,2,isencao_taxas);

SET ret=dbf_fc_cria_bci_valor(w_codigo,799,vvt,w_ano);
SET ret=dbf_fc_cria_bci_valor(w_codigo,899,vvc,w_ano);
SET ret=dbf_fc_cria_bci_valor(w_codigo,999,vvi,w_ano);
SET ret=dbf_fc_cria_bci_valor(w_codigo,1099,m2_terreno,w_ano);
SET ret=dbf_fc_cria_bci_valor(w_codigo,1199,m2_construcao,w_ano); 
SET ret=dbf_fc_cria_bci_valor(w_codigo,6099,aliq * 100,w_ano);
SET ret=dbf_fc_cria_bci_valor(w_codigo,5599,iptu,w_ano);