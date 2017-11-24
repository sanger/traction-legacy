# frozen_string_literal: true

# What should work order have ('key') for particular pipeline for work to be done
# (i.e. file_type, number_of_flowcells, etc)
class Requirement < ApplicationRecord
  belongs_to :pipeline
end
