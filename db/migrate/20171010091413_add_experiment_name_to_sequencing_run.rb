class AddExperimentNameToSequencingRun < ActiveRecord::Migration[5.1]
  def change
    add_column :sequencing_runs, :experiment_name, :string
  end
end
