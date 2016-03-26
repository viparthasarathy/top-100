# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'top_100/version'

Gem::Specification.new do |spec|
  spec.name          = "top_100"
  spec.version       = Top100::VERSION
  spec.authors       = ["viparthasarathy"]
  spec.email         = ["viparthasarathy@gmail.com"]
  spec.summary       = %q{A CLI gem that allows the user to acquire information about trending songs and artists.}
  spec.homepage      = "https://github.com/viparthasarathy/top-100"
  spec.executables   = ["top_100"]


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.require_paths = ["lib", "lib/top_100"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "nokogiri"
end
