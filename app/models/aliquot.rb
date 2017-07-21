class Aliquot < ApplicationRecord

  enum qc_state: %i[fail proceed_at_risk proceed]
end
