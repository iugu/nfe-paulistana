require 'savon'

module NfePaulistana
  class Gateway

    METHODS = {
      envio_rps: "EnvioRPSRequest",
      envio_lote_rps: "EnvioLoteRPSRequest",
      teste_envio_lote_rps: "TesteEnvioLoteRPSRequest",
      cancelamento_n_fe: "CancelamentoNFeRequest",
      consulta_cnpj: "ConsultaCNPJRequest",
      consulta_n_fe: "ConsultaNFeRequest",
      consulta_n_fe_recebidas: "ConsultaNFeRecebidasRequest",
      consulta_n_fe_emitidas: "ConsultaNFeEmitidasRequest",
      consulta_lote: "ConsultaLoteRequest",
      consulta_informacoes_lote: "ConsultaInformacoesLoteRequest"
    }

    def initialize(options = {})
      @options = {
        ssl_cert_p12_path: "",
        ssl_cert_path: "",
        ssl_key_path: "",
        ssl_cert_pass: "",
        wsdl: 'https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx?wsdl'
      }.merge(options)
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

    def certificate
      OpenSSL::PKCS12.new(File.read(@options[:ssl_cert_p12_path]), @options[:ssl_cert_pass])
    end

    def request(method, data = {})
      response = client.call(method, message: XmlBuilder.new.xml_for(method, data, certificate))
      method_response = (method.to_s + "_response").to_sym
      Response.new(xml: response.hash[:envelope][:body][method_response][:retorno_xml], method: method)
    rescue Savon::Error => error
    end

    def client
      Savon.client(
        soap_version: 2,
        env_namespace: :soap,
        ssl_verify_mode: :peer,
        ssl_cert_file: @options[:ssl_cert_path],
        ssl_cert_key_file: @options[:ssl_key_path],
        ssl_cert_key_password: @options[:ssl_cert_pass],
        wsdl: @options[:wsdl],
        namespace_identifier: nil
      )
    end
  end
end
