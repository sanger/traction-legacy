class DeleteLibraryTable < ActiveRecord::Migration[5.1]
  def change
    drop_table(:libraries)
  end
end
