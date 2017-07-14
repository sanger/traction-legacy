# frozen_string_literal: true

class CreateSamples < ActiveRecord::Migration[5.1]
  def change
    create_table :samples do |t|
      t.string :name
      t.integer :fragment_size
      t.decimal :concentration, precision: 18, scale: 8
      t.integer :qc_state
      t.references :tube, index: true, foreign_key: true
      t.timestamps
    end
  end
end
