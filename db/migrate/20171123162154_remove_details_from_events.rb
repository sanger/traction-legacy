class RemoveDetailsFromEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :state_from, :string
    remove_column :events, :state_to, :string
    remove_reference :events, :work_order, foreign_key: true
  end
end
