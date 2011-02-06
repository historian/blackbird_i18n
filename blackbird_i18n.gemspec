# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require "blackbird_i18n/version"

Gem::Specification.new do |s|
  s.name        = "blackbird_i18n"
  s.version     = Blackbird::I18n::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Simon Menke']
  s.email       = ['simon.menke@gmail.com']
  s.homepage    = "http://github.com/fd/blackbird_i18n"
  s.summary     = "I18n support for blackbird"
  s.description = "Easy I18n database support for blackbird"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "blackbird_i18n"

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'

  s.add_runtime_dependency 'blackbird'
end
