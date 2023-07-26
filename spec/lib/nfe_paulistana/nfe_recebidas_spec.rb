require 'bundler/setup'
require 'nfe_paulistana'
require 'byebug'
require 'dotenv'

Dotenv.load
describe 'NFE' do
  describe '#nfe_recebidas' do
    before(:each) do
      @gateway = NfePaulistana::Gateway.new(ENV['CERT_PATH'], ENV['CERT_PASS'])
    end

    it 'returns nfe_recebidas total' do
      response = @gateway.consulta_nfe_recebidas(
        { cnpj_remetente: '38240036000115', cnpj: '38240036000115',
          data_inicio: '2022-11-01', data_fim: '2022-11-30', pagina: 10 }
      )

      expect(response[:n_fe].last.keys).to include(:chave_n_fe)
    end
  end
end
