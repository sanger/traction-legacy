class CreateWorkOrderRequirements < ActiveRecord::Migration[5.1]
  def change
    create_table :work_order_requirements do |t|
      t.string :value
      t.references :requirement, foreign_key: true
      t.references :work_order, foreign_key: true

      t.timestamps
    end
  end
end
