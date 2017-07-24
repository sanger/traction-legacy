class Library < ApplicationRecord

  belongs_to :aliquot
  
  validates_presence_of :kit_number, :volume
end
