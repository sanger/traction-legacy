class CreateProcessSteps < ActiveRecord::Migration[5.1]
  def change
    create_table :process_steps do |t|
      t.string :name
      t.references :pipeline, foreign_key: true

      t.timestamps
    end
  end
end
