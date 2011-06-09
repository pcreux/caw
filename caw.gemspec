# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "caw/version"

Gem::Specification.new do |s|
  s.name        = "caw"
  s.version     = Caw::VERSION
  s.authors     = ["Philippe Creux"]
  s.email       = ["pcreux@gmail.com"]
  s.homepage    = "https://github.com/pcreux/caw"
  s.summary     = %q{Read your Twitter timeline aloud}
  s.description = %q{Caw reads aloud your Twitter timeline.}

  s.default_executable = %q{caw}

  s.add_dependency 'twitter', '>=1.5.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
