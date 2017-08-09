# frozen_string_literal: true

require 'json_api_client'

module Sequencescape
  # for classes/objects created from Sequencescape responses using json api client
  # initializer is in config/initializers/sequencescape_api.rb
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
