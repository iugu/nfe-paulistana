require 'spec_helper'
describe 'NFE' do
  describe '#nfe_consulta' do
    before(:each) do
      @gateway = NfePaulistana::Gateway.new(ENV['CERT_PATH'], ENV['CERT_PASS'])
    end

    it 'returns nfe_recebidas total' do
      VCR.use_cassette('nfe_recebidas') do
        response = @gateway.consulta_nfe_recebidas(
          {
            cnpj_remetente: ENV['CNPJ'],
            cnpj: ENV['CNPJ'],
            data_inicio: '2023-07-01',
            data_fim: '2023-07-30',
            inscricao: '77764684'
          }
        )
        expect(response.retorno[:cabecalho][:sucesso]).to eq(true)
      end
    end
    it 'busca as notas fiscais emitidas' do
      VCR.use_cassette('nfe_emitidas') do
        response = @gateway.consulta_nfe_emitidas(
          {
            cnpj_remetente: ENV['CNPJ'],
            cnpj: ENV['CNPJ'],
            data_inicio: '2023-08-01',
            data_fim: '2023-08-07',
            inscricao: '77764684'
          }
        )
        expect(response.retorno[:cabecalho][:sucesso]).to eq(true)
      end
    end
  end
end
