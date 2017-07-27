class CreateWorkOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :work_orders do |t|
      t.integer :state, default: 0
      t.string :uuid
      t.references :aliquot, index: true, foreign_key: true
      t.timestamps
    end
  end
end
