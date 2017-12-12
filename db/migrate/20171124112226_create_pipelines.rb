class CreatePipelines < ActiveRecord::Migration[5.1]
  def change
    create_table :pipelines do |t|
      t.string :name
      t.boolean :flexible, default: false

      t.timestamps
    end
  end
end
