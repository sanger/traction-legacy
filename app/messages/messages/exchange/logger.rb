# frozen_string_literal: true

module Messages
  class Exchange
    # A simple logger replacement for a channel
    class Logger
      def topic(*args)
        Rails.logger.info "Configuring topic exchange with: #{args}"
        self
      end

      def publish(message, routing_key:)
        Rails.logger.info "Published: #{message} with routing key: #{routing_key}"
      end
    end
  end
end
