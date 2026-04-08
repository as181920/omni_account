class AddAllowContraBalanceToOmniAccountAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :omni_account_accounts, :allow_contra_balance, :boolean
  end
end
