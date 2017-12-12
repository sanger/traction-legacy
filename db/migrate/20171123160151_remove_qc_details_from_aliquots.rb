class RemoveQcDetailsFromAliquots < ActiveRecord::Migration[5.1]
  def change
    remove_column :aliquots, :fragment_size, :integer
    remove_column :aliquots, :concentration, :decimal
    remove_column :aliquots, :qc_state, :integer
    remove_reference :aliquots, :tube, foreign_key: true
  end
end
