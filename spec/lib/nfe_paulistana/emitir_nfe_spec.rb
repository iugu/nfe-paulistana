# testar uma emissao de nota fiscal paulistana
require 'bundler/setup'
require 'nfe_paulistana'
require 'byebug'
require 'dotenv'
Dotenv.load
describe 'NFE' do
  describe 'Emissão de nota fiscal' do
    before(:each) do
      @gateway = NfePaulistana::Gateway.new(ENV['CERT_PATH'], ENV['CERT_PASS'])
    end
    it 'has some behaviour' do
      response = @gateway.envio_rps(
        {
          cnpj_remetente: '38240036000204',
          inscricao_prestador: '77764684',
          data_emissao: '2023-07-27',
          email_tomador: 'rafael.rosa@cuidar.me',
          tipo_rps: 'RPS',
          serie_rps: '00001',
          status_rps: 'N',
          valor_servicos: '500.00',
          aliquota_servicos: '0.02',
          tributacao_rps: 'T',
          numero_rps: '3',
          cpf_tomador: '40304247839',
          codigo_servico: '05274',
          discriminacao: 'Teste via API'
        }
      )
      byebug
      response = gateway.cancelamento_nfe({
        cnpj_remetente: "99999999999999",
        inscricao_prestador: "99999999",
        numero_nfe: "9"
      })

      response = @gateway.cancelamento_nfe({
                                         cnpj_remetente: '38240036000204',
                                         inscricao_prestador: '77764684',
                                         numero_nfe: '1'
                                       })
      byebug
    end
  end
end
