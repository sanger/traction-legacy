# frozen_string_literal: true

# SequencingRun
class SequencingRun < ApplicationRecord
  has_many :flowcells

  enum state: %i[pending completed user_terminated instrument_crashed restart]

  validates_presence_of :instrument_name

  accepts_nested_attributes_for :flowcells,
                                reject_if: proc { |attributes| attributes['work_order_id'].blank? }

  scope :by_date, (-> { order(created_at: :desc) })

  with_options if: :flowcells_present? do
    validates_with MaximumFlowcellValidator
    validates_with WorkOrderLibraryValidator
  end

  def experiment_name
    id
  end

  def work_orders
    return [] unless flowcells_present?
    flowcells.collect(&:work_order)
  end

  def flowcells_present?
    flowcells.present?
  end
end
