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

desc "Compile scripts, and produce a minified version."
task :build_scripts => [:compile_scripts] do
  require 'closure-compiler'
  build_prefix = "build/#{BHM::GoogleMaps::VERSION}"
  FileUtils.mkdir_p build_prefix
  Dir["javascripts/*.js"].each do |js|
    new_name = js.gsub(/^javascripts\//, build_prefix + "/").gsub(/\.js$/, "-#{BHM::GoogleMaps::VERSION}.js")
    FileUtils.cp js, new_name
    min_name = new_name.gsub(/\.js$/, '.min.js')
    File.open(min_name, "w+") do |f|
      f.write Closure::Compiler.new.compile(File.read(js))
    end
  end
  # Copy javascript into stuff.
  prefix = "lib/generators/bhm/google_maps/gmap_js/templates/public/javascripts"
  Dir[File.join(prefix, "**/*.js")].each { |file| File.delete(file) }
  Dir[File.join(build_prefix, "**/*.js")].each do |file|
    destination_path = file.gsub(/^#{Regexp.escape build_prefix}/, prefix)
    FileUtils.cp file, destination_path
  end
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