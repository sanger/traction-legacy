# frozen_string_literal: true

# SequencingRun
class SequencingRun < ApplicationRecord
  MAX_FLOWCELLS = 5

  has_many :flowcells

  enum state: %i[pending completed user_terminated instrument_crashed restart]

  validates_presence_of :instrument_name

  accepts_nested_attributes_for :flowcells,
                                reject_if: proc { |attributes| attributes['work_order_id'].blank? }

  with_options if: :flowcells_present? do
    validates_with MaximumFlowcellValidator
    validates_with WorkOrderStateValidator, state: :library_preparation
  end

  def experiment_name
    id
  end

  def work_orders
    return unless flowcells_present?
    flowcells.collect(&:work_order)
  end

  def flowcells_present?
    flowcells.present?
  end

  def flowcells_by_position
    [].tap do |f|
      (1..MAX_FLOWCELLS).each do |i|
        f << (flowcells.detect { |o| o.position == i } || Flowcell.new(position: i))
      end
    end
  end
end
