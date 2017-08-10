# frozen_string_literal: true

module Sequencescape
  module Api
    # creates FakeWorkOrder, that does not require connection to sequencescape api
    class FakeWorkOrder
      include ActiveModel::Model

      attr_accessor :id, :state, :name, :to_key, :model_name, :sample_uuid, :options

      # mocking actual Sequencescape::Api::WorkOrder methods

      def self.for_reception
        test_work_orders.select { |work_order| work_order.state == 'pending' }
      end

      def self.find_by_ids(ids)
        test_work_orders.select { |work_order| ids.include?(work_order.id.to_s) }
      end

      def self.find_by_id(id)
        test_work_orders.select { |work_order| work_order.id.to_s == id }.first || new(id: id)
      end

      def self.update_state(work_order)
        sequencescape_work_order = find_by_id(work_order.uuid)
        sequencescape_work_order.state = work_order.state
      end

      def sample_uuid
        @sample_uuid ||= SecureRandom.uuid
      end

      def not_ready_for_upload
        name.nil? || id.nil? || sample_uuid.nil? || required_option_missing
      end

      def library_preparation_type
        options[:library_type]
      end

      def file_type
        options[:file_type]
      end

      def number_of_flowcells
        options[:number_of_flowcells]
      end

      def required_option_missing
        !(library_preparation_type && file_type && number_of_flowcells)
      end

      # create and destroy test work orders for tests

      def self.test_work_orders
        @test_work_orders ||= create_test_work_orders
      end

      def self.destroy_test_work_orders
        @test_work_orders = nil
      end

      ModelName = Struct.new(:param_key)

      def self.create_test_work_orders
        [].tap do |list|
          5.times do |_i|
            id = Random.rand(1000)
            list << new(id: id,
                        state: 'pending',
                        name: "PLATE_WELL#{id}",
                        to_key: [id.to_s],
                        model_name: ModelName.new('sequencescape_api_work_order'),
                        options: {library_type: 'rapid', file_type: 'fast5', number_of_flowcells: 3})
          end
        end
      end

      def self.create_invalid_test_work_orders
        work_orders = create_test_work_orders
        work_orders[0].id = nil
        work_orders[1].name = nil
        @test_work_orders = work_orders
      end
    end
  end
end
