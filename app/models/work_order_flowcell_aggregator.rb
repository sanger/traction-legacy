# frozen_string_literal: true

# WorkOrderFlowcellAggregator
class WorkOrderFlowcellAggregator
  include ActiveModel::Model

  attr_reader :sequencing_run, :work_orders, :work_orders_by_flowcell, :invalid_work_orders

  validate :check_flowcell_count

  def initialize(sequencing_run)
    @sequencing_run = sequencing_run
    @work_orders = create_work_orders
    @work_orders_by_flowcell = create_work_orders_by_flowcell
  end

  private

  def create_work_orders
    WorkOrder.find(sequencing_run.flowcells.collect(&:work_order_id).uniq)
             .each_with_object({}) do |work_order, result|
      result[work_order.id] = work_order
    end
  end

  def create_work_orders_by_flowcell
    sequencing_run.flowcells.each_with_object({}) do |flowcell, result|
      id = flowcell.work_order_id
      result[id] ||= []
      result[id] << assign_flowcells(flowcell)
    end
  end

  def assign_flowcells(flowcell)
    [].tap do |flowcells|
      flowcells << flowcell
      flowcells << work_orders[id].flowcells.to_a
    end.flatten.uniq
  end

  def check_flowcell_count
    work_orders.each do |_key, work_order|
      these_flowcells = work_order.number_of_flowcells
      them_flowcells = work_orders_by_flowcell[work_order.id].length
      next unless these_flowcells < them_flowcells
      errors.add(:work_order, "#{work_order.name} has more flowcells (#{them_flowcells}) "\
        "than was originally requested (#{these_flowcells})")
    end
  end
end
