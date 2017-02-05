#
# Copyright 2013-17 the original author or authors
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

# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__), 'lib', 'debut', 'version.rb'])

Gem::Specification.new do |s|
  s.name        = 'debut'
  s.version     = LiveTribe::Debut::VERSION
  s.date        = '2017-02-04'
  s.summary     = "A simple way to register your cloud instance"
  s.description = "A simple way to register your cloud instance with DNS and other lookup services"
  s.platform    = Gem::Platform::RUBY
  s.license     = 'Apache-2.0'
  s.authors     = ["LiveTribe - Systems Management Project"]
  s.email       = 'livetribe-dev@googlegroups.com'
  s.homepage    = 'http://www.livetribe.org'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_paths = %w[lib]

  s.bindir = 'bin'
  s.executables = %w[debut]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md]

  s.add_dependency('fog', '~> 1')
  s.add_dependency('gli', '~> 2.7')

  s.add_development_dependency('minitest', '~> 5')
  s.add_development_dependency('rake', '~> 12')

end