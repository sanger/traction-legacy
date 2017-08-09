# frozen_string_literal: true

# WorkOrderStateValidator
# Check that each work order is in the correct state for the action
class WorkOrderStateValidator < ActiveModel::Validator
  def validate(record)
    record.work_orders.each do |work_order|
      required_state = options[:state].to_s
      next unless work_order.state != required_state
      record.errors.add(:work_order,
                        "#{work_order.name} has not gone through
                        #{required_state.to_s.humanize}")
    end
  end
end
