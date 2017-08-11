# frozen_string_literal: true

# WorkOrderForm
class WorkOrderForm
  include ActiveModel::Model

  attr_reader :work_order, :params
  delegate_missing_to :work_order

  validate :check_form, :check_qc

  PERMITTED_ATTRIBUTES =  { aliquot_attributes: %i[id concentration fragment_size qc_state],
                            library_attributes: %i[volume kit_number ligase_batch_number] }.freeze

  REQUIRED_ATTRIBUTES = { aliquot: %i[concentration fragment_size qc_state],
                          library: %i[volume kit_number] }.with_indifferent_access

  def initialize(work_order)
    @work_order = work_order
  end

  def template
    return 'aliquot' if work_order.started?
    return 'library' if work_order.qc?
  end

  def submit(params)
    @params = params
    if valid?
      update_work_order
    else
      false
    end
  end

  def update_work_order
    ActiveRecord::Base.transaction do
      work_order.update_attributes(work_order_params)
      work_order.next_state!
      Sequencescape::Api::WorkOrder.update_state(work_order)
      true
    end
  end

  def self.model_name
    ActiveModel::Name.new(WorkOrder)
  end

  def persisted?
    work_order.id?
  end

  private

  def work_order_params
    params.permit(PERMITTED_ATTRIBUTES)
  end

  def check_form
    check_attributes(:aliquot) if work_order.started?
    check_attributes(:library) if work_order.qc?
  end

  def check_attributes(key)
    REQUIRED_ATTRIBUTES[key].each do |attribute|
      if params["#{key}_attributes"][attribute].blank?
        errors.add(key, "#{attribute.to_s.humanize} can't be blank")
      end
    end
  end

  def check_qc
    return unless work_order.qc? && work_order.aliquot.fail?
    errors.add(:library, "Can't be created if sample has failed qc")
  end
end
