class CreateAliquots < ActiveRecord::Migration[5.1]
  def change
    create_table :aliquots do |t|
      t.integer :fragment_size
      t.decimal :concentration, precision: 18, scale: 8
      t.integer :qc_state
      t.timestamps
    end
  end
end
