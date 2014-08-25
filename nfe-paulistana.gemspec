# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nfe-paulistana/version"

Gem::Specification.new do |s|
  s.name        = "nfe-paulistana"
  s.version     = NfePaulistana::VERSION
  s.authors     = ["Marcelo Paez Sequeira"]
  s.email       = ["marcelo@iugu.com"]
  s.homepage    = "https://iugu.com"
  s.summary     = %q{Notafiscal Eletronica}
  s.description = %q{Gema para utilização do Webservice da Nf Paulistana}

  s.rubyforge_project = "nfe-paulistana"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "nokogiri", "1.5.9"
  s.add_dependency "savon", "2.3.0"
  s.add_dependency "signer"
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
  s.add_development_dependency "debugger"
  # s.add_runtime_dependency "rest-client"
end
