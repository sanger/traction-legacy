# frozen_string_literal: true

module Sequencescape
  # factory to create traction objects from sequencescape api objects (created with json_client_api)
  class Factory
    include ActiveModel::Model

    attr_accessor :sequencescape_work_orders

    validates :sequencescape_work_orders, presence: true
    validate :ready_for_upload, if: :sequencescape_work_orders_present?

    def create!
      sequencescape_work_orders.each do |sequencescape_work_order|
        ActiveRecord::Base.transaction do
          tube = Tube.create!
          sample = Sample.create!(name: sequencescape_work_order.name, uuid: sequencescape_work_order.sample_uuid) #rubocop:disable all
          aliquot = Aliquot.create!(tube: tube, sample: sample)
          work_order = WorkOrder.create!(aliquot: aliquot, uuid: sequencescape_work_order.id)
          # should it be here? it feels right it fails if sequencescape is not updated
          Sequencescape::Api::WorkOrder.update_state(work_order)
        end
      end
    end

    def sequencescape_work_orders_present?
      sequencescape_work_orders.present?
    end

    def ready_for_upload
      not_ready = sequencescape_work_orders.select(&:not_ready_for_upload)
      names_or_ids = not_ready.map { |w| w.name || w.id }.join(', ')
      errors.add(:work_orders, "#{names_or_ids} are not ready to be uploaded") unless not_ready.empty? #rubocop:disable all
    end
  end
end
