# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'version'
require 'date'

Gem::Specification.new do |s|
  s.name        = "zucchini-ios"
  s.version     = Zucchini::VERSION
  s.date        = Date.today.to_s
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Vasily Mikhaylichenko", "Rajesh Kumar", "Kevin O'Neill"]
  s.license     = "BSD"
  s.email       = ["vaskas@zucchiniframework.org"]
  s.homepage    = "http://www.zucchiniframework.org"
  s.summary     = %q{Functional testing framework for iOS-powered devices}
  s.description = %q{Zucchini follows simple walkthrough scenarios for your iOS app, takes screenshots and compares them to the reference ones.}

  s.add_runtime_dependency     "clamp"
  s.add_development_dependency "rspec"
  s.add_development_dependency "watchr"

  s.files         = `git ls-files | grep -vE '(web|.watchr)'`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = %w(zucchini)
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.9.2'
end
