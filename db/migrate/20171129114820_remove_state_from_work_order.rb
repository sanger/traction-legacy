class RemoveStateFromWorkOrder < ActiveRecord::Migration[5.1]
  def change
    remove_column :work_orders, :state, :integer
  end
end
