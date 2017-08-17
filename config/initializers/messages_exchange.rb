# frozen_string_literal: true

require_dependency 'messages/exchange/logger'
require_dependency 'messages/exchange'

module Messages
  # Build exchanges easily
  class ExchangeFactory
    def initialize(config)
      @config = config
    end

    def setup
      Messages::Exchange.configure(channel: channel, exchange: @config['exchange'])
    end

    private

    def bunny_type
      ENV.fetch('BUNNY_TYPE', @config['type'])
    end

    def channel
      case bunny_type
      when 'bunny' then
        bunny_channel
      when 'logger' then
        Messages::Exchange::Logger.new
      else
        raise StandardError,
              "Unrecognized message client type: #{bunny_type}"
      end
    end

    def bunny_channel
      bunny = Bunny.new(@config.fetch('amqp_url'))
      bunny.start
      bunny.create_channel
    end
  end
end

Messages::ExchangeFactory.new(Rails.configuration.bunny).setup
