# frozen_string_literal: true

require 'json_api_client'

module Sqsc
  # for classes/objects created from sqsc responces using json api client
  module Api
    # "abstract" base class
    class Base < JsonApiClient::Resource
      # should go to configuration SqscApi::Base.site = ''
      self.site = 'http://localhost:3000/api/v2/'
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
