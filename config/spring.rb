# frozen_string_literal: true

%w[
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  app/validators/**
].each { |path| Spring.watch(path) }
