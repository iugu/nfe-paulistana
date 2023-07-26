# frozen_string_literal: true

# module for create client savon to use all gem
module NfePaulistana
  # class connection for use self for instance of directly client
  class Connection
    attr_reader :certificate

    def initialize(ssl_cert_p12_path, ssl_cert_pass, wsdl = NfePaulistana::WSDL)
      @ssl_cert_p12_path = ssl_cert_p12_path
      @ssl_cert_pass = ssl_cert_pass
      @certificate = OpenSSL::PKCS12.new(File.binread(ssl_cert_p12_path), ssl_cert_pass)
      @wsdl = wsdl
    end

    def client
      pkcs = @certificate
      cert = Tempfile.new
      cert << pkcs.certificate.to_pem
      cert.flush

      key = Tempfile.new
      key << pkcs.key.to_pem
      key.flush
      soap_client(cert, key)
    end

    private

    def soap_client(cert, key)
      Savon.client(
        env_namespace: :soap, ssl_verify_mode: :peer,
        ssl_cert_file: cert.path, ssl_cert_key_file: key.path, ssl_cert_key_password: @ssl_cert_pass,
        wsdl: @wsdl, namespace_identifier: nil
      )
    end
  end
end
