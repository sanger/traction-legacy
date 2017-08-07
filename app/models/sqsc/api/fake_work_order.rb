# frozen_string_literal: true

module Sqsc
  module Api
    # creates FakeWorkOrder, that does not require connection to sqsc api
    class FakeWorkOrder
      include ActiveModel::Model

      attr_accessor :id, :state, :name, :to_key, :model_name

      def self.for_reception
        test_work_orders.select {|work_order| work_order.state == 'pending'}
      end

      def self.find_by_ids(ids)
        test_work_orders.select {|work_order| ids.include?(work_order.id.to_s)}
      end

      def update_state_to(state)
        @state = state
      end

      def sample_uuid
        SecureRandom.uuid
      end

      def self.test_work_orders
        @@test_work_orders ||= create_test_work_orders
      end

      private

      ModelName = Struct.new(:param_key)

      def self.create_test_work_orders
        [].tap do |list|
          5.times do |i|
            list << new(id: i + 1,
                        state: 'pending',
                        name: "PLATE_WELL#{i + 1}",
                        to_key: [(i+1).to_s],
                        model_name: ModelName.new('sqsc_api_work_order'))
          end
        end
      end

    end
  end
end
