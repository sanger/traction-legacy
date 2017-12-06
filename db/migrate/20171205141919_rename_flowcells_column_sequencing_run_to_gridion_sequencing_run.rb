class RenameFlowcellsColumnSequencingRunToGridionSequencingRun < ActiveRecord::Migration[5.1]
  def change
    rename_column :flowcells, :sequencing_run_id, :gridion_sequencing_run_id
  end
end
