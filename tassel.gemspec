# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tassel/version'

Gem::Specification.new do |gem|
  gem.name          = "tassel"
  gem.version       = Tassel::VERSION
  gem.authors       = ["Carl Hall"]
  gem.email         = ["carl.hall@gmail.com"]
  gem.description   = %q{Tassel is a todo list and notes manager with project-style contexts.}
  gem.summary       = %q{Tassel is a todo list and notes manager with project-style contexts.}
  gem.homepage      = "http://github.com/thecarlhall/tassel"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
