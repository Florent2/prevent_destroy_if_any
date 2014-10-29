# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "prevent_destroy_if_any/version"

Gem::Specification.new do |s|
  s.name        = "prevent_destroy_if_any"
  s.version     = PreventDestroyIfAny::VERSION
  s.authors     = ["Florent Guilleux"]
  s.email       = ["florent2@gmail.com"]
  s.homepage    = "https://github.com/Florent2/prevent_destroy_if_any"
  s.summary     = %q{ActiveRecord plugin to prevent destroy when associations are present}
  s.description = %q{ActiveRecord plugin to prevent destroy when associations are present}

  s.rubyforge_project = "prevent_destroy_if_any"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activerecord", '>= 3.0.0'
  s.add_development_dependency "bundler", '>= 1.0.0'
  s.add_development_dependency "rspec", '>= 0'
  s.add_development_dependency "database_cleaner", '>= 0'
  s.add_development_dependency "sqlite3", '>= 0'
  s.add_development_dependency "rake", '>= 0'
end
