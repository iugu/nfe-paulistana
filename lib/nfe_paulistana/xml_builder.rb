# frozen_string_literal: true

module NfePaulistana
  class XmlBuilder
    METHODS = {
      envio_rps: 'PedidoEnvioRPS',
      envio_lote_rps: 'PedidoEnvioLoteRPS',
      teste_envio_lote_rps: 'PedidoEnvioLoteRPS',
      cancelamento_n_fe: 'PedidoCancelamentoNFe',
      consulta_n_fe: 'PedidoConsultaNFe',
      consulta_n_fe_recebidas: 'PedidoConsultaNFePeriodo',
      consulta_n_fe_emitidas: 'PedidoConsultaNFePeriodo',
      consulta_lote: 'PedidoConsultaLote',
      consulta_informacoes_lote: 'PedidoInformacoesLote',
      consulta_cnpj: 'PedidoConsultaCNPJ'
    }.freeze

    DEFAULT_DATA = {
      cpf_remetente: '',
      cnpj_remetente: '',
      inscricao_prestador: '',
      serie_rps: '',
      numero_rps: '',
      tipo_rps: '',
      data_emissao: '',
      status_rps: '',
      tributacao_rps: '',
      valor_servicos: '0',
      valor_deducoes: '0',
      valor_pis: '0',
      valor_cofins: '0',
      valor_inss: '0',
      valor_ir: '0',
      valor_csll: '0',
      codigo_servico: '0',
      aliquota_servicos: '0',
      iss_retido: false,
      cpf_tomador: '',
      cnpj_tomador: '',
      iss_retido_intermediario: false,
      cpf_intermediario: '',
      cnpj_intermediario: '',
      im_tomador: '',
      ie_tomador: '',
      im_intermediario: '',
      razao_tomador: '',
      tp_logradouro: '',
      logradouro: '',
      nr_endereco: '',
      compl_endereco: '',
      bairro: '',
      cidade: '',
      uf: '',
      cep: '',
      email_tomador: '',
      email_intermediario: '',
      discriminacao: '',
      wsdl: NfePaulistana::WSDL
    }.freeze

    def xml_for(method, data, certificado)
      data = DEFAULT_DATA.merge(data)
      "<VersaoSchema>1</VersaoSchema><MensagemXML>#{assinar(xml(method, data, certificado), certificado).gsub('&', '&amp;').gsub('>', '&gt;').gsub('<', '&lt;').gsub('"', '&quot;').gsub("'", '&apos;')}</MensagemXML>".gsub(
        /\n/, ''
      )
    end

    private

    def xml(method, data, certificado)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.send(METHODS[method], 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                                  'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema', 'xmlns' => 'http://www.prefeitura.sp.gov.br/nfe') do
          xml.Cabecalho('Versao' => '1', :xmlns => '') do
            xml.CPFCNPJRemetente do
              xml.CPF data[:cpf_remetente] unless data[:cpf_remetente].blank?
              xml.CNPJ data[:cnpj_remetente] unless data[:cnpj_remetente].blank?
            end
            send("add_#{method}_cabecalho_data_to_xml", xml, data, certificado)
          end
          send("add_#{method}_data_to_xml", xml, data, certificado)
        end
      end
      Nokogiri::XML(builder.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION))
    end

    def add_cancelamento_n_fe_cabecalho_data_to_xml(xml, data, _certificado)
      xml.transacao data[:transacao] || true
    end

    def add_envio_rps_cabecalho_data_to_xml(xml, data, certificado); end

    def add_envio_lote_rps_cabecalho_data_to_xml(xml, data, certificado)
      add_lote_cabecalho_data_to_xml(xml, data, certificado)
    end

    def add_teste_envio_lote_rps_cabecalho_data_to_xml(xml, data, certificado)
      add_lote_cabecalho_data_to_xml(xml, data, certificado)
    end

    def add_lote_cabecalho_data_to_xml(xml, data, _certificado)
      xml.transacao data[:transacao] || true
      xml.dtInicio data[:data_inicio]
      xml.dtFim data[:data_fim]
      xml.QtdRPS data[:qtd_rps]
      xml.ValorTotalServicos data[:valor_total_servicos]
      xml.ValorTotalDeducoes data[:valor_total_deducoes]
    end

    def add_consulta_cnpj_cabecalho_data_to_xml(xml, data, certificado); end

    def add_consulta_n_fe_cabecalho_data_to_xml(xml, data, certificado); end

    def add_consulta_n_fe_recebidas_cabecalho_data_to_xml(xml, data, certificado)
      add_consulta_n_fe_periodo_cabecalho_data_to_xml(xml, data, certificado)
    end

    def add_consulta_n_fe_emitidas_cabecalho_data_to_xml(xml, data, certificado)
      add_consulta_n_fe_periodo_cabecalho_data_to_xml(xml, data, certificado)
    end

    def add_consulta_n_fe_periodo_cabecalho_data_to_xml(xml, data, _certificado)
      unless data[:cpf].blank? && data[:cnpj].blank?
        xml.CPFCNPJ do
          xml.CPF data[:cpf] unless data[:cpf].blank?
          xml.CNPJ data[:cnpj] unless data[:cnpj].blank?
        end
      end
      xml.Inscricao data[:inscricao] unless data[:inscricao].blank?
      xml.dtInicio data[:data_inicio]
      xml.dtFim data[:data_fim]
      xml.NumeroPagina data[:pagina] || 1
    end

    def add_consulta_lote_cabecalho_data_to_xml(xml, data, _certificado)
      xml.NumeroLote data[:numero_lote]
    end

    def add_consulta_informacoes_lote_cabecalho_data_to_xml(xml, data, _certificado)
      xml.NumeroLote data[:numero_lote]
      xml.InscricaoPrestador data[:inscricao_prestador]
    end

    def add_consulta_n_fe_recebidas_data_to_xml(xml, data, certificado); end

    def add_consulta_n_fe_emitidas_data_to_xml(xml, data, certificado); end

    def add_consulta_n_fe_data_to_xml(xml, data, _certificado)
      xml.Detalhe(xmlns: '') do
        add_chave_rps_to_xml(xml, data) if !data[:numero_rps].blank? && !data[:serie_rps].blank?
        add_chave_nfe_to_xml(xml, data) if data[:numero_nfe]
      end
    end

    def add_consulta_cnpj_data_to_xml(xml, data, _certificado)
      xml.CNPJContribuinte(xmlns: '') do
        xml.CNPJ data[:cnpj_contribuinte]
      end
    end

    def add_cancelamento_n_fe_data_to_xml(xml, data, certificado)
      xml.Detalhe(xmlns: '') do
        add_chave_nfe_to_xml(xml, data)
        xml.AssinaturaCancelamento assinatura_cancelamento_n_fe(data, certificado)
      end
    end

    def add_envio_rps_data_to_xml(xml, data, certificado)
      add_rps_to_xml(xml, data, certificado)
    end

    def add_envio_lote_rps_data_to_xml(xml, data, certificado)
      add_lote_rps_data_to_xml(xml, data, certificado)
    end

    def add_teste_envio_lote_rps_data_to_xml(xml, data, certificado)
      add_lote_rps_data_to_xml(xml, data, certificado)
    end

    def add_lote_rps_data_to_xml(xml, data, certificado)
      data[:lote_rps].each do |rps|
        add_rps_to_xml(xml, rps, certificado)
      end
    end

    def add_consulta_lote_data_to_xml(xml, data, certificado); end

    def add_consulta_informacoes_lote_data_to_xml(xml, data, certificado); end

    def add_chave_nfe_to_xml(xml, data)
      xml.ChaveNFe do
        xml.InscricaoPrestador data[:inscricao_prestador]
        xml.NumeroNFe data[:numero_nfe]
      end
    end

    def add_chave_rps_to_xml(xml, data)
      xml.ChaveRPS do
        xml.InscricaoPrestador data[:inscricao_prestador]
        xml.SerieRPS data[:serie_rps] unless data[:serie_rps].blank?
        xml.NumeroRPS data[:numero_rps] unless data[:numero_rps].blank?
      end
    end

    def add_rps_to_xml(xml, data, certificado)
      data = DEFAULT_DATA.merge(data)
      xml.RPS(xmlns: '') do
        xml.Assinatura assinatura_envio_rps(data, certificado)
        add_chave_rps_to_xml(xml, data)
        xml.TipoRPS data[:tipo_rps]
        xml.DataEmissao data[:data_emissao]
        xml.StatusRPS data[:status_rps]
        xml.TributacaoRPS data[:tributacao_rps]
        xml.ValorServicos data[:valor_servicos]
        xml.ValorDeducoes data[:valor_deducoes]
        xml.ValorPIS data[:valor_pis] if data[:valor_pis] != '0'
        xml.ValorCOFINS data[:valor_cofins] if data[:valor_cofins] != '0'
        xml.ValorINSS data[:valor_inss] if data[:valor_inss] != '0'
        xml.ValorIR data[:valor_ir] if data[:valor_ir] != '0'
        xml.ValorCSLL data[:valor_csll] if data[:valor_csll] != '0'
        xml.CodigoServico data[:codigo_servico]
        xml.AliquotaServicos data[:aliquota_servicos]
        xml.ISSRetido data[:iss_retido]
        unless data[:cpf_tomador].blank? && data[:cnpj_tomador].blank?
          xml.CPFCNPJTomador do
            xml.CPF data[:cpf_tomador] unless data[:cpf_tomador].blank?
            xml.CNPJ data[:cnpj_tomador] unless data[:cnpj_tomador].blank?
          end
        end
        xml.InscricaoMunicipalTomador data[:im_tomador] unless data[:im_tomador].blank?
        xml.InscricaoEstadualTomador data[:ie_tomador] unless data[:ie_tomador].blank?
        xml.RazaoSocialTomador data[:razao_tomador] unless data[:razao_tomador].blank?
        unless data[:tp_logradouro].blank? && data[:logradouro].blank? && data[:nr_endereco] && data[:compl_endereco]
          xml.EnderecoTomador do
            xml.TipoLogradouro data[:tp_logradouro]
            xml.Logradouro data[:logradouro]
            xml.NumeroEndereco data[:nr_endereco]
            xml.ComplementoEndereco data[:compl_endereco]
            xml.Bairro data[:bairro] unless data[:bairro].blank?
            xml.Cidade data[:cidade] unless data[:cidade].blank?
            xml.UF data[:uf] unless data[:uf]
            xml.CEP data[:cep] unless data[:cep]
          end
        end
        xml.EmailTomador data[:email_tomador]
        #         unless (data[:cpf_intermediario].blank? and data[:cnpj_intermediario].blank?)
        #           xml.CPFCNPJIntermediario {
        #             xml.CPF data[:cpf_intermediario] unless data[:cpf_intermediario].blank?
        #             xml.CNPJ data[:cnpj_intermediario] unless data[:cnpj_intermediario].blank?
        #           }
        #           xml.InscricaoMunicipalIntermediario data[:im_intermediario] unless data[:im_intermediario].blank?
        #           xml.ISSRetidoIntermediario data[:iss_retido_intermediario]
        #           xml.EmailIntermediario data[:email_intermediario]
        #         end
        xml.Discriminacao data[:discriminacao]
      end
    end

    def assinar(xml, certificado)
      xml = Nokogiri::XML(xml.to_s, &:noblanks)

      # 1. Digest Hash for all XML
      xml_canon = xml.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
      xml_digest = Base64.encode64(OpenSSL::Digest::SHA1.digest(xml_canon)).strip

      # 2. Add Signature Node
      signature = xml.xpath('//ds:Signature', 'ds' => 'http://www.w3.org/2000/09/xmldsig#').first
      unless signature
        signature = Nokogiri::XML::Node.new('Signature', xml)
        signature.default_namespace = 'http://www.w3.org/2000/09/xmldsig#'
        xml.root.add_child(signature)
      end

      # 3. Add Elements to Signature Node

      # 3.1 Create Signature Info
      signature_info = Nokogiri::XML::Node.new('SignedInfo', xml)

      # 3.2 Add CanonicalizationMethod
      child_node = Nokogiri::XML::Node.new('CanonicalizationMethod', xml)
      child_node['Algorithm'] = 'http://www.w3.org/2001/10/xml-exc-c14n#'
      signature_info.add_child child_node

      # 3.3 Add SignatureMethod
      child_node = Nokogiri::XML::Node.new('SignatureMethod', xml)
      child_node['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#rsa-sha1'
      signature_info.add_child child_node

      # 3.4 Create Reference
      reference = Nokogiri::XML::Node.new('Reference', xml)
      reference['URI'] = ''

      # 3.5 Add Transforms
      transforms = Nokogiri::XML::Node.new('Transforms', xml)

      child_node = Nokogiri::XML::Node.new('Transform', xml)
      child_node['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#enveloped-signature'
      transforms.add_child child_node

      child_node = Nokogiri::XML::Node.new('Transform', xml)
      child_node['Algorithm'] = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
      transforms.add_child child_node

      reference.add_child transforms

      # 3.6 Add Digest
      child_node = Nokogiri::XML::Node.new('DigestMethod', xml)
      child_node['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#sha1'
      reference.add_child child_node

      # 3.6 Add DigestValue
      child_node = Nokogiri::XML::Node.new('DigestValue', xml)
      child_node.content = xml_digest
      reference.add_child child_node

      # 3.7 Add Reference and Signature Info
      signature_info.add_child reference
      signature.add_child signature_info

      # 4 Sign Signature
      sign_canon = signature_info.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
      signature_hash = certificado.key.sign(OpenSSL::Digest.new('SHA1'), sign_canon)
      signature_value = Base64.encode64(signature_hash).gsub("\n", '')

      # 4.1 Add SignatureValue
      child_node = Nokogiri::XML::Node.new('SignatureValue', xml)
      child_node.content = signature_value
      signature.add_child child_node

      # 5 Create KeyInfo
      key_info = Nokogiri::XML::Node.new('KeyInfo', xml)

      # 5.1 Add X509 Data and Certificate
      x509_data = Nokogiri::XML::Node.new('X509Data', xml)
      x509_certificate = Nokogiri::XML::Node.new('X509Certificate', xml)
      x509_certificate.content = certificado.certificate.to_s.gsub(/-----[A-Z]+ CERTIFICATE-----/, '').gsub(
        /\n/, ''
      )

      x509_data.add_child x509_certificate
      key_info.add_child x509_data

      # 5.2 Add KeyInfo
      signature.add_child key_info

      # 6 Add Signature
      xml.root.add_child signature

      # Return XML
      xml.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
    end

    def assinatura_cancelamento_n_fe(data, certificado)
      part1 = data[:inscricao_prestador].rjust(8, '0')
      part2 = data[:numero_nfe].rjust(12, '0')
      value = part1 + part2
      assinatura_simples(value, certificado)
    end

    def assinatura_envio_rps(data, certificado)
      part1 = data[:inscricao_prestador].rjust(8, '0')
      part2 = data[:serie_rps].ljust(5)
      part3 = data[:numero_rps].rjust(12, '0')
      part4 = data[:data_emissao].delete('-')
      part5 = data[:tributacao_rps]
      part6 = data[:status_rps]
      part7 = data[:iss_retido] ? 'S' : 'N'
      part8 = data[:valor_servicos].delete(',').delete('.').rjust(15, '0')
      part9 = data[:valor_deducoes].delete(',').delete('.').rjust(15, '0')
      part10 = data[:codigo_servico].rjust(5, '0')
      part11 = (if data[:cpf_tomador].blank?
                  data[:cnpj_tomador].blank? ? '3' : '2'
                else
                  '1'
                end)
      part12 = (if data[:cpf_tomador].blank?
                  if data[:cnpj_tomador].blank?
                    ''.rjust(14,
                             '0')
                  else
                    data[:cnpj_tomador].rjust(
                      14, '0'
                    )
                  end
                else
                  data[:cpf_tomador].rjust(14,
                                           '0')
                end)
      #       part13 = (data[:cpf_intermediario].blank? ? (data[:cnpj_intermediario].blank? ? '3' : '2') : '1')
      #       part14 = (data[:cpf_intermediario].blank? ? (data[:cnpj_intermediario].blank? ? "".rjust(14,'0') : data[:cnpj_intermediario].rjust(14,'0') ) : data[:cpf_intermediario].rjust(14,'0'))
      #       part15 = data[:iss_retido_intermediario] ? 'S' : 'N'

      # value = part1 + part2 + part3 + part4 + part5 + part6 + part7 + part8 + part9 + part10 + part11 + part12 + part13 + part14 + part15
      value = part1 + part2 + part3 + part4 + part5 + part6 + part7 + part8 + part9 + part10 + part11 + part12

      assinatura_simples(value, certificado)
    end

    def assinatura_simples(value, certificado)
      sign_hash = certificado.key.sign(OpenSSL::Digest.new('SHA1'), value)
      Base64.encode64(sign_hash).gsub("\n", '').gsub("\r", '').strip
    end
  end
end
