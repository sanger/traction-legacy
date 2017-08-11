# frozen_string_literal: true

FactoryGirl.define do
  factory :event do
    state_from 'old_state'
    state_to 'new_state'
    work_order
  end
end
