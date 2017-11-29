# frozen_string_literal: true

# WorkOrderLibraryValidator
# Check that each work order has a library
class WorkOrderLibraryValidator < ActiveModel::Validator
  def validate(record)
    record.work_orders_include_unsaved.each do |work_order|
      next if work_order.went_through_step('library_preparation')
      record.errors.add(:work_order,
                        "#{work_order.name} should go through library preparation first")
    end
  end
end
