# frozen_string_literal: true

require_relative '../../test_helper'

describe 'Envio RPS' do
  before do
    @nfe = NfePaulistana::Gateway.new(
      ssl_cert_p12_path: ENV['NFE_CERT_P12_PATH'],
      ssl_cert_path: ENV['NFE_CERT_PATH'],
      ssl_key_path: ENV['NFE_KEY_PATH'],
      ssl_cert_pass: ENV['NFE_CERT_PASS']
    )
  end

  it 'should create the NFs-e' do
    response = @nfe.envio_rps({
                                cnpj_remetente: ENV['NFE_CNPJ'],
                                inscricao_prestador: ENV['NFE_IM'],
                                aliquota_servicos: ENV['NFE_ALIQUOTA'],
                                data_emissao: Time.now.to_date.strftime,
                                discriminacao: 'Teste NFS-e',
                                codigo_servico: ENV['NFE_COD_SERVICO'],
                                valor_servicos: '100.00',
                                tributacao_rps: 'T',
                                status_rps: 'N',
                                tipo_rps: 'RPS',
                                serie_rps: 'AAAAA',
                                numero_rps: Time.now.to_i.to_s,
                                email_tomador: ENV['NFE_EMAIL'],
                                cpf_tomador: ENV['NFE_CPF']
                              })
    assert response.success? == true
  end
end
