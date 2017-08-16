# frozen_string_literal: true

# WorkOrderLibraryValidator
# Check that each work order has a library
class WorkOrderLibraryValidator < ActiveModel::Validator
  def validate(record)
    record.work_orders.each do |work_order|
      next if work_order.library?
      record.errors.add(:work_order,
                        "#{work_order.name} must have a library")
    end
  end
end
