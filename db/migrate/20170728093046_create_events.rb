class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :state_from
      t.string :state_to
      t.references :work_order, index: true, foreign_key: true
      t.timestamps
    end
  end
end
