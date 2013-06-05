# encoding: UTF-8

require "nfe-paulistana/version"
require "nfe-paulistana/xml_builder"
require "nfe-paulistana/response"
require "nfe-paulistana/gateway"
require "signer"
require "savon"

module NfePaulistana
  WSDL = 'https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx?wsdl'
  Savon.configure do |config|
    config.soap_version = 2
  end
  Savon.env_namespace = :soap

  def self.enviar(data = {})
    certificado = OpenSSL::PKCS12.new(File.read(data[:cert_path]), data[:cert_pass]) 
    client = get_client(certificado)

    begin
      response = client.request(:envio_rps) do |soap|
        soap.input = [ 
            "EnvioRPSRequest", 
              {"xmlns" => "http://www.prefeitura.sp.gov.br/nfe"}
        ]

        soap.body = XmlBuilder.new.xml_for(:envio_rps, data, certificado)

        soap.version = 2
      end
      Response.new(xml: response.to_hash[:envio_rps_response][:retorno_xml], method: :envio_rps_response)
    rescue Savon::Error => error
    end
  end

  private

  def get_client(certificado)
    client = Savon::Client.new do |wsdl, http|
      wsdl.document = WSDL
      # http.auth.ssl.cert_key_file = "/Users/patricknegri/Desenvolvimento/Certificado-Iugu-Chave.pem"
      # http.auth.ssl.cert_file = "/Users/patricknegri/Desenvolvimento/Certificado-Iugu.pem"
      http.auth.ssl.cert_key = certificado.key
      http.auth.ssl.cert = certificado.certificate
      http.auth.ssl.verify_mode = :peer

      # http.ssl_client_auth( :cert => @certificado, :key => @certificado.key, :verify_mode => OpenSSL::SSL::VERIFY_NONE )
      # http.auth.ssl.cert = @certificado
      # http.auth.ssl.key = @certificado.key
      # http.auth.ssl.verify_mode = :none
    end
  end

end
