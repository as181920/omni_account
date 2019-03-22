class RemoveOmniAccountAccountHolderIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :omni_account_accounts, column: [:holder_type, :holder_id]
  end
end
