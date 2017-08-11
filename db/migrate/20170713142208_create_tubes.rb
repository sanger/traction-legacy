class CreateTubes < ActiveRecord::Migration[5.1]
  def change
    create_table :tubes do |t|
      t.string :barcode
      t.timestamps
    end
  end
end
