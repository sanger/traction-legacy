# frozen_string_literal: true

module WorkOrderForm
  # LibraryPreparation form
  class LibraryPreparation < Base
    validate :check_library, :check_qc_status

    def update_state
      work_order.assign_state(:library_preparation)
    end

    private

    def check_library
      return if work_order.library.valid?
      work_order.library.errors.each do |key, value|
        errors.add(key, value)
      end
    end

    def check_qc_status
      return unless work_order.qc? && work_order.aliquot.fail?
      errors.add(:library, "Can't be created if sample has failed qc")
    end
  end
end
