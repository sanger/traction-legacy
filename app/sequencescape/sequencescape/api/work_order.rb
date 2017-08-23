# frozen_string_literal: true

module Sequencescape
  module Api
    # creates WorkOrder objects based on json received from sequencescape api
    class WorkOrder < Base
      has_many :samples
      has_one :source_receptacle
      has_one :study

      def self.for_reception
        return [] if Rails.configuration.sequencescape_disabled == true
        includes(:samples, :source_receptacle, :study)
          .where(order_type: 'traction_grid_ion', state: 'pending')
          .all
      end

      def self.find_by_ids(ids)
        return [] if Rails.configuration.sequencescape_disabled == true
        includes(:samples, :source_receptacle, :study).where(id: ids.join(',')).all
      end

      def self.find_by_id(id)
        where(id: id).all.try(:first)
      end

      def self.update_state(work_order)
        return true if Rails.configuration.sequencescape_disabled == true
        sequencescape_work_order = find_by_id(work_order.sequencescape_id)
        sequencescape_work_order.update_attributes(state: work_order.state)
      end

      def name
        source_receptacle.name
      end

      def sample_uuid
        samples.first.uuid
      end

      def study_uuid
        study.uuid
      end

      def library_preparation_type
        options[:library_type]
      end

      def data_type
        options[:data_type]
      end

      def number_of_flowcells
        quantity[:number]
      end
    end
  end
end
