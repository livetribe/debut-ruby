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

require 'debut/version'

module LiveTribe
  module Debut

    class Debutante

      USE_ENVIRONMENT = '<use environment>'
      USE_LOCAL_HOSTNAME = true

      def initialize(attributes)
        provider = attributes[:provider].to_s.downcase.to_sym
        begin
          require "debut/#{provider}"
          if LiveTribe::Debut.providers.include?(provider)
            @provider = LiveTribe::Debut.providers[provider].new(attributes)
          else
            raise ArgumentError.new("#{provider} is not a recognized debut provider")
          end
        rescue LoadError
          raise ArgumentError.new("#{provider} is not a recognized debut provider")
        end

        @provider.use_local_hostname = USE_LOCAL_HOSTNAME
      end

      def hostname
        @provider.hostname
      end

      def hostname=(hostname)
        @provider.hostname = hostname
      end

      def name
        @provider.name
      end

      def name=(name)
        @provider.name = name
      end

      def subdomain
        @provider.subdomain
      end

      def subdomain=(subdomain)
        @provider.subdomain = subdomain
      end

      def use_local_hostname
        @provider.use_local_hostname
      end

      def use_local_hostname=(use_local_hostname)
        @provider.use_local_hostname = use_local_hostname
      end

      def hello
        @provider.hello
      end

      def goodbye
        @provider.goodbye
      end

      def to_s
        "#{@provider.name}.#{@provider.subdomain}:#{@provider.to_s}"
      end
    end

    def self.providers
      @providers ||= {}
    end

    def self.providers=(new_providers)
      @providers = new_providers
    end

    class Provider
      def Provider.inherited(clazz)
        provider = clazz.to_s.split('::').last
        LiveTribe::Debut.providers[provider.downcase.to_sym] = clazz
      end
    end

  end
end
