# frozen_string_literal: true

# A Sample
class Sample < ApplicationRecord
  has_one :aliquot

  validates_presence_of :uuid

  def readonly?
    !new_record?
  end
end
