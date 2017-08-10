class CreateFlowcells < ActiveRecord::Migration[5.1]
  def change
    create_table :flowcells do |t|
      t.string :flowcell_id
      t.integer :position
      t.references :sequencing_run, index: true, foreign_key: true
      t.references :work_order, index: true, foreign_key: true
      t.timestamps
    end
  end
end
