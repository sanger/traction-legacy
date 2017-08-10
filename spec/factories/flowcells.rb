# frozen_string_literal: true

FactoryGirl.define do
  factory :flowcell do
    work_order { create(:work_order_for_sequencing) }
    sequencing_run

    transient do
      sequence(:n) { |n| n }
    end

    flowcell_id { n.to_s.rjust(10, '1').to_i }
    position { n }
  end
end
