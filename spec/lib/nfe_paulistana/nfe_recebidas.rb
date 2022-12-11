require 'bundler/setup'
require 'nfe_paulistana'

describe "NFE" do
    describe "#nfe_recebidas" do

      before(:each) do
        @gateway = NfePaulistana::Gateway.new(ENV['CERT_PATH'],ENV['CERT_PASS'])
      end

      it "returns nfe_recebidas total" do
        response = @gateway.consulta_nfe_recebidas_todas({cnpj_remetente: ENV['CNPJ_REMETENTE'],cnpj: ENV['CNPJ'], data_inicio: ENV['DATA_INICIO'], data_fim: ENV['DATA_FIM']} )
        expect(response.last).not_to include(:n_fe)
      end

    end
  end