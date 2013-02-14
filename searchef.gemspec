# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'searchef/version'

Gem::Specification.new do |gem|
  gem.name          = "searchef"
  gem.version       = Searchef::VERSION
  gem.authors       = ["Fletcher Nichol"]
  gem.email         = ["fnichol@nichol.ca"]
  gem.description   = %q{Stub Chef Search!}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/fnichol/searchef"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = []
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'chef'
  gem.add_runtime_dependency 'webmock'
  gem.add_runtime_dependency 'fauxhai'
end
