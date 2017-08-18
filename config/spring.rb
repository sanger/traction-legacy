# frozen_string_literal: true

%w[
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  app/validators/**
].each { |path| Spring.watch(path) }

Spring.after_fork do
  # Reconnect any bunny exchanges. Both ensures that actual connections
  # are re-established following the fork, and that the BUNNY_TYPE
  # environmental variable is acknowledged
  Messages::ExchangeFactory.new(Rails.configuration.bunny).setup
end
