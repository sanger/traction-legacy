FactoryGirl.define do
  factory :work_order do
    aliquot

    uuid { SecureRandom.uuid }
  end
end
