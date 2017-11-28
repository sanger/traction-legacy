class CreateMetadataFields < ActiveRecord::Migration[5.1]
  def change
    create_table :metadata_fields do |t|
      t.string :name
      t.boolean :required
      t.string :data_type
      t.references :process_step, foreign_key: true

      t.timestamps
    end
  end
end
