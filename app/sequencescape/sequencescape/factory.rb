# frozen_string_literal: true

module Sequencescape
  # factory to create traction objects from sequencescape api objects (created with json_client_api)
  class Factory
    include ActiveModel::Model

    attr_accessor :sequencescape_work_orders, :sequencescape_work_orders_ids

    validates :sequencescape_work_orders, :sequencescape_work_orders_ids, presence: true
    validate :all_selected_were_found, if: :sequencescape_work_orders_and_ids_present?
    validate :ready_for_upload, if: :sequencescape_work_orders_and_ids_present?

    def create!
      sequencescape_work_orders.each do |sequencescape_work_order|
        ActiveRecord::Base.transaction do
          sample = Sample.find_or_create_by(uuid: sequencescape_work_order.sample_uuid)
          aliquot = Aliquot.new(sample: sample, name: sequencescape_work_order.name)
          # sequencescape work orders do nit have uuids for now, do I use id as unique identifier
          work_order = WorkOrder.create(aliquot: aliquot, uuid: sequencescape_work_order.id)
          # should it be here? it feels right it fails if sequencescape is not updated
          Sequencescape::Api::WorkOrder.update_state(work_order)
        end
      end
    end

    def sequencescape_work_orders_and_ids_present?
      sequencescape_work_orders.present? && sequencescape_work_orders_ids.present?
    end

    def all_selected_were_found
      not_found = (sequencescape_work_orders_ids - found_ids).join(', ')
      errors.add(:work_orders, "with ids #{not_found} were not found in Sequencescape, please contact PSD") unless not_found.empty? #rubocop:disable all
    end

    def ready_for_upload
      not_ready = sequencescape_work_orders.select(&:not_ready_for_upload)
      names_or_ids = not_ready.map { |w| w.name || w.id }.join(', ')
      errors.add(:work_orders, "#{names_or_ids} are not ready to be uploaded, please contact PSD") unless not_ready.empty? #rubocop:disable all
    end

    private

    def found_ids
      sequencescape_work_orders.map { |w| w.id.to_s }
    end
  end
end
