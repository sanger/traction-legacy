# frozen_string_literal: true

# A Sample
class Sample < ApplicationRecord
  has_one :aliquot

  validates :name, presence: true, uniqueness: true
  validates_presence_of :uuid

  def readonly?
    !new_record?
  end
end
