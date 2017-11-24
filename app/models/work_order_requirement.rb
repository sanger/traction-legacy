# frozen_string_literal: true

# Work order metadata 'value'
class WorkOrderRequirement < ApplicationRecord
  belongs_to :requirement
  belongs_to :work_order
end
