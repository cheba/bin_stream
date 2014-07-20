# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bin_stream/version'

Gem::Specification.new do |spec|
  spec.name          = "bin_stream"
  spec.version       = BinStream::VERSION
  spec.authors       = ["Alexander Mankuta"]
  spec.email         = ["alex@pointlessone.org"]
  spec.summary       = %q{Binary streams convenience reader and writer}
  spec.description   = %q{Reader let's you easily read common data types from stream. Such as uint32 or int16 or many others. Writers provides a simple API to serialize and write those data types to stream.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "yard", "~> 0.8.7"
  spec.add_development_dependency "yardstick", "~> 0.9.9"
end
