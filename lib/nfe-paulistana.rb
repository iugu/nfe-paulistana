# encoding: UTF-8

require "nfe-paulistana/version"
require "nfe-paulistana/xml_builder"
require "nfe-paulistana/response"
require "nfe-paulistana/gateway"
require "signer"
require "savon"

module NfePaulistana
  WSDL = 'https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx?wsdl'

  def self.enviar(data = {})
    certificado = OpenSSL::PKCS12.new(File.read(data[:cert_path]), data[:cert_pass]) 
    client = get_client(certificado)

    begin
      response = client.call(:envio_rps, message: {
        input: [ 
            "EnvioRPSRequest", 
              {"xmlns" => "http://www.prefeitura.sp.gov.br/nfe"}
        ],
        body: XmlBuilder.new.xml_for(:envio_rps, data, certificado),
        version: 2
      })
      Response.new(xml: response.hash[:envio_rps_response][:retorno_xml], method: :envio_rps_response)
    rescue Savon::Error => error
      error
    end
  end

  private

  def get_client(certificado)
    Savon.client(soap_version: 2, env_namespace: :soap, ssl_verify_mode: :peer, ssl_cert_file: certificado.certificate, ssl_cert_key_file: certificado.key, wsdl: WSDL)
  end

end
