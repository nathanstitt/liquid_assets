# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
    gem.name = "liquid_assets"
    gem.homepage = "http://github.com/nathanstitt/liquid_assets"
    gem.license = "MIT"
    gem.summary = %Q{Liquid formmated views and assets}
    gem.description = %Q{Allows you to use Liquid format templates in Rails, both as view templates and as compiled JavaScript via the asset_pipeline.}
    gem.email = "nathan@stitt.org"
    gem.authors = ["Nathan Stitt"]
    # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
    test.libs << 'lib' << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
    version = File.exist?('VERSION') ? File.read('VERSION') : ""
    rdoc.main = 'README.md'
    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "liquid_assets #{version}"
    rdoc.rdoc_files.include('README.md')
    rdoc.rdoc_files.include('lib/liquid_assets/config.rb')
end
