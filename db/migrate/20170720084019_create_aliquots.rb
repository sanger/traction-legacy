class CreateAliquots < ActiveRecord::Migration[5.1]
  def change
    create_table :aliquots do |t|
      t.string :name
      t.integer :fragment_size
      t.decimal :concentration, precision: 18, scale: 8
      t.integer :qc_state
      t.references :sample, index: true, foreign_key: true
      t.references :tube, index: true, foreign_key: true
      t.timestamps
    end
  end
end
