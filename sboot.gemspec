# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sboot/version'

Gem::Specification.new do |spec|
  spec.name          = "sboot"
  spec.version       = Sboot::VERSION
  spec.authors       = ["Simone Bierti"]
  spec.email         = ["sbierti@gmail.com"]

  spec.summary       = %q{Restful resources generator for Spring Boot}
  spec.description   = %q{Restful resources generator for Spring Boot}
  spec.homepage      = "http://localhost:3000"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "'http://mygemserver.com'"
  end

  spec.add_dependency 'thor'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'coveralls'
end
