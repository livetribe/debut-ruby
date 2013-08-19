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

module LiveTribe
  module Debut
    INSTANCE_METADATA_HOST = 'http://169.254.169.254'
    INSTANCE_METADATA_PATH = '/latest/user-data'
    INSTANCE_LOCAL_HOSTNAME_PATH = '/latest/meta-data/local-hostname'
    INSTANCE_PUBLIC_HOSTNAME_PATH = '/latest/meta-data/public-hostname'

    class AWS < LiveTribe::Debut::Provider
      require 'json'
      require 'fog'

      def initialize(attributes)
        @dns = Fog::DNS.new(attributes)

        @hostname = LiveTribe::Debut::Debutante::USE_ENVIRONMENT
        @name = LiveTribe::Debut::Debutante::USE_ENVIRONMENT
        @subdomain = LiveTribe::Debut::Debutante::USE_ENVIRONMENT
        @use_local_hostname = LiveTribe::Debut::Debutante::USE_LOCAL_HOSTNAME
      end

      def hostname
        @hostname
      end

      def hostname=(hostname)
        @hostname = hostname
      end

      def name
        @name
      end

      def name=(name)
        @name = name
      end

      def subdomain
        @subdomain
      end

      def subdomain=(subdomain)
        @subdomain = subdomain
      end

      def use_local_hostname
        @use_local_hostname
      end

      def use_local_hostname=(use_local_hostname)
        @use_local_hostname = use_local_hostname
      end

      def to_s
        'aws'
      end

      def hello
        name, subdomain = collect_name_and_subdomain
        hostname = collect_hostname
        fqdn = "#{name}.#{subdomain}"
        for zone in @dns.zones
          if zone.domain == subdomain
            record = zone.records.find { |r| r.name == fqdn && r.type == 'CNAME' }
            if record
              puts "Destroying old record for #{fqdn}"

              record.destroy
            end

            zone.records.create(
                :value => hostname,
                :name => fqdn,
                :type => 'CNAME'
            )

            puts "Registered hostname #{hostname} at #{fqdn}"

            return
          end
        end
        raise ArgumentError.new("Unable to find route53 zone: #{subdomain}")
      end

      def goodbye
        name, subdomain = collect_name_and_subdomain
        fqdn = "#{name}.#{subdomain}"
        @dns.zones.each { |zone|
          if zone.domain == subdomain
            record = zone.records.find { |r| r.name == fqdn && r.type == 'CNAME' }
            if record
              record.destroy
            end

            puts "Unregistered #{fqdn}"

            return
          end
        }
        raise ArgumentError.new("Unable to find route53 zone: #{subdomain}")
      end

      protected

      def collect_name_and_subdomain
        name = @name
        subdomain = @subdomain

        if name == LiveTribe::Debut::Debutante::USE_ENVIRONMENT || subdomain == LiveTribe::Debut::Debutante::USE_ENVIRONMENT
          connection = Excon.new(INSTANCE_METADATA_HOST)
          metadata = Fog::JSON.decode(connection.get(:path => INSTANCE_METADATA_PATH, :expects => 200).body)
          metadata.default = LiveTribe::Debut::Debutante::USE_ENVIRONMENT

          if name == LiveTribe::Debut::Debutante::USE_ENVIRONMENT
            name = metadata['name']
          end

          if subdomain == LiveTribe::Debut::Debutante::USE_ENVIRONMENT
            subdomain = metadata['subdomain']
          end
        end

        if name == LiveTribe::Debut::Debutante::USE_ENVIRONMENT || subdomain == LiveTribe::Debut::Debutante::USE_ENVIRONMENT
          raise ArgumentError.new("Name or subdomain not set: #{name}, #{subdomain}")
        end

        return name, subdomain
      end

      def collect_hostname
        hostname = @hostname

        if hostname == LiveTribe::Debut::Debutante::USE_ENVIRONMENT
          connection = Excon.new(INSTANCE_METADATA_HOST)

          if @use_local_hostname
            path = INSTANCE_LOCAL_HOSTNAME_PATH
          else
            path = INSTANCE_PUBLIC_HOSTNAME_PATH
          end

          metadata = Fog::JSON.decode(connection.get(:path => path, :expects => 200).body)

          hostname = metadata['hostname']
        end

        hostname
      end
    end
  end
end
