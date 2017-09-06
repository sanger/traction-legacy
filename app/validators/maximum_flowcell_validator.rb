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
    aggregator = WorkOrderFlowcellAggregator.new(record)
    return if aggregator.valid?
    aggregator.errors.each do |key, value|
      record.errors.add(key, value)
    end
  end
end
