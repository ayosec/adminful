# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "adminful/version"

Gem::Specification.new do |s|
  s.name        = "adminful"
  s.version     = Adminful::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.summary     = "A simple, powerful and non-invasive admin interface based on Backbone.js"
  s.email       = "ayosec@gmail.com"
  s.homepage    = "http://github.com/ayosec/adminful"
  s.description = s.summary
  s.authors     = ['Ayose Cazorla']

  s.rubyforge_project = "inherited_resources"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "backbone-rails"
end
