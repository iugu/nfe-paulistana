Nota Fiscal Paulistana
======================

Forked from: https://github.com/iugu/nfe-paulistana

Instanciando o Gateway
----------------------

    gateway = NfePaulistana::Gateway.new(ssl_cert_p12_path: "path/to/certificate.(p12 ou pfx)", ssl_cert_pass: "password")

    ****OBS:** pfx and p12 is same files, you don't need convert.

Use Savon (And HTTPI as HTTP interface)
---------------------------------------

If you experience trouble with the HTTPI cURL adapter:
HTTPI.adapter = :net_http

Install certificate chain
-------------------------

Dont forget to check if you have ca chain installed.
More info: https://help.ubuntu.com/community/OpenSSL

Metodos
-------

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
        cnpj_remetente: "",
        cnpj: "38240036000115",
        data_inicio: "2022-11-01",
        data_fim: "2022-11-30",
        inscricao: ""
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

**ConsultaCNPJ Todas Notas Recebidas Período**

    response = gateway.consulta_nfe_recebidas_todas({
        cnpj_remetente: "99999999999999",
        cnpj_contribuinte: "99999999999999"
      })
 ****OBS:** Cadas página é colocada numa posição no objeto do tipo array que poderá ser manipulado como array ou convertido para Hash. Exemplo h = response[0].to_h


**Exemplo Arquivo .env**
CERT_PATH="Cert.pfx"
CERT_PASS="password"
CNPJ_REMETENTE=""
CNPJ=""
DATA_INICIO=""
DATA_FIM=""

**Carregar as variáveis de ambiente**
export $(cat ./.env | grep -v ^# | xargs) >/dev/null

**Teste de Busca Todas Notas por período**
rspec spec/lib/nfe_paulistana/nfe_recebidas.rb 

