class CreateLabEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :lab_events do |t|
      t.datetime :date
      t.references :receptacle, foreign_key: true
      t.references :aliquot, foreign_key: true
      t.integer :state
      t.references :process_step, foreign_key: true

      t.timestamps
    end
  end
end
