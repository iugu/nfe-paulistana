# frozen_string_literal: true

require_relative '../../test_helper'

describe 'Envio RPS' do
  before do
    @nfe = NfePaulistana::Gateway.new(
      ssl_cert_p12_path: ENV.fetch('NFE_CERT_P12_PATH', nil),
      ssl_cert_pass: ENV.fetch('NFE_CERT_PASS', nil)
    )
  end

  it 'should create the NFs-e' do
    response = @nfe.envio_rps({
                                cnpj_remetente: ENV.fetch('NFE_CNPJ', nil),
                                inscricao_prestador: ENV.fetch('NFE_IM', nil),
                                aliquota_servicos: ENV.fetch('NFE_ALIQUOTA', nil),
                                data_emissao: Time.now.to_date.strftime,
                                discriminacao: 'Teste NFS-e',
                                codigo_servico: ENV.fetch('NFE_COD_SERVICO', nil),
                                valor_servicos: '100.00',
                                tributacao_rps: 'T',
                                status_rps: 'N',
                                tipo_rps: 'RPS',
                                serie_rps: 'AAAAA',
                                numero_rps: Time.now.to_i.to_s,
                                email_tomador: ENV.fetch('NFE_EMAIL', nil),
                                cpf_tomador: ENV.fetch('NFE_CPF', nil)
                              })
    assert response.success? == true
  end
end
