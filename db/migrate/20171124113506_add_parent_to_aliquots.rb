class AddParentToAliquots < ActiveRecord::Migration[5.1]
  def change
    add_reference :aliquots, :parent, foreign_key: true
  end
end
