# encoding: utf-8

require 'rubygems'
require 'bundler/gem_tasks'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

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
