class RenameTableTubeToReceptacle < ActiveRecord::Migration[5.1]
  def change
    rename_table :tubes, :receptacles
  end
end
