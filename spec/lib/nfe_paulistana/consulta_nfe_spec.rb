require 'bundler/setup'
require 'nfe_paulistana'
require 'byebug'
require 'dotenv'

Dotenv.load
describe 'NFE' do
  describe '#nfe_consulta' do
    before(:each) do
      @gateway = NfePaulistana::Gateway.new(ENV['CERT_PATH'], ENV['CERT_PASS'])
    end

    it 'returns nfe_recebidas total' do
      response = @gateway.consulta_nfe_recebidas({
                                                   cnpj_remetente: '',

                                                   cnpj: '38240036000204',
                                                   data_inicio: '2022-11-01',
                                                   data_fim: '2022-11-30',
                                                   inscricao: '77764684'
                                                 })

      byebug
      expect(response[:n_fe].last.keys).to include(:chave_n_fe)
    end
  end
end
