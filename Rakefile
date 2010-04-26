require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require File.expand_path("./lib/bhm/google_maps/version", File.dirname(__FILE__))

desc "Default: run unit tests."
task :default => :test

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "bhm-google-maps"
    gem.summary     = "Helpers for Google Maps v3 in Rails - Using html 5, the google maps api v3 and the static maps api"
    gem.description = "A set of helpers and javascript files that makes it trivial to implement google maps unobtrusively in an application."
    gem.email       = "darcy.laycock@youthtree.org.au"
    gem.homepage    = "http://github.com/YouthTree/bhm-google-maps"
    gem.authors     = ["Darcy Laycock"]
    gem.version     = BHM::GoogleMaps::VERSION
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

desc "Compiles the javascript from Coffeescript to Javascript"
task :compile_scripts do
  system "coffee --no-wrap -c coffeescripts/*.coffee -o javascripts/"
end

desc "Interactively compiles coffeescripts as they're changed"
task :watch_scripts do
  system "coffee --no-wrap -w -c coffeescripts/*.coffee -o javascripts/"
end

desc "Generate docs for the bhm-google-maps plugin"
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = "bhm-google-maps"
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Test the bhm-google-maps plugin"
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib'
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end