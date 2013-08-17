# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__), 'lib', 'debut', 'version.rb'])

Gem::Specification.new do |s|
  s.name        = 'debut'
  s.version     = Debut::VERSION
  s.date        = '2013-07-14'
  s.summary     = "A simple way to register your cloud instance"
  s.description = "A simple way to register your cloud instance with DNS and other lookup services"
  s.platform    = Gem::Platform::RUBY
  s.license     = 'ASL-2'
  s.authors     = ["LiveTribe - Systems Management Project"]
  s.email       = 'dev@livetribe.codehaus.org'
  s.homepage    = 'http://www.livetribe.org'

  s.files       = %w(
bin/debut
lib/debut/aws.rb
lib/debut/version.rb
lib/debut.rb
                  )

  s.require_paths << 'lib'

  s.bindir = 'bin'
  s.executables << 'debut'

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md]

  s.add_dependency('fog', '>=1')
  s.add_dependency('gli', '>=2.7')

  s.add_development_dependency('minitest')
  s.add_development_dependency('rake')

end