# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'liquid_assets/version'

Gem::Specification.new do |spec|
    spec.name          = "liquid_assets"
    spec.version       = LiquidAssets::VERSION
    spec.authors       = ["Nathan Stitt"]
    spec.email         = ["nathan@stitt.org"]
    spec.description   = %q{A rails engine that supports writing both server and client side templates in Liqud markup}
    spec.summary       = %q{Liquid formmated views and assets}
    spec.homepage      = "http://github.com/nathanstitt/liquid_assets"
    spec.license       = "MIT"

    spec.files         = `git ls-files`.split($/)
    spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
    spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
    spec.require_paths = ["lib"]

    spec.add_dependency 'liquid'
    spec.add_dependency 'tilt'
    spec.add_dependency 'execjs'
    spec.add_dependency 'sprockets'
    spec.add_dependency 'actionpack', '>=3.2'

    spec.add_development_dependency "bundler", "~> 1.3"
    spec.add_development_dependency "rake"
end
