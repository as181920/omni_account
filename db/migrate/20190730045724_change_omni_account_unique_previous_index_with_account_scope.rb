class ChangeOmniAccountUniquePreviousIndexWithAccountScope < ActiveRecord::Migration[5.2]
  def change
    remove_index :omni_account_account_histories, column: :previous_id, unique: true
    add_index :omni_account_account_histories, [:previous_id, :account_id], unique: true, name: "index_omni_account_histories_on_previous_and_account"
  end
end
