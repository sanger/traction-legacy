# frozen_string_literal: true

class CreateSamples < ActiveRecord::Migration[5.1]
  def change
    create_table :samples do |t|
      t.string :name
      t.string :uuid
      t.timestamps
    end
  end
end
