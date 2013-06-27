# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "lolsoap"
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jon Leighton"]
  s.date = "2013-06-27"
  s.description = "A library for dealing with SOAP requests and responses. We tear our hair out so you don't have to."
  s.email = "j@jonathanleighton.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".travis.yml",
    ".yardopts",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/lolsoap.rb",
    "lib/lolsoap/builder.rb",
    "lib/lolsoap/client.rb",
    "lib/lolsoap/envelope.rb",
    "lib/lolsoap/errors.rb",
    "lib/lolsoap/fault.rb",
    "lib/lolsoap/hash_builder.rb",
    "lib/lolsoap/request.rb",
    "lib/lolsoap/response.rb",
    "lib/lolsoap/wsdl.rb",
    "lib/lolsoap/wsdl/element.rb",
    "lib/lolsoap/wsdl/immediate_type_reference.rb",
    "lib/lolsoap/wsdl/named_type_reference.rb",
    "lib/lolsoap/wsdl/null_element.rb",
    "lib/lolsoap/wsdl/null_type.rb",
    "lib/lolsoap/wsdl/operation.rb",
    "lib/lolsoap/wsdl/type.rb",
    "lib/lolsoap/wsdl_parser.rb",
    "lolsoap.gemspec",
    "test/fixtures/stock_quote.wsdl",
    "test/fixtures/stock_quote_fault.xml",
    "test/fixtures/stock_quote_fault_soap_1_1.xml",
    "test/fixtures/stock_quote_response.xml",
    "test/helper.rb",
    "test/integration/test_client.rb",
    "test/integration/test_envelope.rb",
    "test/integration/test_request.rb",
    "test/integration/test_response.rb",
    "test/integration/test_wsdl.rb",
    "test/unit/test_builder.rb",
    "test/unit/test_client.rb",
    "test/unit/test_envelope.rb",
    "test/unit/test_fault.rb",
    "test/unit/test_hash_builder.rb",
    "test/unit/test_request.rb",
    "test/unit/test_response.rb",
    "test/unit/test_wsdl.rb",
    "test/unit/test_wsdl_parser.rb",
    "test/unit/wsdl/test_element.rb",
    "test/unit/wsdl/test_type.rb"
  ]
  s.homepage = "http://github.com/loco2/lolsoap"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "A library for dealing with SOAP requests and responses."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.5.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.5.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.5.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end

