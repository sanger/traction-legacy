# frozen_string_literal: true

module Sequencescape
  module Api
    # this class is used if sequencescape connection is disabled
    # see config/initializers/sequencescape_api.rb and config/sequencescape.yml
    class FakeWorkOrder
      def self.for_reception
        []
      end

      def self.find_by_ids(_ids)
        []
      end

      def self.update_state(_work_order, state=nil)
        true
      end
    end
  end
end
