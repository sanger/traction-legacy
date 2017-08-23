# frozen_string_literal: true

module WorkOrderForm
  # Qc form
  class Qc < Base
    validate :check_aliquot

    def update_state
      work_order.assign_state(:qc)
    end

    private

    def check_aliquot
      %i[concentration fragment_size qc_state].each do |attribute|
        if work_order.aliquot.send(attribute).blank?
          errors.add(attribute, "can't be blank")
        end
      end
    end
  end
end
