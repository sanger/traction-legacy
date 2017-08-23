# frozen_string_literal: true

##
# Each WorkOrder has a requested number of flowcells.
# These can be requested across multiple Sequencing Runs
# Need to check that the number of flowcells for the current sequencing run
# for each work order plus the number of flowcells that already exist for the
# work order does not exceed the number of flowcells originally requested
# as this would have an effect on charging.
class MaximumFlowcellValidator < ActiveModel::Validator
  def validate(record)
    work_order = record.work_order
    return unless (work_order.flowcells.count + 1) > work_order.number_of_flowcells
    record.errors.add(:work_order,
                      "#{work_order.name} can only have "\
                      " #{work_order.number_of_flowcells} flowcells")
  end
end
