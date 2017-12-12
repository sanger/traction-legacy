# frozen_string_literal: true

FactoryGirl.define do
  factory :flowcell do
    work_order { create(:gridion_work_order_ready_for_sequencing) }
    sequencing_run

    transient do
      sequence(:n) { |n| n }
    end

    flowcell_id { n.to_s.rjust(10, '1').to_i }
    position { n }

    factory :flowcell_in_sequencing_run do
      work_order { create(:gridion_work_order_ready_for_sequencing) }
    end
  end
end
