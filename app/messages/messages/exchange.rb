# frozen_string_literal: true

module Messages
  # The exchange handled the broadcast of messages
  # to a bunny exchange
  class Exchange
    # A simple logger replacement for a channel
    class Logger
      def topic(*args)
        Rails.logger.info "Configuring topic exchange with: #{args}"
      end

      def publish(message, routing_key:)
        Rails.logger.info "Published: #{message} with routing key: #{routing_key}"
      end
    end

    class << self
      def configure(channel:, exchange:)
        @connection = new(channel: channel, exchange: exchange)
      end

      def connection
        @connection || raise(StandardError, 'Messages::Exchange used before it was configured')
      end
    end

    # Create a new exchange for broadcasting messages.
    # Best done in initialization
    #
    # @param [Bunny:Channel] channel: An active BunnyChannel connected to your RabbitMQ server
    # @param [String] exchange: nil The name of the exchange to use on the given server
    #
    def initialize(channel:, exchange:)
      @channel = channel
      @exchange_name = exchange
    end

    #
    # Publish the provided method to the exchange
    #
    # Example usage:
    #
    # Messages::Exchange.connection << Messages::OseqFlowcell.new(flowcell)
    #
    # @param [Messages::Base] message The message to publish. Must respond to payload
    #                                 and routing_key
    #
    # @return [Messages::Exchange] Returns itself to allow chained publishing
    #
    def <<(message)
      exchange.publish(message.payload, routing_key: message.routing_key)
      self
    end

    private

    def exchange
      @exchange ||= @channel.topic(@exchange_name, auto_delete: false, durable: true)
    end
  end
end
