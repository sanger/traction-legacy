class RenameSequencingRunsToGridionSequencingRuns < ActiveRecord::Migration[5.1]
  def change
    rename_table :sequencing_runs, :gridion_sequencing_runs
  end
end
