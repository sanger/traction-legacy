FactoryGirl.define do
  factory :aliquot do
    sample
    tube
    
    factory :aliquot_after_qc do
      concentration 0.005
      fragment_size 500
      qc_state 'proceed'
    end
  end
end
