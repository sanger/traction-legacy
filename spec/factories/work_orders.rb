# frozen_string_literal: true

FactoryGirl.define do
  factory :work_order do
    aliquot

    uuid { SecureRandom.uuid }

    factory :work_order_with_qc_fail do
      aliquot { build(:aliquot_fail) }
    end
  end
end
