class RemoveOmniAccountEntryOriginUniqueness < ActiveRecord::Migration[5.2]
  def change
    remove_index :omni_account_entries, column: [:origin_type, :origin_id], unique: true
    add_index :omni_account_entries, [:origin_type, :origin_id]
  end
end
