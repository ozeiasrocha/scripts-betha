 /* -- Fórmula de Lançamento*/
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
%%  ********************  OBSERVAÇÃO   ********************
%%  Não pode ser utilizado o comando RETURN nas fórmulas deverá ser utilizado a procedure dbp_raiserror 
%%  da seguinte forma para banco na versão 5 call dbp_raiserror('1 parâmetro mensagem desejada', '2 parâmetro nulo')   
%%  da seguinte forma para banco na versão 7 call dbp_raiserror('1 parâmetro nulo', '2 parâmetro mensagem desejada')  

DECLARE valor_base    DECIMAL(15,4);


SET valor_base = 0;

%%-- Vefificando se foram informadas AS bases que necessitam da metragem para o Calculo

SET valor_base = isnull(dbf_fc_ret_base_decimal(w_codigo, 10),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 11),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 12),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 13),0);
                 
IF ((valor_base > 0) AND (isnull(dbf_fc_ret_base_decimal(w_codigo, 24),0)=0)) THEN
  CALL dbp_raiserror('', 'Deve ser informada a base da metragem para calcular. Item 1.6 do Art. 229.') 
ELSE 
  % Calcula o Valor da Base Pela Metragem Informada
  SET valor_base = valor_base * isnull(dbf_fc_ret_base_decimal(w_codigo, 24),0);
  END IF;
  

% Encontra o valor base de todas AS bases que nao necessitam de M2 para o Calculo

SET valor_base = isnull(dbf_fc_ret_base_decimal(w_codigo, 1),0) + 
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 2),0) +  
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 3),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 4),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 5),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 6),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 7),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 8),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 9),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 14),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 15),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 16),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 17),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 18),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 19),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 20),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 21),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 22),0) +
                 isnull(dbf_fc_ret_base_decimal(w_codigo, 23),0) +
                 isnull((valor_base),0);
                 


% CRIANDO A RECEITA
SET ret = dbf_fc_cria_rec(1101, valor_base);

