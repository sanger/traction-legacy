class Library < ApplicationRecord

  belongs_to :work_order
  belongs_to :tube
  
  validates_presence_of :kit_number, :volume

  after_initialize :build_tube

  private

  def build_tube
    self.tube = Tube.new
  end
end
