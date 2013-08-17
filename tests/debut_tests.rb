# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.  The
# ASF licenses this file to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.

require_relative 'helper'

require 'minitest/autorun'

class TestDebut < MiniTest::Unit::TestCase
  def test_that_namespace_defined
    assert(defined?(LiveTribe::Debut))
  end

  def test_connection_to_test_aws
    debutant = LiveTribe::Debut::Debutante::new({
                                                    :provider => :aws,
                                                    :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
                                                    :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
                                                })
    debutant.hostname = 'ec2-184-72-8-21.us-west-1.compute.amazonaws.com'
    debutant.subdomain = 'mock.livetribe.org.'
    debutant.name = 'travis'

    debutant.hello

    debutant.goodbye

    assert debutant != nil
  end
end
