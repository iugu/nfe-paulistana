# frozen_string_literal: true

require 'nfe_paulistana/version'
require 'nfe_paulistana/xml_builder'
require 'nfe_paulistana/response'
require 'nfe_paulistana/gateway'
require 'nfe_paulistana/connection'
require 'signer'
require 'savon'
require 'byebug'
# gem for working invoiuces in city São Paulo
module NfePaulistana
  WSDL = 'https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx?wsdl'
  def self.enviar(data = {})
    connection = NfePaulistana::Connection.new(data[:cert_path], data[:cert_pass])

    begin
      response = connection.client.call(
        :envio_rps, message: { input: ['EnvioRPSRequest', { 'xmlns' => 'http://www.prefeitura.sp.gov.br/nfe' }],
                               body: XmlBuilder.new.xml_for(:envio_rps, data, connection.certificate), version: 2 }
      )
      Response.new(xml: response.hash[:envio_rps_response][:retorno_xml], method: :envio_rps_response)
    rescue Savon::Error => e
      e
    end
  end
end
