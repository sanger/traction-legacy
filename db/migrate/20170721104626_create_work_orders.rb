class CreateWorkOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :work_orders do |t|
      t.integer :state, default: 0
      t.string :sequencescape_id
      t.integer :number_of_flowcells
      t.string :library_preparation_type
      t.string :data_type
      t.references :aliquot, index: true, foreign_key: true
      t.timestamps
    end
  end
end
