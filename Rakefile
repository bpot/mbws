require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'

require File.dirname(__FILE__) + '/lib/mbws'

def library_root
  File.dirname(__FILE__)
end

task :default => :test

Rake::TestTask.new do |test|
  test.pattern = 'test/*_test.rb'
  test.verbose = true
end

namespace :doc do
  Rake::RDocTask.new do |rdoc|  
    rdoc.rdoc_dir = 'doc'  
    rdoc.title    = "MBWS -- Support for MusicBrainz's XML REST api"  
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.rdoc_files.include('README')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end

  task :deploy => :rerdoc do
    sh %(scp -r doc bpot@rubyforge.org:/var/www/gforge-projects/mbws/)
  end
end

namespace :dist do  
  spec = Gem::Specification.new do |s|
    s.name              = 'mbws'
    s.version           = Gem::Version.new(MBWS::Version)
    s.summary           = "Client library for MusicBrainz's XML API"
    s.description       = s.summary
    s.email             = 'bobby.potter@gmail.com'
    s.author            = 'Bobby Potter'
    s.has_rdoc          = true
    s.extra_rdoc_files  = %w(README COPYING INSTALL)
    s.homepage          = 'http://mbws.rubyforge.org'
    s.rubyforge_project = 'mbws'
    s.files             = FileList['Rakefile', 'lib/**/*.rb', 'bin/*', 'support/**/*.rb']
    s.test_files        = Dir['test/**/*']
    
    s.add_dependency 'xml-simple'
    s.rdoc_options  = ['--title', "MBWS -- Support for MusicBrainz's XML api",
                       '--main',  'README',
                       '--line-numbers', '--inline-source']
  end

  Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar_gz = true
    pkg.package_files.include('{lib,script,test,support}/**/*')
    pkg.package_files.include('README')
    pkg.package_files.include('COPYING')
    pkg.package_files.include('INSTALL')
    pkg.package_files.include('Rakefile')
  end
end 
