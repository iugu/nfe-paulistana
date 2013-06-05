Nota Fiscal Paulistana
=============

Instanciando o Gateway
--------------------

      gateway = NfePaulistana::Gateway.new(cert_path: "path/to/certificate.p12", cert_pass: "password")

Metodos
------------

**EnvioRPS**
      
      response = gateway.envio_rps({
        :cnpj_remetente => "99999999999999",
        :inscricao_prestador => "99999999",
        :data_emissao => "AAAA-MM-DD",
        :email_tomador => "email@email.email",
        :tipo_rps => "RPS",
        :serie_rps => "AAAAA",
        :status_rps => "N",
        :valor_servicos => "10.00",
        :aliquota_servicos => "0.05",
        :tributacao_rps => "T",
        :numero_rps => "1",
        :cpf_tomador => "99999999999",
        :codigo_servico => "99999",
        :discriminacao => ""
      })

**EnvioLoteRPS**

      response = gateway.envio_lote_rps({
        :cnpj_remetente => "99999999999999",
        :inscricao_prestador => "99999999",
        :data_inicio => "AAAA-MM-DD",
        :data_fim => "AAAA-MM-DD",
        :qtd_rps => "2",
        :valor_total_servicos => "20.00",
        :valor_total_deducoes => "0",
        :lote_rps => => [{
          :inscricao_prestador => "99999999",
          :data_emissao => "AAAA-MM-DD",
          :email_tomador => "email@email.email",
          :tipo_rps => "RPS",
          :serie_rps => "AAAAA",
          :status_rps => "N",
          :valor_servicos => "10.00",
          :aliquota_servicos => "0.05",
          :tributacao_rps => "T",
          :numero_rps => "1",
          :cpf_tomador => "99999999999",
          :codigo_servico => "99999",
          :discriminacao => ""
        },{
          :inscricao_prestador => "99999999",
          :data_emissao => "AAAA-MM-DD",
          :email_tomador => "email@email.email",
          :tipo_rps => "RPS",
          :serie_rps => "AAAAA",
          :status_rps => "N",
          :valor_servicos => "10.00",
          :aliquota_servicos => "0.05",
          :tributacao_rps => "T",
          :numero_rps => "2",
          :cpf_tomador => "99999999999",
          :codigo_servico => "99999",
          :discriminacao => ""
        }]
      })

**TesteEnvioLoteRPS**

      response = gateway.teste_envio_lote_rps({
        :cnpj_remetente => "99999999999999",
        :inscricao_prestador => "99999999",
        :data_inicio => "AAAA-MM-DD",
        :data_fim => "AAAA-MM-DD",
        :qtd_rps => "2",
        :valor_total_servicos => "20.00",
        :valor_total_deducoes => "0",
        :lote_rps => => [{
          :inscricao_prestador => "99999999",
          :data_emissao => "AAAA-MM-DD",
          :email_tomador => "email@email.email",
          :tipo_rps => "RPS",
          :serie_rps => "AAAAA",
          :status_rps => "N",
          :valor_servicos => "10.00",
          :aliquota_servicos => "0.05",
          :tributacao_rps => "T",
          :numero_rps => "1",
          :cpf_tomador => "99999999999",
          :codigo_servico => "99999",
          :discriminacao => ""
        },{
          :inscricao_prestador => "99999999",
          :data_emissao => "AAAA-MM-DD",
          :email_tomador => "email@email.email",
          :tipo_rps => "RPS",
          :serie_rps => "AAAAA",
          :status_rps => "N",
          :valor_servicos => "10.00",
          :aliquota_servicos => "0.05",
          :tributacao_rps => "T",
          :numero_rps => "2",
          :cpf_tomador => "99999999999",
          :codigo_servico => "99999",
          :discriminacao => ""
        }]
      })

**ConsultaNFe**

      response = gateway.consulta_nfe({
        cnpj_remetente: "99999999999999",
        inscricao_prestador: "99999999",
        numero_nfe: "9"
      })

      response = gateway.consulta_nfe({
        cnpj_remetente: "99999999999999",
        numero_rps: "9",
        serie_rps: "AAAAA"
      })

**ConsultaNFeRecebidas**

      response = gateway.consulta_nfe_recebidas({
        cnpj_remetente: "99999999999999",
        cnpj: "99999999999999",
        data_inicio: "AAAA-MM-DD",
        data_fim: "AAAA-MM-DD",
        inscricao: "99999999"
      })


**ConsultaNFeEmitidas**

      response = gateway.consulta_nfe_emitidas({
        cnpj_remetente: "99999999999999",
        cnpj: "99999999999999",
        data_inicio: "AAAA-MM-DD",
        data_fim: "AAAA-MM-DD",
        inscricao: "99999999"
      })

**ConsultaLote**

      response = gateway.consulta_lote({
        :cnpj_remetente => "99999999999999",
        :numero_lote => "9"
      })

**ConsultaInformacoesLote**

      response = gateway.consulta_informacoes_lote({
        :cnpj_remetente => "99999999999999",
        :inscricao_prestador => "99999999",
        :numero_lote => "9"
      })

**CancelamentoNFe**

      response = gateway.cancelamento_nfe({
        cnpj_remetente: "99999999999999",
        inscricao_prestador: "99999999",
        numero_nfe: "9"
      })

**ConsultaCNPJ**

      response = gateway.consulta_cnpj({
        cnpj_remetente: "99999999999999",
        cnpj_contribuinte: "99999999999999"
      })
