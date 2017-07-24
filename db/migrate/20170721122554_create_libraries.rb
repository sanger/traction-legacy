class CreateLibraries < ActiveRecord::Migration[5.1]
  def change
    create_table :libraries do |t|
      t.string :kit_number
      t.string :ligase_batch_number
      t.decimal :volume, precision: 18, scale: 8
      t.references :aliquot, index: true, foreign_key: true
      t.references :tube, index: true, foreign_key: true
      t.timestamps
    end
  end
end
