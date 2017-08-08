# frozen_string_literal: true

require 'json_api_client'

module Sqsc
  # for classes/objects created from sqsc responses using json api client
  # initializer is in config/initializers/sqsc_api.rb
  module Api
    # "abstract" base class
    class Base < JsonApiClient::Resource
    end

    class Sample < Base
    end

    class SourceReceptacle < Base
    end

    class Tube < Base
    end

    class Well < Base
    end
  end
end
