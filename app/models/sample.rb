class Sample < ApplicationRecord

  enum qc_state: [:fail, :proceed_at_risk, :proceed]

  validates :name, presence: true, uniqueness: true
end
