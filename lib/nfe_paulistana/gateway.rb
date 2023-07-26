# frozen_string_literal: true

require 'savon'

module NfePaulistana
  class Gateway
    METHODS = {
      envio_rps: 'EnvioRPSRequest',
      envio_lote_rps: 'EnvioLoteRPSRequest',
      teste_envio_lote_rps: 'TesteEnvioLoteRPSRequest',
      cancelamento_n_fe: 'CancelamentoNFeRequest',
      consulta_cnpj: 'ConsultaCNPJRequest',
      consulta_n_fe: 'ConsultaNFeRequest',
      consulta_n_fe_recebidas: 'ConsultaNFeRecebidasRequest',
      consulta_n_fe_emitidas: 'ConsultaNFeEmitidasRequest',
      consulta_lote: 'ConsultaLoteRequest',
      consulta_informacoes_lote: 'ConsultaInformacoesLoteRequest'
    }.freeze

    def initialize(ssl_cert_p12_path, ssl_cert_pass)
      @connection = NfePaulistana::Connection.new(ssl_cert_p12_path, ssl_cert_pass)
    end

    def envio_rps(data = {})
      request(:envio_rps, data)
    end

    def envio_lote_rps(data = {})
      request(:envio_lote_rps, data)
    end

    def teste_envio_lote_rps(data = {})
      request(:teste_envio_lote_rps, data)
    end

    def cancelamento_nfe(data = {})
      request(:cancelamento_n_fe, data)
    end

    def consulta_nfe(data = {})
      request(:consulta_n_fe, data)
    end

    def consulta_nfe_recebidas(data = {})
      request(:consulta_n_fe_recebidas, data)
    end

    def consulta_nfe_recebidas_todas(data = {})
      resposta = []
      pagina = 1
      loop do
        data[:pagina] = pagina
        resposta << request(:consulta_n_fe_recebidas, data).retorno
        pagina += 1
        break unless resposta.last.include?(:n_fe)
      end
      resposta
    end

    def consulta_nfe_emitidas(data = {})
      request(:consulta_n_fe_emitidas, data)
    end

    def consulta_lote(data = {})
      request(:consulta_lote, data)
    end

    def consulta_informacoes_lote(data = {})
      request(:consulta_informacoes_lote, data)
    end

    def consulta_cnpj(data = {})
      request(:consulta_cnpj, data)
    end

    private

    def request(method, data = {})
      response = @connection.client.call(method, message: XmlBuilder.new.xml_for(method, data, @connection.certificate))
      method_response = "#{method}_response".to_sym
      Response.new(xml: response.body[method_response][:retorno_xml], method:).retorno
    rescue Savon::Error => e
      e
    end
  end
end
