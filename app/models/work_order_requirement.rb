# frozen_string_literal: true

# Work order metadata 'value'
class WorkOrderRequirement < ApplicationRecord
  attr_readonly :value
  belongs_to :requirement
  belongs_to :work_order

  def to_h
    { requirement.name => value }
  end
end
