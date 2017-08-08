class CreateSequencingRuns < ActiveRecord::Migration[5.1]
  def change
    create_table :sequencing_runs do |t|
      t.string :instrument_name
      t.integer :state
      t.timestamps
    end
  end
end
