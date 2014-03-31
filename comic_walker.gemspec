# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'comic_walker/version'

Gem::Specification.new do |spec|
  spec.name          = "comic_walker"
  spec.version       = ComicWalker::VERSION
  spec.authors       = ["Kohei Suzuki"]
  spec.email         = ["eagletmt@gmail.com"]
  spec.summary       = %q{Client library for ComicWalker}
  spec.description   = %q{Client library for ComicWalker}
  spec.homepage      = "https://github.com/eagletmt/comic_walker"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard"
  spec.add_dependency "addressable"
  spec.add_dependency "http-cookie"
  spec.add_dependency "rmagick"
  spec.add_dependency "rubyzip"
  spec.add_dependency "thor"
end
