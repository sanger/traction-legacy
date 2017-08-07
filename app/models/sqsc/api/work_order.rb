# frozen_string_literal: true

module Sqsc
  module Api
  # creates WorkOrder objects based on json received from sqsc api
    class WorkOrder < Base
      has_many :samples
      has_one :source_receptacle

      def self.for_reception
        includes(:samples, :source_receptacle).where(state: 'pending').all
      end

      def self.find_by_ids(ids)
        where(id: ids.join(',')).all
      end

      def self.find_by_id(id)
        where(id: id).all.try(:first)
      end

      def update_state_to(state)
        update_attributes(state: state)
      end

      def name
        source_receptacle.name
      end
    end
  end
end
