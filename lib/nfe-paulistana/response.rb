module NfePaulistana
  class Response
    RETURN_ROOT = {
      teste_envio_lote_rps: :envio_lote_rps,
      consulta_n_fe: :consulta,
      consulta_n_fe_emitidas: :consulta,
      consulta_n_fe_recebidas: :consulta,
      consulta_lote: :consulta,
      consulta_informacoes_lote: :informacoes_lote
    }

    def initialize(options = {})
      @options = options
    end

    def xml
      @options[:xml]
    end

    def retorno
      Nori.new(convert_tags_to: ->(tag) { tag.snakecase.to_sym }).parse(xml)[
        ("retorno_" + (RETURN_ROOT[@options[:method]] || @options[:method]).to_s).to_sym
      ]
    end

    def success?
      !!retorno[:cabecalho][:sucesso]
    end

    def errors
      return unless !success?
      retorno[:alerta] || retorno[:erro]
    end
  end
end
