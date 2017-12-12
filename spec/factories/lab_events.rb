# frozen_string_literal: true

FactoryGirl.define do
  factory :lab_event do
    date '2017-11-24 11:26:28'
    receptacle
    aliquot
    state 1
    process_step
  end
end
