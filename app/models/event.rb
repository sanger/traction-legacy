# frozen_string_literal: true

# Event
class Event < ApplicationRecord
  belongs_to :work_order

  validates_presence_of :state_from, :state_to
end
