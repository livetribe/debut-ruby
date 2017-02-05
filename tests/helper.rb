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

require "coveralls"
Coveralls.wear!

require 'simplecov'

if ENV['COVERAGE'] != 'false' && RUBY_VERSION != "1.9.2"
  require 'coveralls'
  SimpleCov.command_name "minitest:#{Process.pid.to_s}"
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.merge_timeout 3600
  SimpleCov.start
end

require 'debut'
