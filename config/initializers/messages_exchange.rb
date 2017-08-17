# frozen_string_literal: true

bunny_type = ENV.fetch('BUNNY_TYPE', Rails.configuration.bunny['type'])
channel = case bunny_type
          when 'bunny' then
            bunny = Bunny.new(Rails.configuration.bunny.fetch('amqp_url'))
            bunny.start
            bunny.create_channel
          when 'logger' then
            Messages::Exchange::Logger.new
          else
            raise StandardError,
                  "Unrecognized message client type: #{bunny_type}"
          end
p channel
Messages::Exchange.configure(channel: channel, exchange: Rails.configuration.bunny['exchange'])
