# frozen_string_literal: true

module Sequencescape
  module Api
    # creates WorkOrder objects based on json received from sequencescape api
    class WorkOrder < Base
      has_many :samples
      has_one :source_receptacle

      def self.for_reception
        includes(:samples, :source_receptacle).where(state: 'pending').all
      end

      def self.find_by_ids(ids)
        includes(:samples, :source_receptacle).where(id: ids.join(',')).all
      end

      def self.find_by_id(id)
        where(id: id).all.try(:first)
      end

      def self.update_state(work_order)
        sequencescape_work_order = find_by_id(work_order.uuid)
        sequencescape_work_order.update_attributes(state: work_order.state)
      end

      def name
        source_receptacle.name
      end

      def sample_uuid
        samples.first.uuid
      end

      def library_preparation_type
        options[:library_type]
      end

      def file_type
        options[:file_type]
      end

      def number_of_flowcells
        # now Sequencescape does not have this option, so 1 is default
        options[:number_of_flowcells] || 1
      end

      def not_ready_for_upload
        name.nil? || id.nil? || sample_uuid.nil? || required_options || required_option_missing
      end

      def required_option_missing
        !(library_preparation_type && file_type && number_of_flowcells)
      end
    end
  end
end
