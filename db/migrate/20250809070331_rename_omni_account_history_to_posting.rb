class RenameOmniAccountHistoryToPosting < ActiveRecord::Migration[8.0]
  def change
    rename_table :omni_account_account_histories, :omni_account_postings
    rename_index :omni_account_postings, :index_omni_account_histories_on_previous_and_account, :index_omni_account_postings_on_previous_and_account
  end
end
