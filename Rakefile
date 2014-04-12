#
# Copyright 2013-15 the original author or authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
require 'bundler/setup'
require 'date'
require 'rake/testtask'
require 'rubygems'
require 'rubygems/package_task'
require File.dirname(__FILE__) + '/lib/debut'

#############################################################################
#
# Helper functions
#
#############################################################################

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def version
  LiveTribe::Debut::VERSION
end

def date
  Date.today.to_s
end

def rubyforge_project
  name
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{version}.gem"
end

def replace_header(head, header_name)
  head.sub!(/(\.#{header_name}\s*= ').*'/) { "#{$1}#{send(header_name)}'"}
end

#############################################################################
#
# Standard tasks
#
#############################################################################

GEM_NAME = "#{name}"
task :default => :test

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['tests/*_tests.rb']
  t.verbose = true
end

#############################################################################
#
# Packaging tasks
#
#############################################################################

task :release => %w(release:prepare release:publish)

namespace :release do
  task :preflight do
    unless `git branch` =~ /^\* master$/
      puts 'You must be on the master branch to release!'
      exit!
    end
    if `git tag` =~ /^\* v#{version}$/
      puts "Tag v#{version} already exists!"
      exit!
    end
  end

  task :prepare => :preflight do
    Rake::Task[:build].invoke
    sh "gem install pkg/#{name}-#{version}.gem"
    Rake::Task[:git_mark_release].invoke
  end

  task :publish do
    Rake::Task[:git_push_release].invoke
    Rake::Task[:gem_push].invoke
  end
end

task :git_mark_release do
  sh "git commit --allow-empty -a -m 'Release #{version}'"
  sh "git tag v#{version}"
end

task :git_push_release do
  sh 'git push origin master'
  sh "git push origin v#{version}"
end

task :gem_push do
  sh "gem push pkg/#{name}-#{version}.gem"
end

desc "Build debut-#{version}.gem"
task :build => :gemspec do
  sh 'mkdir -p pkg'
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end
task :gem => :build

desc "Updates the gemspec and runs 'validate'"
task :gemspec => :validate do
  # read spec file and split out manifest section
  spec = File.read(gemspec_file)

  # replace name version and date
  replace_header(spec, :name)
  replace_header(spec, :version)
  replace_header(spec, :date)
  #comment this out if your rubyforge_project has a different name
  replace_header(spec, :rubyforge_project)

  File.open(gemspec_file, 'w') { |io| io.write(spec) }
  puts "Updated #{gemspec_file}"
end

desc 'Run before pushing out the code'
task :validate do
  libfiles = Dir['lib/*'] - ["lib/#{name}.rb", "lib/#{name}"]
  unless libfiles.empty?
    puts "Directory `lib` should only contain a `#{name}.rb` file and `#{name}` dir."
    exit!
  end
  unless Dir['VERSION*'].empty?
    puts 'A `VERSION` file at root level violates Gem best practices.'
    exit!
  end
end
