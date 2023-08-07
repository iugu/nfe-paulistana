# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'nfe_paulistana/version'

Gem::Specification.new do |s|
  s.name        = 'nfe_paulistana'
  s.version     = NfePaulistana::VERSION
  s.authors     = ['Sidedoor { }', 'Rafael Rosa - Sidedoor { }']
  s.email       = ['rafael@sidedoor.com.br']
  s.homepage    = 'https://sidedoor.com.br'
  s.summary     = 'Nota Fiscal de Serviço Eletronica'
  s.description = 'Gema para utilização do Webservice da Nf Paulistana'

  s.rubyforge_project = 'nfe_paulistana'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'nokogiri', '>= 1.9.1'
  s.add_dependency 'savon', '>= 2.12'
  s.add_dependency 'signer'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'dotenv', '~> 2.5'
  s.add_development_dependency 'net-smtp'
  s.add_development_dependency 'pry-nav'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.metadata['rubygems_mfa_required'] = 'true'
end
