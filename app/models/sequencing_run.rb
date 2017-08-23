# frozen_string_literal: true

# SequencingRun
class SequencingRun < ApplicationRecord
  has_many :flowcells, inverse_of: :sequencing_run
  has_many :work_orders, through: :flowcells

  enum state: %i[pending completed user_terminated instrument_crashed restart]

  validates_presence_of :instrument_name

  accepts_nested_attributes_for :flowcells,
                                reject_if: proc { |attributes| attributes['work_order_id'].blank? }

  scope :by_date, (-> { order(created_at: :desc) })

  with_options if: :flowcells_present? do
    validates_with WorkOrderLibraryValidator
  end

  def experiment_name
    id
  end

  def work_orders_include_unsaved
    work_orders.empty? ? flowcells.collect(&:work_order) : work_orders
  end

  def flowcells_present?
    flowcells.present?
  end
end
