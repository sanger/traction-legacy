class CreateTubes < ActiveRecord::Migration[5.1]
  def change
    create_table :tubes do |t|
      t.timestamps
    end
  end
end
