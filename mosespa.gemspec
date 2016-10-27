# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "mosespa"
  s.version     = '1.4.4'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Grégoire Seux"]
  s.license     = "Apache License v2"
  s.summary     = %q{Play on command line with JIRA}
  s.homepage    = "http://github.com/kamaradclimber/mosespa"
  s.description = %q{}
  s.files         = `/bin/find . -type f`.split("\n")
  s.executables   = `/bin/find bin/ -type f`.split("\n").map{ |f| File.basename(f) }
  #s.require_paths = ["lib"]

  s.add_dependency "jira-ruby"
  s.add_dependency 'trollop'
  s.add_dependency 'colorize'
  s.add_dependency 'table_print'
end
