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
    record.work_orders
          .each_with_object(Hash.new(0)) { |work_order, counts| counts[work_order] += 1 }
          .each do |work_order, count|
            total_flowcell_count = work_order.flowcells.count + count
            next unless work_order.number_of_flowcells < total_flowcell_count
            record.errors.add(:work_order,
                              "#{work_order.name} has #{total_flowcell_count}
                              flowcells which is more than was originally requested
                              (#{work_order.number_of_flowcells})")
          end
  end
end
