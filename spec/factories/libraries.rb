FactoryGirl.define do
  factory :library do
    aliquot
    
    sequence(:kit_number) { |n| "KIT-#{n}" }
    volume 0.03
  end
end
