class RemoveDetailsFromWorkOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :work_orders, :data_type, :string
    remove_column :work_orders, :library_preparation_type, :string
    remove_column :work_orders, :number_of_flowcells, :integer
  end
end
