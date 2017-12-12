class CreateRequirements < ActiveRecord::Migration[5.1]
  def change
    create_table :requirements do |t|
      t.string :name
      t.references :pipeline, foreign_key: true

      t.timestamps
    end
  end
end
