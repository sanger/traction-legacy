# frozen_string_literal: true

module Sqsc
  # factory to create traction objects from sqsc api objects (created using json_client_api)
  class Factory
    include ActiveModel::Model

    attr_accessor :sqsc_work_orders

    validates :sqsc_work_orders, presence: true
    validate :ready_for_upload, if: :sqsc_work_orders_present?

    def create!
      sqsc_work_orders.each do |sqsc_work_order|
        ActiveRecord::Base.transaction do
          tube = Tube.create!
          sample = Sample.create!(name: sqsc_work_order.name, uuid: sqsc_work_order.sample_uuid)
          aliquot = Aliquot.create!(tube: tube, sample: sample)
          work_order = WorkOrder.create!(aliquot: aliquot, uuid: sqsc_work_order.id)
          # should it be here? it feels right it does not create anything if sqsc is not updated
          sqsc_work_order.update_state_to(work_order.state)
        end
      end
    end

    def sqsc_work_orders_present?
      sqsc_work_orders.present?
    end
    #rubocop:disable all
    def ready_for_upload
      not_ready = sqsc_work_orders.select { |w| w.name.nil? || w.id.nil? || w.sample_uuid.nil? }
      names_or_ids = not_ready.map { |w| w.name || w.id }.join(', ')
      errors.add(:work_orders, "#{names_or_ids} are not ready to be uploaded") unless not_ready.empty? #rubocop:disable all
    end
    #rubocop:enable all
  end
end
