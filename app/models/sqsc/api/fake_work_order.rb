# frozen_string_literal: true

module Sqsc
  module Api
    # creates FakeWorkOrder, that does not require connection to sqsc api
    class FakeWorkOrder

      include ActiveModel::Model

      ModelName = Struct.new(:param_key)

      attr_accessor :id, :state, :name, :to_key, :model_name

      def self.for_reception
        [].tap do |list|
          5.times do |i|
            list << self.new( id: i+1,
                              state: 'pending',
                              name: "PLATE_WELL#{i+1}",
                              to_key: [i.to_s],
                              model_name: ModelName.new('sqsc_api_work_order')
                            )
          end
        end
      end

    end
  end
end