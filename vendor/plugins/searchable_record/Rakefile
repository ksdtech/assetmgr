require 'rake'
require 'rake/clean'
require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/contrib/sshpublisher'

CLOBBER << 'rdoc'

desc 'Default: run unit tests.'
task :default => :test

desc 'Unit test the plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs   << 'lib'
  t.pattern = 'test/**/spec_*.rb'
  t.verbose = true
end

desc 'Spec test the plugin.'
Rake::TestTask.new(:spec) do |t|
  t.libs   << 'lib'
  t.options = '-rs'
  t.pattern = 'test/**/spec_*.rb'
  t.verbose = true
end

desc 'Generate documentation for the plugin.'
Rake::RDocTask.new(:rdoc) do |t|
  t.options << '--line-numbers' << '--inline-source'
  t.title    = 'SearchableRecord documentation'
  t.main     = 'README'
  t.rdoc_dir = 'rdoc'
  t.rdoc_files.include('README')
  t.rdoc_files.include('lib/**/*.rb')
end

task :verify_user do
  raise "RUBYFORGE_USER environment variable is not set." if ENV['RUBYFORGE_USER'].nil?
end

desc "Publish the documentation for the plugin to Rubyforge."
task :publish_rdoc => [ :rdoc, :verify_user ] do
  user = ENV['RUBYFORGE_USER']
  
  host       = "#{user}@rubyforge.org"
  remote_dir = "/var/www/gforge-projects/searchable-rec"
  local_dir  = 'rdoc'
  
  publisher = Rake::SshDirPublisher.new(host, remote_dir, local_dir)
  publisher.upload
end

desc "Generate ChangeLog."
task :changelog do
  sh 'svn2cl --group-by-day --linelen=76'
end

desc "Search unfinished parts of source code."
task :todo do
  FileList['**/*.rb'].egrep /#.*(TODO|FIXME)/
end
