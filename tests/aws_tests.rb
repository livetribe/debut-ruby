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

require_relative 'helper'

require 'minitest/autorun'

require 'debut/aws'


class TestAws < MiniTest::Unit::TestCase

  def setup
    @old_mock_value = Excon.defaults[:mock]
    Excon.stubs.clear
  end

  def teardown
    Excon.stubs.clear
    Excon.defaults[:mock] = @old_mock_value
  end

  def test_defaults
    aws = LiveTribe::Debut::AWS::new({:provider => :aws,
                                      :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
                                      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']})
    assert_equal(LiveTribe::Debut::Debutante::USE_ENVIRONMENT, aws.hostname)
    assert_equal(LiveTribe::Debut::Debutante::USE_ENVIRONMENT, aws.name)
    assert_equal(LiveTribe::Debut::Debutante::USE_ENVIRONMENT, aws.subdomain)
    assert_equal(LiveTribe::Debut::Debutante::USE_LOCAL_HOSTNAME, aws.use_local_hostname)

    assert_equal('aws', aws.to_s)
  end

  def test_field_access
    aws = LiveTribe::Debut::AWS::new({:provider => :aws,
                                      :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
                                      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']})
    aws.hostname = 'ec2-184-72-8-21.us-west-1.compute.amazonaws.com'
    assert_equal('ec2-184-72-8-21.us-west-1.compute.amazonaws.com', aws.hostname)

    aws.name = 'travis'
    assert_equal('travis', aws.name)

    aws.subdomain = 'mock.livetribe.org.'
    assert_equal('mock.livetribe.org.', aws.subdomain)

    aws.use_local_hostname = LiveTribe::Debut::Debutante::USE_LOCAL_HOSTNAME
    assert_equal(LiveTribe::Debut::Debutante::USE_LOCAL_HOSTNAME, aws.use_local_hostname)

    assert_equal('aws', aws.to_s)
  end

  def test_name_and_subdomain
    Excon.defaults[:mock] = true

    aws = LiveTribe::Debut::AWS::new({:provider => :aws,
                                      :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
                                      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']})
    aws.name = LiveTribe::Debut::Debutante::USE_ENVIRONMENT
    aws.subdomain = LiveTribe::Debut::Debutante::USE_ENVIRONMENT

    user_data = {
        :name => 'test_name',
        :subdomain => 'test_subdomain'
    }
    Excon.stub({:method => :get, :path => '/latest/user-data'}, {:status => 200, :body => Fog::JSON.encode(user_data)})

    name, subdomain = aws.send :collect_name_and_subdomain

    assert_equal('test_name', name)
    assert_equal('test_subdomain', subdomain)
  end

  def test_missing_name
    check_missing_data({:subdomain => 'test_subdomain'})
  end

  def test_missing_subdomain
    check_missing_data({:name => 'test_name'})
  end

  def test_public_public_hostname
    Excon.defaults[:mock] = true

    aws = LiveTribe::Debut::AWS::new({:provider => :aws,
                                      :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
                                      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']})
    aws.hostname = LiveTribe::Debut::Debutante::USE_ENVIRONMENT
    aws.use_local_hostname = false

    Excon.stub({:method => :get, :path => '/latest/meta-data/public-hostname'}, {:status => 200, :body =>'public_hostname'})

    hostname = aws.send :collect_hostname

    assert_equal('public_hostname', hostname)
  end

  def test_public_local_hostname
    Excon.defaults[:mock] = true

    aws = LiveTribe::Debut::AWS::new({:provider => :aws,
                                      :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
                                      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']})
    aws.hostname = LiveTribe::Debut::Debutante::USE_ENVIRONMENT
    aws.use_local_hostname = true

    Excon.stub({:method => :get, :path => '/latest/meta-data/local-hostname'}, {:status => 200, :body => 'local_hostname'})

    hostname = aws.send :collect_hostname

    assert_equal('local_hostname', hostname)
  end

  protected

  def check_missing_data(user_data)
    Excon.defaults[:mock] = true

    aws = LiveTribe::Debut::AWS::new({:provider => :aws,
                                      :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
                                      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']})
    aws.name = LiveTribe::Debut::Debutante::USE_ENVIRONMENT
    aws.subdomain = LiveTribe::Debut::Debutante::USE_ENVIRONMENT

    Excon.stub({:method => :get, :path => '/latest/user-data'}, {:status => 200, :body => Fog::JSON.encode(user_data)})

    assert_raises(ArgumentError) {
      aws.send :collect_name_and_subdomain
    }
  end
end
