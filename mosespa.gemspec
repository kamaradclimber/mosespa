# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "mosespa"
  s.version     = '0.0.2'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Grégoire Seux"]
  s.summary     = %q{Play on command line with JIRA}
  s.homepage    = "http://github.com/kamaradclimber/mosespa"
  s.description = %q{}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/{functional,unit}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  #s.require_paths = ["lib"]

  s.add_dependency "jira-ruby"
  s.add_dependency 'trollop'
  s.add_dependency 'colorize'
end
