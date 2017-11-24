class CreateMetadataItems < ActiveRecord::Migration[5.1]
  def change
    create_table :metadata_items do |t|
      t.string :value
      t.references :metadata_field, foreign_key: true
      t.references :lab_event, foreign_key: true

      t.timestamps
    end
  end
end
