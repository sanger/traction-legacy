class Aliquot < ApplicationRecord

  belongs_to :sample
  belongs_to :tube

  enum qc_state: %i[fail proceed_at_risk proceed]

  delegate :name, to: :sample

end
