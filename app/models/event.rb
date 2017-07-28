class Event < ApplicationRecord

  belongs_to :work_order

  validates_presence_of :state_from, :state_to

  # def state_from=(state_from)
  #   # binding.pry
  #   write_attribute(:state_from, state_from || 'none')
  # end

end
